import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'pdf_worker_method_channel.dart';

abstract class PdfWorkerPlatform extends PlatformInterface {
  /// Constructs a PdfWorkerPlatform.
  PdfWorkerPlatform() : super(token: _token);

  static final Object _token = Object();

  static PdfWorkerPlatform _instance = MethodChannelPdfWorker();

  /// The default instance of [PdfWorkerPlatform] to use.
  ///
  /// Defaults to [MethodChannelPdfWorker].
  static PdfWorkerPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [PdfWorkerPlatform] when
  /// they register themselves.
  static set instance(PdfWorkerPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }

  // lock & unlock
  /// pdf is encrypted or not
  /// filePath: pdf file path
  /// return: is encrypted
  Future<bool> isEncrypted({required String filePath}) {
    throw UnimplementedError('isEncrypted() has not been implemented.');
  }

  /// lock pdf
  /// filePath: pdf file path
  /// password: pdf password
  /// return: lock result
  Future<bool> lock({required String filePath, required String password}) {
    throw UnimplementedError('lock() has not been implemented.');
  }

  /// unlock pdf
  /// filePath: pdf file path
  /// password: pdf password
  /// return: unlock result
  Future<bool> unlock({required String filePath, required String password}) {
    throw UnimplementedError('unlock() has not been implemented.');
  }
}
