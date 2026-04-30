import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:intl/intl.dart';
import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../common_widget/common.dart';
import '../core/localss/api_data_fetch_localization.dart';
import '../core/size_config.dart';
import '../data/commonRequest/get_toakn_request.dart';
import '../data/request_helper.dart';

class TestItem {
  String label;
  dynamic value;
  TestItem({required this.label, this.value});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value']);
  }
}

class CommonDropdownForEmployee extends StatefulWidget{
  final title;
  final ledgerName;
  final Function(dynamic?) callback;
  final titleIndicator;
  final apiUrl;
  final franchisee;
  final arryList;
  final come;
  final franchiseeName;
  final suffixicon;
  final readOnly;
  final focuscontroller;
  final txtkey;
  final focusnext;
  final mandatory;
  final nameField;
  final idField;
  CommonDropdownForEmployee({required this.title, required this.callback, required this.ledgerName,this.titleIndicator,required this.apiUrl, this.franchisee, this.franchiseeName, this.come,this.suffixicon, this.readOnly,this.focuscontroller,this.txtkey,this.focusnext,this.mandatory, this.nameField, this.idField, this.arryList});




  @override
  State<CommonDropdownForEmployee> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<CommonDropdownForEmployee> with  SingleTickerProviderStateMixin {


  bool isLoaderShow = false;
  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  final TextEditingController _controller = TextEditingController();

  var selectedItem=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setdata();
    mergeFinalArrayToLastCreatedRecord();
    // searchFocus.addListener(() {
    //   if (!searchFocus.hasFocus) {
    //     // Clear text when the field loses focus
    //     _controller.clear();
    //   }
    // });
    searchFocus.addListener(_onFocusChange);
  }

  void _onFocusChange() {
    if (!searchFocus.hasFocus) {
      if(selectedItem==null){
        FocusManager.instance.primaryFocus?.unfocus();
        _controller.clear();
        var snackBar=SnackBar(content: Text(ApplicationLocalizations.of(context).translate("no_item_ava")));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

      }
    }
  }

  @override
  void dispose() {
    searchFocus.removeListener(_onFocusChange);
    searchFocus.dispose();
    super.dispose();
  }
  setdata()async{
    await callGetLedger();
    if(widget.franchisee=="edit"){
      print(":::::: ${widget.franchiseeName}\n ${widget.ledgerName}");
      _controller.text=widget.franchiseeName!=null?widget.franchiseeName:"";
    }
  }
  List<dynamic> ledger_list = [];

  var filteredStates = [];
  List<dynamic> lastCreatedRecord = [];
  // Function to handle record creation
  void createRecord(String id, String name) {
    // Check if the record exists in the lastCreatedRecord list
    var existingRecord = lastCreatedRecord.firstWhere(
          (record) => record['id'] == id,
      orElse: () => null,
    );
    print("kvmnbmbn1111   $existingRecord");
    if (existingRecord != null) {
      // Check if 1 hour has passed since the last creation
      //DateTime lastCreatedTime = existingRecord['createdTime'];
      String lastCreatedTimee =  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.parse(existingRecord['createdTime']));
      DateTime punchInTime = DateTime.parse(lastCreatedTimee); // Your punch-in time
      String now1 =  DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now().toLocal()); // Current time (simulating DateTime.now())
      DateTime now=DateTime.parse(now1);
      Duration difference = now.difference(punchInTime);
      print("kvmnbmbn4444   ${difference}     ${now}   $punchInTime");
      if(difference.inHours>=1){
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('${ApplicationLocalizations.of(context).translate("record_created_succesfully")} $name')),
        );

      }else{
        print("gkjgnjnnm");
        // Show warning snackbar if within 1-hour window
        _controller.clear();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${ApplicationLocalizations.of(context).translate("cant_create_record")} $name. ${ApplicationLocalizations.of(context).translate("try_after_onehr")}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      print("Difference in Hours: ${difference.inHours} hours");
      print("Difference in Minutes: ${difference.inMinutes % 60} minutes");
      print("Difference in Seconds: ${difference.inSeconds % 60} seconds");
    }
  }

  // Function to merge data from finalArrayList into lastCreatedRecord
  void mergeFinalArrayToLastCreatedRecord() {
    for (var record in widget.arryList) {
      var existingRecord = lastCreatedRecord.firstWhere(
            (lastRecord) => lastRecord['id'] == record['Vendor_Code'],
        orElse: () => null,
      );

      if (existingRecord != null) {
        // If the record exists, update it with new information
        existingRecord['createdTime'] = record['Date'];
        existingRecord['vendorName'] = record['Vendor_Name'];
      } else {
        // If the record doesn't exist, add it to lastCreatedRecord
        lastCreatedRecord.add({
          'id': record['Vendor_Code'],
          'createdTime': record['Date'],
          'vendorName': record['Vendor_Name'],
        });
      }
    }
  }
  @override
  Widget build(BuildContext context) {
    return

      Padding(
        padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.02):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            widget.titleIndicator!=false? widget.mandatory==true?
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text:widget.title,style: item_heading_textStyle,),
                  TextSpan(text:"*",style: item_heading_textStyle.copyWith(color: Colors.red),),
                ],
              ),
            )
                : Text(
              widget.title,
              style: item_heading_textStyle,
            ):Container(),
            Padding(
              padding: EdgeInsets.only(top: (SizeConfig.screenHeight) * .005),
              child:  Container(
                height: SizeConfig.screenHeight * .055,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: CommonColor.WHITE_COLOR,
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      offset: Offset(0, 1),
                      blurRadius: 5,
                      color: Colors.black.withOpacity(0.1),
                    ),
                  ],
                ),
                child:    TypeAheadFormField(
                  key: widget.txtkey,
                  getImmediateSuggestions: true,
                  textFieldConfiguration: TextFieldConfiguration(
style: item_heading_textStyle,
                    onChanged: (v)async{
                      if(v.isEmpty) {
                        setState(() {
                          selectedItem=null;
                          print("knjbnbnjbnbn  $v");
                        });
                        await widget.callback(null);
                      }
                    },
                    onSubmitted: (v){
                      if(_controller.text.replaceAll(" ", "").length!=widget.ledgerName.toString().replaceAll(" ", "").length){
                        setState(() {
                          _controller.clear();
                        });
                        widget.callback(null);
                        searchFocus.unfocus();
                      }},
                    onTapOutside: (event) {
                    },
                    onEditingComplete: () {
                      print("onchangedddddd2222  ");
                      if(_controller.text.replaceAll(" ", "").length!=widget.ledgerName.toString().replaceAll(" ", "").length){
                        setState(() {
                          _controller.clear();
                        });
                        widget.callback(null);
                        searchFocus.unfocus();
                      }
                    },
                    onTap: (){
                      // _controller.clear();
                      setState(() {
                        callGetLedger();
                      });
                    },
                    textInputAction: TextInputAction.none, // Change input action to "none"
                    controller: _controller,
                    //enabled: widget.come=="disable"?false:true,
                    enabled: widget.readOnly==false?false:true,
                    focusNode: searchFocus,
                    decoration: textfield_decoration.copyWith(
                      // labelText: '${widget.title}',
                      hintText: "${widget.title}",
                      border: OutlineInputBorder(),
                      suffixIcon: widget.come=="disable"?null: (_controller.text=="" || _controller.text==null)?Icon(Icons.search):IconButton(onPressed: (){
                        setState(() {
                          _controller.clear();
                        });
                        widget.callback(null);
                        searchFocus.requestFocus();
                        // Optionally, trigger the suggestion box to show manually
                        _controller.text = _controller.text; // Trigger a rebuild
                      }, icon: Icon(Icons.clear)),
                      errorStyle: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 16.0,
                          height: 0
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return _getSuggestions(pattern);
                  }, 
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['${widget.nameField}']),
                    );
                  },
                  validator: (value) {
                    print("kkjggkg   $value");
                    if (value!.isEmpty) {
                      return '';
                    }

                  },
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      selectedItem = suggestion['${widget.nameField}'];
                      _controller.text=suggestion['${widget.nameField}'];
                    });
                    print("<><<<<<<<>");
                    print(suggestion);
                    createRecord(suggestion['ID'].toString(),suggestion['Name'].toString());
                    widget.callback(suggestion);

                    if(widget.focuscontroller!=null) {
                      widget.focuscontroller.unfocus();
                      FocusScope.of(context).requestFocus(widget.focusnext);
                    }
                  },
                ),
              ),
            )
          ],
        ),
      );
  }


  Future<List> fetchSimpleData(searchstring) async {
    List<dynamic> _list = [];
    List<dynamic> results = [];
    // if (searchstring.isEmpty) {
    //   // if the search field is empty or only contains white-space, we'll display all users
    //   results = filteredStates;
    // } else {

    results = filteredStates
        .where((user) =>
        user["${widget.nameField}"]
            .toLowerCase()
            .contains(searchstring.toLowerCase()))
        .toList();
    // we use the toLowerCase() method to make it case-insensitive
    // }

    // Refresh the UI
    setState(() {
      ledger_list = results;
    });

    //  for (var ele in data) _list.add(ele['TestName'].toString());
    for (var ele in ledger_list) {
      _list.add(new TestItem.fromJson(
          {'label': "${ele['${widget.nameField}']}", 'value': "${ele['${widget.idField}']}"}));
    }
    return _list;
  }

  callGetLedger() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    String sessionToken = await AppPreferences.getSessionToken();
    AppPreferences.getDeviceId().then((deviceId) {
      setState(() {
        isLoaderShow=true;
      });
      TokenRequestModel model = TokenRequestModel(
        token: sessionToken,
      );
      String apiUrl = baseurl + widget.apiUrl+"Company_ID=$companyId";
      apiRequestHelper.callAPIsForGetAPI(context,apiUrl, model.toJson(), "",
          onSuccess:(data){
            isLoaderShow=false;
            if(data!=null) {
              setState(() {
                ledger_list = data;
                filteredStates=ledger_list;
              });
              print("  LedgerLedgersearrr  ${ledger_list.length} ");
            }
          }, onFailure: (error) {

            CommonWidget.errorDialog(context, error);

            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            // CommonWidget.gotoLoginScreen(context);

          });

    });
  }



  List _getSuggestions(String query) {
    List matches = [];
    matches.addAll(ledger_list);

    matches.retainWhere((s) => s['${widget.nameField}'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}
