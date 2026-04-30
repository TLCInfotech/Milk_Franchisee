import 'package:flutter/material.dart';

import '../../../../../core/localss/api_data_fetch_localization.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../core/common_style.dart';
import '../../core/localss/application_localizations.dart';
import '../../core/size_config.dart';
import '../core/string_en.dart';
import 'menu_block_design.dart';
import 'milk_collection/milk_collection_activity.dart';
import 'milk_route_collection/milk_route_collection_activity.dart';

class SubMenu extends StatefulWidget {
  final menuTitle;
  final transactionList;
  final masterList;
  final reportList;
  final from_date;
  final to_date;
  const SubMenu({
    super.key, this.menuTitle, this.transactionList,
    this.masterList, this.reportList,
    required  this.from_date,
    required this.to_date,
  });

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<SubMenu> {

  bool isTransaction=true;
  bool isReport=false;
  bool isMaster=false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(widget.menuTitle=="User"){
      setState(() {
        isTransaction=false;
        isReport=false;
        isMaster=true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.topLeft,
      children: [
        Container(
          height: MediaQuery
              .of(context)
              .size
              .height * 0.9,
          //width: MediaQuery.of(context).size.width * 0.9,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          alignment: Alignment.topLeft,
          child: Container(
            margin: const EdgeInsets.only(top: 30),
            // padding: const EdgeInsets.all(5),
            alignment: Alignment.topLeft,
            child:  SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[

                  SizedBox(
                    height: 10 ,
                  ),


                   Container(
                     
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blue)
                    ),
                    child: Row(
                      children: [
                    widget.menuTitle=="User" ?Container():   Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                isTransaction=true;
                                isReport=false;
                                isMaster=false;
                          
                              });
                          
                            },
                            child: Container(
                              // height: 40,
                              width: SizeConfig.screenWidth/3,
                              decoration: BoxDecoration(
                                color: isTransaction?Colors.blue:Colors.white,
                                border: Border(
                                    left:BorderSide(color: Colors.black),
                                  right: BorderSide(color: Colors.black),
                                )
                              ),
                              alignment: Alignment.center,
                            
                              padding: EdgeInsets.all(5),
                              child: Text(
                                " ${ ApplicationLocalizations.of(context)!.translate("transaction")!} ",
                                style: subHeading_withBold.copyWith(fontSize: 18,color:isTransaction?Colors.white:Colors.black,),
                              ),
                            ),
                          ),
                        ),

                     Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                isTransaction=false;
                                isReport=true;
                                isMaster=false;
                          
                              });
                            },
                            child:
                            Container(
                              // height: 40,
                              width: SizeConfig.screenWidth/3,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: isReport?Colors.blue:Colors.white,
                            
                                  border: Border(
                                    right: BorderSide(color: Colors.black),
                                  )
                              ),
                              padding: EdgeInsets.all(5),
                              child: Text(
                                " ${ ApplicationLocalizations.of(context)!.translate("report")!} ",
                                style: subHeading_withBold.copyWith(fontSize: 18,color: isReport?Colors.white:Colors.black),
                              ),
                            ),
                          
                          ),
                        ),

                        Expanded(
                          child: GestureDetector(
                            onTap: (){
                              setState(() {
                                isTransaction=false;
                                isReport=false;
                                isMaster=true;
                              });
                            },
                            child:
                             Container(
                               // height: 40,
                               width: SizeConfig.screenWidth/3,
                               decoration: BoxDecoration(
                                 color: isMaster?Colors.blue:Colors.white,
                             
                                   // border: Border(
                                   //   left:BorderSide(color: Colors.black),
                                   //   right: BorderSide(color: Colors.black),
                                   // )
                             
                               ),
                               padding: EdgeInsets.all(5),
                               alignment: Alignment.center,
                               child: Text(
                                 " ${ ApplicationLocalizations.of(context)!.translate("master")!} ",
                                 style: subHeading_withBold.copyWith(fontSize: 18,color: isMaster?Colors.white:Colors.black),
                               ),
                             ),
                          
                          ),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  isTransaction?
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      runAlignment: WrapAlignment.spaceBetween,
                      alignment: WrapAlignment.start,
                      // crossAxisAlignment: WrapCrossAlignment.start,
                      // alignment: WrapAlignment.spaceEvenly,
                      children: [

                        for (var i=0;i<widget.transactionList.length;i++)
                          MenuBlocksDesign(
                            fontmenuSize: 15,
                            menuHeight: 70,
                            menuWidth:  SizeConfig.screenWidth*0.9/ 3,
                            borderColor: i%2==0?Colors.purple:Colors.blue,
                            menuTitle: widget.transactionList[i],
                            menuIcon: null,
                            onPressed: () {
                               if(widget.transactionList[i]=="${ApplicationLocalizations.of(context).translate("farmer_route_collection")}"){

                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(

                                    from_date:widget.from_date,
                                    to_date:widget.to_date,
                                route_type: "F", title: null,)));
                              }
                             else if(widget.transactionList[i]=="${ApplicationLocalizations.of(context).translate("center_route_collection")}"){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(
                                    from_date:widget.from_date,
                                    to_date:widget.to_date,
                                    route_type:"C", title: null,)));
                              }
                              else if(widget.transactionList[i]==ApplicationLocalizations.of(context).translate("farmer_milk_collection")){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkCollectionActivity(
                                  from_date:widget.from_date,
                                  to_date:widget.to_date,
                                  route_type: "F",
                                setVal: "",
                                  title: ApplicationLocalizations.of(context).translate("farmer_milk_collection"),
                                )));
                              }

                              else if(widget.transactionList[i]== ApplicationLocalizations.of(context).translate("center_milk_collection")){
                                Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkCollectionActivity(
                                  from_date:widget.from_date,
                                  to_date:widget.to_date,
                                  route_type:"C",
                                  setVal: "",
                                  title: ApplicationLocalizations.of(context).translate("center_milk_collection"),)));
                              }

                            },
                          ),
                      ],
                    ),
                  ):Container(),

                  isReport?Wrap(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    runAlignment: WrapAlignment.spaceBetween,
                    alignment: WrapAlignment.start,
                    children: [

                      for (var i=0;i<widget.reportList.length;i++)
                        MenuBlocksDesign(
                          fontmenuSize: 15,
                          menuHeight: 70,
                          menuWidth:  SizeConfig.screenWidth*0.9/ 3,
                          borderColor: i%2==0?Colors.purple:Colors.blue,
                          menuTitle: widget.reportList[i],
                          menuIcon: null,
                          onPressed: () {
                            // if(widget.reportList[i]==ApplicationLocalizations.of(context).translate("user_updation_report")){
                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=> UserUpdationReport(
                            //     logoImage:"assets/images/tlc.jpg" ,
                            //     title: ApplicationLocalizations.of(context).translate("user_updation_report"),
                            //     fromDate:widget.from_date,
                            //     toDate:widget.to_date,
                            //     setText: "User Updation Report",
                            //     formId: "frmUserUpdationReport",
                            //   )));
                            //
                            // }

                          },
                        ),],
                  ):Container(),




                  isMaster?Wrap(
                    runAlignment: WrapAlignment.spaceEvenly,
                    alignment: WrapAlignment.start,
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [

                      for (var i=0;i<widget.masterList.length;i++)
                        MenuBlocksDesign(

                          fontmenuSize: 15,
                          menuHeight: 70,
                          menuWidth:  SizeConfig.screenWidth*0.9/ 3,
                          borderColor:i%2==0?Colors.purple: Colors.blue,
                          menuTitle: widget.masterList[i],
                          menuIcon: null,
                          onPressed: () {
                            // if(widget.masterList[i]==ApplicationLocalizations.of(context).translate("dealer_rate")){
                            //   Navigator.push(context, MaterialPageRoute(builder: (context)=> DealerRate(
                            //     from_date:widget.from_date,
                            //     to_date:widget.to_date,
                            //     title: ApplicationLocalizations.of(context).translate("dealer_rate"),
                            //   )));
                            // }
                          },
                        ),

                    ],
                  ):Container(),
                ],
              ),
            ),
          ),
        ),

        Positioned(
            top: 5,
            left: 5,
            child:Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
               "${widget.menuTitle}" ,
                style: subHeading_withBold.copyWith(color: Colors.blue),
              ),
            ),
             ),
        Positioned(
          top: -30,
          right: MediaQuery
              .of(context)
              .size
              .width * 0.8 / 2,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pop(context);
            },
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: const Icon(
              Icons.clear,
              color: Colors.red,
            ),
          ),
        ),
      ],
    );
  }
}
