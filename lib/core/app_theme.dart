import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Classe para centralizar a identidade visual do app VoltionHub.
class AppTheme {
  // Paleta de Cores baseada no documento de design[cite: 21].
  static const Color laranjaVoltion = Color(0xFFFF4F00); // Cor primária para ações e alertas[cite: 22].
  static const Color azulVoltion = Color(0xFF1A233A); // Usada em cabeçalhos ou fundos de temas escuros[cite: 24].
  static const Color cinzaEscuro = Color(0xFF333333); // Para textos principais[cite: 25].
  static const Color branco = Color(0xFFFFFFFF); // Para textos sobre fundos escuros e fundos de tela[cite: 27].

  // Estilo de texto principal usando a fonte Inter.
  static TextTheme get textTheme => GoogleFonts.interTextTheme();

  // Decoração padrão para campos de formulário[cite: 111].
  static InputDecoration get inputDecoration => InputDecoration(
        labelStyle: textTheme.bodyLarge?.copyWith(color: branco.withOpacity(0.7)),
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: branco),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: laranjaVoltion, width: 2),
        ),
      );
}