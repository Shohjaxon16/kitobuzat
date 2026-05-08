import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/providers/library_provider.dart';
import '../../core/constants/app_colors.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<LibraryProvider>().loadLibrary();
    });
  }

  @override
  Widget build(BuildContext context) {
    final libraryProvider = context.watch<LibraryProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Mening Kutubxonam", style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
        centerTitle: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: libraryProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.blue))
          : libraryProvider.library.isEmpty
              ? _buildEmptyState()
              : RefreshIndicator(
                  onRefresh: () => libraryProvider.loadLibrary(),
                  child: ListView.builder(
                    padding: const EdgeInsets.all(20),
                    itemCount: libraryProvider.library.length,
                    itemBuilder: (context, index) {
                      final item = libraryProvider.library[index];
                      return _buildLibraryItem(item);
                    },
                  ),
                ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.book_outlined, size: 64, color: Colors.grey),
          const SizedBox(height: 16),
          Text("Hali kitoblaringiz yo'q", style: GoogleFonts.dmSans(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildLibraryItem(Map<String, dynamic> item) {
    final book = item['book'];
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              gradient: const LinearGradient(colors: [AppColors.blue, AppColors.blueLight]),
            ),
            child: const Icon(Icons.book, color: Colors.white),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(book['title'] ?? 'Noma\'lum', style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(book['author'] ?? 'Noma\'lum muallif', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (item['currentPage'] ?? 0) / (book['totalPages'] ?? 100),
                  backgroundColor: Colors.grey.withOpacity(0.2),
                  valueColor: const AlwaysStoppedAnimation(AppColors.blue),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
