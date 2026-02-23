class NoteModel {
  final int? id;
  final int folderId;
  final String title;
  final String content;
  final String? imageGdriveUrl;
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

  // Ambil data dari DB
  factory NoteModel.fromJson(Map<String, dynamic> json) {
    return NoteModel(
      id: json['id'],
      folderId: json['folder_id'],
      title: json['title'],
      content: json['content'] ?? '',
      imageGdriveUrl: json['image_gdrive_url'],
      aiSummary: json['ai_summary'],
      isFavorite: json['is_favorite'] ?? false,
    );
  }

  // Siapkan data untuk DB
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'folder_id': folderId,
      'title': title,
      'content': content,
      'image_gdrive_url': imageGdriveUrl,
      'ai_summary': aiSummary,
      'is_favorite': isFavorite,
    };
  }
}
