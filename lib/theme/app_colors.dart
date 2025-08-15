import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Classe para centralizar a paleta de cores do aplicativo VoltionHub.
class AppColors {

  static const bool isDarkMode = false;

  // Cor primária para ações principais, CTAs e alertas de alta prioridade[cite: 22].
  // Representa energia, alerta e ação[cite: 23].
  static const Color laranjaVoltion = Color(0xFFFF4F00);

  // Cor derivada do fundo do logotipo, para cabeçalhos ou temas escuros[cite: 24].
  static const Color azulVoltion = Color(0xFF1A233A);

  // Cor para textos principais e títulos, garantindo alta legibilidade[cite: 25, 26].
  static const Color cinzaEscuro = Color(0xFF333333);

  // Cor de fundo principal para as telas, proporcionando clareza[cite: 27, 28].
  static const Color branco = Color(0xFFFFFFFF);
  
  // Cor para feedback de sucesso[cite: 30].
  static const Color verdeSucesso = Color(0xFF28A745);

  // Cor para alertas de criticidade média[cite: 31].
  static const Color amareloAlerta = Color(0xFFFFC107);

  // Cor para falhas críticas e itens urgentes[cite: 32].
  static const Color vermelhoPerigo = Color(0xFFDC3545);

  static TextTheme get textTheme => GoogleFonts.interTextTheme();
}