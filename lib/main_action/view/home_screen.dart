import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/main_action/widget/order_status.dart';
import 'package:quan_ly_taiducfood/main_action/widget/sub_statistical.dart';
import 'package:quan_ly_taiducfood/main_action/widget/title_view.dart';
import 'package:quan_ly_taiducfood/main_action/theme/home_theme.dart';
import 'package:quan_ly_taiducfood/main_action/view/widget/list_sub_screen.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import 'package:flutter/material.dart';

import 'widget/list_sub_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key, this.animationController}) : super(key: key);

  final AnimationController animationController;
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  Animation<double> topBarAnimation;
  // ignore: deprecated_member_use
  List<OrderList> _list = List();
  List<Widget> listViews = <Widget>[];
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  DateTime _dateTime;

  GlobalKey<RefreshIndicatorState> reKey;

  int donhang,
      donhuy,
      dontra,
      chuaduyet,
      chothanhtoan,
      choxuatkhoa,
      danggiaohang;

  double doanhthuthang, doanhthungay;

  getAll() {
    donhang = 0;
    donhuy = 0;
    dontra = 0;
    chuaduyet = 0;
    chothanhtoan = 0;
    choxuatkhoa = 0;
    danggiaohang = 0;
    doanhthungay = 0.0;
    doanhthuthang = 0.0;
    var dateNow = DateFormat("dd/MM/yyyy").format(DateTime.now());
    var dateAfter = DateTime.now();
    var dateBefore = DateTime.utc(DateTime.now().year, DateTime.now().month, 1);
    var _date = dateAfter.difference(dateBefore).inDays;
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
          values[key]["giomua"],
          values[key]["tongGiaVon"],
          values[key]["datetime"],
        );
        _list.add(order);
      }

      for (var don in _list) {
        if (dateNow == don.ngaymua && int.parse(don.trangthai) < 4) {
          donhang++;
        }
        if (dateNow == don.ngaymua && don.trangthai == "4") {
          doanhthungay += double.parse(don.tongTienhang);
        }
        if (don.trangthai == "0") {
          chuaduyet++;
        } else if (don.trangthai == "1") {
          choxuatkhoa++;
        } else if (don.trangthai == "2") {
          danggiaohang++;
        } else if (don.trangthai == "3") {
          chothanhtoan++;
        }
      }

      for (int i = 0; i <= _date; i++) {
        _dateTime =
            DateTime.utc(dateBefore.year, dateBefore.month, dateBefore.day + i);
        for (var don in _list) {
          if (don.ngaymua == DateFormat("dd/MM/yyyy").format(_dateTime) &&
              don.tongTienhang != "0.0") {
            if (don.trangthai == "6") {
              donhuy++;
            }
            if (don.trangthai == "5") {
              dontra++;
            }
            if (don.trangthai == "4") {
              doanhthuthang += double.parse(don.tongTienhang);
            }
          }
        }
      }

      setState(() {
        addAllListData();
      });
    });
  }

  @override
  void initState() {
    reKey = GlobalKey<RefreshIndicatorState>();
    donhang = 0;
    donhuy = 0;
    dontra = 0;
    chuaduyet = 0;
    chothanhtoan = 0;
    choxuatkhoa = 0;
    danggiaohang = 0;
    doanhthungay = 0.0;
    doanhthuthang = 0.0;
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

    getAll();
  }

  void addAllListData() {
    listViews.clear();
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
      SubStatistical(
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
      ListSubScreen(
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
      OrderStatus(
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

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    getAll();
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: HomeTheme.background,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: RefreshIndicator(
          key: reKey,
          onRefresh: () async {
            await refreshList();
          },
          child: Stack(
            children: <Widget>[
              getMainListViewUI(),
              getAppBarUI(),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
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
                  color: HomeTheme.white.withOpacity(topBarOpacity),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(32.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: HomeTheme.grey.withOpacity(0.4 * topBarOpacity),
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
                                fontFamily: HomeTheme.fontName,
                                fontWeight: FontWeight.w700,
                                fontSize: 23 - 6 * topBarOpacity,
                                letterSpacing: 1.2,
                                color: HomeTheme.darkerText,
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
                                    color: HomeTheme.grey,
                                    size: 18,
                                  ),
                                ),
                                Text(
                                  '${DateFormat('dd MMM').format(DateTime.now()).toString()}',
                                  textAlign: TextAlign.left,
                                  style: TextStyle(
                                    fontFamily: HomeTheme.fontName,
                                    fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    letterSpacing: -0.2,
                                    color: HomeTheme.darkerText,
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
