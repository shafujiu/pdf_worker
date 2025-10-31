import 'package:flutter_test/flutter_test.dart';
import 'package:pdf_worker/pdf_worker.dart';
import 'package:pdf_worker/pdf_worker_platform_interface.dart';
import 'package:pdf_worker/pdf_worker_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockPdfWorkerPlatform
    with MockPlatformInterfaceMixin
    implements PdfWorkerPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');

  @override
  Future<bool> isEncrypted({required String filePath}) => Future.value(false);

  @override
  Future<bool> isEncryptedByTail({required String filePath}) => Future.value(false);

  @override
  Future<bool> lock({required String filePath, required String userPassword, required String ownerPassword}) {
    return Future.value(false);
  }

  @override
  Future<bool> unlock({required String filePath, required String password}) {
    return Future.value(false);
  }

}

void main() {
  final PdfWorkerPlatform initialPlatform = PdfWorkerPlatform.instance;

  test('$MethodChannelPdfWorker is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelPdfWorker>());
  });

  test('getPlatformVersion', () async {
    PdfWorker pdfWorkerPlugin = PdfWorker();
    MockPdfWorkerPlatform fakePlatform = MockPdfWorkerPlatform();
    PdfWorkerPlatform.instance = fakePlatform;

    expect(await pdfWorkerPlugin.getPlatformVersion(), '42');
  });

  test('isEncryptedByTail', () async {
    PdfWorker pdfWorkerPlugin = PdfWorker();
    MockPdfWorkerPlatform fakePlatform = MockPdfWorkerPlatform();
    PdfWorkerPlatform.instance = fakePlatform;

    expect(await pdfWorkerPlugin.isEncryptedByTail(filePath: 'test.pdf'), false);
  });

  test('isEncrypted', () async {
    PdfWorker pdfWorkerPlugin = PdfWorker();
    MockPdfWorkerPlatform fakePlatform = MockPdfWorkerPlatform();
    PdfWorkerPlatform.instance = fakePlatform;

    expect(await pdfWorkerPlugin.isEncrypted(filePath: 'test.pdf'), false);
  });

  test('lock', () async {
    PdfWorker pdfWorkerPlugin = PdfWorker();
    MockPdfWorkerPlatform fakePlatform = MockPdfWorkerPlatform();
    PdfWorkerPlatform.instance = fakePlatform;

    await pdfWorkerPlugin.lock(filePath: 'test.pdf', userPassword: '123456', ownerPassword: '123456');
  });

  test('unlock', () async {
    PdfWorker pdfWorkerPlugin = PdfWorker();
    MockPdfWorkerPlatform fakePlatform = MockPdfWorkerPlatform();
    PdfWorkerPlatform.instance = fakePlatform;

    expect(await pdfWorkerPlugin.unlock(filePath: 'test.pdf', password: '123456'), false);
  });
}
