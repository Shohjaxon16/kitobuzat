import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hugeicons/hugeicons.dart';
import '../../features/home/home_screen.dart';
import '../../features/library/library_screen.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/auth/login_screen.dart';
import '../../core/theme/auth_provider.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final auth = context.watch<AuthProvider>();

    final List<Widget> screens = [
      const HomeScreen(),
      auth.isAuthenticated ? const LibraryScreen() : const LoginScreen(),
      const Center(child: Text("Qidirish (Tez kunda)")),
      auth.isAuthenticated ? const ProfileScreen() : const LoginScreen(),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: screens,
      ),
      bottomNavigationBar: Container(
        height: 85,
        margin: const EdgeInsets.fromLTRB(20, 0, 20, 25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface.withOpacity(0.9),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isDark 
                ? Colors.white.withOpacity(0.05) 
                : Colors.black.withOpacity(0.05),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
              blurRadius: 25,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
            child: Theme(
              data: Theme.of(context).copyWith(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                splashFactory: NoSplash.splashFactory,
              ),
              child: BottomNavigationBar(
                currentIndex: _selectedIndex,
                onTap: (index) => setState(() => _selectedIndex = index),
                type: BottomNavigationBarType.fixed,
                selectedItemColor: AppColors.blue,
                unselectedItemColor: isDark 
                    ? AppColors.darkText2.withOpacity(0.4) 
                    : AppColors.lightText2.withOpacity(0.4),
                backgroundColor: Colors.transparent,
                elevation: 0,
                selectedFontSize: 11,
                unselectedFontSize: 11,
                showSelectedLabels: true,
                showUnselectedLabels: true,
                selectedLabelStyle: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
                unselectedLabelStyle: GoogleFonts.dmSans(
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.2,
                ),
                items: [
                  _buildNavItem(
                    index: 0,
                    icon: HugeIcons.strokeRoundedHome01,
                    label: "Bosh sahifa",
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 1,
                    icon: HugeIcons.strokeRoundedBook02,
                    label: "Kutubxona",
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 2,
                    icon: HugeIcons.strokeRoundedSearch01,
                    label: "Qidirish",
                    isDark: isDark,
                  ),
                  _buildNavItem(
                    index: 3,
                    icon: HugeIcons.strokeRoundedUser,
                    label: "Profil",
                    isDark: isDark,
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }

  BottomNavigationBarItem _buildNavItem({
    required int index,
    required List<List<dynamic>> icon,
    required String label,
    required bool isDark,
  }) {
    final isSelected = _selectedIndex == index;
    return BottomNavigationBarItem(
      icon: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: HugeIcon(
          icon: icon,
          color: isSelected 
              ? AppColors.blue 
              : (isDark ? AppColors.darkText2.withOpacity(0.4) : AppColors.lightText2.withOpacity(0.4)),
          size: 22,
        ),
      ),
      label: label,
    );
  }
}
