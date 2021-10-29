import 'package:flutter/material.dart';
import 'package:tekmob/theme.dart';

class SocmedButton extends StatelessWidget {
  final String buttonText;
  final Image iconSocmed;

  const SocmedButton({required this.buttonText, required this.iconSocmed});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.06,
        width: MediaQuery.of(context).size.height * 0.15,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade300),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.05),
              spreadRadius: 3,
              blurRadius: 2,
              offset: Offset(0, 2), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            iconSocmed,
            SizedBox(
              width: 5,
            ),
            Text(buttonText,
                style: smallerText.copyWith(
                    fontFamily: "OpenSans", color: purpleDark))
          ],
        ));
  }
}
