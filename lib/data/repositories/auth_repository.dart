import 'package:supabase_flutter/supabase_flutter.dart';

class AuthRepository {
  final _client = Supabase.instance.client;

  // Login pakai email
  Future<AuthResponse> signIn(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Gagal login: $e');
    }
  }

  // Daftar akun baru
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    Map<String, dynamic>? data,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: data, // Ini data username buat SQL Trigger
      );
    } catch (e) {
      throw Exception('Gagal daftar: $e');
    }
  }

  // Logout
  Future<void> signOut() async => await _client.auth.signOut();

  // Ambil info user yang lagi login
  User? get currentUser => _client.auth.currentUser;
}
