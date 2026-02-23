import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class GDriveService {
  final String _scriptUrl = "https://script.google.com/macros/s/AKfycbzwcSAb9MvcrwRc9TWiSJkyu-9_GUN2-cSqjKH-l2RMbtaaby54nHWzFxi9mDPAmYPMeA/exec";

  Future<String?> uploadImage(File imageFile) async {
    try {
      print("GDRIVE: Membaca byte...");
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);

      // 1. Kirim POST Pertama
      var response = await http.post(
        Uri.parse(_scriptUrl),
        body: {
          'data': base64Image,
          'filename': 'vault_${DateTime.now().millisecondsSinceEpoch}.jpg',
          'filetype': 'image/jpeg',
        },
      );

      print("GDRIVE STATUS AWAL: ${response.statusCode}");

      // 2. JURUS PINDAH KAMAR: Jika dapet 302, kejar link-nya!
      if (response.statusCode == 302) {
        // Ambil link baru dari header 'location'
        String? newUrl = response.headers['location'];
        if (newUrl != null) {
          print("GDRIVE: Mengejar link redirect...");
          // Kita tembak link baru pake GET (Google maunya gitu)
          response = await http.get(Uri.parse(newUrl));
        }
      }

      print("GDRIVE FINAL STATUS: ${response.statusCode}");
      print("GDRIVE FINAL BODY: ${response.body}");

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'success') {
          print("MANTAP! LINK TEMBUS: ${resData['url']}");
          return resData['url'];
        }
      }
      return null;
    } catch (e) {
      print("GDRIVE ERROR: $e");
      return null;
    }
  }
}