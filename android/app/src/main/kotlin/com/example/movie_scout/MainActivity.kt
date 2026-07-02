package com.xicra.moviescout

import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.xicra.moviescout/shortcut"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "pinShortcut") {
                val id = call.argument<String>("id")
                val shortLabel = call.argument<String>("shortLabel")
                val url = call.argument<String>("url")
                val iconBytes = call.argument<ByteArray>("iconBytes")

                if (id == null || shortLabel == null || url == null) {
                    result.error("INVALID_ARGS", "Missing required arguments", null)
                    return@setMethodCallHandler
                }

                if (ShortcutManagerCompat.isRequestPinShortcutSupported(context)) {
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(url)).apply {
                        setPackage(context.packageName)
                    }

                    val builder = ShortcutInfoCompat.Builder(context, id)
                        .setShortLabel(shortLabel)
                        .setIntent(intent)

                    if (iconBytes != null) {
                        val bitmap = BitmapFactory.decodeByteArray(iconBytes, 0, iconBytes.size)
                        builder.setIcon(IconCompat.createWithBitmap(bitmap))
                    }

                    val shortcutInfo = builder.build()
                    ShortcutManagerCompat.requestPinShortcut(context, shortcutInfo, null)
                    result.success(true)
                } else {
                    result.success(false)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
