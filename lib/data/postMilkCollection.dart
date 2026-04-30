class PostMilkCollection {

  String? date;
  String? session;
  String? deduction;
  String? Comm_Code;
  String? Rate;
  String? From_Date;
  String? To_Date;
  String? operatorCode;
  String? routeCode;
  String? vehicleNo;
  String? transporter;
  String? modifierMachine;
  int? transportNo;
  List<dynamic>? data;

  PostMilkCollection(
      {this.date,
        this.session,
        this.Comm_Code,
        this.deduction,
        this.Rate,
        this.To_Date,
        this.operatorCode,
        this.From_Date,
        this.routeCode,
        this.vehicleNo,
        this.transporter,
        this.modifierMachine,
        this.transportNo,
        this.data});

  PostMilkCollection.fromJson(Map<String, dynamic> json) {
    date = json['Date'];
    session = json['Session'];
  Comm_Code = json['Comm_Code'];
  deduction=json['Deduction_Code'];
  From_Date = json['From_Date'];
  To_Date = json['To_Date'];
  Rate = json['Rate'];
    operatorCode = json['Modifier'];
    routeCode = json['Route_Code'];
    vehicleNo = json['Vehicle_No'];
    transporter=json['Transporter'];
    modifierMachine=json['Modifier_Machine'];
    transportNo = json['Transport_No'];
    if (json['DATA'] != null) {
      data = <dynamic>[];
      json['DATA'].forEach((v) {
        data!.add( v.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Date'] = this.date;
    data['Session'] = this.session;
    data['Comm_Code'] = this.Comm_Code;
    data['Deduction_Code']=this.deduction;
    data['Rate'] = this.Rate;
    data['From_Date'] = this.From_Date;
    data['To_Date'] = this.To_Date;
    data['Modifier'] = this.operatorCode;
    data['Route_Code'] = this.routeCode;
    data['Vehicle_No'] = this.vehicleNo;
    data['Transporter']=this.transporter;
    data['Modifier_Machine']=this.modifierMachine;
    data['Transport_No'] = this.transportNo;
    if (this.data != null) {
      data['DATA'] = this.data!.map((v) => v).toList();
    }
    return data;
  }
}
