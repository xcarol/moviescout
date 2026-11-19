# Watchlist & New Season Notifications

Reference diagrams for [watchlist_update_service.dart](lib/features/watchlist/services/watchlist_update_service.dart) and [watchlist_notification_evaluator.dart](lib/features/notifications/services/watchlist_notification_evaluator.dart).

## State Variables

| Variable | Values | Role |
| :--- | :--- | :--- |
| `lastNotifiedSeason` | `-1` (`seasonNotInitialized`) | Baseline never computed yet (also mapped from Supabase `<= 0` on fetch) |
| | `0` | Baseline computed as `0` (waiting for S1 to premiere or complete) |
| | `N >= 1` | Season `N` already baselined or notified |
| `lastUpdated` | `'1970-01-01'` (`defaultDate`) | Never synced from TMDB yet (`evaluateNotification` returns `none`) |
| | ISO timestamp | Synced on this date; scanned once per `watchlistProvidersUpdateFrequencyDays` (1 day) |
| `wasAvailable` / `isAvailable` | `bool` | Intersection of `flatrateProviderIds` (before/after TMDB update) with `enabledProviderIds` |
| `notifyCompleteSeason` | `bool` (preference) | Wait until a season finishes airing before notifying |
| `watchlistNewSeasonNotificationWindowDays` | `14` days | Max age since premiere (or finale when `notifyCompleteSeason = true`) to trigger `newSeason` |

---

## 1. Per-Title Update Flow (`_updateTitle`)

```mermaid
flowchart TD
    Start["checkNeedsUpdate(title, now)"] --> NeedCheck{"now - lastUpdated >= 1d OR (isSerie AND lastNotifiedSeason == -1)?"}
    NeedCheck -- No --> Skip["UpdateType.none (Skip)"]
    NeedCheck -- Yes --> Fetch["titleBeforeUpdate = snapshot; updateTitleLight(title)"]
    Fetch --> SaveMeta{"lastUpdated or flatrateProviderIds changed?"}
    SaveMeta -- Yes --> PersistMeta["updateTitlesMetadata([title]) (merge keeps max lastNotifiedSeason)"]
    SaveMeta -- No --> InitCheck
    PersistMeta --> InitCheck["initializeBaselineIfNeeded"]

    InitCheck --> IsUninit{"isSerie AND lastNotifiedSeason == -1?"}
    IsUninit -- Yes --> CalcBase["lastNotifiedSeason = getBaselineSeason(...); sync titleBeforeUpdate; save DB"]
    IsUninit -- No --> Eval
    CalcBase --> Eval["evaluateNotification(...)"]

    Eval -- "none" --> DoneNone["Return false"]
    Eval -- "seasonTooOld" --> MarkOld["Set lastNotifiedSeason = numberOfSeasons; save DB + enqueue cloud sync; return false"]
    Eval -- "newAvailability" --> NotifyAvail["Send availability notification; if isSerie set lastNotifiedSeason = numberOfSeasons; save DB + enqueue cloud sync"]
    Eval -- "newSeason" --> NotifySeason["Send new season notification; set lastNotifiedSeason = numberOfSeasons; ensure in watchlist + save DB + enqueue cloud sync"]
```
![Diagram of _updateTitle](assets/docs/update_title_flow.jpeg)

---

## 2. Baseline Calculation (`getBaselineSeason`)

Runs **once** when `lastNotifiedSeason == -1` (`AppConstants.seasonNotInitialized`).

```mermaid
flowchart TD
    Start["getBaselineSeason(title, now, notifyCompleteSeason)"] --> HasSeasons{"numberOfSeasons <= 0?"}
    HasSeasons -- Yes --> RetZero["Return 0"]
    HasSeasons -- No --> HasNext{"nextEpisodeToAir != null AND seasonNumber > 0?"}

    HasNext -- Yes --> Ep1{"episodeNumber == 1?"}
    Ep1 -- Yes --> AirDateCheck{"airDate > now?"}
    AirDateCheck -- Yes --> RetNextMinus1["Return nextSeason - 1"]
    AirDateCheck -- No --> EmptyDate{"airDate == null AND (lastEpisode == null OR lastEpisode.seasonNumber < nextSeason)?"}
    EmptyDate -- Yes --> RetNextMinus1
    EmptyDate -- No --> CompletePref1
    Ep1 -- No --> CompletePref1{"notifyCompleteSeason?"}
    CompletePref1 -- Yes --> RetNextMinus1
    CompletePref1 -- No --> RetCurr1["Return numberOfSeasons"]

    HasNext -- No --> LastEp{"lastEpisodeToAir == null OR lastEpisodeToAir.seasonNumber < numberOfSeasons?"}
    LastEp -- Yes --> RetCurrMinus1["Return numberOfSeasons - 1"]
    LastEp -- No --> CompletePref2{"notifyCompleteSeason AND NOT _isSeasonComplete?"}
    CompletePref2 -- Yes --> RetCurrMinus1
    CompletePref2 -- No --> RetCurr2["Return numberOfSeasons"]
```
![Diagram of getBaseLine](assets/docs/get_base_line_flow.jpeg)


---

## 3. Notification Evaluation (`evaluateNotification`)

```mermaid
flowchart TD
    Start["evaluateNotification(...)"] --> FirstSync{"titleBeforeUpdate.lastUpdated == '1970-01-01'?"}
    FirstSync -- Yes --> RetNone0["Return none (silent first sync)"]
    FirstSync -- No --> BecameAvail{"isAvailable AND NOT wasAvailable?"}

    BecameAvail -- Yes --> AvailComplete{"isSerie AND notifyCompleteSeason?"}
    AvailComplete -- No --> RetAvail["Return newAvailability"]
    AvailComplete -- Yes --> IsComp{"_isSeasonComplete(title, currentSeason, now)?"}
    IsComp -- Yes --> RetAvail
    IsComp -- No --> RetNone1["Return none (deferred; providers saved, next run uses newSeason)"]

    BecameAvail -- No --> CheckSeason{"isAvailable AND isSerie AND currentSeason > lastNotified?"}
    CheckSeason -- No --> RetNone2["Return none"]
    CheckSeason -- Yes --> PrefMode{"notifyCompleteSeason?"}

    PrefMode -- True --> FinCheck{"lastEpisode.season == currentSeason AND nextEpisode.season != currentSeason AND lastEpisode.airDate <= now?"}
    FinCheck -- Yes --> FinWin{"(now - lastEpisode.airDate) < 14d?"}
    FinWin -- Yes --> RetSeason["Return newSeason"]
    FinWin -- No --> RetOld1["Return seasonTooOld"]
    FinCheck -- No --> RetNone3["Return none"]

    PrefMode -- False --> StartCheck1{"lastEpisode.season == currentSeason?"}
    StartCheck1 -- Yes --> HasSeasonDate{"season.air_date exists?"}
    HasSeasonDate -- Yes --> InWin1{"0 <= (now - season.air_date) < 14d?"}
    InWin1 -- Yes --> RetSeason
    InWin1 -- No --> OldWin1{"(now - season.air_date) >= 14d?"}
    OldWin1 -- Yes --> RetOld2["Return seasonTooOld"]
    OldWin1 -- No --> CheckNext1
    HasSeasonDate -- No --> Ep1Fallback{"lastEpisode.episodeNumber == 1?"}
    Ep1Fallback -- Yes --> RetSeason
    Ep1Fallback -- No --> CheckNext1

    StartCheck1 -- No --> CheckNext1{"nextEpisode.season == currentSeason AND nextEpisode.episodeNumber == 1 AND nextEpisode.airDate <= now?"}
    CheckNext1 -- Yes --> NextWin{"(now - nextEpisode.airDate) < 14d?"}
    NextWin -- Yes --> RetSeason
    NextWin -- No --> RetOld3["Return seasonTooOld"]
    CheckNext1 -- No --> RetNone4["Return none"]
```
![Diagram of evaluateNotification](assets/docs/evaluate_notification_flow.jpeg)

---

## Key Behavioral Notes

- **Deferred `newAvailability` with `notifyCompleteSeason = true`:** When an incomplete season becomes available on a provider, `flatrateProviderIds` is persisted on the first run. Once the last episode airs, `wasAvailable` is already `true`, so it fires as `newSeason` ("New season") provided `currentSeason > lastNotifiedSeason` (the 14-day window only starts from that finale date).
- **Cloud sync (`CloudTitleRepository`):** Local `-1` (`seasonNotInitialized`) is clamped to `0` (`math.max(0, lastNotifiedSeason)`) on write, and remote values `<= 0` are mapped back to `-1` on initial fetch.

---

## 4. User Use Cases (When Do You Get Notified?)

### Movies

- **Not available → available** on any of your enabled platforms → **Notifies** (*Now available*).
- Already available, not available, or removed → **Does not notify**.

### TV Series

| Real-World Situation | `notifyCompleteSeason = false` | `notifyCompleteSeason = true` |
| :--- | :--- | :--- |
| **1. You add a series NOT yet on your platforms**, and later it arrives on one | **Notifies** (*Now available*) as soon as it arrives | **Notifies** (*Now available*) if already complete; if still airing, defers and **notifies** (*New season*) once the season finishes |
| **2. You add a series ALREADY on your platforms whose current season already started/ended** | **Does not notify** on add (baseline set to `numberOfSeasons`) | **Does not notify** if finished; if still airing, baseline is `numberOfSeasons - 1` so it **notifies** when finished |
| **3. You add an unreleased series ALREADY listed on a platform** | Baseline stays `0`; **notifies** (*New season*) when S1 premieres | Baseline stays `0`; **notifies** (*New season*) when S1 finishes |
| **4. A followed/watchlist series on your platforms gets a new season** | **Notifies** (*New season*) when it premieres | **Notifies** (*New season*) when the last episode airs |
| **5. A new season premiered (or finished, if `notifyCompleteSeason = true`) `>= 14` days ago** (missed sync or late TMDB update) | **Does not notify** and marks `lastNotifiedSeason = currentSeason` | **Does not notify** and marks `lastNotifiedSeason = currentSeason` |
| **6. A new season airs, but the series is NOT on your platforms** | **Does not notify** (will notify via Case 1 if the series later arrives on your platforms) | **Does not notify** (will notify via Case 1 if the series later arrives complete on your platforms) |

