
class LoginRequestModel {
  LoginRequestModel({
    String? Password,
    String? UID,
    // String? AppType,
    // String? PushKey,
    String? Machine_Name,
    String? Modifier,}){
    _Password = Password;
    _UID = UID;
    // _PushKey = PushKey;
    // _AppType = AppType;
    _Machine_Name = Machine_Name;
    _Modifier=Modifier;
  }

  LoginRequestModel.fromJson(dynamic json) {
    _Password = json['Password'];
    _UID = json['UID'];
    // _PushKey = json['PushKey'];
    // _AppType = json['AppType'];
    _Machine_Name = json['Modifier_Machine'];
    _Modifier=json['Modifier'];
  }
  String? _Password;
  String? _UID;
  // String? _PushKey;
  // String? _AppType;
  String? _Machine_Name;
  String? _Modifier;

  String? get Password => _Password;
  String? get UID => _UID;
  // String? get AppType => _AppType;
  // String? get PushKey => _PushKey;
  String? get Machine_Name => _Machine_Name;
  String? get Modifier => _Modifier;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['Password'] = _Password;
    map['UID'] = _UID;
    // map['PushKey'] = _PushKey;
    // map['AppType'] = _AppType;
    map['Modifier_Machine'] = _Machine_Name;
    map['Modifier'] = _Modifier;

    return map;
  }

}