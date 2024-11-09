import 'package:flutter/material.dart';
import 'package:pdf_reader/components/my_text_field.dart';
import 'package:pdf_reader/components/my_tile.dart';
import 'package:pdf_reader/models/file_model.dart';
import 'package:pdf_reader/models/pdf_provider.dart';
import 'package:pdf_reader/pages/pdf_view_page.dart';
import 'package:provider/provider.dart';

class AllFilePage extends StatefulWidget {
  const AllFilePage({super.key});

  @override
  State<AllFilePage> createState() => _AllFilePageState();
}

class _AllFilePageState extends State<AllFilePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        Provider.of<PDFProvider>(context, listen: false).loadPDFFiles();
      },
    );
  }

  void openPDF(FileModel fileModel) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PDFViewPage(
          file: fileModel.file,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final files = context.watch<PDFProvider>().allFiles;

    return Center(
      child: files.isEmpty
          ? Center(
              child: Text(
                "There's no PDF file in your device.",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inverseSurface,
                ),
              ),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: MyTextField(
                    hintText: 'Search',
                    borderRadius: 50.0,
                    suffixIcon: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.search_rounded,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Text(
                    files.length == 1 ? '${files.length} File' : '${files.length} Files',
                  ),
                ),
                Consumer<PDFProvider>(
                  builder: (context, value, child) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: files.length,
                        itemBuilder: (context, index) {
                          FileModel pdfFileModel = value.allFiles[index];
                          return MyTile(
                            fileModel: pdfFileModel,
                            onTap: (fileModel) => openPDF(fileModel),
                            onFavoriteToggle: (fileModel) {
                              value.toggleFavorite(fileModel); // Gọi toggleFavorite
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
    );
  }
}
