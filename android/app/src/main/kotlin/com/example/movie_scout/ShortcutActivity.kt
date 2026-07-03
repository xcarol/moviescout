package com.xicra.moviescout

import io.flutter.embedding.android.FlutterActivity

class ShortcutActivity: FlutterActivity() {
    override fun getDartEntrypointFunctionName(): String {
        return "mainShortcut"
    }
}
