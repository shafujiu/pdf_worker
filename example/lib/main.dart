import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf_worker_example/locker_page.dart';
import 'package:pdf_worker_example/merge_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: MergePage(),
      initialBinding: BindingsBuilder(
        () {
          Get.put(LockerController());
          Get.put(MergeController());
        },
      ),
    );
  }
}

// class _MyAppState extends State<MyApp> {
//   String _platformVersion = 'Unknown';
//   final _pdfWorkerPlugin = PdfWorker();

//   @override
//   void initState() {
//     super.initState();
//     initPlatformState();
//   }

//   // Platform messages are asynchronous, so we initialize in an async method.
//   Future<void> initPlatformState() async {
//     String platformVersion;
//     // Platform messages may fail, so we use a try/catch PlatformException.
//     // We also handle the message potentially returning null.
//     try {
//       platformVersion =
//           await _pdfWorkerPlugin.getPlatformVersion() ?? 'Unknown platform version';
//     } on PlatformException {
//       platformVersion = 'Failed to get platform version.';
//     }

//     // If the widget was removed from the tree while the asynchronous platform
//     // message was in flight, we want to discard the reply rather than calling
//     // setState to update our non-existent appearance.
//     if (!mounted) return;

//     setState(() {
//       _platformVersion = platformVersion;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//         appBar: AppBar(
//           title: const Text('Plugin example app'),
//         ),
//         body: Column(
//           children: [
//             Text('Running on: $_platformVersion\n'),
//             ElevatedButton(
//               onPressed: () async {
//                 // 获取assets/Swift PDF Example.pdf的路径
//                 final path = 'assets/Swift PDF Example.pdf';
//                 final result = await _pdfWorkerPlugin.isEncrypted(filePath: path);
//                 setState(() {
//                   _platformVersion = result.toString();
//                 });
//               },
//               child: const Text('Check if PDF is encrypted'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
