import PDFKit
import UIKit

enum ImageFormat: String {
    case png
    case jpg

    var fileExtension: String { rawValue }
}

struct PdfToImagesConfig {
    let pagesIndex: [Int]?
    let imgFormat: ImageFormat
    let quality: Int

    init(pagesIndex: [Int]? = nil, imgFormat: ImageFormat = .png, quality: Int = 100) {
        let clampedQuality = max(0, min(quality, 100))
        self.pagesIndex = pagesIndex
        self.imgFormat = imgFormat
        self.quality = clampedQuality
    }

    init(from dict: [String: Any]?) {
        guard let dict = dict else {
            self = PdfToImagesConfig()
            return
        }

        let rawPages = dict["pagesIndex"] as? [Any]
        let parsedPages = rawPages?.compactMap { $0 as? Int }
        let formatRaw = (dict["imgFormat"] as? String)?.lowercased()
        let format = formatRaw.flatMap { ImageFormat(rawValue: $0) } ?? .png
        let quality = dict["quality"] as? Int ?? 100

        self = PdfToImagesConfig(pagesIndex: parsedPages?.isEmpty == true ? nil : parsedPages,
                                 imgFormat: format,
                                 quality: quality)
    }

    var normalizedQuality: CGFloat { CGFloat(quality) / 100.0 }
}

enum PdfToImageError: Error {
    case outOfPage
    case fileNotFound
}

class PdfToImageHelper {

    static func pdfToImages(inputPath: String, outputDirectory: String, config: PdfToImagesConfig?)
        throws -> [String]
    {
        guard let pdfDocument = PDFDocument(url: URL(fileURLWithPath: inputPath)) else {
            throw PdfToImageError.fileNotFound
        }

        let outputURL = URL(fileURLWithPath: outputDirectory, isDirectory: true)
        if !FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.createDirectory(
                at: outputURL, withIntermediateDirectories: true)
        }
        let config = config ?? PdfToImagesConfig()
        let targetPages: [Int]
        if let pages = config.pagesIndex {
            targetPages = pages
        } else {
            targetPages = Array(0..<pdfDocument.pageCount)
        }

        guard targetPages.allSatisfy({ $0 >= 0 && $0 < pdfDocument.pageCount }) else {
            throw PdfToImageError.outOfPage
        }

        var imagesPath = [String]()

        for index in targetPages {
            guard let pdfPage = pdfDocument.page(at: index) else { throw PdfToImageError.outOfPage }
            let mediaBoxRect = pdfPage.bounds(for: .cropBox)
            let renderSize = mediaBoxRect.size

            let renderer = UIGraphicsImageRenderer(size: renderSize)
            let image = renderer.image { context in
                UIColor.white.set()
                context.fill(CGRect(origin: .zero, size: renderSize))
                let cgContext = context.cgContext
                cgContext.translateBy(x: 0.0, y: renderSize.height)
                cgContext.scaleBy(x: 1, y: -1)

                pdfPage.draw(with: .cropBox, to: cgContext)
            }

            let fileURL = createFileURL(directory: outputURL, format: config.imgFormat, index: index)
            let data: Data?
            switch config.imgFormat {
            case .png:
                data = image.pngData()
            case .jpg:
                data = image.jpegData(compressionQuality: config.normalizedQuality)
            }

            guard let imageData = data else { continue }
            do {
                try imageData.write(to: fileURL)
                imagesPath.append(fileURL.path)
            } catch {
                continue
            }
        }
        return imagesPath
    }

    private static func createFileURL(directory: URL, format: ImageFormat, index: Int?) -> URL {
        let fileName: String
        if let pageIndex = index {
            fileName = "image_page_\(pageIndex + 1).\(format.fileExtension)"
        } else {
            fileName = "image.\(format.fileExtension)"
        }
        return directory.appendingPathComponent(fileName)
    }
}
