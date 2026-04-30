import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/localss/api_data_fetch_localization.dart';

import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../core/size_config.dart';
import '../data/commonRequest/get_toakn_request.dart';
import '../data/request_helper.dart';
import '../common_widget/common.dart';



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

class SearchableDropdownWithObject extends StatefulWidget{
  final title;
  final name;
  final Function(dynamic?) callback;
  final titleIndicator;
  final apiUrl;
  final status;
  final readOnly;
  final txtkey;
  final focusnext;
  final mandatory;
  final focuscontroller;
  SearchableDropdownWithObject({required this.title, required this.callback, required this.name,this.titleIndicator,required this.apiUrl,this.status, this.readOnly,this.focuscontroller,this.txtkey,this.focusnext,this.mandatory});




  @override
  State<SearchableDropdownWithObject> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableDropdownWithObject> with  SingleTickerProviderStateMixin {
  bool isLoaderShow = false;
  TextEditingController _textController = TextEditingController();

  ApiRequestHelper apiRequestHelper = ApiRequestHelper();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    callGetLedger();
    print("gggggg ${widget.status}");
    if(widget.status=="edit"){
      print(":::::: ${widget.name}");
      _controller.text=widget.name;
    }
    searchFocus.addListener(_onFocusChange);

  }

  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;

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

  Future<List> fetchSimpleData(searchstring) async {
    List<dynamic> _list = [];
    List<dynamic> results = [];
    // if (searchstring.isEmpty) {
    //   // if the search field is empty or only contains white-space, we'll display all users
    //   results = filteredStates;
    // } else {

    results = filteredStates
        .where((user) =>
        user["Code"]
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
          {'label': "${ele['Code']}", 'value': "${ele['Code']}"}));
    }
    return _list;
  }

  callGetLedger() async {
    String companyId = await AppPreferences.getCompanyId();
    String baseurl=await AppPreferences.getDomainLink();
    //String lang=await AppPreferences.getLang();
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
              print("  LedgerLedger  $data ");
            }
          }, onFailure: (error) {
            CommonWidget.errorDialog(context, error);

            // CommonWidget.onbordingErrorDialog(context, "Signup Error",error.toString());
            //  widget.mListener.loaderShow(false);
            //  Navigator.of(context, rootNavigator: true).pop();
          }, onException: (e) {
            CommonWidget.errorDialog(context, e);

          },sessionExpire: (e) {
            CommonWidget.gotoLoginScreen(context);
            
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
                  style: item_heading_textStyle,
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
                    textInputAction: TextInputAction.none, // Change input action to "none"
                   focusNode: searchFocus,
                    controller: _controller,
                    enabled: widget.readOnly==false?false:true,
                    decoration: textfield_decoration.copyWith(
                      // labelText: '${widget.title}',
                        hintText: "${widget.title}",
                        border: OutlineInputBorder(),
                      suffixIcon: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //(_controller.text != "")?Container():
                          IconButton(
                            onPressed: (){
                              setState(() {
                                searchFocus.requestFocus();
                                if(_isListening==false){
                                  _controller.clear();
                                }
                              });
                            },
                            icon: Icon(_isListening
                                ? Icons.mic
                                : Icons.mic_none),
                          ),
                          (_controller.text == "" )
                              ? const Icon(Icons.search)
                              : IconButton(
                            onPressed: () {
                              setState(() {
                                _controller.clear();
                              });
                              widget.callback("");
                              searchFocus.requestFocus();
                              _controller.text =
                                  _controller.text; // Trigger a rebuild
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                      ),                          errorStyle: TextStyle(
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
                      title: Text(suggestion['Code']),
                    );
                  },
                  validator: (value) {
                                  print("kkjggkg   $value");
                  if (value!.isEmpty) {
                  return '';
                  }},
                  onSuggestionSelected: (suggestion) {
                    setState(() {
                      print("knjbnbnjbnbn2222  $suggestion  $selected");
                      selectedItem = suggestion['Code'];
                      selected=suggestion;
                      _controller.text=suggestion['Code'];
                    });
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
  List _getSuggestions(String query) {
    List matches = [];
    matches.addAll(ledger_list);

    matches.retainWhere((s) => s['Code'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }



}
