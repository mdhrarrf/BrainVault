import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/auth_viewmodel.dart';

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  final _username = TextEditingController();
  bool isRegister = false; // Status: lagi mau login atau daftar?

  @override
  Widget build(BuildContext context) {
    final authVM = context.watch<AuthViewModel>();

    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const Icon(
                Icons.psychology,
                size: 80,
                color: Colors.deepPurpleAccent,
              ),
              const SizedBox(height: 16),
              Text(
                isRegister ? "Daftar BrainVault" : "Masuk BrainVault",
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 32),

              // Field Username cuma muncul kalau lagi mau DAFTAR
              if (isRegister) ...[
                TextField(
                  controller: _username,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
              ],

              TextField(
                controller: _email,
                decoration: const InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _pass,
                decoration: const InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              const SizedBox(height: 24),

              authVM.isLoading
                  ? const CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (isRegister) {
                            await authVM.signUp(
                              _email.text.trim(), // Tambahkan .trim()
                              _pass.text.trim(), // Tambahkan .trim()
                              _username.text.trim(),
                            );
                          } else {
                            await authVM.signIn(_email.text, _pass.text);
                          }

                          if (authVM.errorMessage != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(authVM.errorMessage!)),
                            );
                          } else {
                            // Jika berhasil, pindah ke Home
                            Navigator.pushReplacementNamed(context, '/home');
                          }
                        },
                        child: Text(
                          isRegister ? "Buat Akun" : "Masuk Sekarang",
                        ),
                      ),
                    ),

              // Tombol buat ganti Mode (Login <-> Daftar)
              TextButton(
                onPressed: () => setState(() => isRegister = !isRegister),
                child: Text(
                  isRegister
                      ? "Sudah punya akun? Login"
                      : "Belum punya akun? Daftar",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
