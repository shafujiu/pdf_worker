
import 'pdf_worker_platform_interface.dart';

class PdfWorker {
  Future<String?> getPlatformVersion() {
    return PdfWorkerPlatform.instance.getPlatformVersion();
  }

  Future<bool> isEncryptedByTail({required String filePath}) {
    return PdfWorkerPlatform.instance.isEncryptedByTail(filePath: filePath);
  }

  Future<bool> isEncrypted({required String filePath}) {
    return PdfWorkerPlatform.instance.isEncrypted(filePath: filePath);
  }

  Future<void> lock({required String filePath, required String userPassword, required String ownerPassword}) async {
     await PdfWorkerPlatform.instance.lock(filePath: filePath, userPassword: userPassword, ownerPassword: ownerPassword);
  }

  Future<bool> unlock({required String filePath, required String password}) {
    return PdfWorkerPlatform.instance.unlock(filePath: filePath, password: password);
  }
}
