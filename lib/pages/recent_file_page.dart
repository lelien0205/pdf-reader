import 'package:flutter/material.dart';
import 'package:pdf_reader/components/my_text_field.dart';
import 'package:pdf_reader/components/my_tile.dart';
import 'package:pdf_reader/models/file_model.dart';
import 'package:pdf_reader/models/pdf_provider.dart';
import 'package:pdf_reader/pages/pdf_view_page.dart';
import 'package:provider/provider.dart';

class RecentFilePage extends StatelessWidget {
  const RecentFilePage({super.key});

void openPDF(BuildContext context, FileModel fileModel) {
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
    final recentFiles = context.watch<PDFProvider>().recentFiles;

    return recentFiles.isEmpty
        ? Center(
            child: Text(
              "You haven't opened any files yet.",
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
                  recentFiles.length == 1 ? '${recentFiles.length} File' : '${recentFiles.length} Files',
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: recentFiles.length,
                  itemBuilder: (context, index) {
                    FileModel recentFile = recentFiles[index];
                    return MyTile(
                      fileModel: recentFile,
                      onTap: (fileModel) => openPDF(context, fileModel),
                      onFavoriteToggle: (fileModel) {
                        Provider.of<PDFProvider>(context, listen: false).toggleFavorite(fileModel);
                      },
                    );
                  },
                ),
              ),
            ],
          );
  }
}