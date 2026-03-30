import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Light theme colors
  static const Color _lightBackground = Color(0xFFFAFAFA);
  static const Color _lightSurface = Color(0xFFFFFFFF);
  static const Color _lightSidebar = Color(0xFFF0F0F0);
  static const Color _lightBorder = Color(0xFFE0E0E0);
  static const Color _lightAccent = Color(0xFF007AFF);
  static const Color _lightText = Color(0xFF1D1D1F);
  static const Color _lightTextSecondary = Color(0xFF6E6E73);

  // Dark theme colors
  static const Color _darkBackground = Color(0xFF000000);
  static const Color _darkSurface = Color(0xFF1C1C1E);
  static const Color _darkSidebar = Color(0xFF111111);
  static const Color _darkBorder = Color(0xFF2C2C2E);
  static const Color _darkAccent = Color(0xFF0A84FF);
  static const Color _darkText = Color(0xFFF5F5F7);
  static const Color _darkTextSecondary = Color(0xFF98989D);

  // Syntax highlight colors (dark mode)
  static const Color syntaxKeyword = Color(0xFFFC5FA3);
  static const Color syntaxString = Color(0xFFFC6A5D);
  static const Color syntaxComment = Color(0xFF6C7986);
  static const Color syntaxNumber = Color(0xFFD0BF69);
  static const Color syntaxFunction = Color(0xFF41A1C0);

  static TextTheme _buildTextTheme(Color textColor, bool useGoogleFonts) {
    final baseStyle = useGoogleFonts
        ? GoogleFonts.interTextTheme()
        : const TextTheme();
    return baseStyle.copyWith(
      displayLarge: (baseStyle.displayLarge ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 57),
      displayMedium: (baseStyle.displayMedium ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 45),
      displaySmall: (baseStyle.displaySmall ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 36),
      headlineLarge: (baseStyle.headlineLarge ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 32, fontWeight: FontWeight.w700),
      headlineMedium: (baseStyle.headlineMedium ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: (baseStyle.headlineSmall ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: (baseStyle.titleLarge ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 22, fontWeight: FontWeight.w500),
      titleMedium: (baseStyle.titleMedium ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 16, fontWeight: FontWeight.w500),
      titleSmall: (baseStyle.titleSmall ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
      bodyLarge: (baseStyle.bodyLarge ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 16, height: 1.6),
      bodyMedium: (baseStyle.bodyMedium ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 14, height: 1.6),
      bodySmall: (baseStyle.bodySmall ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 12, height: 1.5),
      labelLarge: (baseStyle.labelLarge ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 14),
      labelMedium: (baseStyle.labelMedium ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 12),
      labelSmall: (baseStyle.labelSmall ?? const TextStyle())
          .copyWith(color: textColor, fontSize: 11),
    );
  }

  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: _lightAccent,
        surface: _lightSurface,
        background: _lightBackground,
        onPrimary: Colors.white,
        onSurface: _lightText,
        onBackground: _lightText,
        outline: _lightBorder,
      ),
      scaffoldBackgroundColor: _lightBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _lightBackground,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: _lightText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerColor: _lightBorder,
      dividerTheme: const DividerThemeData(
        color: _lightBorder,
        thickness: 1,
        space: 0,
      ),
      textTheme: _buildTextTheme(_lightText, true),
      extensions: const [
        AppColors(
          sidebarBackground: _lightSidebar,
          editorBackground: _lightSurface,
          previewBackground: _lightBackground,
          borderColor: _lightBorder,
          secondaryText: _lightTextSecondary,
          editorFontFamily: 'monospace',
          contentFontFamily: 'sans-serif',
          selectionColor: Color(0x33007AFF),
          lineHighlightColor: Color(0x0A007AFF),
          codeBackground: Color(0xFFF0F0F0),
        ),
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: _darkAccent,
        surface: _darkSurface,
        background: _darkBackground,
        onPrimary: Colors.white,
        onSurface: _darkText,
        onBackground: _darkText,
        outline: _darkBorder,
      ),
      scaffoldBackgroundColor: _darkBackground,
      appBarTheme: const AppBarTheme(
        backgroundColor: _darkBackground,
        elevation: 0,
        titleTextStyle: TextStyle(
          color: _darkText,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
      dividerColor: _darkBorder,
      dividerTheme: const DividerThemeData(
        color: _darkBorder,
        thickness: 1,
        space: 0,
      ),
      textTheme: _buildTextTheme(_darkText, true),
      extensions: const [
        AppColors(
          sidebarBackground: _darkSidebar,
          editorBackground: _darkSurface,
          previewBackground: _darkBackground,
          borderColor: _darkBorder,
          secondaryText: _darkTextSecondary,
          editorFontFamily: 'monospace',
          contentFontFamily: 'sans-serif',
          selectionColor: Color(0x330A84FF),
          lineHighlightColor: Color(0x0A0A84FF),
          codeBackground: Color(0xFF2C2C2E),
        ),
      ],
    );
  }
}

/// Theme extension for custom app colors
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.sidebarBackground,
    required this.editorBackground,
    required this.previewBackground,
    required this.borderColor,
    required this.secondaryText,
    required this.editorFontFamily,
    required this.contentFontFamily,
    required this.selectionColor,
    required this.lineHighlightColor,
    required this.codeBackground,
  });

  final Color sidebarBackground;
  final Color editorBackground;
  final Color previewBackground;
  final Color borderColor;
  final Color secondaryText;
  final String editorFontFamily;
  final String contentFontFamily;
  final Color selectionColor;
  final Color lineHighlightColor;
  final Color codeBackground;

  @override
  AppColors copyWith({
    Color? sidebarBackground,
    Color? editorBackground,
    Color? previewBackground,
    Color? borderColor,
    Color? secondaryText,
    String? editorFontFamily,
    String? contentFontFamily,
    Color? selectionColor,
    Color? lineHighlightColor,
    Color? codeBackground,
  }) {
    return AppColors(
      sidebarBackground: sidebarBackground ?? this.sidebarBackground,
      editorBackground: editorBackground ?? this.editorBackground,
      previewBackground: previewBackground ?? this.previewBackground,
      borderColor: borderColor ?? this.borderColor,
      secondaryText: secondaryText ?? this.secondaryText,
      editorFontFamily: editorFontFamily ?? this.editorFontFamily,
      contentFontFamily: contentFontFamily ?? this.contentFontFamily,
      selectionColor: selectionColor ?? this.selectionColor,
      lineHighlightColor: lineHighlightColor ?? this.lineHighlightColor,
      codeBackground: codeBackground ?? this.codeBackground,
    );
  }

  @override
  AppColors lerp(AppColors? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      sidebarBackground:
          Color.lerp(sidebarBackground, other.sidebarBackground, t)!,
      editorBackground:
          Color.lerp(editorBackground, other.editorBackground, t)!,
      previewBackground:
          Color.lerp(previewBackground, other.previewBackground, t)!,
      borderColor: Color.lerp(borderColor, other.borderColor, t)!,
      secondaryText: Color.lerp(secondaryText, other.secondaryText, t)!,
      editorFontFamily: editorFontFamily,
      contentFontFamily: contentFontFamily,
      selectionColor: Color.lerp(selectionColor, other.selectionColor, t)!,
      lineHighlightColor:
          Color.lerp(lineHighlightColor, other.lineHighlightColor, t)!,
      codeBackground: Color.lerp(codeBackground, other.codeBackground, t)!,
    );
  }
}
