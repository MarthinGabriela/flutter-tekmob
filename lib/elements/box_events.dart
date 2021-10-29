import 'package:flutter/material.dart';
import 'package:tekmob/theme.dart';

class BoxEvent extends StatelessWidget {
  final String text;
  final Image iconEvents;

  const BoxEvent({required this.text, required this.iconEvents});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: MediaQuery.of(context).size.height * 0.18,
        width: MediaQuery.of(context).size.height * 0.18,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: purpleDark),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 2,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Column(
            // crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 40),
              iconEvents,
              SizedBox(height: 8),
              Text(text,
                  style: normalText.copyWith(
                      fontFamily: "OpenSans", color: purpleDark))
            ]));
  }
}
