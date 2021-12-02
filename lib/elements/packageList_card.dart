import 'package:flutter/material.dart';
import 'package:tekmob/services/package/packageListRepo.dart';
import 'package:tekmob/theme.dart';

class PackageListWidget extends StatelessWidget {
  final PackageList packageList;
  // final Function() deleteListPackage;
  // final Function() editListPackage;

  const PackageListWidget({
    required this.packageList,
    // required this.deleteListPackage,
    // required this.editListPackage,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Container(
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 8, 0, 8),
            child: Text("ID: " + packageList.packageId,
                style: normalText.copyWith(
                  color: blueViolet,
                  fontWeight: FontWeight.bold,
                  fontFamily: "OpenSans",
                )),
          ),
          Column(
            children: packageList.listItem
                .map((item) => Container(
                    margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(item.name,
                            style: normalText.copyWith(
                              color: Colors.black,
                              fontFamily: "OpenSans",
                            )),
                        Text("${item.quantity}",
                            style: normalText.copyWith(
                              color: blueViolet,
                              fontWeight: FontWeight.bold,
                              fontFamily: "OpenSans",
                            )),
                      ],
                    )))
                .toList(),
          ),
          Container(
              child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, size: 32),
                color: Colors.green[600],
                tooltip: 'Edit Package',
                onPressed: () {},
              ),
              IconButton(
                  icon: const Icon(Icons.delete_forever_rounded, size: 32),
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
