import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepo;

  User? currentUser;
  bool isLoading = false;
  String? errorMessage;

  AuthViewModel(this._authRepo); // Inject repo lewat constructor

  // Cek apakah user udah login atau belum
  void checkAuthStatus() {
    currentUser = _authRepo.currentUser;
    notifyListeners();
  }

  // Proses masuk
  Future<void> signIn(String email, String password) async {
    _setLoading(true);
    try {
      await _authRepo.signIn(email, password);
      currentUser = _authRepo.currentUser;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Proses daftar
  Future<void> signUp(String email, String password, String username) async {
    _setLoading(true);
    try {
      await _authRepo.signUp(
        email: email,
        password: password,
        data: {'username': username}, // Kirim username ke metadata
      );
      errorMessage = null;
    } catch (e) {
      errorMessage = e.toString();
    } finally {
      _setLoading(false);
    }
  }

  // Keluar aplikasi
  Future<void> signOut() async {
    await _authRepo.signOut();
    currentUser = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    isLoading = value;
    if (value) errorMessage = null; // Reset error pas mulai loading
    notifyListeners();
  }
}
