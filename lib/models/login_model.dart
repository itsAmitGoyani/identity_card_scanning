class LoginModel {
  String userId, accessToken, tokenType;
  DateTime accessTokenExpiresAtUtc;

  LoginModel(this.userId, this.accessToken, this.tokenType,
      this.accessTokenExpiresAtUtc);

  LoginModel.fromJson(Map<String, dynamic> json)
      : userId = json['userId'],
        accessToken = json['accessToken'],
        tokenType = json['tokenType'],
        accessTokenExpiresAtUtc =
            DateTime.parse(json['accessTokenExpiresAtUtc']);

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['userId'] = userId;
    data['accessToken'] = accessToken;
    data['tokenType'] = tokenType;
    data['accessTokenExpiresAtUtc'] = accessTokenExpiresAtUtc.toIso8601String();
    return data;
  }
}
