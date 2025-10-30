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
  Future<bool> lock({required String filePath, required String password}) {
    return Future.value(true);
  }

  @override
  Future<bool> unlock({required String filePath, required String password}) {
    return Future.value(true);
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

  test('isEncrypted', () async {
    PdfWorker pdfWorkerPlugin = PdfWorker();
    MockPdfWorkerPlatform fakePlatform = MockPdfWorkerPlatform();
    PdfWorkerPlatform.instance = fakePlatform;

    expect(await pdfWorkerPlugin.isEncrypted(filePath: 'test.pdf'), false);
  });
}
