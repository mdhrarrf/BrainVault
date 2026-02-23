class NoteModel {
  final int? id;
  final int folderId;
  final String title;
  final String content;
  final String? imageGdriveUrl; // Nama di Dart
  final String? aiSummary;
  final bool isFavorite;

  NoteModel({
    this.id,
    required this.folderId,
    required this.title,
    required this.content,
    this.imageGdriveUrl,
    this.aiSummary,
    this.isFavorite = false,
  });

  // Ambil data dari Supabase (JSON -> Object)
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      folderId: json['folder_id'],
      title: json['title'],
      content: json['content'] ?? '',
      // SESUAIKAN DENGAN NAMA KOLOM SQL
      imageGdriveUrl: json['image_gdrive_url'],
      aiSummary: json['ai_summary'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  // Kirim data ke Supabase (Object -> JSON)
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'folder_id': folderId,
      'title': title,
      'content': content,
      // INI KUNCINYA! Harus 'image_gdrive_url' pake underscore
      'image_gdrive_url': imageGdriveUrl,
      'ai_summary': aiSummary,
      'is_favorite': isFavorite,
    };
  }
}
