import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Classe para centralizar a paleta de cores do aplicativo VoltionHub.
class AppColors {
  // Cor primária para ações principais, CTAs e alertas de alta prioridade.
  // Representa energia, alerta e ação.
  static const Color laranjaVoltion = Color(0xFFFF4F00);

  // Cor derivada do fundo do logotipo, para cabeçalhos ou temas escuros.
  static const Color azulVoltion = Color(0xFF1A233A);

  // Cor para ícones.
  static Color icons = Color(0xFFFFFFFF).withOpacity(0.7);

  // Cor para textos principais e títulos, garantindo alta legibilidade.
  static const Color cinzaEscuro = Color(0xFF333333);

  // Cor de fundo principal para as telas, proporcionando clareza.
  static const Color branco = Color(0xFFFFFFFF);

  // Cor para feedback de sucesso.
  static const Color verdeSucesso = Color(0xFF28A745);

  // Cor para alertas de criticidade média.
  static const Color amareloAlerta = Color(0xFFFFC107);

  // Cor para falhas críticas e itens urgentes.
  static const Color vermelhoPerigo = Color(0xFFDC3545);

  static TextTheme get textTheme => GoogleFonts.interTextTheme();
}