import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/main_action/ui_view/body_measurement.dart';
import 'package:quan_ly_taiducfood/main_action/ui_view/mediterranesn_diet_view.dart';
import 'package:quan_ly_taiducfood/main_action/ui_view/title_view.dart';
import 'package:quan_ly_taiducfood/main_action/fintness_app_theme.dart';
import 'package:quan_ly_taiducfood/main_action/home/meals_list_view.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import 'package:flutter/material.dart';

import 'meals_list_view.dart';

class MyDiaryScreen extends StatefulWidget {
  const MyDiaryScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _MyDiaryScreenState createState() => _MyDiaryScreenState();
}

class _MyDiaryScreenState extends State<MyDiaryScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  // ignore: deprecated_member_use
  List<OrderList> _list = List();
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  int donhang,
      donhuy,
      dontra,
      chuaduyet,
      chothanhtoan,
      choxuatkhoa,
      danggiaohang;

  double doanhthuthang, doanhthungay;

  void checkDonhang(String trangthai) {
    if (trangthai == "0") {
      chuaduyet++;
    } else if (trangthai == "1") {}
  }

  getAll() {
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Order");
    referenceProduct.once().then((DataSnapshot snapshot) {
      _list.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      for (var key in keys) {
        OrderList order = new OrderList(
          values[key]["idDonHang"],
          values[key]["idGioHang"],
          values[key]["tongTienhang"],
          values[key]["tongSoluong"],
          values[key]["phiGiaohang"],
          values[key]["chietKhau"],
          values[key]["banSiLe"],
          values[key]["paymethod"],
          values[key]["idKhachHang"],
          values[key]["ngaymua"],
          values[key]["trangthai"],
        );
        checkDonhang(values[key]["trangthai"]);
        _list.add(order);
      }
      donhang = _list.length;

      setState(() {
        addAllListData();
      });
    });
  }

  void getDataDB() {
    donhang = 0;
    donhuy = 0;
    dontra = 0;
    chuaduyet = 0;
    chothanhtoan = 0;
    choxuatkhoa = 0;
    danggiaohang = 0;
    doanhthungay = 0.0;
    doanhthuthang = 0.0;
    getAll();
  }

  @override
  void initState() {
    topBarAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
            parent: widget.animationController,
            curve: Interval(0, 0.5, curve: Curves.fastOutSlowIn)));

    scrollController.addListener(() {
      if (scrollController.offset >= 24) {
        if (topBarOpacity != 1.0) {
          setState(() {
            topBarOpacity = 1.0;
          });
        }
      } else if (scrollController.offset <= 24 &&
          scrollController.offset >= 0) {
        if (topBarOpacity != scrollController.offset / 24) {
          setState(() {
            topBarOpacity = scrollController.offset / 24;
          });
        }
      } else if (scrollController.offset <= 0) {
        if (topBarOpacity != 0.0) {
          setState(() {
            topBarOpacity = 0.0;
          });
        }
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getDataDB();
  }

  void addAllListData() {
    const int count = 9;
    listViews.add(
      TitleView(
        titleTxt: 'Doanh thu',
        subTxt: 'Chi tiết',
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 0, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
      ),
    );
    // doanh thu thang + doanh thu ngay
    listViews.add(
      MediterranesnDietView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 1, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        doanhthungay: doanhthungay,
        doanhthuthang: doanhthuthang,
        donhangmoi: donhang,
        donhanghuy: donhuy,
        donhangtra: dontra,
      ),
    );
    // menu chuc nang
    listViews.add(
      MealsListView(
        mainScreenAnimation: Tween<double>(begin: 0.0, end: 1.0).animate(
            CurvedAnimation(
                parent: widget.animationController,
                curve: Interval((1 / count) * 3, 1.0,
                    curve: Curves.fastOutSlowIn))),
        mainScreenAnimationController: widget.animationController,
      ),
    );
    // thong tin don hang
    listViews.add(
      BodyMeasurementView(
        animation: Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
            parent: widget.animationController,
            curve:
                Interval((1 / count) * 5, 1.0, curve: Curves.fastOutSlowIn))),
        animationController: widget.animationController,
        chothanhtoan: chothanhtoan,
        choxuatkho: choxuatkhoa,
        danggiaohang: danggiaohang,
        donchuaduyet: chuaduyet,
      ),
    );
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: FitnessAppTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: <Widget>[
            getMainListViewUI(),
            getAppBarUI(),
            SizedBox(
              height: MediaQuery.of(context).padding.bottom,
            )
          ],
        ),
      ),
    );
  }

  Widget getMainListViewUI() {
    return FutureBuilder<bool>(
      future: getData(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox();
        } else {
          return ListView.builder(
            controller: scrollController,
            padding: EdgeInsets.only(
              top: AppBar().preferredSize.height +
                  MediaQuery.of(context).padding.top +
                  24,
              bottom: 62 + MediaQuery.of(context).padding.bottom,
            ),
            itemCount: listViews.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (BuildContext context, int index) {
              widget.animationController.forward();
              return listViews[index];
            },
          );
        }
      },
    );
  }

  Widget getAppBarUI() {
    return Column(
      children: <Widget>[
        AnimatedBuilder(
          animation: widget.animationController,
          builder: (BuildContext context, Widget child) {
            return FadeTransition(
              opacity: topBarAnimation,
              child: Container(
                decoration: BoxDecoration(
                  color: FitnessAppTheme.white.withOpacity(topBarOpacity),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: FitnessAppTheme.grey
                            .withOpacity(0.4 * topBarOpacity),
                        offset: const Offset(1.1, 1.1),
                        blurRadius: 10.0),
                  ],
                ),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: MediaQuery.of(context).padding.top,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          left: 16,
                          right: 16,
                          top: 16 - 8.0 * topBarOpacity,
                          bottom: 12 - 8.0 * topBarOpacity),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Tổng quan',
                              textAlign: TextAlign.right,
                              style: TextStyle(
                                fontFamily: FitnessAppTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 23 - 6 * topBarOpacity,
                                letterSpacing: 1.2,
                                color: FitnessAppTheme.darkerText,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 8,
                              right: 8,
                            ),
                            child: Row(
                              children: <Widget>[
                                Padding(
                                  padding: const EdgeInsets.only(right: 8),
                                  child: Icon(
                                    Icons.calendar_today,
                                    color: FitnessAppTheme.grey,
                                    size: 18,
                                  ),
                                ),
                                Text(
                                  '${DateFormat('dd MMM').format(DateTime.now()).toString()}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: FitnessAppTheme.fontName,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    letterSpacing: -0.2,
                                    color: FitnessAppTheme.darkerText,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        )
      ],
    );
  }
}
