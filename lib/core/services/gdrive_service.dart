import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../constants/app_constants.dart';

class GDriveService {
  Future<String?> uploadImage(File imageFile) async {
    try {
      // Ubah gambar jadi Base64 String
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // Kirim ke Google Apps Script
      final response = await http.post(
        Uri.parse(AppConstants.gDriveScriptUrl),
        body: {
          'filename': 'vault_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'filetype': 'image/jpeg',
          'data': base64Image,
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['url']; // Kembalikan link gambar publik
      }
      return null;
    } catch (e) {
      print("Gagal upload gambar: $e");
      return null;
    }
  }
}
