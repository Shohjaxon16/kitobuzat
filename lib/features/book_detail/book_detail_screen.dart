import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/constants/app_colors.dart';
import '../../models/book.dart';

class BookDetailScreen extends StatefulWidget {
  final Book? book;
  const BookDetailScreen({super.key, this.book});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  String _selectedOption = 'buy';
  bool _ctaPressed = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final book = widget.book ?? const Book(
      title: "O'tkan Kunlar",
      author: "Abdulla Qodiriy",
      coverGradient: [Color(0xFF1E3A8A), Color(0xFF3B82F6)],
      rating: 4.6,
      price: "35 000",
    );

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header Stack
            Stack(
              children: [
                Container(
                  height: 260,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: book.coverGradient.length >= 2 
                        ? [book.coverGradient[0], book.coverGradient[1]]
                        : [const Color(0xFF1E3A8A), const Color(0xFF3B82F6)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 50,
                  left: 20,
                  right: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        book.title,
                        style: GoogleFonts.playfairDisplay(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Text(
                        "${book.author} · 1925",
                        style: GoogleFonts.dmSans(
                          fontSize: 14,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 50,
                  left: 20,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Iconsax.arrow_left, color: Colors.white, size: 22),
                    ),
                  ),
                ),
                Positioned(
                  top: 50,
                  right: 20,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Iconsax.heart, color: Colors.white, size: 22),
                  ),
                ),
              ],
            ),
            // Content
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Stats Row
                  Transform.translate(
                    offset: const Offset(0, -30),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: colorScheme.outline, width: 0.5),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10)),
                        ],
                      ),
                      child: Row(
                        children: [
                          _buildStatItem("${book.rating} ⭐", "Reyting", isDark),
                          _buildDivider(isDark),
                          _buildStatItem("287", "Sahifa", isDark),
                          _buildDivider(isDark),
                          _buildStatItem("2.1K", "O'quvchi", isDark),
                        ],
                      ),
                    ),
                  ),
                  const Text("Kitob haqida", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 12),
                  Text(
                    "\"${book.title}\" - o'zbek adabiyotining durdonalaridan biri bo'lib, unda sevgi, sadoqat va milliy an'analar mahorat bilan tasvirlangan. Asar o'zbek romanchiligining asoschisi Abdulla Qodiriy tomonidan yozilgan.",
                    style: GoogleFonts.dmSans(fontSize: 13, color: AppColors.getText2(context), height: 1.65),
                  ),
                  const SizedBox(height: 24),
                  // Price Selection
                  Row(
                    children: [
                      _buildPriceOption(
                        type: 'buy',
                        label: "Sotib olish",
                        price: book.price,
                        sub: "so'm · abadiy",
                      ),
                      const SizedBox(width: 12),
                      _buildPriceOption(
                        type: 'rent',
                        label: "Ijaraga olish",
                        price: "8 500",
                        sub: "so'm / oyiga",
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  // CTA Button
                  _buildCTAButton(book.price),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceOption({required String type, required String label, required String price, required String sub}) {
    final isSelected = _selectedOption == type;
    final colorScheme = Theme.of(context).colorScheme;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedOption = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.blue.withOpacity(0.08) : colorScheme.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isSelected ? AppColors.blue : colorScheme.outline,
              width: isSelected ? 1.5 : 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: GoogleFonts.dmSans(fontSize: 12, color: AppColors.getText2(context))),
              const SizedBox(height: 4),
              Text(price, style: GoogleFonts.dmSans(fontSize: 18, fontWeight: FontWeight.w700, color: colorScheme.onSurface)),
              Text(sub, style: GoogleFonts.dmSans(fontSize: 11, color: AppColors.getText2(context))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCTAButton(String price) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _ctaPressed = true),
      onTapUp: (_) => setState(() => _ctaPressed = false),
      onTapCancel: () => setState(() => _ctaPressed = false),
      child: AnimatedScale(
        scale: _ctaPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: double.infinity,
          height: 52,
          decoration: BoxDecoration(
            color: _ctaPressed ? AppColors.blueDark : AppColors.blue,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Iconsax.shopping_cart, color: Colors.white, size: 20),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Text(
                  key: ValueKey(_selectedOption),
                  _selectedOption == 'buy' ? "Sotib olish — $price so'm" : "Ijaraga olish — 8 500 so'm/oy",
                  style: GoogleFonts.dmSans(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, bool isDark) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: AppColors.getText2(context))),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(
      width: 1,
      height: 30,
      color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
    );
  }
}
