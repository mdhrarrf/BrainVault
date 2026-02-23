import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/folder_model.dart';
import '../models/note_model.dart';
import '../../core/constants/app_constants.dart';

class NoteRepository {
  final _client = Supabase.instance.client;

  // AMBIL SEMUA FOLDER
  Future<List<FolderModel>> getFolders() async {
    try {
      final response = await _client
          .from(AppConstants.tableFolders)
          .select()
          .order('created_at', ascending: false);

      return (response as List)
          .map((json) => FolderModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal ambil folder: $e');
    }
  }

  // BUAT FOLDER BARU
  Future<void> createFolder(FolderModel folder) async {
    try {
      // Pastikan AppConstants.tableFolders isinya 'folders'
      await _client.from('folders').insert(folder.toJson());
    } catch (e) {
      print("LOG ERROR REPO: $e"); // Cek ini di Debug Console VS Code
      throw Exception('Gagal buat folder: $e');
    }
  }

  // AMBIL NOTES BERDASARKAN FOLDER
  Future<List<NoteModel>> getNotesByFolder(int folderId) async {
    try {
      final response = await _client
          .from(AppConstants.tableNotes)
          .select()
          .eq('folder_id', folderId);

      return (response as List)
          .map((json) => NoteModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Gagal ambil catatan: $e');
    }
  }

  // TAMBAH CATATAN BARU
  Future<void> addNote(NoteModel note) async {
    try {
      await _client.from(AppConstants.tableNotes).insert(note.toJson());
    } catch (e) {
      throw Exception('Gagal simpan catatan: $e');
    }
  }
}
