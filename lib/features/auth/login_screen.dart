import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:iconsax/iconsax.dart';
import '../../core/providers/auth_provider.dart';
import '../../core/constants/app_colors.dart';
import '../../shared/widgets/main_scaffold.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              // Logo
              RichText(text: TextSpan(children: [
                TextSpan(text: 'Kitob',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32, fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface)),
                TextSpan(text: 'Joy',
                  style: GoogleFonts.playfairDisplay(
                    fontSize: 32, fontWeight: FontWeight.w700,
                    color: AppColors.blue)),
              ])),
              const SizedBox(height: 8),
              Text('Xush kelibsiz!',
                style: GoogleFonts.dmSans(
                  fontSize: 16, color: AppColors.getText2(context))),
              const SizedBox(height: 40),

              // Email field
              _buildLabel('Email'),
              const SizedBox(height: 8),
              _buildTextField(
                controller: _emailController,
                hint: 'email@gmail.com',
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
              const SizedBox(height: 12),

              // Forgot password
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Parolni unutdingizmi?',
                    style: GoogleFonts.dmSans(
                      color: AppColors.blue, fontSize: 13)),
                ),
              ),
              const SizedBox(height: 24),

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

              // Login button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: auth.isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  ),
                  child: auth.isLoading
                    ? const SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2))
                    : Text('Kirish',
                        style: GoogleFonts.dmSans(
                          color: Colors.white, fontSize: 15,
                          fontWeight: FontWeight.w600)),
                ),
              ),
              const SizedBox(height: 24),

              // Register link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Hisobingiz yo'qmi? ",
                    style: GoogleFonts.dmSans(
                      color: AppColors.getText2(context), fontSize: 14)),
                  GestureDetector(
                    onTap: () => Navigator.push(context,
                      MaterialPageRoute(
                        builder: (_) => const RegisterScreen())),
                    child: Text("Ro'yxatdan o'ting",
                      style: GoogleFonts.dmSans(
                        color: AppColors.blue, fontSize: 14,
                        fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _login() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) return;
    final success = await context.read<AuthProvider>().login(
      _emailController.text.trim(),
      _passwordController.text,
    );
    if (success && mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainScaffold()),
        (_) => false,
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
