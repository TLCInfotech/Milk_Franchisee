import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

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
  dynamic unit;
  dynamic rate;
  dynamic gst;
  TestItem({required this.label, this.value,this.unit,this.rate,this.gst});

  factory TestItem.fromJson(Map<String, dynamic> json) {
    return TestItem(label: json['label'], value: json['value'],unit:"${json['unit']}",rate:"${json['rate']}",gst:"${json['gst']}");
  }
}

class SearchableDropdownWithExistingList extends StatefulWidget{
  final title;
  final name;
  final Function(dynamic?) callback;
  final titleIndicator;
  final apiUrl;
  final status;
  final come;
  final insertedList;
  final focuscontroller;
  final txtkey;
  final focusnext;
  final mandatory;
  SearchableDropdownWithExistingList({required this.title, required this.callback, required this.name,this.titleIndicator,this.come,required this.apiUrl,this.status,this.insertedList,this.focuscontroller,this.txtkey,this.focusnext,this.mandatory});

  @override
  State<SearchableDropdownWithExistingList> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableDropdownWithExistingList> with  SingleTickerProviderStateMixin {

  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }
  getData()async{
    await callGetLedger();
    print("gggggg ${widget.status}");
    if(widget.status=="edit"){
      print(":::::: ${widget.name}");
      _controller.text=widget.name;

    }
    else{
      _controller.clear();
      setState(() {
        selected=null;
      });
    }
    searchFocus.addListener(_onFocusChange);
  }

  FocusNode searchFocus = FocusNode() ;

  void _onFocusChange() {
    if (!searchFocus.hasFocus) {
      if(selected==null){
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

  List<dynamic> ledger_list = [];

  var filteredStates = [];


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
            ledger_list=[];
            if(data!=null) {

                setState(() {
                  ledger_list = data;
                  filteredStates = ledger_list;
                });
              // }

              print(" FFFFFFFFFFFFFF ${ledger_list.length} ${filteredStates.length}");

            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);


          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            // CommonWidget.gotoLoginScreen(context);

          });

    });
  }

  final TextEditingController _controller = TextEditingController();
  final FocusNode reqFocus=FocusNode();

  var selectedItem=null;
  var selected=null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:  widget.titleIndicator!=false?EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.0):EdgeInsets.only(top: (SizeConfig.screenHeight) * 0.0),
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
              child: TypeAheadFormField(

                key: widget.txtkey,
                textFieldConfiguration: TextFieldConfiguration(
                  onTap: (){
                    setState(() {
                      callGetLedger();
                    });
                  },
                  onChanged: (v)async{
                    if(v.isEmpty) {
                      setState(() {
                        selected=null;
                        print("knjbnbnjbnbn  $v");
                      });
                      await widget.callback(selected);
                    }
                  },
                  style: item_heading_textStyle,
                  textInputAction: TextInputAction.none,
                //  enabled: widget.come=="disable"?false:true, // Change input action to "none"
                  focusNode: searchFocus,
                  controller: _controller,
                  decoration: textfield_decoration.copyWith(

                    // labelText: '${widget.title}',
                      hintText: "${widget.title}",
                      border: OutlineInputBorder(),
                      suffixIcon: _controller.text=="" ?Icon(Icons.search):IconButton(onPressed: (){
                      setState(() {
                      _controller.clear();
                      });
                      widget.callback("");
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

                suggestionsCallback: (pattern)async  {
                  return await _getSuggestions(pattern);

                },
                itemBuilder: (context, suggestion) {
                  return ListTile(
                    title: Text(suggestion['Name']),
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
                    selectedItem = suggestion['Name'];
                    selected=suggestion;
                    _controller.text=suggestion['Name'];
                  });
                  widget.callback(suggestion);
                  widget.focuscontroller.unfocus();
                  FocusScope.of(context).requestFocus(widget.focusnext);
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  List _getSuggestions(String query) {
    List matches = [];
    matches.addAll(ledger_list);

    // matches.retainWhere((s) => s['Name'].toLowerCase().contains(query.toLowerCase()));
    print(matches
        .where((s) => s['Name'].toLowerCase().contains(query.toLowerCase()))
        .toList());
    // return matches;
    return matches
        .where((s) => s['Name'].toLowerCase().contains(query.toLowerCase()))
        .toList();
  }


}
