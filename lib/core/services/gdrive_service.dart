import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GDriveService {
  // PASTE URL WEB APP APPS SCRIPT KAMU DI SINI
  final String _scriptUrl = "https://script.google.com/macros/s/AKfycbz2pobnsYPhpBH1Z37QwxcFbpe_04IcW5DvKATOXH_VvgrdQETIxN39sQOJhjUCSelZfg/exec";

  Future<String?> uploadImage(File imageFile) async {
    try {
      // 1. Ubah gambar jadi teks (Base64)
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // 2. Kirim ke Google Apps Script
      final response = await http.post(
        Uri.parse(_scriptUrl),
        body: {
          'data': base64Image,
          'filename': 'vault_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'filetype': 'image/jpeg',
        },
      );

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success') {
          return resData['url']; // Ini link gambar publiknya
        }
      }
      return null;
    } catch (e) {
      print("GDRIVE ERROR: $e");
      return null;
    }
  }
}
