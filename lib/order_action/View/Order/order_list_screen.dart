import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import 'order_detail_screen.dart';
import 'order_theme.dart';

class OrderListScreen extends StatefulWidget {
  @override
  _OrderListScreenState createState() => _OrderListScreenState();
  static const routeName = '/order-list-screen';
}

class _OrderListScreenState extends State<OrderListScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  // _OrderListScreenState();

  String nameKH;

  List<OrderList> orderList = [];
  static String nameStatus = "";

  var customer = Customer();

  List<Customer> customerList = [];

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    // getAllOrderList();

    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Order");
    referenceProduct.once().then((DataSnapshot snapshot) {
      orderList.clear();
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
        orderList.add(order);
      }
      setState(() {});
    });
    print(orderList.length);
  }

  getStatus(String id) {
    if (id == "0") {
      nameStatus = "Chưa giao hàng";
    }
  }

  // getAllCustomerList(String id) async {
  //   customerList.clear();
  //   var customers = await _customerService.readCustomerList();
  //   customers.forEach((customer) {
  //     setState(() {
  //       if (customer['id'] == id) {
  //         var customerModel = new Customer();
  //         customerModel.idCustomer = customer['id'];
  //         customerModel.name = customer['name'];
  //         customerModel.phone = customer['phone'];
  //         customerModel.email = customer['email'];
  //         customerModel.address = customer['address'];
  //         customerList.add(customerModel);
  //       }
  //     });
  //   });
  //   print(customer.name);
  // }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // getAllOrderList();
    // final Map data = ModalRoute.of(context).settings.arguments;
    // idDonHang = data['idDonHang'];
  }

  // Future<bool> getData() async {
  //   await Future<dynamic>.delayed(const Duration(milliseconds: 200));
  //   return true;
  // }

  // @override
  // void dispose() {
  //   animationController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: OrderAppTheme.buildLightTheme(),
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              InkWell(
                splashColor: Colors.transparent,
                focusColor: Colors.transparent,
                highlightColor: Colors.transparent,
                hoverColor: Colors.transparent,
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Column(
                  children: [
                    getAppBarUI(),
                    Container(
                      child: SingleChildScrollView(
                        controller: _scrollController,
                        // headerSliverBuilder:
                        //     (BuildContext context, bool innerBoxIsScrolled) {
                        //   return <Widget>[];
                        // },
                        child: Container(
                          height: MediaQuery.of(context).size.height - 80,
                          color:
                              OrderAppTheme.buildLightTheme().backgroundColor,
                          child: ListView.builder(
                            itemCount: orderList.length,
                            shrinkWrap: true,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (_, index) {
                              return orderListScreenView(
                                orderList[index].idDonHang,
                                orderList[index].idKhachHang,
                                orderList[index].ngaymua,
                                orderList[index].trangthai,
                                orderList[index].idGioHang,
                                orderList[index].banSiLe,
                                orderList[index].chietKhau,
                                orderList[index].paymethod,
                                orderList[index].phiGiaohang,
                                orderList[index].tongSoluong,
                                orderList[index].tongTienhang,
                              );
                              // OrderListScreenView(
                              //   callback: () {
                              //     setState(() {});
                              //   },
                              //   orderList: orderList[index],
                              //   animation: animation,
                              //   animationController: animationController,
                              // );
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget orderListScreenView(
      String idDonHang,
      String idKhachHang,
      String ngaymua,
      String trangthai,
      String idGioHang,
      String banSiLe,
      String chietKhau,
      String paymethod,
      String phiGiaohang,
      String tongSoluong,
      String tongTienhang) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
    int tongthInt = double.parse(tongTienhang).round();
    getStatus(trangthai);
    // print(customerList.first.name);
    return
        // AnimatedBuilder(
        //   animation: animationController,
        //   builder: (BuildContext context, Widget child) {
        //     return FadeTransition(
        //       // opacity: animation,
        //       child: Transform(
        //         // transform: Matrix4.translationValues(
        //         //     0.0, 50 * (1.0 - animation.value), 0.0),
        //         child:
        Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 8, bottom: 16),
      child: InkWell(
        splashColor: Colors.transparent,
        onTap: () {
          Navigator.of(context)
              .pushNamed(OrderDetailScreen.routeName, arguments: {
            'idGioHang': idGioHang,
            'idDonHang': idDonHang,
            'banSiLe': banSiLe,
            'chietKhau': chietKhau,
            'idKhachHang': idKhachHang,
            'ngaymua': ngaymua,
            'paymethod': paymethod,
            'phiGiaohang': phiGiaohang,
            'trangthai': trangthai,
            'tongSoluong': tongSoluong,
            'tongTienhang': tongTienhang,
          });
        },
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
                                      "Mã: " + idDonHang,
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
                                          padding: EdgeInsets.only(
                                              top: 8, bottom: 8),
                                          child: Text(
                                            idKhachHang.toString(),
                                            style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.black54),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 4,
                                        ),
                                      ],
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
                                            ngaymua.toString(),
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
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  formatCurrency.format(tongthInt),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  nameStatus,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red[400],
                                    fontSize: 14,
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
    //       ),
    //     );
    //   },
    // );
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
            top: MediaQuery.of(context).padding.top, left: 8, right: 45),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height,
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
                  'Danh sách đơn hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
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
