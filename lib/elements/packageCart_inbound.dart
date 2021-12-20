import 'package:flutter/material.dart';
import 'package:tekmob/services/package/packageListRepo.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/screens/inbound/inbound_storing.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PackageCart extends StatelessWidget {
  final Map<String, dynamic> packageData;
  final String uid;
  // final Function() deleteListPackage;
  // final Function() editListPackage;

  const PackageCart({
    required this.packageData,
    required this.uid,
    // required this.deleteListPackage,
    // required this.editListPackage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      // alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Text("ID: " + packageData['packageId'],
                style: normalText.copyWith(
                  color: blueViolet,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans",
                )),
          ),
          Container(
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(packageData['description'],
                      style: normalText.copyWith(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                      )),
                  SizedBox(
                    height: 16,
                  ),
                  Text("Gudang ID" + packageData['warehouseId'],
                      style: normalText.copyWith(
                        color: Colors.black,
                        fontFamily: "OpenSans",
                      )),
                ],
              )),
          Container(
              padding: EdgeInsets.fromLTRB(40, 24, 40, 16),
              child: Ink(
                // color: purpleDark,
                child: InkWell(
                    onTap: () async {
                      print("onTap");
                      print(packageData);
                      print(packageData['packageId']);
                      print(packageData['warehouseId']);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => InboundStoring(
                                uid: uid,
                                packageId: packageData['packageId'],
                                warehouseId: packageData['warehouseId'],
                              )));
                      print(packageData['packageId']);
                      // await scanQR();
                      // Navigator.pop(context);
                    },
                    child: WideButton(
                        buttonText: "Store Package", colorSide: "Not Dark")),
              )),
          Container(
              margin: EdgeInsets.fromLTRB(0, 0, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                      icon: const Icon(Icons.delete_forever_rounded, size: 40),
                      color: Colors.red[800],
                      tooltip: 'Delete Package',
                      onPressed: () {}),
                ],
              ))
        ],
      ),
    ));
  }
}
