import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../core/localss/api_data_fetch_localization.dart';

import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../dialog/Delete_Dialog.dart';

class DeleteDialogLayout extends StatefulWidget{

  final Function(String?) callback;

  DeleteDialogLayout({required this.callback});

  @override
  State<DeleteDialogLayout> createState() => _GetStateLayoutState();
}

class _GetStateLayoutState extends State<DeleteDialogLayout>{

  var response="";

  @override
  Widget build(BuildContext context) {
    return    IconButton(
      icon:  const FaIcon(
      FontAwesomeIcons.trash,
      size: 16,
      color: Colors.redAccent,
      ),
      onPressed: () async{
      await   showGeneralDialog(
            barrierColor: Colors.black.withOpacity(0.5),
            transitionBuilder: (context, a1, a2, widget) {
              final curvedValue = Curves.easeInOutBack.transform(a1.value) - 1.0;
              // return Transform(
              //   transform: Matrix4.translationValues(0.0, curvedValue * 200, 0.0),
              return Transform.scale(
                scale: a1.value,
                child: Opacity(
                  opacity: a1.value,
                  child: DeleteDialog(
                      onCallBack:(value)async{

                        setState(() {
                         response=value;
                        });

                      }
                  ),
                ),
              );
            },
            transitionDuration: Duration(milliseconds: 200),
            barrierDismissible: true,
            barrierLabel: '',
            context: context,
            pageBuilder: (context, animation2, animation1) {
              return Container();
            });

      print("############3");
      print(response);
      await widget.callback(response);


      },
    );
  }

}