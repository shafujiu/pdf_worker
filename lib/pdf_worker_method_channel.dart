import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'pdf_worker_platform_interface.dart';

/// An implementation of [PdfWorkerPlatform] that uses method channels.
class MethodChannelPdfWorker extends PdfWorkerPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('pdf_worker');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>(
      'getPlatformVersion',
    );
    return version;
  }

  @override
  Future<bool> isEncrypted({required String filePath}) async {
    try {
      final bool result = await methodChannel.invokeMethod('isEncrypted', {
        'filePath': filePath,
      });
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to check if PDF is encrypted: '${e.message}'.");
      }
      rethrow;
    }
  }

  @override
  Future<bool> lock({required String filePath, required String password}) async {
    try {
      final bool result = await methodChannel.invokeMethod('lock', {
        'filePath': filePath,
        'password': password,
      });
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to lock PDF: '${e.message}'.");
      }
      rethrow;
    }
  }

  @override
  Future<bool> unlock({required String filePath, required String password}) async {
    try {
      final bool result = await methodChannel.invokeMethod('unlock', {
        'filePath': filePath,
        'password': password,
      });
      return result;
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print("Failed to unlock PDF: '${e.message}'.");
      }
      rethrow;
    }
  }
}
