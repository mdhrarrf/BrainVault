import 'package:flutter/material.dart';
import '../../data/models/folder_model.dart';
import '../../data/repositories/note_repository.dart';

class FolderViewModel extends ChangeNotifier {
  final NoteRepository _noteRepo;

  List<FolderModel> folders = [];
  bool isLoading = false;
  String? errorMessage;

  FolderViewModel(this._noteRepo);

  // Ambil semua folder dari database
  Future<void> fetchFolders() async {
    _setLoading(true);
    try {
      folders = await _noteRepo.getFolders();
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Tambah folder baru
  Future<void> addFolder(String name, String icon, String userId) async {
    _setLoading(true);
    try {
      final newFolder = FolderModel(
        userId: userId,
        name: name,
        iconEmoji: icon,
      );
      await _noteRepo.createFolder(newFolder);
      await fetchFolders(); // Refresh list setelah nambah
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    isLoading = value;
    if (value) errorMessage = null;
    notifyListeners();
  }
}
