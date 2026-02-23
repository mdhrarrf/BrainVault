import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../viewmodels/note_viewmodel.dart';
import '../../data/models/folder_model.dart';
import 'add_note_view.dart';
import 'note_detail_view.dart';

class NoteListView extends StatefulWidget {
  final FolderModel folder;
  const NoteListView({super.key, required this.folder});

  @override
  State<NoteListView> createState() => _NoteListViewState();
}

class _NoteListViewState extends State<NoteListView> {
  @override
  void initState() {
    super.initState();
    // Refresh data setiap kali masuk ke folder ini
    Future.microtask(
      () => context.read<NoteViewModel>().fetchNotes(widget.folder.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteVM = context.watch<NoteViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(widget.folder.name),
        surfaceTintColor: AppColors.background,
      ),
      body: noteVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : noteVM.notes.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: noteVM.notes.length,
              itemBuilder: (context, index) {
                final note = noteVM.notes[index];
                return _buildNoteCard(context, note);
              },
            ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteView(folderId: widget.folder.id!),
            ),
          );
        },
        label: const Text("Catatan Baru"),
        icon: const Icon(Icons.edit_note),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
    );
  }

  // Widget Tampilan saat Folder Kosong
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.note_add_outlined, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            "Belum ada catatan di sini.",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Text(
            "Mulai tulis ide jeniusmu hari ini!",
            style: TextStyle(color: AppColors.textSecondary),
          ),
        ],
      ),
    );
  }

  // Widget Kartu Catatan yang Elegan
  Widget _buildNoteCard(BuildContext context, note) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NoteDetailView(note: note),
              ),
            );
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        note.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.grey,
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // AI Summary Bubble (Tanda aplikasi canggih)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.aiBubble,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.auto_awesome,
                        size: 14,
                        color: AppColors.primary,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          note.aiSummary ?? "Meringkas ide kamu...",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // Footer: Tanggal atau info lainnya
                Text(
                  "Klik untuk detail selengkapnya",
                  style: TextStyle(fontSize: 11, color: Colors.grey[400]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
