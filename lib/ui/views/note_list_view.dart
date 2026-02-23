import 'package:brainvault/ui/views/add_note_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/note_viewmodel.dart';
import '../../data/models/folder_model.dart';

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
    // Ambil catatan berdasarkan ID folder
    Future.microtask(
      () => context.read<NoteViewModel>().fetchNotes(widget.folder.id!),
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteVM = context.watch<NoteViewModel>();

    return Scaffold(
      appBar: AppBar(title: Text(widget.folder.name)),
      body: noteVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: noteVM.notes.length,
              itemBuilder: (context, index) {
                final note = noteVM.notes[index];
                return ListTile(
                  title: Text(note.title),
                  subtitle: Text(
                    note.aiSummary ?? "Belum ada ringkasan AI",
                    maxLines: 2,
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () {
                    /* Nanti: Lihat detail catatan */
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddNoteView(folderId: widget.folder.id!),
            ),
          );
        },
        child: const Icon(Icons.add_home), // Icon biar pas buat nambah note
      ),
    );
  }
}
