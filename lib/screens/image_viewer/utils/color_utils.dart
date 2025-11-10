import 'package:flutter/material.dart';

class ColorUtils {
  // Use the background color directly for the button, with adjustment for visibility
  static Color calculateButtonColor(Color backgroundColor, bool isDarkMode) {
    final hsl = HSLColor.fromColor(backgroundColor);
    
    if (isDarkMode) {
      // For dark backgrounds: make it lighter for better button visibility
      return hsl
          .withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0))
          .toColor();
    } else {
      // For light backgrounds: make it darker for better button visibility
      return hsl
          .withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0))
          .toColor();
    }
  }

  // Calculate text color that contrasts well with the button color
  static Color calculateTextColor(Color buttonColor) {
    // Calculate relative luminance
    final luminance = buttonColor.computeLuminance();
    
    // Use white text for dark buttons, black text for light buttons
    return luminance > 0.5 ? Colors.black : Colors.white;
  }
}

