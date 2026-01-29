## Flutter local notifications
-keep class com.dexterous.** { *; }

## Workmanager
-keep class com.be2ewise.workmanager.** { *; }

## Isar
-keep class io.isar.** { *; }
-keep class * extends io.isar.IsarLink { *; }
-keep class * extends io.isar.IsarLinks { *; }

## Shared Preferences
-keep class com.google.gson.** { *; }

## General Flutter
-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.embedding.** { *; }
-keep class io.flutter.embedding.engine.plugins.** { *; }

## Play Core (fixes R8 missing classes)
-dontwarn com.google.android.play.core.**
-dontwarn com.google.android.gms.internal.**
-dontwarn com.google.android.gms.common.**
