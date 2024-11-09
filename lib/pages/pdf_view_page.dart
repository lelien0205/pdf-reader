import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_reader/models/file_model.dart';
import 'package:pdf_reader/models/pdf_provider.dart';
import 'package:provider/provider.dart';

class PDFViewPage extends StatelessWidget {
  final File file;
  const PDFViewPage({
    super.key,
    required this.file,
  });

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PDFProvider>();
      provider.addRecentFile(FileModel(file: file));
    });
    return Scaffold(
      appBar: AppBar(
        title: Text(file.path.split('/').last.replaceAll('.pdf', '')),
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
