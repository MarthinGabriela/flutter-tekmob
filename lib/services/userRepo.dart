class UserRepo {
  final String uid;

  UserRepo({required this.uid});
}

class UserLoginData {
  final String uid;
  final String firstName;
  final String lastName;
  final String companyId;
  final String roleId;
  var warehouseIds;

  UserLoginData(
      {required this.uid,
      required this.firstName,
      required this.lastName,
      required this.companyId,
      required this.roleId,
      required this.warehouseIds});
}
