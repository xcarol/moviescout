package com.xicra.moviescout

import android.content.Intent
import android.graphics.BitmapFactory
import android.net.Uri
import android.os.Bundle
import androidx.core.view.WindowCompat
import androidx.core.content.pm.ShortcutInfoCompat
import androidx.core.content.pm.ShortcutManagerCompat
import androidx.core.graphics.drawable.IconCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.xicra.moviescout/shortcut"

    override fun onCreate(savedInstanceState: Bundle?) {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }

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
                } else {
                    if (ShortcutManagerCompat.isRequestPinShortcutSupported(context)) {
                        val intent = Intent(context, ShortcutActivity::class.java).apply {
                            action = Intent.ACTION_VIEW
                            data = Uri.parse(url)
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }

                        val builder = ShortcutInfoCompat.Builder(context, id)
                            .setShortLabel(shortLabel)
                            .setIntent(intent)

                        if (iconBytes != null) {
                            val options = BitmapFactory.Options().apply {
                                inJustDecodeBounds = true
                            }
                            BitmapFactory.decodeByteArray(iconBytes, 0, iconBytes.size, options)
                            
                            options.inSampleSize = calculateInSampleSize(options, 192, 192)
                            options.inJustDecodeBounds = false
                            
                            val bitmap = BitmapFactory.decodeByteArray(iconBytes, 0, iconBytes.size, options)
                            builder.setIcon(IconCompat.createWithBitmap(bitmap))
                        }

                        val shortcutInfo = builder.build()
                        ShortcutManagerCompat.requestPinShortcut(context, shortcutInfo, null)
                        result.success(true)
                    } else {
                        result.success(false)
                    }
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun calculateInSampleSize(options: BitmapFactory.Options, reqWidth: Int, reqHeight: Int): Int {
        val height = options.outHeight
        val width = options.outWidth
        var inSampleSize = 1

        if (height > reqHeight || width > reqWidth) {
            val halfHeight = height / 2
            val halfWidth = width / 2
            while (halfHeight / inSampleSize >= reqHeight && halfWidth / inSampleSize >= reqWidth) {
                inSampleSize *= 2
            }
        }
        return inSampleSize
    }
}
