import 'package:flutter/material.dart';
import '../../core/app_theme.dart'; // Importa nosso tema customizado.

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // A tela de login pode usar o Azul Voltion como fundo para alto contraste[cite: 24].
    return Scaffold(
      backgroundColor: AppTheme.azulVoltion,
      body: SafeArea(
        // O layout deve ser centralizado e limpo[cite: 56].
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logotipo da VoltionHub em destaque no centro[cite: 57].
                Image.asset(
                  'assets/images/voltion_logo.png',
                  height: 80, // Ajuste a altura conforme necessário
                ),
                const SizedBox(height: 60),

                // Campo para "ID do Usuário"[cite: 57].
                TextFormField(
                  style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.branco),
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'ID do Usuário',
                  ),
                ),
                const SizedBox(height: 20),

                // Campo para "Senha"[cite: 57].
                TextFormField(
                  obscureText: true,
                  style: AppTheme.textTheme.bodyLarge?.copyWith(color: AppTheme.branco),
                  decoration: AppTheme.inputDecoration.copyWith(
                    labelText: 'Senha',
                  ),
                ),
                const SizedBox(height: 40),

                // Botão "Entrar" com a cor primária Laranja Voltion[cite: 58].
                // Este é um botão primário com fundo laranja e texto branco[cite: 106].
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppTheme.laranjaVoltion,
                    foregroundColor: AppTheme.branco,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Lógica de autenticação aqui
                  },
                  child: Text(
                    'Entrar',
                    // Títulos e textos de botões podem usar um peso maior[cite: 37, 38].
                    style: AppTheme.textTheme.titleMedium?.copyWith(
                        color: AppTheme.branco, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 20),

                // Link para "Esqueci minha senha"[cite: 58].
                // Este é um botão de texto, sem borda ou fundo[cite: 107].
                TextButton(
                  onPressed: () {
                    // Lógica para recuperação de senha
                  },
                  child: Text(
                    'Esqueci minha senha',
                    style: AppTheme.textTheme.bodyMedium
                        ?.copyWith(color: AppTheme.branco.withOpacity(0.8)),
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