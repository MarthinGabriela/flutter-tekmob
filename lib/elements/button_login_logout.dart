import 'package:flutter/material.dart';
import 'package:tekmob/theme.dart';

class WideButton extends StatelessWidget {
  final String buttonText;
  final String colorSide;
  const WideButton({required this.buttonText, required this.colorSide});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.05,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: colorSide == 'Dark' ? Colors.black : Colors.grey.shade300),
          color: colorSide == 'Dark' ? Colors.white : purpleDark,
        ),
        child: Text(buttonText,
            style: normalText.copyWith(
              color: colorSide == 'Dark' ? purpleDark : Color(0xFFFFFFFF),
              fontFamily: "OpenSans",
            )));
  }
}
