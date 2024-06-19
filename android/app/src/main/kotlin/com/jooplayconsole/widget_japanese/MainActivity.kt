package com.jooplayconsole.widget_japanese

import android.appwidget.AppWidgetManager
import android.content.ComponentName
import android.content.Context
import android.os.Bundle
import android.widget.RemoteViews
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.example.widget/update"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "updateWidget") {
                val word = call.argument<String>("word")
                if (word != null) {
                    updateWidget(word)
                    result.success(null)
                } else {
                    result.error("UNAVAILABLE", "Word not available.", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }

    private fun updateWidget(word: String) {
        val context: Context = applicationContext
        val appWidgetManager = AppWidgetManager.getInstance(context)
        val views = RemoteViews(context.packageName, R.layout.widget_layout)
        views.setTextViewText(R.id.widget_text, word)

        val widget = ComponentName(context, MyWidgetProvider::class.java)
        appWidgetManager.updateAppWidget(widget, views)
    }
}