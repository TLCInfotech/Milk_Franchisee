import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../common_widget/common.dart';
import '../../core/app_preferance.dart';
import '../../core/colors.dart';
import '../../core/common_style.dart';
import 'dart:io';

import '../../core/size_config.dart';
import '../../dialog/log_out_dialog.dart';

class CustomeAppBar extends StatefulWidget {
  const CustomeAppBar({
    super.key,
    required this.title,
    this.dashbord,
    required this.onPress
  });
  final dashbord;
final Function? onPress;
  final String title;

  @override
  State<CustomeAppBar> createState() => _CustomeAppBarState();
}

class _CustomeAppBarState extends State<CustomeAppBar> {

  File? logo=null;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getdata();
  }
  getdata()async{
    var data= await AppPreferences.getCompanylogo();
    var cName= await AppPreferences.getCompanyName();
print("jvbvbv  $data");

if (data != null && data.toString().trim().isNotEmpty) {
      try {
        final decodedData = jsonDecode(data);

        logo = await CommonWidget.convertBytesToFile(
          decodedData,
          cName,
        );
      } catch (e) {
        print("Invalid JSON in logo data: $e");
      }
    }

    String companyId = await AppPreferences.getCompanyId();
    setState(() {
      logo=logo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AppBar(
        leadingWidth: widget.dashbord==true?0: 20,
        leading: widget.dashbord==true?Container():IconButton(onPressed: (){

          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back),color:Colors.white,),
        automaticallyImplyLeading: false,
        title:  Container(
          width: SizeConfig.screenWidth,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             logo==null?Container(): Container(
                height:SizeConfig.screenHeight*.04,
                width:SizeConfig.screenHeight*.04,
                margin: EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    image: DecorationImage(
                      image: FileImage(logo!),
                      fit: BoxFit.cover,
                    )
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 20.0),
                  child: Text(
                    widget.title,
                    style:  TextStyle(
                      color: CommonColor.WHITE_COLOR,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.visible, // Allows wrapping instead of truncating
                    maxLines: null, // Allows unlimited lines
                    softWrap: true, // Ensures text moves to the next line if needed
                  ),
                ),
              ),
            widget.dashbord==true?GestureDetector(
                onTap: () {
                  showCupertinoDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return const LogOutDialog(
                        );
                      });
                },
                child: Padding(
                  // width: 80,
                  padding: const EdgeInsets.all(8.0),
                  child: const FaIcon(Icons.logout,
                    color: CommonColor.WHITE_COLOR,
                  ),
                ),
              ):Container(),
            ],
          ),
        ),
        backgroundColor: CommonColor.THEME_COLOR,
      ),
    );
  }
}
