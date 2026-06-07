class LoginResponse {
  final bool success;
  final int statusCode;
  final String message;
  final int? userId;
  final String? username;
  final String? fullName;
  final String? email;
  final int? roleId;
  final String? roleName;
  final bool? superAdmin;
  final String? token;
  final String? passResetFlag;

  LoginResponse({
    required this.success,
    required this.statusCode,
    required this.message,
    this.userId,
    this.username,
    this.fullName,
    this.email,
    this.roleId,
    this.roleName,
    this.superAdmin,
    this.token,
    this.passResetFlag,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json['Success'] ?? json['success'] ?? false,
      statusCode: json['StatusCode'] ?? json['statusCode'] ?? 0,
      message: json['Message'] ?? json['message'] ?? '',
      userId: json['UserId'] ?? json['userId'],
      username: json['Username'] ?? json['username'],
      fullName: json['FullName'] ?? json['fullName'] ?? json['user_fullname'],
      email: json['Email'] ?? json['email'] ?? json['user_email'],
      roleId: json['RoleId'] ?? json['roleId'] ?? json['user_role_id'],
      roleName: json['RoleName'] ?? json['roleName'],
      superAdmin: json['SuperAdmin'] ?? json['superAdmin'],
      token: json['Token'] ?? json['token'],
      passResetFlag: json['PassResetFlag']?.toString() ?? json['passResetFlag']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'Success': success,
      'StatusCode': statusCode,
      'Message': message,
      'UserId': userId,
      'Username': username,
      'FullName': fullName,
      'Email': email,
      'RoleId': roleId,
      'RoleName': roleName,
      'SuperAdmin': superAdmin,
      'Token': token,
      'PassResetFlag': passResetFlag,
    };
  }
}

