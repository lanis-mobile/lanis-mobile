package com.example.app

import android.app.Activity
import android.content.Intent
import android.net.Uri
import android.os.Bundle
import com.zynksoftware.documentscanner.ScanActivity
import com.zynksoftware.documentscanner.model.DocumentScannerErrorModel
import com.zynksoftware.documentscanner.model.ScannerResults
import java.io.File

class AppScanActivity: ScanActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.app_scan_activity_layout)
        addFragmentContentLayout()
    }

    override fun onClose() {
        finish()
    }

    override fun onError(error: DocumentScannerErrorModel) {
        when (error.errorMessage) {
            DocumentScannerErrorModel.ErrorMessage.TAKE_IMAGE_FROM_GALLERY_ERROR -> TODO()
            DocumentScannerErrorModel.ErrorMessage.PHOTO_CAPTURE_FAILED -> TODO()
            DocumentScannerErrorModel.ErrorMessage.CAMERA_USE_CASE_BINDING_FAILED -> TODO()
            DocumentScannerErrorModel.ErrorMessage.DETECT_LARGEST_QUADRILATERAL_FAILED -> TODO()
            DocumentScannerErrorModel.ErrorMessage.INVALID_IMAGE -> TODO()
            DocumentScannerErrorModel.ErrorMessage.CAMERA_PERMISSION_REFUSED_WITHOUT_NEVER_ASK_AGAIN -> TODO()
            DocumentScannerErrorModel.ErrorMessage.CAMERA_PERMISSION_REFUSED_GO_TO_SETTINGS -> TODO()
            DocumentScannerErrorModel.ErrorMessage.STORAGE_PERMISSION_REFUSED_WITHOUT_NEVER_ASK_AGAIN -> TODO()
            DocumentScannerErrorModel.ErrorMessage.STORAGE_PERMISSION_REFUSED_GO_TO_SETTINGS -> TODO()
            DocumentScannerErrorModel.ErrorMessage.CROPPING_FAILED -> TODO()
            null -> TODO()
        }
    }

    override fun onSuccess(scannerResults: ScannerResults) {
        val file: File? = scannerResults.croppedImageFile

        if (file != null) {
            val uri = Uri.fromFile(file)

            val intent = Intent()
            intent.setData(uri)

            setResult(Activity.RESULT_OK, intent)

            finish()
        } else {
            setResult(Activity.RESULT_CANCELED)
            finish()
        }
    }

}