package com.example.pdf_worker

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** PdfWorkerPlugin */
class PdfWorkerPlugin : FlutterPlugin, MethodCallHandler {
    // The MethodChannel that will the communication between Flutter and native Android
    //
    // This local reference serves to register the plugin with the Flutter Engine and unregister it
    // when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var pdfLocker: PdfLocker
    private lateinit var pdfMerger: PdfMerger

    override fun onAttachedToEngine(flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "pdf_worker")
        channel.setMethodCallHandler(this)
        pdfLocker = PdfLocker()
        pdfMerger = PdfMerger()
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "isEncryptedByTail" -> {
                val filePath = call.argument<String>("filePath")
                if (filePath == null) {
                    result.error("INVALID_ARGUMENTS", "File path is null", null)
                    return
                }
                // if do not catch exception, the app will brokendown on flutter method channel
                try {
                    val isEncrypted = pdfLocker.isEncryptedByTail(filePath)
                    result.success(isEncrypted)
                } catch (e: Exception) {
                    result.error("IS_ENCRYPTED_BY_TAIL_FAILED", "Failed to check if PDF is encrypted by tail", e.message)
                }
            }
            "isEncrypted" -> {
                val filePath = call.argument<String>("filePath")
                if (filePath == null) {
                    result.error("INVALID_ARGUMENTS", "File path is null", null)
                    return
                }
                try {
                    val isEncrypted = pdfLocker.isEncrypted(filePath)
                    result.success(isEncrypted)
                } catch (e: Exception) {
                    result.error("IS_ENCRYPTED_FAILED", "Failed to check if PDF is encrypted", e.message)
                }
            }
            "lock" -> {
                val filePath = call.argument<String>("filePath")
                val userPassword = call.argument<String>("userPassword")
                val ownerPassword = call.argument<String>("ownerPassword")
                if (filePath == null || userPassword == null || ownerPassword == null) {
                    result.error("INVALID_ARGUMENTS", "File path or password is null", null)
                    return
                }
                try {
                    pdfLocker.lock(filePath, userPassword, ownerPassword)
                    result.success(true)
                } catch (e: Exception) {
                    result.error("LOCK_FAILED", "Failed to lock PDF", e.message)
                }
            }
            "unlock" -> {
                val filePath = call.argument<String>("filePath")
                val password = call.argument<String>("password")
                if (filePath == null || password == null) {
                    result.error("INVALID_ARGUMENTS", "File path or password is null", null)
                    return
                }
                try {
                    val isUnlocked = pdfLocker.unlock(filePath, password)
                    result.success(isUnlocked)
                } catch (e: Exception) {
                    result.error("UNLOCK_FAILED", "Failed to unlock PDF", e.message)
                }
            }
            "choosePagesIndexToMerge" -> {
                val inputPath = call.argument<String>("inputPath")
                val outputPath = call.argument<String>("outputPath")
                val pagesIndex = call.argument<List<Int>>("pagesIndex")
                if (inputPath == null || outputPath == null || pagesIndex == null) {
                    result.error("INVALID_ARGUMENTS", "Input path, output path or pages is null", null)
                    return
                }
                try {
                    val outputPath = pdfMerger.choosePagesIndexToMerge(inputPath, outputPath, pagesIndex)
                    result.success(outputPath)
                } catch (e: Exception) {
                    result.error("CHOOSE_PAGES_TO_MERGE_FAILED", "Failed to choose pages to merge", e.message)
                }
            }
            "mergePdfFiles" -> {
                val filesPath = call.argument<List<String>>("filesPath")
                val outputPath = call.argument<String>("outputPath")
                if (filesPath == null || outputPath == null) {
                    result.error("INVALID_ARGUMENTS", "Files path or output path is null", null)
                    return
                }
                try {
                    val outputPath = pdfMerger.mergePdfFiles(filesPath, outputPath)
                    result.success(outputPath)
                } catch (e: Exception) {
                    result.error("MERGE_PDF_FILES_FAILED", "Failed to merge PDF files", e.message)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }
}
