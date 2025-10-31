
import 'pdf_worker_platform_interface.dart';

class PdfWorker {
  Future<String?> getPlatformVersion() {
    return PdfWorkerPlatform.instance.getPlatformVersion();
  }

  // need try catch, if path is not exist, it will throw exception
  // filePath: the path of pdf file on your device, not flutter assets path
  Future<bool> isEncryptedByTail({required String filePath}) {
    return PdfWorkerPlatform.instance.isEncryptedByTail(filePath: filePath);
  }

  // need try catch, if path is not exist, it will throw exception
  Future<bool> isEncrypted({required String filePath}) {
    return PdfWorkerPlatform.instance.isEncrypted(filePath: filePath);
  }

  // need try catch, if path is not exist, it will throw exception
  Future<void> lock({required String filePath, required String userPassword, required String ownerPassword}) async {
     await PdfWorkerPlatform.instance.lock(filePath: filePath, userPassword: userPassword, ownerPassword: ownerPassword);
  }

  // need try catch, if path is not exist, it will throw exception
  Future<bool> unlock({required String filePath, required String password}) {
    return PdfWorkerPlatform.instance.unlock(filePath: filePath, password: password);
  }
}
