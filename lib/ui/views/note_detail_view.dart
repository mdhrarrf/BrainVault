import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../data/models/note_model.dart';

class NoteDetailView extends StatelessWidget {
  final NoteModel note;
  const NoteDetailView({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Detail Catatan"),
        backgroundColor: AppColors.background,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Hero Image Section (Jika ada gambar)
            if (note.imageGdriveUrl != null)
              _buildHeroImage(note.imageGdriveUrl!),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 2. Judul Catatan (Ukuran Besar & Bold)
                  Text(
                    note.title,
                    style: const TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Smart AI Summary Box (Modern Glassmorphism Style)
                  _buildAISummaryBox(note.aiSummary),

                  const SizedBox(height: 32),

                  // 4. Content Section
                  const Text(
                    "Catatan Lengkap",
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    note.content,
                    style: TextStyle(
                      fontSize: 17,
                      height: 1.7, // Line height biar enak dibaca
                      color: Colors.grey[800],
                    ),
                  ),

                  const SizedBox(height: 50), // Spasi bawah biar nggak mepet
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget Gambar yang Elegan
  Widget _buildHeroImage(String url) {
    return Container(
      width: double.infinity,
      height: 300,
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Image.network(
          url,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) return child;
            return Container(
              color: Colors.grey[100],
              child: const Center(child: CircularProgressIndicator()),
            );
          },
          errorBuilder: (context, error, stackTrace) => Container(
            color: Colors.grey[200],
            child: const Icon(
              Icons.broken_image_outlined,
              size: 50,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // Widget Box AI Summary yang Mewah
  Widget _buildAISummaryBox(String? summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primary.withOpacity(0.08),
            AppColors.accent.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primary.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.auto_awesome,
                color: AppColors.primary,
                size: 20,
              ),
              const SizedBox(width: 10),
              Text(
                "RINGKASAN AI",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.1,
                  color: AppColors.primary.withOpacity(0.8),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            summary ?? "AI belum memberikan ringkasan.",
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              fontStyle: FontStyle.italic,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
