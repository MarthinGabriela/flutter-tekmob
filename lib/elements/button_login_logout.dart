import 'package:flutter/material.dart';
import 'package:tekmob/theme.dart';

class WideButton extends StatelessWidget {
  final String buttonText;
  const WideButton({required this.buttonText});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        height: MediaQuery.of(context).size.height * 0.06,
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
              color: buttonText == 'Log Out'
                  ? Colors.black
                  : Colors.grey.shade300),
          color: buttonText == 'Log Out' ? Colors.white : purpleDark,
        ),
        child: Text(buttonText,
            style: normalText.copyWith(
              color: buttonText == 'Log Out' ? purpleDark : Color(0xFFFFFFFF),
              fontFamily: "OpenSans",
            )));
  }
}
