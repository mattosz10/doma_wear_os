package com.example.doma_app

import android.content.Context
import android.content.Intent
import android.provider.Settings
import android.media.AudioDeviceCallback
import android.media.AudioDeviceInfo
import android.media.AudioManager
import android.content.pm.PackageManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.doma/audio"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        val audioManager = getSystemService(Context.AUDIO_SERVICE) as AudioManager
        val channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)

        // Item 3: Registro de Callback para Detecção Dinâmica
        audioManager.registerAudioDeviceCallback(object : AudioDeviceCallback() {
            override fun onAudioDevicesAdded(addedDevices: Array<out AudioDeviceInfo>?) {
                super.onAudioDevicesAdded(addedDevices)
                channel.invokeMethod("onAudioChanged", "added")
            }

            override fun onAudioDevicesRemoved(removedDevices: Array<out AudioDeviceInfo>?) {
                super.onAudioDevicesRemoved(removedDevices)
                channel.invokeMethod("onAudioChanged", "removed")
            }
        }, null)

        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                // Item 2: Enumeração de saídas de áudio
                "checkAudioOutput" -> {
                    val type = call.argument<Int>("type") ?: -1
                    val isAvailable = audioOutputAvailable(type, audioManager)
                    result.success(isAvailable)
                }
                // Item 4: Intent para Configurações de Bluetooth
                "openBluetoothSettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_BLUETOOTH_SETTINGS).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
                            putExtra("EXTRA_CONNECTION_ONLY", true)
                            putExtra("EXTRA_CLOSE_ON_CONNECT", true)
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERR_BT", e.message, null)
                    }
                }
                else -> result.notImplemented()
            }
        }
    }

    private fun audioOutputAvailable(type: Int, audioManager: AudioManager): Boolean {
        if (!packageManager.hasSystemFeature(PackageManager.FEATURE_AUDIO_OUTPUT)) return false
        return audioManager.getDevices(AudioManager.GET_DEVICES_OUTPUTS).any { it.type == type }
    }
}