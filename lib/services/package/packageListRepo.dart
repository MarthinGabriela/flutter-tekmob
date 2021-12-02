import 'package:tekmob/services/package/packageRepo.dart';

class PackageList {
  List<PackageRepo> listItem = [];
  String packageId;

  PackageList({required this.listItem, required this.packageId});
}
