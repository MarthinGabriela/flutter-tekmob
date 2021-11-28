import 'package:tekmob/services/package/packageRepo.dart';

class PackageList {
  List<PackageRepo> listPackage = [];

  PackageList(this.listPackage);

  List get list => listPackage;
}
