import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_constants.dart';
import 'data/repositories/auth_repository.dart';
import 'data/repositories/note_repository.dart';
import 'ui/viewmodels/auth_viewmodel.dart';
import 'ui/viewmodels/folder_viewmodel.dart';
import 'ui/viewmodels/note_viewmodel.dart';
import 'ui/views/login_view.dart';
import 'ui/views/home_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: AppConstants.supabaseUrl,
    anonKey: AppConstants.supabaseAnonKey,
  );

  runApp(const BrainVaultApp());
}

class BrainVaultApp extends StatelessWidget {
  const BrainVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => AuthRepository()),
        Provider(create: (_) => NoteRepository()),
        ChangeNotifierProvider(
          create: (c) => AuthViewModel(c.read<AuthRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => FolderViewModel(c.read<NoteRepository>()),
        ),
        ChangeNotifierProvider(
          create: (c) => NoteViewModel(c.read<NoteRepository>()),
        ),
      ],
      child: MaterialApp(
        title: 'BrainVault',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorSchemeSeed: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        // Cek user sudah login atau belum
        home: Supabase.instance.client.auth.currentUser == null
            ? const AuthView()
            : const HomeView(),
        routes: {
          '/login': (_) => const AuthView(),
          '/home': (_) => const HomeView(),
        },
      ),
    );
  }
}
