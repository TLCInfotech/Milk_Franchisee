import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import '../../../../../../common_widget/common.dart';
import '../../../../../../common_widget/get_date_layout.dart';
import '../../../../../../common_widget/signleLine_TexformField.dart';
import '../../../../../../core/app_preferance.dart';
import '../../../../../../core/colors.dart';
import '../../../../../../core/common_style.dart';
import '../../../../../../core/internet_check.dart';
import '../../../../../../core/localss/api_data_fetch_localization.dart';
import '../../../../../../core/localss/application_localizations.dart';
import '../../../../../../core/size_config.dart';
import '../../../../../../data/commonRequest/get_toakn_request.dart';
import '../../../../../../data/constant.dart';
import '../../../../../../data/request_helper.dart';
import '../../../../../../searchable_Dropdowns/common_dropdown.dart';
import '../../../../../../searchable_Dropdowns/serchable_drop_down_for_existing_list.dart';
import '../../core/string_en.dart';


class AddOrEditMilkCollection extends StatefulWidget {
  final AddOrEditMilkCollectionInterface mListener;
  final dynamic editproduct;
  final date;
  final id;
  final readOnly;
  final route_type;
  final route_code;
  final String setVal;
  final String title;
  final session;
  final sessionName;
  const AddOrEditMilkCollection(
      {super.key,
        required this.mListener,
        required this.editproduct,
        required this.date,
        this.readOnly,
        this.id,
        this.route_type,
        this.route_code,
        this.session,
        this.sessionName, required this.setVal, required this.title
      });

  @override
  State<AddOrEditMilkCollection> createState() => _AddOrEditMilkCollectionState();
}

class _AddOrEditMilkCollectionState extends State<AddOrEditMilkCollection> {
  var kgFactor = 0.9707;
  var CLRConversionFactor = 0.36;
  var FATFactor = 0.21;

  bool isLoaderShow = false;
  final _formkey = GlobalKey<FormState>();

  TextEditingController _textController = TextEditingController();
  FocusNode partyFocus = FocusNode();
  final _partyKey = GlobalKey<FormFieldState>();


  var selectedPartyId = null;
  var selectedPartyName = "";

  var selectedMilkType=null;


  TextEditingController kgqty = TextEditingController();
  FocusNode kgqtyFocus = FocusNode();
  final _kgqtyKey = GlobalKey<FormFieldState>();


  TextEditingController ltrqty = TextEditingController();
  FocusNode ltrqtyFocus = FocusNode();
  final _ltrqtyKey = GlobalKey<FormFieldState>();



  TextEditingController fat = TextEditingController();
  FocusNode fatFocus = FocusNode();
  final _fatKey = GlobalKey<FormFieldState>();


  TextEditingController snfqty = TextEditingController();
  FocusNode snfFocus = FocusNode();
  final _snfKey = GlobalKey<FormFieldState>();


  TextEditingController clr = TextEditingController();
  FocusNode clrFocus = FocusNode();
  final _clrKey = GlobalKey<FormFieldState>();

  TextEditingController rate = TextEditingController();
  FocusNode rateFocus = FocusNode();
  final _rateKey = GlobalKey<FormFieldState>();


  TextEditingController amount = TextEditingController();
  FocusNode amountFocus = FocusNode();


  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  FocusNode searchFocus = FocusNode();

  getCompanyId() async {
    String companyId1 = await AppPreferences.getCompanyId();
    if(mounted){
      setState(() {
        companyId = companyId1;
      });}
    print("CompanyIDttttttt=> ${widget.route_type}");
  }

  var companyId = "0";


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
 //   callGetFactorValue();
    setVal();
    print("CompanyIDttttttt=> ${widget.route_type}");


  }
  List insertedList=[];

  setVal() async {
    if(mounted) {
      setState(() {
        isLoaderShow = true;
      });
    }
    print("Edited Item: ${widget.editproduct}");
    Future.delayed(Duration(seconds: 5)).then((_) {
      print("This will run after 2 seconds");
       callGetFactorValue();
    });
  //  await callGetFactorValue();

    if (widget.editproduct != null) {
      if(mounted){
        setState(() {
          selectedPartyId = widget.editproduct['Code'] != null
              ? widget.editproduct['Code']
              : null;
          selectedPartyName = widget.editproduct['Code_Name'] != null
              ? widget.editproduct['Code_Name']
              : null;
          selectedMilkType=widget.editproduct['Milk_Type'] != null ? widget.editproduct['Milk_Type'] : null;
          kgqty.text =widget.editproduct['Qty_In_KG']!="" &&widget.editproduct['Qty_In_KG']!=null?double.parse(widget.editproduct['Qty_In_KG'].toString()).toStringAsFixed(2):"";
          ltrqty.text= widget.editproduct['Qty_In_Liter']!="" &&widget.editproduct['Qty_In_Liter']!=null?double.parse(widget.editproduct['Qty_In_Liter'].toString()).toStringAsFixed(2):"";
          fat.text=widget.editproduct['Fat']!="" &&widget.editproduct['Fat']!=null?double.parse(widget.editproduct['Fat'].toString()).toStringAsFixed(2):"";
          clr.text=widget.editproduct['Lacto']!="" &&widget.editproduct['Lacto']!=null?double.parse(widget.editproduct['Lacto'].toString()).toStringAsFixed(2):"";
          snfqty.text=widget.editproduct['SNF']!="" &&widget.editproduct['SNF']!=null?double.parse(widget.editproduct['SNF'].toString()).toStringAsFixed(2):"";
          rate.text=    widget.editproduct['Rate']!="" &&widget.editproduct['Rate']!=null?double.parse(widget.editproduct['Rate'].toString()).toStringAsFixed(2):"";
          amount.text=  widget.editproduct['Amount']!="" &&widget.editproduct['Amount']!=null?double.parse(widget.editproduct['Amount'].toString()).toStringAsFixed(2):"";
          isLoaderShow=false;
        });}

    }
  // callGetFactorValue();
  }

  var itemsList = [];
  var filteredItemsList = [];

  var amountedited=false;

  var discountamtedited=false;


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Stack(
      alignment: Alignment.center,
      children: [
        Material(
          color: Colors.transparent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * .05,
                    right: SizeConfig.screenWidth * .05),
                child: Container(
                  height: SizeConfig.screenHeight * 0.8,
                  width: SizeConfig.screenWidth,
                  decoration: const BoxDecoration(
                    color:CommonColor.BACKGROUND_COLOR,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                    ),
                  ),
                  padding: EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child:isLoaderShow?Container():Form(
                      key: _formkey,
                      child:  Column(
                        children: [
                          Container(
                            height: SizeConfig.screenHeight * .08,
                            child: Center(
                              child:Text(widget.title,
                                style: appbar_text_style),
                            ),
                          ),
                         getAddSearchLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                          getMilkTypeLayout(SizeConfig.screenHeight, SizeConfig.screenWidth),
                         widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting?Container():
                         getKgAndLtr(SizeConfig.screenHeight, SizeConfig.screenWidth),
                          Row(
                            children: [
                              Expanded(child: getFatQuantityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth)),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(child: getSnfQuantityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth)),
                              SizedBox(
                                width: 15,
                              ),
                              Expanded(child: getClrQuantityLayout(SizeConfig.screenHeight, SizeConfig.screenWidth)),

                            ],
                          ),
                          widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting?Container():
                          getRateAndAmount(SizeConfig.screenHeight, SizeConfig.screenWidth),


                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    left: SizeConfig.screenWidth * .05,
                    right: SizeConfig.screenWidth * .05),
                child: getAddForButtonsLayout(
                    SizeConfig.screenHeight, SizeConfig.screenWidth),
              ),
            ],
          ),
        ),
        Positioned.fill(child: CommonWidget.isLoader(isLoaderShow)),
      ],
    );
  }

  // rate amount layout


  List<dynamic> ledger_list = [];



  //franchisee name
  Widget getAddSearchLayout(double parentHeight, double parentWidth) {
    print("sadas ${selectedPartyName}");
    return SearchableDropdownWithExistingList(
      apiUrl:ApiConstants().ledger+"?Group_ID=${widget.route_type}&Route_Code=${widget.route_code}&",
      mandatory: true,
      txtkey: _partyKey,
      focusnext:null,
      name: selectedPartyName,
      come: widget.editproduct!=null?"disable":"",
      status: selectedPartyName==""?"":"edit",
      titleIndicator: true,
      title: ApplicationLocalizations.of(context)!.translate("party")!,
      insertedList:insertedList,
      focuscontroller: partyFocus,
      callback: (item) async {
        if(item!=""){
          if(mounted){
            setState(() {
              selectedPartyId = item['ID'].toString();
              selectedPartyName = item['Name'].toString();
            });}
          _partyKey.currentState!.validate();
          await getRate();
        }

      },
    );


  }

  Widget getMilkTypeLayout(double parentHeight, double parentWidth) {
    return CommonDropdown(
      apiUrl: ApiConstants().item + "?Party_ID=${selectedPartyId}&Date=${widget.date}&Category=Milk&",
      nameField:"ID",
      idField:"ID",
      titleIndicator: true,
      ledgerName: selectedMilkType,
      franchiseeName:  selectedMilkType,
      franchisee: selectedMilkType!=null?"edit":"",
      readOnly: true,
      title: ApplicationLocalizations.of(context)!.translate("milk")!,
      callback: (item)async {
        if(mounted){
          setState(() {
            selectedMilkType= item['ID']!;
          });}

        print("############3 Vocher type");
        await getRate();

      },
    ) ;

  }


  Widget getKgAndLtr(double parentHeight, double parentWidth) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SingleLineEditableTextFormField(
          mandatory: true,
          txtkey: _kgqtyKey,
          parentWidth: (parentWidth),
          validation: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
          readOnly: widget.readOnly,
          controller: kgqty,
          focuscontroller: kgqtyFocus,
          focusnext: ltrqtyFocus,
          title: ApplicationLocalizations.of(context)!.translate("kg")!,
          callbackOnchage: (value) async {
            if(mounted){
              setState(() {
             //   kgqty.text = value;
              });}
            await CalculateLtrQty();
            await calGetAmount();
            _kgqtyKey.currentState!.validate();
          },
          textInput: TextInputType.numberWithOptions(
              decimal: true
          ),
          maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
      ),

      SizedBox(width: 5,),

       Expanded(
         child: SingleLineEditableTextFormField(
            parentWidth: (parentWidth),
            validation: (value) {
              if (value!.isEmpty) {
                return "";
              }
              return null;
            },
            readOnly: widget.readOnly,
            controller: ltrqty,
            focuscontroller: ltrqtyFocus,
            focusnext: fatFocus,
            title: ApplicationLocalizations.of(context)!.translate("ltr")!,
            callbackOnchage: (value) async {
              print("########### $value");
              if(mounted){
                setState(() {
             //     ltrqty.text=value;
                });}
              await CalculateKgQty();
              await calGetAmount();
            },
            textInput: TextInputType.numberWithOptions(
                decimal: true
            ),
            maxlines: 1,
            format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
               ),
       ),
    ]);
  }

  /* widget for item quantity layout */
  Widget getFatQuantityLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(
        mandatory: false,
        txtkey: _fatKey,
        suffix: Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: fat,
        focuscontroller: fatFocus,
        focusnext: snfFocus,
        title: ApplicationLocalizations.of(context)!.translate("fat")!,
        callbackOnchage: (value) async {
          if(mounted) {

            if (fat.text == "") {
              setState(() {
                rate.clear();
                amount.clear();
              });
            }
            else {
              setState(() {
              //  fat.text = value;
                CalculateClr();
               // CalculateSnf();
                getRate();
              });

            }
            _fatKey.currentState!.validate();
          }
        },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );
  }

  /* widget for item quantity layout */
  Widget getSnfQuantityLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(

        mandatory: false,
        txtkey: _snfKey,
        suffix: Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: snfqty,
        focuscontroller: snfFocus,
        focusnext: clrFocus,
        title: ApplicationLocalizations.of(context)!.translate("snf")!,
        callbackOnchage: (value) async {
          if(value!="") {
            if(mounted){
              setState(() {
              //  snfqty.text = value;
              });}
            _snfKey.currentState!.validate();
          }
          await CalculateClr();
          await getRate();
          await calGetAmount();

        },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );
  }

  /* widget for item quantity layout */
  Widget getClrQuantityLayout(double parentHeight, double parentWidth) {
    return SingleLineEditableTextFormField(

        mandatory: false,
        txtkey: _clrKey,
        suffix: Text(""),
        validation: (value) {
          if (value!.isEmpty) {
            return "";
          }
          return null;
        },
        readOnly: widget.readOnly,
        controller: clr,
        focuscontroller: clrFocus,
        focusnext: rateFocus,
        title: ApplicationLocalizations.of(context)!.translate("clr")!,
        callbackOnchage: (value) async {
          if(value!="") {
            if(mounted){
              setState(() {
             //   clr.text = value;
              });}
            _clrKey.currentState!.validate();
          }
          await CalculateSnf();
          await getRate();
          await calGetAmount();
        },
        textInput: TextInputType.numberWithOptions(
            decimal: true
        ),
        maxlines: 1,
        format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
    );
  }

  // rate amount layout
  Widget getRateAndAmount(double parentHeight, double parentWidth) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      SingleLineEditableTextFormField(
          mandatory: false,
          txtkey: _rateKey,
          parentWidth: (parentWidth),
          validation: (value) {
            if (value!.isEmpty) {
              return "";
            }
            return null;
          },
          readOnly: false,
          controller: rate,
          focuscontroller: rateFocus,
          focusnext: amountFocus,
          title: ApplicationLocalizations.of(context)!.translate("rate")!,
          callbackOnchage: (value) async {
            if(mounted){
              setState(() {
              //  rate.text = value;
              });}
            if(snfqty.text!="")
              await CalculateSnf();

            _rateKey.currentState!.validate();
          },
          textInput: TextInputType.numberWithOptions(
              decimal: true
          ),
          maxlines: 1,
          format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
      ),
      SizedBox(width: 5,),

      Expanded(
        child: SingleLineEditableTextFormField(
            parentWidth: (parentWidth),
            validation: (value) {
              if (value!.isEmpty) {
                return "";
              }
              return null;
            },
            readOnly: false,
            controller: amount,
            focuscontroller: amountFocus,
            focusnext: null,
            title: ApplicationLocalizations.of(context)!.translate("amount")!,
            callbackOnchage: (value) async {
              print("########### $value");
              if(mounted){
                setState(() {
                  // amount.text=value;
        
                });}
            },
            textInput: TextInputType.numberWithOptions(
                decimal: true
            ),
            maxlines: 1,
            format:  FilteringTextInputFormatter.allow(RegExp(r'(^\d*\.?\d{0,2})'))
        ),
      ),
    ]);
  }

  /* widget for button layout */
  Widget getFieldTitleLayout(String title) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(
        top: 10,
        //  bottom: 10,
      ),
      child: Text(
        "$title",
        style: item_heading_textStyle,
      ),
    );
  }


  CalculateLtrQty()async{
    // (Qty_In_KG * kgFactor, 2);
    double Kgqty = kgqty.text == "" ? 0.0 : double.parse(kgqty.text);
    var LtrQty= Kgqty * kgFactor;
    if(mounted){
      setState(() {
        ltrqty.text=LtrQty.toStringAsFixed(2);
      });}
  }

  CalculateKgQty()async{
    // (Qty_In_KG * kgFactor, 2);
    double LtrQty = ltrqty.text == "" ? 0.0 : double.parse(ltrqty.text);
    var KgQty= LtrQty / kgFactor;
    if(mounted){
      setState(() {
        kgqty.text=KgQty.toStringAsFixed(2);
      });}
  }

  CalculateClr()async{
    print("CLR CALCULATION");
    print(snfqty.text);
    if (snfqty.text==""|| fat.text==""){
      if(mounted){
        setState(() {
          clr.clear();
        });}
    }
    if(snfqty.text!="") {
      var snf = snfqty.text == "" ? 0.0 : double.parse(snfqty.text);
      var fatv = fat.text == "" ? 0.0 : double.parse(fat.text);
      var lactos = (4 * (snf - CLRConversionFactor - (FATFactor*fatv))) ;
      print("############ $lactos");
      var lactoInt=(double.parse(lactos.toStringAsFixed(2))*2).round();
      setState(() {
        clr.text = (lactoInt/2.0).toStringAsFixed(2);
      });
    }
  }

  CalculateSnf()async{

    print(clr.text);
    if(clr.text!="") {
      var Fat = fat.text == "" ? 0.0 : double.parse(fat.text);
      var lactos = clr.text == "" ? 0.0 : double.parse(clr.text);
      var newsnf = ((lactos / 4) + (FATFactor * Fat) + CLRConversionFactor);
      if(mounted){
        setState(() {
          snfqty.text = (newsnf).toStringAsFixed(2);
        });}
    }
    else if(clr.text==""){
      if(mounted){
        setState(() {
          snfqty.clear();
        });}
    }
  }

  callGetFactorValue() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      if(mounted){
        setState(() {
          isLoaderShow=true;
        });}
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + ApiConstants().milk_default_values + "?Company_ID=$companyId&Group_Type=Farmer";
      apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            isLoaderShow=false;
            if(mounted) {
              setState(() {
                kgFactor = data['kgFactor'] != null ? data['kgFactor'] : null;
                CLRConversionFactor = data['CLRConversionFactor'] != null
                    ? data['CLRConversionFactor']
                    : null;
                FATFactor =
                data['FATFactor'] != null ? data['FATFactor'] : null;
              });
            }
            // }

            print(" FFFFFFFFFFFFFF ${kgFactor} $CLRConversionFactor  $FATFactor}");

          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);

          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            // CommonWidget.gotoLoginScreen(context);

            // widget.mListener.loaderShow(false);
          });

    });
  }

  calGetAmount()async{
    if(rate.text!="") {
      double a = double.parse(ltrqty.text) * double.parse(rate.text);
      if(mounted){
        setState(() {
          amount.text = a.toStringAsFixed(2);
        });}
    }

  }


  getRate()async{
    if(selectedPartyId!=null && fat.text!=""&&snfqty.text!=""&& selectedMilkType!=null){
      await callGetRate();
    }
  }

  callGetRate() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      // setState(() {
      //   isLoaderShow=true;
      // });
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + ApiConstants().rate + "?Company_ID=$companyId&Date=${DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.date))}&Session=${widget.session}&Center_Code=${selectedPartyId}&Milk_Type=${selectedMilkType}&FAT=${fat.text}&SNF=${snfqty.text}";
      apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
          onSuccess:(data)async{
            // isLoaderShow=false;
            if(mounted){
              setState(() {

                rate.text=data[0]['rate'].toString();
              });}
            await calGetAmount();

            // }

            print(" FFFFFFFFFFFFFF $data}");

          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);


          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            // CommonWidget.gotoLoginScreen(context);

            // widget.mListener.loaderShow(false);
          });

    });
  } 

  /* Widget for Buttons Layout */
  Widget getAddForButtonsLayout(double parentHeight, double parentWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth * .45,
            // width: SizeConfig.blockSizeVertical * 20.0,
            decoration: const BoxDecoration(
              color: CommonColor.HINT_TEXT,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("close")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle,
                ),
              ],
            ),
          ),
        ),
        GestureDetector(
          onTap: () async{
            String creatorName = await AppPreferences.getUId();
            String device = await AppPreferences.getDeviceId();

            // bool r=_rateKey.currentState!.validate();
            if(       widget.setVal==StringEn.farmerLabTesting||widget.setVal==StringEn.centerLabTesting){
              bool v=_partyKey.currentState!.validate();

              if( selectedPartyId!=null&& v){
                var item = {};
                if (widget.editproduct != null) {
                  item = {
                    // "New_Item_Code": selectedPartyId,
                    "Seq_No": widget.editproduct != null ? widget.editproduct['Seq_No'] : null,
                    "Transport_No":widget.editproduct!=null?widget.editproduct['Transport_No']:null,
                    "Date":DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.date.toString())),
                    "Session": widget.session,
                    "Code":selectedPartyId,
                    "Code_Name":selectedPartyName,
                    "Milk_Type": selectedMilkType,
                    "Fat": fat.text!=""?fat.text:null,
                    "Lacto": clr.text!=""?clr.text:null,
                    "SNF": snfqty.text!=""?snfqty.text:null,
                    "Modifier": creatorName,
                    "Modifier_Machine": device
                  };
                  await callPutMilkCollection(item);
                }
              }
            }else{
              bool v=_partyKey.currentState!.validate();
              bool q=_kgqtyKey.currentState!.validate();
            if ( selectedPartyId!=null&& v && q  ) {
              var item = {};
              if (widget.editproduct != null) {
                item = {
                  // "New_Item_Code": selectedPartyId,
                  "Seq_No": widget.editproduct != null ? widget.editproduct['Seq_No'] : null,
                  "Transport_No":widget.editproduct!=null?widget.editproduct['Transport_No']:null,
                  "Date":DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.date.toString())),
                  "Session": widget.session,
                  "Code":selectedPartyId,
                  "Code_Name":selectedPartyName,
                  "Milk_Type": selectedMilkType,
                  "Qty_In_KG": kgqty.text!=""?kgqty.text:null,
                  "Qty_In_Liter": ltrqty.text!=""?ltrqty.text:null,
                  "Fat": fat.text!=""?fat.text:null,
                  "Lacto": clr.text!=""?clr.text:null,
                  "SNF": snfqty.text!=""?snfqty.text:null,
                  "Rate": rate.text!=""?rate.text:null,
                  "Amount":amount.text!=""?amount.text:null,
                  "Modifier": creatorName,
                  "Modifier_Machine": device

                };
                await callPutMilkCollection(item);
              } else {
                item = {
                  "Date":DateFormat('yyyy-MM-dd').format(DateTime.parse(widget.date.toString())),
                  "Session": widget.session,
                  // "Transport_No":widget.editproduct!=null?widget.editproduct['Transport_No']:null,
                  "Code":selectedPartyId,
                  "Code_Name":selectedPartyName,
                  "Milk_Type": selectedMilkType,
                  "Qty_In_KG": kgqty.text!=""?kgqty.text:null,
                  "Qty_In_Liter": ltrqty.text!=""?ltrqty.text:null,
                  "Fat": fat.text!=""?fat.text:null,
                  "Lacto": clr.text!=""?clr.text:null,
                  "SNF": snfqty.text!=""?snfqty.text:null,
                  "Rate": rate.text!=""?rate.text:null,
                  "Amount":amount.text!=""?amount.text:null,
                  "Modifier": creatorName,
                  "Modifier_Machine": device
                };
                await callPostMilkCollection(item);
              }

              print(item);

            }
            else {
            }}
          },
          onDoubleTap: () {},
          child: Container(
            height: parentHeight * .05,
            width: parentWidth * .45,
            decoration: BoxDecoration(
              color: CommonColor.THEME_COLOR,
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(5),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  ApplicationLocalizations.of(context)!.translate("save")!,
                  textAlign: TextAlign.center,
                  style: text_field_textStyle.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }


  callPutMilkCollection(model) async {

    String baseurl = await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });
        String apiUrl = baseurl + ApiConstants().milk_collection+"?Company_ID=$companyId";
        print("gkbnbgnmg $apiUrl \n $model");
        apiRequestHelper.callAPIsForPutAPI(context,apiUrl, model, "",
            onSuccess: (data) async {
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow = true;
              });
              if (widget.mListener != null) {
                widget.mListener.AddOrEditMilkCollectionDetail("Sucess");
                Navigator.pop(context);
              }
            }, onFailure: (error) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, e.toString());
            }, sessionExpire: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }

  callPostMilkCollection(model) async {
    String creatorName = await AppPreferences.getUId();
    String device = await AppPreferences.getDeviceId();
    String baseurl = await AppPreferences.getDomainLink();
    String companyId = await AppPreferences.getCompanyId();

    InternetConnectionStatus netStatus = await InternetChecker.checkInternet();
    if (netStatus == InternetConnectionStatus.connected) {
      AppPreferences.getDeviceId().then((deviceId) {
        setState(() {
          isLoaderShow = true;
        });


        String apiUrl = baseurl + ApiConstants().milk_collection+"?Company_ID=$companyId";
        apiRequestHelper.callAPIsForDynamicPI(context,apiUrl, model, "",
            onSuccess: (data) async {
              print("  ITEM  $data ");
              setState(() {
                isLoaderShow = true;

              });
              if (widget.mListener != null) {
                widget.mListener.AddOrEditMilkCollectionDetail("Sucess");
                Navigator.pop(context);
              }
            }, onFailure: (error) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, error.toString());
            }, onException: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.errorDialog(context, e.toString());
            }, sessionExpire: (e) {
              setState(() {
                isLoaderShow = false;
              });
              CommonWidget.gotoLoginScreen(context);
              // widget.mListener.loaderShow(false);
            });
      });
    } else {
      if (mounted) {
        setState(() {
          isLoaderShow = false;
        });
      }
      CommonWidget.noInternetDialogNew(context);
    }
  }


}

abstract class AddOrEditMilkCollectionInterface {
  AddOrEditMilkCollectionDetail(dynamic item);
}
