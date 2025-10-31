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

} catch (e) {
    debugPrint(e.toString());
}
```


