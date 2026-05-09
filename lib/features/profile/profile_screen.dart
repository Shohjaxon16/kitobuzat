import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_provider.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    final themeProvider = context.watch<ThemeProvider>();
    final auth = context.watch<AuthProvider>();
    final user = auth.user;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),
              // Top bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("Profil", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => themeProvider.toggleTheme(),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            width: 38,
                            height: 38,
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Theme.of(context).dividerColor, width: 0.5),
                            ),
                            child: Icon(themeProvider.isDark ? Iconsax.sun_1 : Iconsax.moon, color: AppColors.blue, size: 20),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          width: 38,
                          height: 38,
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: colorScheme.outline, width: 0.5),
                          ),
                          child: Icon(Iconsax.setting, size: 20, color: isDark ? AppColors.darkText : AppColors.lightText),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 30),
              // Avatar
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(colors: [AppColors.blue, AppColors.blueDark], begin: Alignment.topLeft, end: Alignment.bottomRight),
                ),
                alignment: Alignment.center,
                child: Text(user?['fullName']?.toString().substring(0, 1).toUpperCase() ?? "U", style: GoogleFonts.playfairDisplay(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.white)),
              ),
              const SizedBox(height: 12),
              Text(user?['fullName'] ?? "Foydalanuvchi", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(user?['email'] ?? "email@example.uz", style: TextStyle(fontSize: 13, color: AppColors.getText2(context))),
              const SizedBox(height: 30),
              // Stats Card
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  decoration: BoxDecoration(
                    color: colorScheme.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: colorScheme.outline, width: 0.5),
                  ),
                  child: Row(
                    children: [
                      _buildStatItem("24", "Kitob", context),
                      _buildDivider(isDark),
                      _buildStatItem("3", "Ijara", context),
                      _buildDivider(isDark),
                      _buildStatItem("1842", "Sahifa", context),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 30),
              // Menu items
              _MenuItemTile(icon: Iconsax.heart, iconColor: AppColors.blue, iconBg: const Color(0x1F3B82F6), label: "Sevimlilar", onTap: () {}),
              _MenuItemTile(icon: Iconsax.card, iconColor: AppColors.green, iconBg: const Color(0x1F22C55E), label: "To'lov usullari", onTap: () {}),
              _MenuItemTile(icon: Iconsax.document_download, iconColor: AppColors.amber, iconBg: const Color(0x1FF59E0B), label: "Yuklab olinganlar", onTap: () {}),
              _MenuItemTile(icon: Iconsax.notification, iconColor: AppColors.purple, iconBg: const Color(0x1FA855F7), label: "Bildirishnomalar", onTap: () {}),
              _MenuItemTile(
                icon: Iconsax.logout, 
                iconColor: AppColors.red, 
                iconBg: const Color(0x1FEF4444), 
                label: "Chiqish",
                onTap: () => auth.logout(),
              ),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 12, color: AppColors.getText2(context))),
        ],
      ),
    );
  }

  Widget _buildDivider(bool isDark) {
    return Container(width: 1, height: 30, color: isDark ? AppColors.darkBorder : AppColors.lightBorder);
  }
}

class _MenuItemTile extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String label;
  final VoidCallback? onTap;

  const _MenuItemTile({required this.icon, required this.iconColor, required this.iconBg, required this.label, this.onTap});

  @override
  State<_MenuItemTile> createState() => __MenuItemTileState();
}

class __MenuItemTileState extends State<_MenuItemTile> {
  bool _pressed = false;
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapUp: (_) {
          setState(() => _pressed = false);
          widget.onTap?.call();
        },
        onTapCancel: () => setState(() => _pressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          color: _pressed 
              ? Theme.of(context).colorScheme.surface.withOpacity(0.5) 
              : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: widget.iconBg, 
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(widget.icon, color: widget.iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  widget.label,
                  style: GoogleFonts.dmSans(
                    fontSize: 14, 
                    color: Theme.of(context).colorScheme.onSurface,
                    fontWeight: _isHovered ? FontWeight.w600 : FontWeight.w500,
                  ),
                ),
              ),
              AnimatedOpacity(
                duration: const Duration(milliseconds: 200),
                opacity: 0.5,
                child: Icon(Iconsax.arrow_right_3, color: AppColors.getText2(context), size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
