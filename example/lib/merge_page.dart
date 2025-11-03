import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_worker/pdf_worker.dart';
import 'package:pdfrx/pdfrx.dart';

class MergeController extends GetxController {
  final _pdfWorkerPlugin = PdfWorker();
  Rx<PdfDocumentRef?> docRef = Rx(null);
  late final String tempFilePath;
  @override
  void onInit() {
    super.onInit();

    _copyAssetToTemp(
      assetPath: 'assets/Swift PDF Example.pdf',
      tempName: 'swift_pdf_example.pdf',
    );
  }

  void _copyAssetToTemp({
    required String assetPath,
    required String tempName,
  }) async {
    final byteData = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final file = File('${tempDir.path}/$tempName')
      ..createSync(recursive: true)
      ..writeAsBytesSync(byteData.buffer.asUint8List());
    tempFilePath = file.path;
  }

  Future<void> choosePagesToMerge() async {
    try {
      final inputPath = tempFilePath;
      final pagesIndex = [1, 2];
      final tempDir = await getTemporaryDirectory();
      final outputPath = '${tempDir.path}/merged.pdf';
      final result = await _pdfWorkerPlugin.choosePagesIndexToMerge(
        inputPath: inputPath,
        outputPath: outputPath,
        pagesIndex: pagesIndex,
      );
      if (result != null) {
        docRef.value = PdfDocumentRefFile(result);
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<void> mergePdfFiles() async {
    try {
      final tempDir = await getTemporaryDirectory();
      final mergedPath = '${tempDir.path}/merged.pdf'; // 1,2
      final outputPath = '${tempDir.path}/files_merged.pdf';
      final filesPath = [tempFilePath, mergedPath];
      final result = await _pdfWorkerPlugin.mergePdfFiles(
        filesPath: filesPath,
        outputPath: outputPath,
      );

        docRef.value = PdfDocumentRefFile(result);
      
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

class MergePage extends GetView<MergeController> {
  const MergePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Merge Page')),
      body: Column(
        children: [
          ElevatedButton(onPressed: () async {controller.choosePagesToMerge();}, child: const Text('Choose Pages To Merge')),

          ElevatedButton(onPressed: () async {controller.mergePdfFiles();}, child: const Text('Merge PDF Files')),
          Obx(
            () => Expanded(
              child: controller.docRef.value != null
                  ? PdfViewer(controller.docRef.value!)
                  : const Center(child: Text('No PDF')),
            ),
          ),
        ],
      ),
    );
  }
}
