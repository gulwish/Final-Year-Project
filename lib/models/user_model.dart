class UserModel {
  String? uid;
  String? profileImage;
  String? name;
  String? serviceProvided;
  String? address;
  String? phone;
  String? email;
  bool? isUser;
  String? deviceToken;
  // ignore: non_constant_identifier_names
  String? CNICImage;
  bool? isCNICVerified;

  UserModel({
    this.uid,
    this.name,
    this.address,
    this.phone,
    this.email,
    this.isUser,
    this.profileImage,
    this.serviceProvided,
    this.deviceToken,
    // ignore: non_constant_identifier_names
    this.CNICImage,
    this.isCNICVerified = false,
  });

  Map toMap(UserModel user) {
    var data = <String, dynamic>{};
    data['uid'] = user.uid;
    data['profile_image'] = user.profileImage;
    data['name'] = user.name;
    data['service_provided'] = user.serviceProvided;
    data['address'] = user.address;
    data['phone'] = user.phone;
    data['email'] = user.email;
    data['is_user'] = user.isUser;
    data['device_token'] = user.deviceToken;
    data['cnic_image'] = user.CNICImage;
    data['cnic_verified'] = user.isCNICVerified;
    return data;
  }

  UserModel.fromMap(Map<String, dynamic> mapData) {
    uid = mapData['uid'];
    profileImage = mapData['profile_image'];
    name = mapData['name'];
    serviceProvided = mapData['service_provided'];
    address = mapData['address'];
    phone = mapData['phone'];
    email = mapData['email'];
    isUser = mapData['is_user'];
    deviceToken = mapData['device_token'];
    CNICImage = mapData['cnic_image'];
    isCNICVerified = mapData['cnic_verified'] ?? false;
  }

  bool equals(UserModel user) => user.uid == uid;
}
