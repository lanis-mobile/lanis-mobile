package com.example.app

import com.zynksoftware.documentscanner.ScanActivity
import com.zynksoftware.documentscanner.model.DocumentScannerErrorModel
import com.zynksoftware.documentscanner.model.ScannerResults

class AppScanActivity: ScanActivity() {
    override fun onClose() {
        TODO("Not yet implemented")
    }

    override fun onError(error: DocumentScannerErrorModel) {
        TODO("Not yet implemented")
    }

    override fun onSuccess(scannerResults: ScannerResults) {
        TODO("Not yet implemented")
    }

}