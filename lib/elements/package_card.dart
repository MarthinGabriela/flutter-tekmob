import 'package:flutter/material.dart';
import 'package:tekmob/services/package/packageRepo.dart';
import 'package:tekmob/theme.dart';

class PackageWidget extends StatelessWidget {
  final PackageRepo package;
  final Function() deletePackage;
  final Function() editPackage;

  const PackageWidget(
      {required this.package,
      required this.deletePackage,
      required this.editPackage});

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
                  child: Text("ID: " + package.eanId,
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
                        Text(package.name,
                            style: normalText.copyWith(
                              color: Colors.black,
                              fontFamily: "OpenSans",
                            )),
                        Text("${package.quantity}",
                            style: normalText.copyWith(
                              color: blueViolet,
                              fontWeight: FontWeight.bold,
                              fontFamily: "OpenSans",
                            )),
                      ],
                    )),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 8, 8, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, size: 32),
                          color: Colors.green[600],
                          tooltip: 'Edit Package',
                          onPressed: editPackage,
                        ),
                        IconButton(
                            icon: const Icon(Icons.delete_forever_rounded,
                                size: 32),
                            color: Colors.red[800],
                            tooltip: 'Delete Package',
                            onPressed: deletePackage),
                      ],
                    ))
              ],
            )),
        SizedBox(
          height: 16,
        )
      ]),
    );
  }
}
