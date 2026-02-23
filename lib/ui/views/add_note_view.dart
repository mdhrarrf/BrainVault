import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../viewmodels/note_viewmodel.dart';

class AddNoteView extends StatefulWidget {
  final int folderId;
  const AddNoteView({super.key, required this.folderId});

  @override
  State<AddNoteView> createState() => _AddNoteViewState();
}

class _AddNoteViewState extends State<AddNoteView> {
  final _title = TextEditingController();
  final _content = TextEditingController();
  File? _selectedImage;

  // Fungsi pilih gambar dari galeri
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteVM = context.watch<NoteViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Catatan Baru")),
      body: noteVM.isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 10),
                  Text("Gemini sedang berpikir... 🧠"),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _title,
                    decoration: const InputDecoration(labelText: "Judul"),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _content,
                    decoration: const InputDecoration(labelText: "Isi Catatan"),
                    maxLines: 5,
                  ),
                  const SizedBox(height: 20),

                  // Preview Gambar
                  _selectedImage != null
                      ? (kIsWeb
                            ? Image.network(
                                _selectedImage!.path,
                                height: 200,
                              ) // Jika di Web pakai Network (Blob URL)
                            : Image.file(
                                _selectedImage!,
                                height: 200,
                              )) // Jika di HP pakai File
                      : OutlinedButton.icon(
                          onPressed: _pickImage,
                          icon: const Icon(Icons.image),
                          label: const Text("Tambah Gambar"),
                        ),

                  const SizedBox(height: 32),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (_title.text.isEmpty || _content.text.isEmpty) return;
                        
                        await noteVM.addNote(
                          folderId: widget.folderId,
                          title: _title.text,
                          content: _content.text,
                          imageFile: _selectedImage, // <--- PASTIKAN INI ADA & TIDAK TYPO
                        );
                        
                        if (mounted) Navigator.pop(context);
                      },
                      child: const Text("Simpan & Rangkum (AI)"),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
