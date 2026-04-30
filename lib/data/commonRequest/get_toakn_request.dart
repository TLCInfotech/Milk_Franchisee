

class TokenRequestModel {
  TokenRequestModel({
    String? token,
    String? page,
    String? machnine_code,
    String? schedule_code,
  }){
    _token = token;
    _page = page;
    _machine_code=machnine_code;
    _schedule_code=schedule_code;
  }

  TokenRequestModel.fromJson(dynamic json) {
    _token = json['token'];
    _page = json['pageNumber'];
    _machine_code=json['Machine_Code'];
    _schedule_code=json['Schedule_Code'];
  }
  String? _machine_code;
  String? _schedule_code;
  String? _token;
  String? _page;

  String? get token => _token;
  String? get page => _page;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['token'] = _token;
    map['pageNumber'] = _page;
    map['Schedule_Code']=_schedule_code;
    map['Machine_Code']=_machine_code;
    return map;
  }

}
