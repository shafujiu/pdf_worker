import Flutter
import UIKit

public class PdfWorkerPlugin: NSObject, FlutterPlugin {
    let pdfLocker = PdfLocker()
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "pdf_worker", binaryMessenger: registrar.messenger())
    let instance = PdfWorkerPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    switch call.method {
    case "getPlatformVersion":
      result("iOS " + UIDevice.current.systemVersion)
    case "isEncrypted":
      guard let args = call.arguments as? [String: Any],
        let filePath = args["filePath"] as? String,
        let password = args["password"] as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENTS", message: "Missing filePath or password", details: nil))
        return
      }
      let result = pdfLocker.isEncrypted(filePath: filePath)
      result(result)
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
