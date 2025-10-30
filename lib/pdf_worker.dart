
import 'pdf_worker_platform_interface.dart';

class PdfWorker {
  Future<String?> getPlatformVersion() {
    return PdfWorkerPlatform.instance.getPlatformVersion();
  }

  Future<bool> isEncrypted({required String filePath}) {
    return PdfWorkerPlatform.instance.isEncrypted(filePath: filePath);
  }

  Future<bool> lock({required String filePath, required String password}) {
    return PdfWorkerPlatform.instance.lock(filePath: filePath, password: password);
  }

  Future<bool> unlock({required String filePath, required String password}) {
    return PdfWorkerPlatform.instance.unlock(filePath: filePath, password: password);
  }
}
