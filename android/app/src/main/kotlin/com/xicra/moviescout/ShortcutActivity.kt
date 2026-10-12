package com.xicra.moviescout

import android.app.Activity
import android.content.Intent
import android.os.Bundle

class ShortcutActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val forwardIntent = Intent(intent).apply {
            setClass(this@ShortcutActivity, MainActivity::class.java)
            flags = Intent.FLAG_ACTIVITY_SINGLE_TOP or Intent.FLAG_ACTIVITY_CLEAR_TOP
        }
        startActivity(forwardIntent)
        finish()
    }
}
