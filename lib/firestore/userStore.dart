import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tekmob/services/userRepo.dart';

class UserStore {
  final String uid;
  UserStore({required this.uid});

  final CollectionReference users =
      FirebaseFirestore.instance.collection("users");

  Stream<UserLoginData?> get userStoreData {
    return users.doc(uid).snapshots().map(_userFromFirestore);
  }

  UserLoginData? _userFromFirestore(DocumentSnapshot data) {
    return UserLoginData(
        uid: uid,
        firstName: data['firstName'],
        lastName: data['lastName'],
        companyId: data['companyId'],
        roleId: data['roleId'],
        warehouseIds: data['warehouseIds']);
  }
}
