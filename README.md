# pdf_worker

A new Flutter plugin project. you can lock, unlock PDF file.

## Getting Started

### usage

```dart
final pdfWorker = PdfWorker();

try {
    // path need the device pdf file path
    final isEncrypted = await pdfWorker.isEncrypted(filePath: 'test.pdf');
    await pdfWorker.lock(filePath: 'test.pdf', password: '123456');
    final locked = await pdfWorker.unlock(filePath: 'test.pdf', password: '123456');

    // replace your file path, or look example
    final outputPath = await pdfWorker.choosePagesIndexToMerge(
      inputPath: 'test.pdf',
      outputPath: 'outpath.pdf',
      pagesIndex: [1, 2],
    );
    final mergedPath = await pdfWorker.mergePdfFiles(
      filesPath: ['test.pdf', 'test1.pdf'],
      outputPath: 'outpath.pdf',
    );

} catch (e) {
    debugPrint(e.toString());
}

```

### TODO List

- [ ] add merge pdf to long picture
- [ ] add images to pdf 
- [ ] add pdf to images



