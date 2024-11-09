import 'dart:convert';
import 'dart:io';
import 'package:external_path/external_path.dart';
import 'package:flutter/foundation.dart';
import 'package:pdf_reader/models/file_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PDFProvider with ChangeNotifier {
  final List<FileModel> _allFiles = [];
  final List<FileModel> _recentFiles = [];
  final List<FileModel> _favoriteFiles = [];
  final Set<String> _filePaths = {};
  final String fixedDirectoryPath = '/storage/emulated/0/';
  bool _isLoaded = false;

  List<FileModel> get allFiles => _allFiles;
  List<FileModel> get recentFiles => _recentFiles;
  List<FileModel> get favoriteFiles => _favoriteFiles;

  Future<void> loadPDFFiles() async {
    if (_isLoaded) {
      return;
    }
    _allFiles.clear();
    _filePaths.clear();
    await baseDirectory();
    await _loadFavoriteFiles();
    await _loadRecentFiles();
    _isLoaded = true;
    notifyListeners();
  }

  Future<void> baseDirectory() async {
    DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
    AndroidDeviceInfo androidDeviceInfo = await deviceInfoPlugin.androidInfo;

    // String externalStoragePath = '/storage/emulated/0/';
    String? externalStoragePath = await ExternalPath.getExternalStoragePublicDirectory(ExternalPath.DIRECTORY_DOWNLOADS);

    if (androidDeviceInfo.version.sdkInt < 30) {
      PermissionStatus permissionStatus = await Permission.storage.request();
      if (permissionStatus.isGranted) {
        await getFiles(externalStoragePath);
      } else {
        if (kDebugMode) {
          print("Permission denied");
        }
      }
    } else {
      PermissionStatus permissionStatus = await Permission.manageExternalStorage.request();
      if (permissionStatus.isGranted) {
        await getFiles(externalStoragePath);
      } else {
        if (kDebugMode) {
          print("Permission denied");
        }
      }
    }
  }

  Future<void> getFiles(String directoryPath) async {
    try {
      var rootDirectory = Directory(directoryPath);
      var directories = rootDirectory.list(recursive: true, followLinks: false);

      await for (var entity in directories) {
        if (entity is File) {
          if (entity.path.endsWith(".pdf")) {
            if (!_filePaths.contains(entity.path)) {
              var fileModel = FileModel(file: entity);
              _allFiles.add(fileModel);
              _filePaths.add(entity.path);
            }
          }
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print("Error reading files: $e");
      }
    }
  }

  Future<void> _loadFavoriteFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteFileData = prefs.getString('favorite_file_data') ?? '[]';
    final List<dynamic> favoriteFileList = jsonDecode(favoriteFileData);

    _favoriteFiles.clear();
    for (var fileModel in _allFiles) {
      final isFavorite = favoriteFileList.any((data) => data['path'] == fileModel.file.path);
      fileModel.isFavorite = isFavorite;
      if (isFavorite) {
        _favoriteFiles.add(fileModel);
      }
    }
  }

  Future<void> _loadRecentFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final recentFileData = prefs.getString('recent_file_data') ?? '[]';
    final List<dynamic> recentFileList = jsonDecode(recentFileData);

    _recentFiles.clear();
    for (var data in recentFileList) {
      try {
        var file = File(data['path']);
        if (await file.exists()) {
          var fileModel = FileModel(file: file, isFavorite: data['isFavorite'] ?? false);
          _recentFiles.add(fileModel);
        }
      } catch (e) {
        if (kDebugMode) {
          print("Error loading file: ${data['path']} - $e");
        }
      }
    }
    _recentFiles.sort((a, b) => b.file.lastAccessedSync().compareTo(a.file.lastModifiedSync()));
  }

  Future<void> _saveFavoriteFiles() async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteFileData = _allFiles
        .where((fileModel) => fileModel.isFavorite)
        .map(
          (fileModel) => {
            'path': fileModel.file.path
          },
        )
        .toList();
    final favoriteFileDataString = jsonEncode(favoriteFileData);
    await prefs.setString('favorite_file_data', favoriteFileDataString);
  }

  Future<void> _saveRecentFiles() async {
    final prefs = await SharedPreferences.getInstance();
    _recentFiles.removeWhere((fileModel) => !fileModel.file.existsSync());
    final recentFileData = jsonEncode(
      _recentFiles
          .map((fileModel) => {
                'path': fileModel.file.path,
                'isFavorite': fileModel.isFavorite,
              })
          .toList(),
    );
    await prefs.setString('recent_file_data', recentFileData);
  }

  void toggleFavorite(FileModel fileModel) {
    fileModel.isFavorite = !fileModel.isFavorite;
    if (fileModel.isFavorite) {
      if (!_favoriteFiles.contains(fileModel)) {
        _favoriteFiles.add(fileModel);
      }
    } else {
      _favoriteFiles.remove(fileModel);
    }

    int recentIndex = _recentFiles.indexWhere((file) => file.file.path == fileModel.file.path);
    if (recentIndex != -1) {
      _recentFiles[recentIndex] = fileModel;
    }

    _saveFavoriteFiles();
    _saveRecentFiles();
    notifyListeners();
  }

  void addRecentFile(FileModel fileModel) {
    _recentFiles.removeWhere((file) => file.file.path == fileModel.file.path);
    final isFavorite = _favoriteFiles.any((file) => file.file.path == fileModel.file.path);
    fileModel.isFavorite = isFavorite;
    _recentFiles.insert(0, fileModel);
    _saveRecentFiles();
    notifyListeners();
  }
}
