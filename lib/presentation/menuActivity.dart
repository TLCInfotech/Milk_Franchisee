import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:milk_fr/presentation/login/change_password.dart';

import '../core/app_preferance.dart';
import '../core/colors.dart';
import '../core/common_style.dart';
import '../core/localss/api_data_fetch_localization.dart';
import 'milk_collection/milk_collection_activity.dart';
import 'milk_route_collection/milk_route_collection_activity.dart';

class MenuActivity extends StatefulWidget {
  final fromD;
  final toD;

  const MenuActivity({super.key, this.fromD, this.toD});

  @override
  State<MenuActivity> createState() => _MenuActivityState();
}

class _MenuActivityState extends State<MenuActivity> {
  bool isCollapsed = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getLocal();
    setDataComm();
    addMainMenu();
  }

  addMainMenu()async{
    setState(() {
      mainMenu.add("${ApplicationLocalizations.of(context).translate("transaction")}");
      mainMenu.add("${ApplicationLocalizations.of(context).translate("report")}");
      mainMenu.add("${ApplicationLocalizations.of(context).translate("master")}");
      mainMenu.add("${ApplicationLocalizations.of(context).translate("change_password")}");

    });

  }

  String logoImage = "";
  String companyName = "";
  String userName = "";

  setDataComm() async {
    logoImage = await AppPreferences.getCompanyUrl();
    userName = await AppPreferences.getUId();
    companyName = await AppPreferences.getCompanyName();
    setState(() {});
  }

  List MasterMenu = [];
  List TransactionMenu = [];
  List ReportMenu = [];

  String companyId = "";
  var dataArr;
  var dataArrM;
  var dataArrR;
  int workingDay = 0;
  DateTime viewWorkDDate = DateTime.now();
  final DateTime today = DateTime.now();
  getLocal() async {
    /// 🔹 Helper (inside same file)
    List<dynamic> safeJsonList(String? value) {
      if (value == null || value.isEmpty || value == "null") {
        return [];
      }

      try {
        final decoded = jsonDecode(value);
        if (decoded is List) {
          return decoded;
        }
        return [];
      } catch (e) {
        print("JSON Decode Error => $e");
        return [];
      }
    }

    /// 🔹 Preferences Data
    companyId = await AppPreferences.getCompanyId();

    String? menu = await AppPreferences.getMasterMenuList();
    String? tr = await AppPreferences.getTransactionMenuList();
    String? re = await AppPreferences.getReportMenuList();

    print("MENU => $menu");
    print("TR => $tr");
    print("RE => $re");

    /// 🔹 Decode safely
    List<dynamic> menuList = safeJsonList(menu);
    List<dynamic> trList = safeJsonList(tr);
    List<dynamic> reList = safeJsonList(re);

    /// 🔹 Assign State
    setState(() {
      /// Raw data
      dataArrM = menuList;
      dataArr = trList;
      dataArrR = reList;

      /// Only Form_ID lists
      MasterMenu = menuList.map((i) => i['Form_ID']).toList();
      TransactionMenu = trList.map((i) => i['Form_ID']).toList();
      ReportMenu = reList.map((i) => i['Form_ID']).toList();
    });

    print("vvbbbbbbb   $MasterMenu");
    print("vvbbbbbbb   $dataArrM");
  }

  List mainMenu = [];

  var selectedMainMenu = "Transaction";

  /// ---------------- DRAWER UI ----------------
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      width: MediaQuery.of(context).size.width * 0.9,
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                /// LEFT MENU
                Container(
                  width: 100,
                  decoration: BoxDecoration(
                    color: CommonColor.THEME_COLOR.withOpacity(0.05),
                  ),
                  child: ListView.builder(
                    itemCount: mainMenu.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        tileColor: selectedMainMenu == mainMenu[index]
                            ? CommonColor.THEME_COLOR.withOpacity(0.05)
                            : Colors.transparent,
                        contentPadding: EdgeInsets.zero,
                        onTap: () {
                          setState(() {
                            selectedMainMenu = mainMenu[index];
                          });
                        },
                        title: Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: Column(
                            children: [
                              mainMenu[index]=="${ApplicationLocalizations.of(context).translate("change_password")}"?
                              CircleAvatar(
                                radius: 20,
                                child:Icon(Icons.lock),
                              )
                                  :CircleAvatar(
                                radius: 20,
                                backgroundImage: AssetImage(
                                  'assets/images/${mainMenu[index]}.jpg',
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(mainMenu[index],
                                  style: item_regular_textStyle,textAlign: TextAlign.center,),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                /// RIGHT MENU (FIXED)
                Expanded(
                  child: Padding(
                      padding: EdgeInsets.only(top:10),
                      child: _buildRightMenu()),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRightMenu() {
    if (selectedMainMenu == "${ApplicationLocalizations.of(context).translate("transaction")}") {
      return ListView(
        children: [
          buildSubMenu(
              ApplicationLocalizations.of(context)
                  .translate("center_milk_collection"), onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) =>
                    MilkCollectionActivity(
                      come:"",
                      from_date: widget.fromD,
                      to_date: widget.toD,
                      route_type: "C",
                      setVal: "",
                      title: ApplicationLocalizations.of(
                          context).translate(
                          "center_milk_collection"),)));

          }),
          Divider(
            color: CommonColor.THEME_COLOR,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          buildSubMenu(
              ApplicationLocalizations.of(context)
                  .translate("center_route_collection"), onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(
              from_date: widget.fromD,
              to_date: widget.toD,
              route_type:"C",
              // setVal: "",
              title: ApplicationLocalizations.of(context).translate("center_route_collection"),)));


          }),
          Divider(
            color: CommonColor.THEME_COLOR,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          buildSubMenu(
              ApplicationLocalizations.of(context)
                  .translate("farmer_milk_collection"), onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkCollectionActivity(
              from_date: widget.fromD,
              to_date: widget.toD,
              route_type: "F",
              setVal: "",
              title: ApplicationLocalizations.of(context).translate("farmer_milk_collection"),
            )));
          }),
          Divider(
            color: CommonColor.THEME_COLOR,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
          buildSubMenu(
              ApplicationLocalizations.of(context)
                  .translate("farmer_route_collection"), onTap: () {

            Navigator.push(context, MaterialPageRoute(builder: (context)=>MilkRouteCollectionActivity(
              from_date: widget.fromD,
              to_date: widget.toD,
              route_type: "F",
              // setVal: "",
              title: ApplicationLocalizations.of(context).translate("farmer_route_collection"),
            )));
          }),
          Divider(
            color: CommonColor.THEME_COLOR,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),

        ],
      );
    }

    if (selectedMainMenu == "${ApplicationLocalizations.of(context).translate("master")}") {
      return ListView(children: []);
    }

    if (selectedMainMenu == "${ApplicationLocalizations.of(context).translate("report")}") {
      return ListView(
        children: [
          buildSubMenu("${ApplicationLocalizations.of(context).translate("report")}", onTap: () {}),
          Divider(
            color: CommonColor.THEME_COLOR,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ],
      );
    }
    if (selectedMainMenu == "${ApplicationLocalizations.of(context).translate("change_password")}") {
      return ListView(
        children: [
          buildSubMenu(
              ApplicationLocalizations.of(context)
                  .translate("change_password"), onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangePasswordActivity(
              // setVal: "",
              title: ApplicationLocalizations.of(context).translate("change_password"),
              logoImage: '',)));


          }),
          Divider(
            color: CommonColor.THEME_COLOR,
            thickness: 1,
            indent: 20,
            endIndent: 20,
          ),
        ],
      );
    }

    return Container();
  }

  /// ---------------- SUB MENU ----------------
  Widget buildSubMenu(String title, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20, top: 2, bottom: 2),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        title: Container(
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 10),
          decoration: BoxDecoration(
            // color: CommonColor.THEME_COLOR,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.circle, size: 10, color: CommonColor.THEME_COLOR),
              SizedBox(width: 10),
              Text(
                title,
                style: item_regular_textStyle.copyWith(color: Colors.black),
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }

  /// ---------------- SUB-EXPANDABLE MENU ----------------

  /// ---------------- MAIN EXPANDABLE MENU ----------------
}
