import 'dart:io';

class FileModel {
  final File file;
  bool isFavorite;

  FileModel({
    required this.file,
    this.isFavorite = false,
  });
}
