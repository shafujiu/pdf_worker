package com.example.pdf_worker

import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.pdf.PdfRenderer
import android.os.ParcelFileDescriptor
import androidx.core.graphics.createBitmap
import java.io.File
import java.io.FileNotFoundException
import java.io.FileOutputStream

enum class ImageFormat(val extension: String) {
    PNG("png"),
    JPG("jpg")
}

class PdfToImagesConfig {
    var pagesIndex: List<Int>? = null
    var imgFormat: ImageFormat = ImageFormat.PNG
    var quality: Int = 100

    // 传入 map 参数 初始化
    constructor(configMap: Map<String, Any?>?) {
        configMap ?: return

        val rawPagesIndex = configMap["pagesIndex"]
        pagesIndex = (rawPagesIndex as? List<*>)
                ?.takeIf { items -> items.all { it is Int } }
                ?.map { it as Int }

        val rawImgFormat = configMap["imgFormat"]
        imgFormat = when (rawImgFormat) {
            is ImageFormat -> rawImgFormat
            is String -> runCatching { ImageFormat.valueOf(rawImgFormat) }.getOrDefault(imgFormat)
            else -> imgFormat
        }

        val rawQuality = configMap["quality"]
        quality = (rawQuality as? Number)?.toInt() ?: quality
    }

    constructor()
}

object PdfToImageHelper {
    // quality：整数，范围 0～100
    // 仅对 有损压缩格式（如 JPEG, WEBP_LOSSY） 有效；
    // 对 无损格式（如 PNG, WEBP_LOSSLESS） 无效（会被忽略）。
    fun pdfToImages(
            inputPath: String,
            outputDirectory: String,
            config: PdfToImagesConfig?
    ): List<String> {
        val file = File(inputPath)
        if (!file.exists()) {
            throw FileNotFoundException("File does not exist: $inputPath")
        }
        val config = config ?: PdfToImagesConfig()
        var format = Bitmap.CompressFormat.PNG
        format = when (config.imgFormat) {
            ImageFormat.PNG -> Bitmap.CompressFormat.PNG
            ImageFormat.JPG -> Bitmap.CompressFormat.JPEG
        }

        val fileDescriptor =
                ParcelFileDescriptor.open(File(inputPath), ParcelFileDescriptor.MODE_READ_ONLY)
        val renderer = PdfRenderer(fileDescriptor)
        val pageNumbers = config.pagesIndex ?: (0 until renderer.pageCount).toList()
        // check if pageNumbers is valid
        if (pageNumbers.any { it < 0 || it >= renderer.pageCount }) {
            renderer.close()
            fileDescriptor.close()
            throw IllegalArgumentException("pageNumbers is invalid")
        }

        val pdfImages: MutableList<Bitmap> = mutableListOf()
        val pdfImagesPath: MutableList<String> = mutableListOf()
        for (pageIndex in pageNumbers) {
            val page = renderer.openPage(pageIndex)
            val scale = 3.0f
            val width = (page.width * scale).toInt()
            val height = (page.height * scale).toInt()
            val bitmap = createBitmap(width, height)

            val canvas = Canvas(bitmap)
            canvas.drawColor(Color.WHITE)
            page.render(bitmap, null, null, PdfRenderer.Page.RENDER_MODE_FOR_DISPLAY)

            val imageName =
                    "split_page_${System.currentTimeMillis()}_${pageIndex + 1}.${config.imgFormat.extension}"
            pdfImagesPath.add("$outputDirectory/$imageName")
            val outputFile = File(outputDirectory, imageName)
            FileOutputStream(outputFile).use { out ->
                bitmap.compress(format, config.quality, out)
                pdfImages.add(bitmap)
            }
            // bitmap.recycle()
            page.close()
        }

        renderer.close()
        fileDescriptor.close()
        return pdfImagesPath
    }
}
