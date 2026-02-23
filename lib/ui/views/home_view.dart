import 'package:brainvault/ui/views/note_list_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/folder_viewmodel.dart';
import '../viewmodels/auth_viewmodel.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    // Ambil folder pas halaman dibuka
    Future.microtask(() => context.read<FolderViewModel>().fetchFolders());
  }

  @override
  Widget build(BuildContext context) {
    final folderVM = context.watch<FolderViewModel>();
    final authVM = context.read<AuthViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("BrainVault"),
        actions: [
          IconButton(
            onPressed: () => authVM.signOut().then(
              (_) => Navigator.pushReplacementNamed(context, '/login'),
            ),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: folderVM.isLoading
          ? const Center(child: CircularProgressIndicator())
          : GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: folderVM.folders.length,
              itemBuilder: (context, index) {
                final folder = folderVM.folders[index];
                return Card(
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteListView(folder: folder),
                        ),
                      );
                    },
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          folder.iconEmoji,
                          style: const TextStyle(fontSize: 40),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          folder.name,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddFolderDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddFolderDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Folder Baru"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Nama Folder"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Batal"),
          ),
          ElevatedButton(
            onPressed: () async {
              final authVM = context.read<AuthViewModel>();
              final folderVM = context.read<FolderViewModel>();
              
              if (authVM.currentUser != null && nameController.text.isNotEmpty) {
                try {
                  await folderVM.addFolder(
                    nameController.text, 
                    "📁", 
                    authVM.currentUser!.id
                  );
                  Navigator.pop(context); // Tutup dialog
                } catch (e) {
                  // Tampilkan error biar kita tau rusaknya di mana
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Gagal: $e"))
                  );
                }
              }
            },
            child: const Text("Simpan"),
          ),
        ],
      ),
    );
  }
}
