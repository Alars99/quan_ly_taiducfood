import 'dart:collection';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/customer_action/home_design_course.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/OrderController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quan_ly_taiducfood/order_action/model/test.dart';
import 'add_food.dart';
import 'order_list_screen_view.dart';
import 'order_theme.dart';
import 'order_list_view.dart';

class OrderDetailScreen extends StatefulWidget {
  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
  static const routeName = '/order-detail-screen';
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  List<Sanpham> orderList = [];

  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  getList() {
    final Map data = ModalRoute.of(context).settings.arguments;
    String idgiohang = data['idGioHang'].toString();
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Cart").child(idgiohang);
    referenceProduct.once().then((DataSnapshot snapshot) {
      orderList.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      for (var key in keys) {
        setState(() {
          Sanpham sanpham = new Sanpham(
            name: values[key]["name"],
            price: values[key]["price"],
            count: int.parse(values[key]["count"]),
          );
          orderList.add(sanpham);
        });
      }
      print(orderList.length);
    });
  }

  @override
  void didChangeDependencies() {
    getList();
    super.didChangeDependencies();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map data = ModalRoute.of(context).settings.arguments;
    double mainWidth = MediaQuery.of(context).size.width * 1;
    return Theme(
      data: OrderAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
            children: <Widget>[
              Column(
                children: <Widget>[
                  getAppBarUI(),
                  Expanded(
                    child: AnimatedBuilder(
                      animation: animationController,
                      builder: (BuildContext context, Widget child) {
                        return SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                  padding: EdgeInsets.all(7.0),
                                  child: Card(
                                    clipBehavior: Clip.antiAlias,
                                    elevation: 2,
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(7.0),
                                          child: Row(
                                            children: [
                                              Text(
                                                  "đặt hàng, duyệt, đóng gói, xuất kho, hoàn thành")
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                              Padding(
                                padding: EdgeInsets.all(7.0),
                                child: Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 2,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(14.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          mainAxisSize: MainAxisSize.max,
                                          children: [
                                            Text(
                                              data['tongTienhang'].toString(),
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 33,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text("Bán bởi Tên nhân viên"),
                                            SizedBox(height: 10),
                                            Text("Chi nhánh mặc định"),
                                            SizedBox(height: 10),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.circle,
                                                  size: 15,
                                                  color: Colors.blue,
                                                ),
                                                SizedBox(width: 5),
                                                Text("Trạng thái đơn hàng"),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                top: 8.0,
                                                bottom: 8.0,
                                              ),
                                              child: Divider(
                                                color: Colors.black,
                                              ),
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                Icon(Icons.person),
                                                SizedBox(width: 5),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text('Tên Khách Hàng'),
                                                    SizedBox(height: 5),
                                                    Text('Nguyễn Văn A'),
                                                  ],
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    top: 7.0, left: 7.0, right: 7.0),
                                child: new Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.5),
                                    child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Container(
                                            width: mainWidth,
                                            child: new Text(
                                              "Sản phẩm (" +
                                                  data['tongSoluong'] +
                                                  ")",
                                              style: new TextStyle(
                                                  fontSize: 17.0,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: "Roboto"),
                                            ),
                                          ),
                                        ]),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(0),
                                child: ListView.builder(
                                    scrollDirection: Axis.vertical,
                                    shrinkWrap: true,
                                    itemCount: orderList.length,
                                    itemBuilder: (_, index) {
                                      return orderUIList(
                                        orderList[index].name,
                                        orderList[index].count,
                                        orderList[index].price,
                                      );
                                    }),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: new Card(
                                  clipBehavior: Clip.antiAlias,
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.all(14.5),
                                    child: new Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: <Widget>[
                                          new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(
                                                  "Tổng tiền hàng",
                                                  style: new TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                                Text(
                                                  data['tongTienhang']
                                                      .toString(),
                                                  style: new TextStyle(
                                                    fontSize: 15.5,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ]),
                                          SizedBox(height: 20),
                                          new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(
                                                  "Chiết Khấu",
                                                  style: new TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                                Text(
                                                  data['chietKhau'].toString(),
                                                  style: new TextStyle(
                                                    fontSize: 15.5,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ]),
                                          SizedBox(height: 20),
                                          new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(
                                                  "Phí giao hàng",
                                                  style: new TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                                Text(
                                                  data['phiGiaohang']
                                                      .toString(),
                                                  style: new TextStyle(
                                                    fontSize: 15.5,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ]),
                                          SizedBox(height: 20),
                                          new Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              mainAxisSize: MainAxisSize.max,
                                              children: <Widget>[
                                                Text(
                                                  "Khách hàng phải trả",
                                                  style: new TextStyle(
                                                    fontSize: 15,
                                                    color: Colors.black,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                                Text(
                                                  data['tongTienhang']
                                                      .toString(),
                                                  style: new TextStyle(
                                                    fontSize: 15.5,
                                                    fontFamily: "Roboto",
                                                  ),
                                                ),
                                              ]),
                                        ]),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                    child: Container(
                      height: 60,
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RaisedButton(
                              onPressed: () {}, child: Text("Đặt Hàng"),)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderUIList(String name, int count, String price) {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 3, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {},
        child: Container(
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(4, 4),
                blurRadius: 16,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Stack(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    Container(
                      color: OrderAppTheme.buildLightTheme().backgroundColor,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 16, top: 15, bottom: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      name,
                                      textAlign: TextAlign.left,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 13,
                                      ),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Padding(
                                          padding: EdgeInsets.only(top: 8),
                                          child: Text(
                                            price.toString() + " vnd",
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.black
                                                    .withOpacity(1)),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      // them phan so luong
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.only(top: 8),
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8, top: 17, right: 35),
                                child: Text(
                                  "x" + count.toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: OrderAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 8.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 20,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.arrow_back),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Chi tiết đơn hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 20,
              height: AppBar().preferredSize.height,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: const BorderRadius.all(
                        Radius.circular(32.0),
                      ),
                      onTap: () {},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(FontAwesomeIcons.list),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class ContestTabHeader extends SliverPersistentHeaderDelegate {
  ContestTabHeader(
    this.searchUI,
  );
  final Widget searchUI;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return searchUI;
  }

  @override
  double get maxExtent => 52.0;

  @override
  double get minExtent => 52.0;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
