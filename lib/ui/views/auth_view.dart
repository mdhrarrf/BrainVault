import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../../core/theme/app_colors.dart'; // Import warna kita

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _username = TextEditingController();
  bool isRegister = false;

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      // Menggunakan warna background dari theme kita
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start, // Rata kiri biar elegan
            children: [
              const SizedBox(height: 60),

              // 1. Icon Logo Box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Icon(
                  Icons.psychology,
                  size: 40,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 30),

              // 2. Judul & Subjudul
              Text(
                isRegister ? "Buat Akun Baru" : "Selamat Datang\nKembali",
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 1.2,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                isRegister
                    ? "Mulai simpan ide jeniusmu hari ini."
                    : "Masuk untuk mengakses semua catatanmu.",
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16,
                ),
              ),

              const SizedBox(height: 40),

              // 3. Form Input dengan Widget Reusable
              if (isRegister) ...[
                _buildTextField(
                  controller: _username,
                  label: "Username",
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 20),
              ],

              _buildTextField(
                controller: _email,
                label: "Email Address",
                icon: Icons.mail_outline,
              ),

              const SizedBox(height: 20),

              _buildTextField(
                controller: _pass,
                label: "Password",
                icon: Icons.lock_outline,
                isPass: true,
              ),

              const SizedBox(height: 40),

              // 4. Tombol Utama
              authVM.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: () async {
                        if (isRegister) {
                          await authVM.signUp(
                            _email.text.trim(),
                            _pass.text.trim(),
                            _username.text.trim(),
                          );
                        } else {
                          await authVM.signIn(
                            _email.text.trim(),
                            _pass.text.trim(),
                          );
                        }

                        if (authVM.errorMessage != null) {
                          _showSnackBar(context, authVM.errorMessage!);
                        } else {
                          Navigator.pushReplacementNamed(context, '/home');
                        }
                      },
                      child: Text(
                        isRegister ? "Daftar Sekarang" : "Masuk ke BrainVault",
                      ),
                    ),

              const SizedBox(height: 25),

              // 5. Switch Mode (Login <-> Daftar)
              Center(
                child: TextButton(
                  onPressed: () => setState(() => isRegister = !isRegister),
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 15,
                      ),
                      children: [
                        TextSpan(
                          text: isRegister
                              ? "Sudah punya akun? "
                              : "Belum punya akun? ",
                        ),
                        TextSpan(
                          text: isRegister ? "Masuk" : "Daftar",
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Reusable untuk Input Field agar kodingan rapi
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPass = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: controller,
          obscureText: isPass,
          decoration: InputDecoration(
            labelText: label,
            prefixIcon: Icon(icon, size: 22),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }
}
