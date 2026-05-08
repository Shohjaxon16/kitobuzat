import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.colorScheme.onSurface, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Ro'yxatdan o'tish",
                style: GoogleFonts.playfairDisplay(
                  fontSize: 32, fontWeight: FontWeight.w700,
                  color: theme.colorScheme.onSurface)),
              const SizedBox(height: 8),
              Text('Yangi hisob yarating',
                style: GoogleFonts.dmSans(
                  fontSize: 16, color: AppColors.getText2(context))),
              const SizedBox(height: 32),

              // Full Name field
              _buildLabel('To\'liq ism'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _fullNameController,
                hint: 'Shohjahon',
                icon: Iconsax.user,
              ),
              const SizedBox(height: 20),

              // Email field
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'shohjahon@gmail.com',
                icon: Iconsax.sms,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),

              // Password field
              _buildLabel('Parol'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _passwordController,
                hint: '••••••••',
                icon: Iconsax.lock,
                obscure: _obscurePassword,
                suffix: IconButton(
                  icon: Icon(
                    _obscurePassword ? Iconsax.eye_slash : Iconsax.eye,
                    color: AppColors.getText2(context), size: 20),
                  onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              const SizedBox(height: 32),

              // Error message
              if (auth.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: AppColors.red.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: AppColors.red.withOpacity(0.3)),
                  ),
                  child: Text(auth.error!,
                    style: GoogleFonts.dmSans(
                      color: AppColors.red, fontSize: 13)),
                ),

              // Register button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  ),
                  child: auth.isLoading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                    : Text("Ro'yxatdan o'tish",
                        style: GoogleFonts.dmSans(
                          color: Colors.white, fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _register() async {
    if (_emailController.text.isEmpty || 
        _passwordController.text.isEmpty || 
        _fullNameController.text.isEmpty) return;
    
    final success = await context.read<AuthProvider>().register(
      _emailController.text.trim(),
      _passwordController.text,
      _fullNameController.text.trim(),
    );
    
    if (success && mounted) {
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text("Muvaffaqiyatli!"),
          content: const Text("Emailingizga tasdiqlash xati yuborildi. Iltimos, uni tasdiqlang va tizimga kiring."),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  Widget _buildLabel(String text) => Text(text,
    style: GoogleFonts.dmSans(
      fontSize: 14, fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onSurface));

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool obscure = false,
    Widget? suffix,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: Theme.of(context).dividerColor, width: 0.5),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        style: GoogleFonts.dmSans(
          fontSize: 14,
          color: Theme.of(context).colorScheme.onSurface),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.dmSans(
            color: AppColors.getText2(context), fontSize: 14),
          prefixIcon: Icon(icon,
            color: AppColors.getText2(context), size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
