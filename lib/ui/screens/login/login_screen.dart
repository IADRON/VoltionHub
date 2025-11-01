import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:google_fonts/google_fonts.dart';
import '/core/common/constants/app_assets.dart';
import '/core/common/constants/theme/app_colors.dart';
import '/ui/main_navigation.dart';
import '/ui/widgets/button.dart';
import '/ui/widgets/textfield.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() {
      _isPasswordVisible = !_isPasswordVisible;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.background,
        body: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Image.asset(
                    AppAssets.logo,
                    height: 150,
                  ),
                  const Gap(48),
                  CustomTextField(
                    controller: _userIdController,
                    labelText: 'Usuário',
                    icon: Icons.person_outline,
                  ),
                  const Gap(16),
                  CustomTextField(
                    controller: _passwordController,
                    labelText: 'Senha',
                    icon: Icons.lock_outline,
                    isPassword: true,
                    isPasswordVisible: _isPasswordVisible,
                    onVisibilityToggle: _togglePasswordVisibility,
                  ),
                  const Gap(24),
                  CustomButton(
                    text: 'Entrar',
                    onPressed: () {
                        // Implement login logic here
                    },
                  ),
                  const Gap(16),
                  TextButton(
                    onPressed: () {
                      // login sem verificação, para testes, credenciais serão de dev (possui todas as funções)
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MainNavigationScreen(),
                          ),
                        );
                    },
                    child: Text(
                      'Esqueci minha senha',
                      style: GoogleFonts.inter(
                        color: AppColors.orange,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}