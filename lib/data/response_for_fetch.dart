class ApiResponseForFetch {
  ApiResponseForFetch({
    this.vendorCode = "",
    this.vendorName = "",
    this.status = false,
    this.masterMenu = const [],
    this.transactionMenu = const [],
    this.reportMenu = const [],
    this.data = const [],
    this.companyDetail,
    this.msg = "",
    this.token = "",
    this.Machine_Name = "",
    this.code = 0,
    this.UID = "",
    this.vstate = "",
  });

  ApiResponseForFetch.fromJson(dynamic json) {
    status = json['status'] ?? false;
    masterMenu = json['MasterSub_ModuleList'] ?? [];
    transactionMenu = json['TransactionSub_ModuleList'] ?? [];
    reportMenu = json['ReportSub_ModuleList'] ?? [];
    data = json['data'] ?? [];
    msg = json['msg'] ?? "";
    token = json['token'] ?? "";
    Machine_Name = json['Modifier_Machine'] ?? "";
    code = json['code'] ?? 0;
    UID = json['UID'] ?? "";
    companyDetail = json['Company_Detail'] ?? "";
    vendorCode = json['Emp_No'] ?? "";
    vendorName = json['Emp_Name'] ?? "";
    vstate = json['Emp_State'] ?? "";
  }

  bool? status;
  List<dynamic>? masterMenu;
  List<dynamic>? transactionMenu;
  List<dynamic>? reportMenu;
  List<dynamic>? data;
  dynamic? companyDetail;
  String? vendorCode;
  String? vendorName;
  String? msg;
  String? token;
  String? Machine_Name;
  int? code;
  String? UID;
  String? vstate;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = status;
    map['MasterSub_ModuleList'] = masterMenu;
    map['TransactionSub_ModuleList'] = transactionMenu;
    map['ReportSub_ModuleList'] = reportMenu;
    map['data'] = data;
    map['Company_Detail'] = companyDetail ?? "";
    map['msg'] = msg;
    map['token'] = token;
    map['Modifier_Machine'] = Machine_Name;
    map['code'] = code;
    map['UID'] = UID;
    map['Emp_No'] = vendorCode;
    map['Emp_Name'] = vendorName;
    map['Emp_State'] = vstate;
    return map;
  }
}
/*
/// status : "success"
/// data : {"current_page":1,"data":[{"id":1,"game_name":"game nine","type_of_player":1,"release_date":"2022-01-20","cover_picture":"https://s3.amazonaws.com/regenapps.com/gamergrid/cover/61e7bf86255068.93624389","video_url":"https://s3.amazonaws.com/regenapps.com/gamergrid/video/61e7bf9b4ceaa0.36999418","development_studio":2,"game_id":0,"main_genre_id":2,"genre_id":2,"sub_genre_id":1,"game_banner_id":1,"status":1,"created_at":"-0001-11-30 00:00:00","updated_at":"-0001-11-30 00:00:00","selectedGame":"0","gameConsoles":[{"console_id":1,"console_name":"console-1","console_url":"https://s3.amazonaws.com/regenapps.com/gamergrid/console/61dd6b6dae0a70.61742250","selectedConsole":"0"},{"console_id":5,"console_name":"console-5","console_url":"https://s3.amazonaws.com/regenapps.com/gamergrid/console/61dd6ca2d126f7.47253176","selectedConsole":"0"}]}],"first_page_url":"http://gamergriddevapi-v1.0.regenapps.com/api/v1/portal/games/get-games-listing-data?page=1","from":1,"last_page":1,"last_page_url":"http://gamergriddevapi-v1.0.regenapps.com/api/v1/portal/games/get-games-listing-data?page=1","next_page_url":null,"path":"http://gamergriddevapi-v1.0.regenapps.com/api/v1/portal/games/get-games-listing-data","per_page":"10","prev_page_url":null,"to":1,"total":1}
/// msg : "games list data Fetched successfully"
/// code : 200

class ApiResponseForFetch {
  ApiResponseForFetch({
    String? vendorCode,
    String? vendorName,
    bool? status,
    List<dynamic>? masterMenu,
    List<dynamic>?transactionMenu,
    List<dynamic>?reportMenu,
    List<dynamic>?data,
    // int? workingDays,
    dynamic? companyDetail,
    String? msg,
    String? token,
    String? Machine_Name,
    int? code,
    String? UID,
    String? vstate,

  }) {


    _status = status;
    _masterMenu = masterMenu;
    _transactionMenu = transactionMenu;
    _reportMenu = reportMenu;
    _data=data;
    _msg = msg;
    _token = token;
    _Machine_Name = Machine_Name;
    _code = code;
    _UID = UID;
    _s3_url = s3_url;
    _companydetails=companyDetail;
    _vendorcode=vendorCode;
    _vendorname=vendorName;
    _vstate=vstate;
    // _workingday=workingDays
  }

  ApiResponseForFetch.fromJson(dynamic json) {
    _status = json['status'];
    _masterMenu = json['MasterSub_ModuleList'];
    _transactionMenu = json['TransactionSub_ModuleList'];
    _reportMenu = json['MasterSub_ModuleList'];
    _data=json['data'];
    _msg = json['msg'];
    _token = json['token'];
    _Machine_Name = json['Modifier_Machine'];
    _code = json['code'];
    _UID = json['UID'];
    _s3_url = json['s3_url'];
    _companydetails=json['Company_Detail'];
    _vendorcode=json['Emp_No'];
    _vendorname=json['Emp_Name'];
    _vstate=json['Emp_State'];
    // _workingday=json['Working_Days'];
  }

  bool? _status;
  List<dynamic>? _masterMenu;
  List<dynamic>? _transactionMenu;
  List<dynamic>? _reportMenu;
  List<dynamic>? _data;
  dynamic? _companydetails;
  // String? _workingday;

  String? _vendorcode;
  String? _vendorname;

  String? _msg;
  String? _token;
  String? _Machine_Name;
  int? _code;
  String? _UID;
  String? _s3_url;
  String? _vstate;

  bool? get status => _status;
  String? get UID => _UID;
  String? get token => _token;
  String? get Machine_Name => _Machine_Name;
  // String? get workingDays => _workingday;

  List<dynamic>? get masterMenu => _masterMenu;
  List<dynamic>? get transactionMenu => _transactionMenu;
  List<dynamic>? get reportMenu => _reportMenu;
  List<dynamic>? get data => _data;
  dynamic? get companyDetail => _companydetails;
  dynamic? get vendorCode => _vendorcode;
  dynamic? get vendorName => _vendorname;
  dynamic? get vstate => _vstate;



  String? get msg => _msg;
  String? get s3_url => _s3_url;

  int? get code => _code;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['status'] = _status;
    if (_masterMenu != null) {
      map['MasterSub_ModuleList'] = _masterMenu;
    }
    if (_transactionMenu != null) {
      map['TransactionSub_ModuleList'] = _transactionMenu;
    }
    if (_reportMenu != null) {
      map['ReportSub_ModuleList'] = _reportMenu;
    }
    if (_data != null) {
      map['data'] = _data;
    }
    // map['Working_Days'] = _workingday;
    if (this.companyDetail != null) {
      map['Company_Detail'] =
         _companydetails;
    }
    map['msg'] = _msg;
    map['token'] = _token;
    map['Modifier_Machine'] = _Machine_Name;
    map['code'] = _code;
    map['UID'] = _UID;
    map['s3_url'] = _s3_url;
    return map;
  }
}
*/
