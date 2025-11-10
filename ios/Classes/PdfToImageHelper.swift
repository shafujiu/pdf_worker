import PDFKit
import UIKit

class PdfToImageHelper {
    static func pdfToImages(inputPath: String, outputDirectory: String) throws -> [String] {
        guard let pdfDocument = PDFDocument(url: URL(fileURLWithPath: inputPath)) else {
            throw PdfMergerError.fileNotFound
        }
        let outputURL = URL(fileURLWithPath: outputDirectory, isDirectory: true)
        if !FileManager.default.fileExists(atPath: outputURL.path) {
            try FileManager.default.createDirectory(at: outputURL, withIntermediateDirectories: true)
        }
        var imagesPath = [String]()
        for index in 0..<pdfDocument.pageCount {
            guard let page = pdfDocument.page(at: index) else { continue }
            let size = page.bounds(for: .cropBox).size
            let image = page.thumbnail(of: size, for: .cropBox)
            guard let imageData = image.pngData() else { continue }
            let imageURL = outputURL.appendingPathComponent("\(index).png")
            try imageData.write(to: imageURL)
            imagesPath.append(imageURL.path)
        }
        return imagesPath
    }
}
