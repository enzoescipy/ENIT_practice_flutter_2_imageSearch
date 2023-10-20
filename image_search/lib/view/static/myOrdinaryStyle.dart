import 'package:flutter/material.dart';

class WinterGreenColor {
  static final ColorScheme winterGreenTheme = ColorScheme.fromSeed(
    seedColor: WinterGreenColor.snowBlue,
    secondary: WinterGreenColor.sproutGreen,
  );

  static const Color snowBlue = Color.fromARGB(106, 92, 163, 221);
  static const Color sproutGreen = Color.fromARGB(120, 110, 207, 131);
  static const Color petalRed = Color.fromARGB(108, 255, 226, 250);

  static const Color deepGrayBlue = Color.fromARGB(255, 27, 35, 78);
}

class CuteText {
  static const TextTheme cuteTextTheme = TextTheme(
      bodyLarge: TextStyle(color: WinterGreenColor.deepGrayBlue, fontFamily: "Tmoney", fontSize: 40),
      bodyMedium: TextStyle(color: WinterGreenColor.deepGrayBlue, fontFamily: "Tmoney", fontSize: 20),
      bodySmall: TextStyle(color: WinterGreenColor.deepGrayBlue, fontFamily: "Tmoney", fontSize: 15));
  static const Map<String, TextStyle> cuteTextStyle = {"contents": TextStyle(fontFamily: "Tmoney", color: WinterGreenColor.deepGrayBlue)};
}

class RoundyDecoration {
  static BoxDecoration containerDecoration(Color color, {String type = "fill"}) {
    if (type == "fill") {
      return BoxDecoration(borderRadius: BorderRadius.circular(20), color: color);
    } else if (type == "border") {
      return BoxDecoration(borderRadius: BorderRadius.circular(20), border: Border.all(color: color));
    } else {
      throw Exception("no type matched for presets.");
    }
  }
}
