import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // Importe o pacote
import '../../theme/app_colors.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../dashboard/dashboard_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _userIdController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _userIdController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.branco,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/voltion_logo.png',
                  height: 100,
                  semanticLabel: 'Logotipo VoltionHub',
                ),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: _userIdController,
                  labelText: 'ID do Usuário',
                  icon: Icons.person_outline,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: 'Senha',
                  icon: Icons.lock_outline,
                  isPassword: true,
                ),
                const SizedBox(height: 24),
                CustomButton(
                  text: 'Entrar',
                  onPressed: () {
                    if (_userIdController.text == 'eu' &&
                        _passwordController.text == '123') {
                          Navigator.push(context, MaterialPageRoute(
                            builder: (context) => DashboardScreen(),
                          ));
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'Esqueci minha senha',
                    // Aplica a fonte e o estilo usando o pacote.
                    style: GoogleFonts.inter(
                      color: AppColors.laranjaVoltion,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}