import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tekmob/auth/auth.dart';
import 'package:tekmob/elements/button_socmed.dart';
import 'package:tekmob/theme.dart';
import 'package:tekmob/elements/button_login_logout.dart';
import 'package:tekmob/elements/package_card.dart';
import 'package:tekmob/services/package/packageRepo.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OutboundPackage extends StatefulWidget {
  final String uid;
  final String warehouseId;

  const OutboundPackage({required this.uid, required this.warehouseId});

  @override
  _OutboundPackageState createState() => _OutboundPackageState();
}

class _OutboundPackageState extends State<OutboundPackage> {
  final _formKey = GlobalKey<FormState>();
  final firestoreInstance = FirebaseFirestore.instance;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  String warehouse = "";
  String title = "";
  String description = "";
  String x = "";
  String y = "";
  String z = "";
  String ean_id = "";
  String qty = "";
  String itemError = "You haven't add any item yet";
  bool errorSwitch = false;
  String companyId = "";
  String idWarehouse = "";
  String warehouseName = "";

  String _scanBarcode = '';

  List<PackageRepo> packageList = [];
  List<PackageRepo> itemBaruList = [];
  String itemName = "";

  @override
  void didChangeDependencies() async {
    final SharedPreferences prefs = await _prefs;

    print(widget.uid);
    print(widget.warehouseId);

    setState(() {
      companyId = prefs.getString('companyId').toString();
      idWarehouse = prefs.getString('warehouseId').toString();
      warehouseName = prefs.getString('warehouseName').toString();
    });

    super.didChangeDependencies();
  }

  Future<void> scanBarcodeNormal() async {
    String barcodeScanRes;
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          '#ff6666', 'Cancel', true, ScanMode.BARCODE);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      ean_id = barcodeScanRes;
    });
  }

  Future<bool> checkIfDocExists(String docId) async {
    try {
      // Get reference to Firestore collection
      var collectionRef = FirebaseFirestore.instance
          .collection('companies')
          .doc(companyId)
          .collection('products');

      var doc = await collectionRef.doc(docId).get();
      if (doc.exists) itemName = doc['name'];
      return doc.exists;
    } catch (e) {
      throw e;
    }
  }

  Future<Future<AlertDialog?>> showAddItemName(BuildContext context) async {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              content: Form(
                  // key:_formKey,
                  child: Container(
            margin: EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "We don’t seem to have information about the product. Please fill the form below.",
                  style: normalText.copyWith(
                      color: purpleDark, fontFamily: "Open Sans"),
                ),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 16, 24, 0),
                    child: Column(
                        // mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Text("Product Name",
                              style: normalText.copyWith(
                                  fontFamily: "OpenSans",
                                  fontWeight: FontWeight.w800,
                                  color: purpleDark)),
                          Container(
                              width: 144,
                              child: TextFormField(
                                style: TextStyle(
                                    color: blueDark, fontFamily: 'OpenSans'),
                                decoration: inputFormDecor,
                                onChanged: (val) {
                                  setState(() => itemName = val);
                                },
                              )),
                          SizedBox(height: 24),
                          TextButton(
                            child: Text('Save Product'),
                            style: TextButton.styleFrom(
                              primary: Colors.white,
                              backgroundColor: blueViolet,
                              onSurface: Colors.grey,
                            ),
                            onPressed: () async {
                              setState(() {
                                PackageRepo newpack = PackageRepo(
                                    eanId: ean_id,
                                    quantity: int.parse(qty),
                                    name: itemName);
                                packageList.add(newpack);
                                itemBaruList.add(newpack);
                                errorSwitch = false;
                              });

                              setState(() {
                                ean_id = "";
                                qty = "";
                                itemName = "";
                              });
                              Navigator.of(context).pop();
                            },
                          )
                        ])),
              ],
            ),
          )));
        });
  }

  Future<Future<AlertDialog?>> showAddItem(BuildContext context) async {
    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
                // key: _formKey,
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
                            child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("EAN ID",
                                      style: normalText.copyWith(
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.w800,
                                          color: purpleDark)),
                                  Container(
                                      width: 144,
                                      child: TextFormField(
                                        initialValue:
                                            ean_id.isNotEmpty ? ean_id : "",
                                        style: TextStyle(
                                            color: blueDark,
                                            fontFamily: 'OpenSans'),
                                        decoration: inputFormDecor,
                                        onChanged: (val) {
                                          setState(() => ean_id = val);
                                        },
                                      ))
                                ])),
                        SizedBox(width: 16),
                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                              Text("QTY",
                                  style: normalText.copyWith(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w800,
                                      color: purpleDark)),
                              Container(
                                  width: 64,
                                  child: TextFormField(
                                    initialValue: qty.isNotEmpty ? qty : "",
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: TextStyle(
                                        color: blueDark,
                                        fontFamily: 'OpenSans'),
                                    decoration: inputFormDecor,
                                    onChanged: (val) {
                                      setState(() => qty = val);
                                    },
                                  ))
                            ])),
                      ]),
                ),
                SizedBox(
                  height: 32,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.05),
                              spreadRadius: 3,
                              blurRadius: 2,
                              offset:
                                  Offset(0, 2), // changes position of shadow
                            ),
                          ],
                        ),
                        child: IconButton(
                          // @irhamzh should assign assets
                          icon: Image.asset('assets/barcode_icon.png'),
                          iconSize: 16,
                          onPressed: () async {
                            await scanBarcodeNormal();
                            Navigator.pop(context);
                            await showAddItem(context);
                          },
                        ),
                      ),
                      SizedBox(width: 132),
                      TextButton(
                        child: Text('Add Item'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: blueViolet,
                          onSurface: Colors.grey,
                        ),
                        onPressed: () async {
                          bool docExists = await checkIfDocExists(ean_id);
                          if (!docExists) {
                            print("masuk");
                            Navigator.of(context).pop();
                            await showAddItemName(context);
                            // Navigator.of(context).pop();
                          } else {
                            setState(() {
                              PackageRepo newpack = PackageRepo(
                                  eanId: ean_id,
                                  quantity: int.parse(qty),
                                  name: itemName);
                              packageList.add(newpack);
                            });

                            setState(() {
                              ean_id = "";
                              qty = "";
                              itemName = "";
                            });
                            Navigator.of(context).pop();
                          }

                          // setState(() {
                          //   PackageRepo newpack = PackageRepo(
                          //       eanId: ean_id,
                          //       quantity: int.parse(qty),
                          //       name: itemName.isNotEmpty
                          //           ? itemName
                          //           : "james_bond");
                          //   packageList.add(newpack);
                          // });

                          // setState(() {
                          //   ean_id = "";
                          //   qty = "";
                          //   itemName = "";
                          // });
                          // Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                )
              ],
            )),
            // actions: <Widget>[]
          );
        });
  }

  Future<Future<AlertDialog?>> showEditAddItem(
      BuildContext context,
      // String editEanId,
      // String editName,
      // int editQuantity,
      PackageRepo package) async {
    String editEanId = package.eanId;
    String editName = package.name;
    String editQuantity = package.quantity.toString();

    return showDialog<AlertDialog>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Form(
                // key: _formKey,
                child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Container(
                            margin: EdgeInsets.fromLTRB(0, 0, 24, 0),
                            child: Column(
                                // mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Text("EAN ID",
                                      style: normalText.copyWith(
                                          fontFamily: "OpenSans",
                                          fontWeight: FontWeight.w800,
                                          color: purpleDark)),
                                  Container(
                                      width: 144,
                                      child: TextFormField(
                                        initialValue: package.eanId,
                                        style: TextStyle(
                                            color: blueDark,
                                            fontFamily: 'OpenSans'),
                                        decoration: inputFormDecor,
                                        onChanged: (val) {
                                          setState(() => editEanId = val);
                                        },
                                      ))
                                ])),
                        SizedBox(width: 16),
                        Container(
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                              Text("QTY",
                                  style: normalText.copyWith(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w800,
                                      color: purpleDark)),
                              Container(
                                  width: 64,
                                  child: TextFormField(
                                    initialValue: package.quantity.toString(),
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: TextStyle(
                                        color: blueDark,
                                        fontFamily: 'OpenSans'),
                                    decoration: inputFormDecor,
                                    onChanged: (val) {
                                      setState(() => editQuantity = val);
                                    },
                                  ))
                            ])),
                      ]),
                ),
                SizedBox(
                  height: 32,
                ),
                Center(
                  child: Column(
                    children: [
                      Text("Item Name",
                          style: normalText.copyWith(
                              fontFamily: "OpenSans",
                              fontWeight: FontWeight.w800,
                              color: purpleDark)),
                      Container(
                          width: 144,
                          child: TextFormField(
                            initialValue: package.name,
                            style: TextStyle(
                                color: blueDark, fontFamily: 'OpenSans'),
                            decoration: inputFormDecor,
                            onChanged: (val) {
                              setState(() => editName = val);
                            },
                          ))
                    ],
                  ),
                ),
                SizedBox(height: 32),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text('Edit Item'),
                        style: TextButton.styleFrom(
                          primary: Colors.white,
                          backgroundColor: blueViolet,
                          onSurface: Colors.grey,
                        ),
                        onPressed: () async {
                          setState(() {
                            package.eanId = editEanId;
                            package.quantity = int.parse(editQuantity);
                            package.name = editName;
                          });

                          setState(() {
                            editEanId = "";
                            editQuantity = "";
                            editName = "";
                          });
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                )
              ],
            )),
            // actions: <Widget>[]
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Scaffold(
            body: SafeArea(
                child: SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(30, 30, 0, 0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(120),
              child: SizedBox(
                width: 50,
                height: 50,
                child: ElevatedButton(
                  child: Icon(
                    Icons.arrow_back,
                    size: 20,
                  ),
                  onPressed: () {
                    Navigator.pop(context, " cancel");
                  },
                ),
              ),
            ),
          ),
          SizedBox(
            height: 32,
          ),
          Container(
            margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
            child: Text("Create Package",
                style: header_3.copyWith(
                    color: purpleDark, fontFamily: 'QuickSand')),
          ),
          SizedBox(
            height: 32,
          ),
          Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: Text("Warehouse",
                          style: header_5.copyWith(
                              color: blueDark, fontFamily: 'OpenSans')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            initialValue: widget.warehouseId,
                            readOnly: true,
                            enabled: false,
                            focusNode: FocusNode(),
                            style: TextStyle(
                                color: blueDark, fontFamily: 'OpenSans'),
                            decoration: inputFormDecor,
                            // onChanged: (val) {
                            //   setState(() => warehouse = val);
                            // },
                            validator: (val) => val!.isEmpty
                                ? "Please enter a warehouse"
                                : null,
                          )),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: Text("Title",
                          style: header_5.copyWith(
                              color: blueDark, fontFamily: 'OpenSans')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            style: TextStyle(
                                color: blueDark, fontFamily: 'OpenSans'),
                            decoration: inputFormDecor,
                            onChanged: (val) {
                              setState(() => title = val);
                            },
                            validator: (val) =>
                                val!.isEmpty ? "Please enter a title" : null,
                          )),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: Text("Description",
                          style: header_5.copyWith(
                              color: blueDark, fontFamily: 'OpenSans')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 32, 0),
                      child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            maxLines: null,
                            keyboardType: TextInputType.multiline,
                            style: TextStyle(
                                color: blueDark, fontFamily: 'OpenSans'),
                            decoration: inputFormDecor,
                            onChanged: (val) {
                              setState(() => description = val);
                            },
                            validator: (val) => val!.isEmpty
                                ? "Please enter a description"
                                : null,
                          )),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: Text("Dimensions (in cm)",
                          style: header_5.copyWith(
                              color: blueDark, fontFamily: 'OpenSans')),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 16, 0, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("X",
                                  style: normalText.copyWith(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w800,
                                      color: purpleDark)),
                              Container(
                                  width: 120,
                                  child: TextFormField(
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter x parameter"
                                        : null,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: TextStyle(
                                        color: blueDark,
                                        fontFamily: 'OpenSans'),
                                    decoration: inputFormDecor,
                                    onChanged: (val) {
                                      setState(() => x = val);
                                    },
                                  ))
                            ],
                          )),
                          SizedBox(width: 16),
                          Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Y",
                                  style: normalText.copyWith(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w800,
                                      color: purpleDark)),
                              Container(
                                  width: 120,
                                  child: TextFormField(
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter y parameter"
                                        : null,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: TextStyle(
                                        color: blueDark,
                                        fontFamily: 'OpenSans'),
                                    decoration: inputFormDecor,
                                    onChanged: (val) {
                                      setState(() => y = val);
                                    },
                                  ))
                            ],
                          )),
                          SizedBox(width: 16),
                          Container(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text("Z",
                                  style: normalText.copyWith(
                                      fontFamily: "OpenSans",
                                      fontWeight: FontWeight.w800,
                                      color: purpleDark)),
                              Container(
                                  width: 120,
                                  child: TextFormField(
                                    validator: (val) => val!.isEmpty
                                        ? "Please enter z parameter"
                                        : null,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    style: TextStyle(
                                        color: blueDark,
                                        fontFamily: 'OpenSans'),
                                    decoration: inputFormDecor,
                                    onChanged: (val) {
                                      setState(() => z = val);
                                    },
                                  ))
                            ],
                          )),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 32,
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(32, 0, 0, 0),
                      child: Text("Items",
                          style: header_5.copyWith(
                              color: blueDark, fontFamily: 'OpenSans')),
                    ),
                    errorSwitch == false
                        ? SizedBox(
                            height: 16,
                          )
                        : Container(
                            margin: EdgeInsets.fromLTRB(0, 16, 0, 16),
                            child: Center(
                              child: Text(itemError,
                                  style: normalText.copyWith(
                                      color: Colors.red,
                                      fontFamily: "OpenSans")),
                            ),
                          ),
                    Container(
                      child: Column(
                        children: packageList
                            .map((package) => PackageWidget(
                                package: package,
                                deletePackage: () {
                                  setState(() {
                                    packageList.remove(package);
                                  });
                                },
                                editPackage: () async {
                                  await showEditAddItem(context, package);
                                }))
                            .toList(),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Ink(
                          // color: purpleDark,
                          child: InkWell(
                              onTap: () async {
                                await showAddItem(context);
                              },
                              child: WideButton(
                                  buttonText: "+ Add Item", colorSide: "Dark")),
                        )),
                    SizedBox(
                      height: 48,
                    ),
                    Container(
                        padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                        child: Ink(
                          // color: purpleDark,
                          child: InkWell(
                              onTap: () async {
                                if (_formKey.currentState!.validate()) {
                                  if (packageList.isNotEmpty) {
                                    print("masuk ontap");
                                    setState(() {
                                      errorSwitch = false;
                                      // itemError = "";
                                    });

                                    List<Map<String, dynamic>> itemArray = [];

                                    for (int i = 0;
                                        i < packageList.length;
                                        i++) {
                                      var perItem = new Map<String, dynamic>();
                                      perItem["id"] = packageList[i].eanId;
                                      perItem["quantity"] =
                                          packageList[i].quantity;
                                      itemArray.add(perItem);
                                      // print("loop itemArray number" +
                                      //     (i + 1).toString());
                                    }
                                    print("masuk ontap 2");

                                    var userRef = FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(widget.uid);

                                    var userIni = await userRef.get();

                                    var packageId;

                                    await firestoreInstance
                                        .collection('companies')
                                        .doc(companyId)
                                        .collection('warehouses')
                                        .doc(idWarehouse)
                                        .collection('packages')
                                        .add({
                                      "authorFirstName": userIni["firstName"],
                                      "authorLastName": userIni["lastName"],
                                      "authorId": widget.uid,
                                      "companyId": userIni["companyId"],
                                      "createdAt": DateTime.now(),
                                      "description": description,
                                      "status": "ready",
                                      "title": title,
                                      "warehouseId": idWarehouse,
                                      "xDim": int.parse(x),
                                      "yDim": int.parse(y),
                                      "zDim": int.parse(z),
                                      "items": FieldValue.arrayUnion(itemArray),
                                    }).then((value) {
                                      packageId = value.id;
                                    });

                                    print("masuk ontap 3");

                                    await firestoreInstance
                                        .collection('companies')
                                        .doc(companyId)
                                        .collection('warehouses')
                                        .doc(idWarehouse)
                                        .collection('packages')
                                        .doc(packageId)
                                        .update({
                                      "packageId": packageId,
                                    });

                                    if (itemBaruList.isNotEmpty) {
                                      for (int i = 0;
                                          i < itemBaruList.length;
                                          i++) {
                                        await firestoreInstance
                                            .collection('companies')
                                            .doc(companyId)
                                            .collection('products')
                                            .doc(itemBaruList[i].eanId)
                                            .set(
                                                {"name": itemBaruList[i].name});
                                      }
                                    }
                                    Navigator.pop(context, " " + packageId);
                                  } else {
                                    setState(() {
                                      errorSwitch = true;
                                      // itemError = "afafsadaffsfa";
                                      // itemError =
                                      //     "You haven't add any item yet";
                                    });
                                  }
                                }
                                // Navigator.of(context).pop(context, packageId);
                              },
                              child: WideButton(
                                  buttonText: "Save Package",
                                  colorSide: "Not Dark")),
                        )),
                    SizedBox(
                      height: 32,
                    ),
                  ]))
        ],
      ),
    ))));
  }
}
