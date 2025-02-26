package com.example.app

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.net.Uri
import android.provider.MediaStore
import android.widget.Toast
import androidx.activity.result.contract.ActivityResultContracts.RequestPermission
import androidx.appcompat.app.AppCompatActivity
import androidx.core.content.ContextCompat
import com.zynksoftware.documentscanner.ui.DocumentScanner
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.FileInputStream
import java.io.FileNotFoundException
import java.io.FileOutputStream
import java.io.IOException


class MainActivity: FlutterActivity() {
    private val createFileCode = 1404
    private val scanDocumentCode = 4200
    private val takePhotoCode = 4242
    private var filePath = ""
    private var scanDocumentCallback: ((Uri?) -> Unit)? = null
    private var takePhotoCallback: ((Uri?) -> Unit)? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,
            STORAGE_CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "saveFile" -> {
                    filePath = call.argument<String>("filePath").toString()
                    createFile(call.argument<String>("fileName").toString(), call.argument<String>("mimeType").toString())
                }
                "scanDocument" -> {
                    scanDocument { uri ->
                        result.success(uri)
                    }
                }
                "takePhoto" -> {
                    takePhoto { uri ->
                        result.success(uri)
                    }
                }
                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        super.onActivityResult(requestCode, resultCode, data)
        when (requestCode) {
            createFileCode -> {
                data?.data?.let { uri ->
                    try {
                        contentResolver.openFileDescriptor(uri, "w")?.use {
                            FileInputStream(filePath).use { inputStream ->
                                FileOutputStream(it.fileDescriptor).use { outputStream ->
                                    inputStream.copyTo(outputStream)
                                }
                            }
                        }
                    } catch (e: FileNotFoundException) {
                        e.printStackTrace()
                    } catch (e: IOException) {
                        e.printStackTrace()
                    }
                }
            }
            scanDocumentCode -> {
                data?.data?.let { uri ->
                    scanDocumentCallback?.let { callback ->
                        callback(uri)
                        scanDocumentCallback = null
                    }
                }
            }
            takePhotoCode -> {
                data?.data?.let { uri ->
                    takePhotoCallback?.let { callback ->
                        callback(uri)
                        takePhotoCallback = null
                    }
                }
            }
        }
    }

    private fun createFile(fileName: String, mimeType: String) {
        val intent = Intent(Intent.ACTION_CREATE_DOCUMENT).apply {
            addCategory(Intent.CATEGORY_OPENABLE)
            type = mimeType
            putExtra(Intent.EXTRA_TITLE, fileName)
        }
        startActivityForResult(intent, createFileCode)
    }

    /**
     * Returns the file path
     */
    private fun scanDocument(callback: (Uri?) -> Unit) {
        val configuration = DocumentScanner.Configuration()
        configuration.imageQuality = 100
        configuration.imageType = Bitmap.CompressFormat.PNG
        configuration.galleryButtonEnabled = true
        DocumentScanner.init(this, configuration)

        val intent = Intent(this, AppScanActivity::class.java)
        startActivityForResult(intent, scanDocumentCode)

        scanDocumentCallback = callback
    }

    /**
     * Take a photo using the system camera and return the image as path
     */
    private fun takePhoto(callback: (Uri?) -> Unit) {
        var cameraPermissionGranted = false

        val requestPermissionLauncher = registerForActivityResult(RequestPermission()) { // WARUUUUM
            isGranted: Boolean ->
                if (isGranted) {
                    cameraPermissionGranted = true
                } else {
                    val text = R.string.errorCameraRefused
                    val duration = Toast.LENGTH_SHORT

                    val toast = Toast.makeText(this, text, duration)
                    toast.show()
                }
            }


        when {
            ContextCompat.checkSelfPermission(context, Manifest.permission.CAMERA) == PackageManager.PERMISSION_GRANTED -> {
                cameraPermissionGranted = true
            }
            else -> {
                requestPermissionLauncher.launch(Manifest.permission.CAMERA)
            }
        }

        if (cameraPermissionGranted) {
            val intent = Intent(MediaStore.ACTION_IMAGE_CAPTURE)
            startActivityForResult(intent, takePhotoCode)

            takePhotoCallback = callback
        } else {
            callback(null)
        }
    }

    companion object {
        private const val STORAGE_CHANNEL = "io.github.lanis-mobile/storage"
    }
}
