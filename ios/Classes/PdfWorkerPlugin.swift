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
      case "isEncryptedByTail":
        guard let args = call.arguments as? [String: Any],
        let filePath = args["filePath"] as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENTS", message: "Missing filePath", details: nil))
        return
      }
      do {
        let isEncrypted = try pdfLocker.isEncryptedByTail(filePath: filePath)
        result(isEncrypted)
      } catch {
        result(FlutterError(code: "FILE_NOT_FOUND", message: "File not found", details: nil))
      }
    case "isEncrypted":
      guard let args = call.arguments as? [String: Any],
        let filePath = args["filePath"] as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENTS", message: "Missing filePath", details: nil))
        return
      }
      do {
        let isEncrypted = try pdfLocker.isEncrypted(filePath: filePath)
        result(isEncrypted)
      } catch {
        result(FlutterError(code: "FILE_NOT_FOUND", message: "File not found", details: nil))
      }
    case "lock":
      guard let args = call.arguments as? [String: Any],
        let filePath = args["filePath"] as? String,
        let userPassword = args["userPassword"] as? String,
        let ownerPassword = args["ownerPassword"] as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENTS", message: "Missing filePath or password", details: nil))
        return
      }
      do {
         try pdfLocker.lock(filePath: filePath, ownerPassword: ownerPassword, userPassword: userPassword)
        result(true)
      } catch {
        result(FlutterError(code: "FILE_NOT_FOUND", message: "File not found", details: nil))
      }
    case "unlock":
      guard let args = call.arguments as? [String: Any],
        let filePath = args["filePath"] as? String,
        let password = args["password"] as? String
      else {
        result(
          FlutterError(
            code: "INVALID_ARGUMENTS", message: "Missing filePath or password", details: nil))
        return
      }
      do {
        let isUnlocked = try pdfLocker.unlock(filePath: filePath, password: password)
        result(isUnlocked)
      } catch {
        result(FlutterError(code: "FILE_NOT_FOUND", message: "File not found", details: nil))
      }
    default:
      result(FlutterMethodNotImplemented)
    }
  }
}
