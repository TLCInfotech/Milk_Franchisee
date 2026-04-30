import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/localss/api_data_fetch_localization.dart';

import 'package:flutter/services.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import '../../core/colors.dart';
import '../../core/common_style.dart';
import '../core/size_config.dart';
import '../data/request_helper.dart';


class SearchableItemsDropdown extends StatefulWidget{
  final title;
  final ledgerName;
  final Function(dynamic?) callback;
  final titleIndicator;
  final franchisee;
  final come;
  final franchiseeName;
  final suffixicon;
  final readOnly;
  final focuscontroller;
  final txtkey;
  final focusnext;
  final listArrya;
  final mandatory;
  SearchableItemsDropdown({required this.title, required this.callback,  this.ledgerName,this.titleIndicator, this.franchisee, this.franchiseeName, this.come,this.suffixicon, this.readOnly,this.focuscontroller,this.txtkey,this.focusnext,this.mandatory, this.listArrya});




  @override
  State<SearchableItemsDropdown> createState() => _SingleLineEditableTextFormFieldState();
}

class _SingleLineEditableTextFormFieldState extends State<SearchableItemsDropdown> with  SingleTickerProviderStateMixin {
  bool isLoaderShow = false;
  FocusNode searchFocus = FocusNode() ;
  ApiRequestHelper apiRequestHelper = ApiRequestHelper();
  final TextEditingController _controller = TextEditingController();

  var selectedItem=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    searchFocus.addListener(_onFocusChange);

  }

  bool _isListening = false;
  String _text = "";
  double _confidence = 1.0;


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
                        // callGetLedger();
                      });
                    },
                    textInputAction: TextInputAction.none, // Change input action to "none"
                    controller: _controller,
                    enabled: widget.readOnly==false?false:true,
                    focusNode: searchFocus,
                    decoration: textfield_decoration.copyWith(
                      // labelText: '${widget.title}',
                      hintText: "${widget.title}",
                      border: OutlineInputBorder(),
                      suffixIcon: widget.come=="disable"?null: Row(
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
                              widget.callback(null);
                              searchFocus.requestFocus();
                              _controller.text =
                                  _controller.text; // Trigger a rebuild
                            },
                            icon: const Icon(Icons.clear),
                          ),
                        ],
                      ),                          errorStyle: const TextStyle(
                        color: Colors.redAccent,
                        fontSize: 16.0,
                        height: 0
                    ),
                      errorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent),
                      ),
                      focusedErrorBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.redAccent, width: 2.0),
                      ),
                    ),
                  ),
                  suggestionsCallback: (pattern) {
                    return _getSuggestions(pattern);
                  },
                  itemBuilder: (context, suggestion) {
                    return ListTile(
                      title: Text(suggestion['Item_Name']),
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
                      selectedItem = suggestion['Item_Name'];
                      //_controller.text=suggestion['Name'];
                      _controller.clear();
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
    matches.addAll(widget.listArrya);

    matches.retainWhere((s) => s['Item_Name'].toLowerCase().contains(query.toLowerCase()));
    return matches;
  }

}
