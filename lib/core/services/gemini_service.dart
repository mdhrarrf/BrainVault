import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class GeminiService {
  final String _apiKey = 'AIzaSyDTILwu9h5FS9_nKf8gurbX54ak81Iim6c';

  Future<String> generateSummary(String content) async {
    try {
      // KITA PAKAI MODEL YANG ADA DI LIST KAMU TADI: gemini-flash-latest
      final String url =
          'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-latest:generateContent?key=$_apiKey';

      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {
                  "text":
                      "Ringkas catatan ini dalam maksimal 15 kata: $content",
                },
              ],
            },
          ],
        }),
      );

      print("DEBUG STATUS FINAL: ${response.statusCode}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['candidates'][0]['content']['parts'][0]['text'];
      } else {
        print("ERROR DETAIL: ${response.body}");
        // Jika flash-latest sibuk, coba pakai lite-latest (cadangan kedua dari list kamu)
        return await _generateWithLite(content);
      }
    } catch (e) {
      print("EXCEPTION: $e");
      return "AI sedang offline.";
    }
  }

  // CADANGAN: Pakai gemini-flash-lite-latest (ada di list kamu tadi)
  Future<String> _generateWithLite(String content) async {
    final String urlLite =
        'https://generativelanguage.googleapis.com/v1beta/models/gemini-flash-lite-latest:generateContent?key=$_apiKey';
    final res = await http.post(
      Uri.parse(urlLite),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": "Ringkas dalam 10 kata: $content"},
            ],
          },
        ],
      }),
    );
    if (res.statusCode == 200) {
      final data = jsonDecode(res.body);
      return data['candidates'][0]['content']['parts'][0]['text'];
    }
    return "Gagal meringkas (${res.statusCode})";
  }
}
