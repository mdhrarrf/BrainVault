import 'dart:io';
import 'package:flutter/material.dart';
import '../../data/models/note_model.dart';
import '../../data/repositories/note_repository.dart';
import '../../core/services/gemini_service.dart';
import '../../core/services/gdrive_service.dart';

class NoteViewModel extends ChangeNotifier {
  final NoteRepository _noteRepo;

  // Service tambahan buat AI dan Upload
  final GeminiService _gemini = GeminiService();
  final GDriveService _gDrive = GDriveService();

  List<NoteModel> notes = [];
  bool isLoading = false;

  NoteViewModel(this._noteRepo);

  // 1. FUNGSI AMBIL CATATAN (Yang tadi hilang)
  Future<void> fetchNotes(int folderId) async {
    _setLoading(true);
    try {
      notes = await _noteRepo.getNotesByFolder(folderId);
    } catch (e) {
      debugPrint("Gagal ambil notes: $e");
    } finally {
      _setLoading(false);
    }
  }

  // 2. FUNGSI TAMBAH CATATAN (Versi Pintar)
  Future<void> addNote({
    required int folderId,
    required String title,
    required String content,
    File? imageFile,
  }) async {
    _setLoading(true);
    try {
      String? imageUrl;
      String aiSummary = "Menunggu AI...";

      // Upload gambar ke GDrive dulu kalo ada filenya
      if (imageFile != null) {
        imageUrl = await _gDrive.uploadImage(imageFile);
      }

      // Minta Gemini bikinin ringkasan otomatis
      aiSummary = await _gemini.generateSummary(content);

      // Gabungin semua data buat disimpen ke Supabase
      final newNote = NoteModel(
        folderId: folderId,
        title: title,
        content: content,
        imageGdriveUrl: imageUrl,
        aiSummary: aiSummary,
      );

      await _noteRepo.addNote(newNote);

      // Refresh list biar catatan baru langsung muncul
      await fetchNotes(folderId);
    } catch (e) {
      debugPrint("Gagal simpan catatan: $e");
    } finally {
      _setLoading(false);
    }
  }

  // Helper buat ganti status loading
  void _setLoading(bool value) {
    isLoading = value;
    notifyListeners();
  }
}
