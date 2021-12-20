import 'package:flutter/material.dart';
import 'package:tekmob/services/package/packageRepo.dart';
import 'package:tekmob/theme.dart';

class CardStoring extends StatelessWidget {
  final String itemId;
  final String itemName;
  final String itemQuantity;

  const CardStoring(
      {required this.itemId,
      required this.itemName,
      required this.itemQuantity});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(children: <Widget>[
        Container(
            alignment: Alignment.center,
            // height: MediaQuery.of(context).size.height * 0.06,
            width: MediaQuery.of(context).size.width * 0.8,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Container(
                  margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
                  child: Text("ID: " + itemId,
                      style: normalText.copyWith(
                        color: blueViolet,
                        fontWeight: FontWeight.bold,
                        fontFamily: "OpenSans",
                      )),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(itemName,
                            style: normalText.copyWith(
                              color: Colors.black,
                              fontFamily: "OpenSans",
                            )),
                        Text(itemQuantity,
                            style: normalText.copyWith(
                              color: blueViolet,
                              fontWeight: FontWeight.bold,
                              fontFamily: "OpenSans",
                            )),
                      ],
                    )),
              ],
            )),
        SizedBox(
          height: 16,
        )
      ]),
    );
  }
}
