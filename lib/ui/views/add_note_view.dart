import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
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

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (pickedFile != null) {
      setState(() => _selectedImage = File(pickedFile.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final noteVM = context.watch<NoteViewModel>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Tulis Catatan"),
        backgroundColor: AppColors.background,
        actions: [
          // Tombol simpan di pojok kanan atas (Gaya iOS/Modern)
          if (!noteVM.isLoading)
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: TextButton(
                onPressed: _handleSave,
                child: const Text(
                  "Simpan",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ),
        ],
      ),
      body: noteVM.isLoading
          ? _buildLoadingState()
          : SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),

                  // 1. Input Judul (Tanpa Border Biar Kayak Editor Beneran)
                  TextField(
                    controller: _title,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                    decoration: const InputDecoration(
                      hintText: "Judul Catatan...",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),

                  const Divider(height: 30, thickness: 0.5),

                  // 2. Input Konten
                  TextField(
                    controller: _content,
                    maxLines: null, // Auto expand
                    style: const TextStyle(fontSize: 18, height: 1.6),
                    decoration: const InputDecoration(
                      hintText: "Mulai mengetik ide jeniusmu di sini...",
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      filled: false,
                    ),
                  ),

                  const SizedBox(height: 30),

                  // 3. Media Picker Section
                  _buildImagePicker(),

                  const SizedBox(height: 100), // Spasi buat scroll
                ],
              ),
            ),
    );
  }

  // Fungsi Logic Simpan
  void _handleSave() async {
    if (_title.text.isEmpty || _content.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Judul dan isi tidak boleh kosong!")),
      );
      return;
    }

    final noteVM = context.read<NoteViewModel>();
    await noteVM.addNote(
      folderId: widget.folderId,
      title: _title.text,
      content: _content.text,
      imageFile: _selectedImage,
    );

    if (mounted) Navigator.pop(context);
  }

  // Widget Loading yang Elegan
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: AppColors.primary),
          const SizedBox(height: 20),
          const Text(
            "Gemini sedang merangkum...",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          Text(
            "Mohon tunggu sebentar",
            style: TextStyle(color: Colors.grey[500], fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Widget Image Picker yang Rapi
  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_selectedImage != null)
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: kIsWeb
                    ? Image.network(
                        _selectedImage!.path,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      )
                    : Image.file(
                        _selectedImage!,
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: GestureDetector(
                  onTap: () => setState(() => _selectedImage = null),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.close,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          )
        else
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 30),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.grey[300]!,
                  style: BorderStyle.solid,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.add_photo_alternate_outlined,
                    size: 40,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Tambah Foto",
                    style: TextStyle(color: Colors.grey[500]),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
