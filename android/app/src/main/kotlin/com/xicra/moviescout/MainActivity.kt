package com.xicra.moviescout

import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import androidx.activity.enableEdgeToEdge
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Main activity of the application.
 * Sets up the Flutter engine and provides a MethodChannel
 * to handle shortcut creation requests from Dart.
 */
class MainActivity: FlutterFragmentActivity() {
    private val CHANNEL = "com.xicra.moviescout/shortcut"
    private var methodChannel: MethodChannel? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        enableEdgeToEdge()
        super.onCreate(savedInstanceState)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
        methodChannel = channel
        channel.setMethodCallHandler { call, result ->
            if (call.method == "pinShortcut") {
                val id = call.argument<String>("id")
                val shortLabel = call.argument<String>("shortLabel")
                val url = call.argument<String>("url")
                val iconBytes = call.argument<ByteArray>("iconBytes")

                if (id == null || shortLabel == null || url == null) {
                    result.error("INVALID_ARGS", "Missing required arguments", null)
                } else {
                    if (ShortcutManagerCompat.isRequestPinShortcutSupported(this)) {
                        val intent = Intent(this, MainActivity::class.java).apply {
                            action = Intent.ACTION_VIEW
                            data = Uri.parse(url)
                            addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                        }

                        val builder = ShortcutInfoCompat.Builder(this, id)
                            .setShortLabel(shortLabel)
                            .setIntent(intent)

                        if (iconBytes != null) {
                            val options = BitmapFactory.Options()
                            options.inSampleSize = 1
                            val bitmap = BitmapFactory.decodeByteArray(iconBytes, 0, iconBytes.size, options)
                            builder.setIcon(IconCompat.createWithBitmap(bitmap))
                        }

                        val shortcutInfo = builder.build()
                        ShortcutManagerCompat.requestPinShortcut(this, shortcutInfo, null)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
            } else if (call.method == "moveToBackground") {
                moveTaskToBack(true)
                result.success(true)
            } else {
                result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        if (intent.action == Intent.ACTION_MAIN && intent.hasCategory(Intent.CATEGORY_LAUNCHER)) {
            methodChannel?.invokeMethod("resetToHome", null)
        }
    }
}
