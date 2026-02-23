class FolderModel {
  final int? id; // Nullable karena pas buat baru, ID belum ada
  final String userId;
  final String name;
  final String iconEmoji;

  FolderModel({
    this.id,
    required this.userId,
    required this.name,
    required this.iconEmoji,
  });

  // Ubah JSON dari Supabase jadi Object Dart
  factory FolderModel.fromJson(Map<String, dynamic> json) {
    return FolderModel(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      iconEmoji: json['icon_emoji'] ?? '📁',
    );
  }

  // Ubah Object Dart jadi JSON buat dikirim ke Supabase
  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'user_id': userId,
      'name': name,
      'icon_emoji': iconEmoji,
    };
  }
}
