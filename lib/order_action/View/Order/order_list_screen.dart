import 'dart:async';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/products_action/theme/order&pro_theme.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import '../../../main.dart';
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

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));
  var colortxt;
  String nameKH;
  List<OrderList> orderList = [];
  List<OrderList> orderList2 = [];
  static String nameStatus = "";
  var customer = Customer();
  var _customerService = CustomerService();
  List<Customer> customerList = [];

  GlobalKey<RefreshIndicatorState> reKey;

  String text;

  @override
  void initState() {
    super.initState();
    reKey = GlobalKey<RefreshIndicatorState>();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    orderList.clear();
    orderList2.clear();

    getData();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    getData();
    return null;
  }

  getData() {
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
          values[key]["giomua"],
          values[key]["tongGiaVon"],
          values[key]["datetime"],
        );
        orderList.add(order);
        orderList.sort((a, b) {
          DateTime adate = DateTime.parse(a.datetime);
          DateTime bdate = DateTime.parse(b.datetime);
          return bdate.compareTo(adate);
        });
        for (var a in orderList) {
          print(a.datetime);
        }
      }
      setState(() {});
    });
  }

  getStatus(String id) {
    if (id == "0") {
      nameStatus = "Chưa duyệt";
      colortxt = Colors.blue[300];
    } else if (id == "1") {
      nameStatus = "Chờ đóng gói";
      colortxt = Colors.blue[500];
    } else if (id == "2") {
      nameStatus = "Chờ xuất kho";
      colortxt = Colors.blue[700];
    } else if (id == "3") {
      nameStatus = "Chờ thanh toán";
      colortxt = Colors.blue[900];
    } else if (id == "4") {
      nameStatus = "Đã thanh toán";
      colortxt = Colors.green[600];
    } else if (id == "5") {
      nameStatus = "Đã trả hàng";
      colortxt = Colors.red;
    } else if (id == "6") {
      nameStatus = "Đã hủy đơn";
      colortxt = Colors.red;
    }
  }

  getAllCustomerList(String id) async {
    customerList.clear();
    var customers = await _customerService.readCustomerList();
    customers.forEach((customer) {
      setState(() {
        if (customer['id'] == id) {
          var customerModel = new Customer();
          customerModel.idCustomer = customer['id'];
          customerModel.name = customer['name'];
          customerModel.phone = customer['phone'];
          customerModel.email = customer['email'];
          customerModel.address = customer['address'];
          customerList.add(customerModel);
        }
      });
    });
  }

  getLocgiatri(int i) {
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Order");
    referenceProduct.once().then((DataSnapshot snapshot) {
      orderList2.clear();
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
        orderList.add(order);
        orderList2.add(order);
      }

      if (i == 1) {
        orderList.clear();
        orderList2.sort((a, b) {
          var adate = double.parse(a.tongTienhang).round();
          var bdate = double.parse(b.tongTienhang).round();
          return adate.compareTo(bdate);
        });
        for (var t in orderList2) {
          orderList.add(t);
        }
      } else if (i == 3) {
        orderList.clear();

        for (var sp in orderList2) {
          if (sp.trangthai == "0") {
            orderList.add(sp);
            orderList.sort((a, b) {
              DateTime adate = DateTime.parse(a.datetime);
              DateTime bdate = DateTime.parse(b.datetime);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 2) {
        orderList.clear();
        orderList2.sort((a, b) {
          var adate = double.parse(a.tongTienhang).round();
          var bdate = double.parse(b.tongTienhang).round();
          return bdate.compareTo(adate);
        });
        for (var t in orderList2) {
          orderList.add(t);
        }
      } else if (i == 4) {
        orderList.clear();

        for (var sp in orderList2) {
          if (sp.trangthai == "1") {
            orderList.add(sp);
            orderList.sort((a, b) {
              DateTime adate = DateTime.parse(a.datetime);
              DateTime bdate = DateTime.parse(b.datetime);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 5) {
        orderList.clear();

        for (var sp in orderList2) {
          if (sp.trangthai == "3") {
            orderList.add(sp);
            orderList.sort((a, b) {
              DateTime adate = DateTime.parse(a.datetime);
              DateTime bdate = DateTime.parse(b.datetime);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 6) {
        orderList.clear();

        for (var sp in orderList2) {
          if (sp.trangthai == "2") {
            orderList.add(sp);
            orderList.sort((a, b) {
              DateTime adate = DateTime.parse(a.datetime);
              DateTime bdate = DateTime.parse(b.datetime);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 7) {
        orderList.clear();

        for (var sp in orderList2) {
          if (sp.trangthai == "4") {
            orderList.add(sp);
            orderList.sort((a, b) {
              DateTime adate = DateTime.parse(a.datetime);
              DateTime bdate = DateTime.parse(b.datetime);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 8) {
        orderList.clear();

        for (var sp in orderList2) {
          if (sp.trangthai == "5") {
            orderList.add(sp);
            orderList.sort((a, b) {
              DateTime adate = DateTime.parse(a.datetime);
              DateTime bdate = DateTime.parse(b.datetime);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 9) {
        orderList.clear();

        for (var sp in orderList2) {
          if (sp.trangthai == "6") {
            orderList.add(sp);
            orderList.sort((a, b) {
              DateTime adate = DateTime.parse(a.datetime);
              DateTime bdate = DateTime.parse(b.datetime);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 10) {
        orderList.clear();

        for (var sp in orderList2) {
          orderList.add(sp);
          orderList.sort((a, b) {
            DateTime adate = DateTime.parse(a.datetime);
            DateTime bdate = DateTime.parse(b.datetime);
            return bdate.compareTo(adate);
          });
        }
      } else if (i == 11) {
        orderList.clear();

        for (var sp in orderList2) {
          orderList.add(sp);
          orderList.sort((a, b) {
            DateTime adate = DateTime.parse(a.datetime);
            DateTime bdate = DateTime.parse(b.datetime);
            return adate.compareTo(bdate);
          });
        }
      }

      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  // Future<bool> getData() async {
  //   await Future<dynamic>.delayed(const Duration(milliseconds: 200));
  //   return true;
  // }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  Widget search() {
    return Padding(
      padding: const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 0),
              child: Container(
                decoration: BoxDecoration(
                  color: OrderProductTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(12.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 4.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (text) {
                      Search(text.toLowerCase());
                    },
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor:
                        OrderProductTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Tên sản phẩm...',
                      icon: Icon(FontAwesomeIcons.search,
                          size: 20, color: HexColor('#54D3C2')),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: OrderAppTheme.buildLightTheme(),
      child: Container(
        height: MediaQuery.of(context).size.height,
        child: new Scaffold(
          body: Column(
            children: [
              // InkWell(
              //   splashColor: Colors.transparent,
              //   focusColor: Colors.transparent,
              //   highlightColor: Colors.transparent,
              //   hoverColor: Colors.transparent,
              //   onTap: () {
              //     FocusScope.of(context).requestFocus(FocusNode());
              //   },
              //   child:
              Expanded(
                child: Container(
                  height: MediaQuery.of(context).size.height - 80,
                  child: Column(
                    children: [
                      getAppBarUI(),
                      search(),
                      // SingleChildScrollView(
                      //   controller: _scrollController,

                      //     child:
                      Expanded(
                        child: RefreshIndicator(
                          key: reKey,
                          onRefresh: () async {
                            await refreshList();
                          },
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
                                orderList[index].datetime,
                              );
                            },
                          ),
                        ),
                      ),

                      // ),
                    ],
                  ),
                ),
              ),
              // ),
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
      String tongTienhang,
      String datetime) {
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
    int tongthInt = double.parse(tongTienhang).round();
    getStatus(trangthai);
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
                                    Column(
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
                                        // Padding(
                                        //   padding: EdgeInsets.only(top: 8),
                                        //   child: Text(
                                        //     datetime.toString(),
                                        //     style: TextStyle(
                                        //         fontSize: 14,
                                        //         color: Colors.black
                                        //             .withOpacity(1)),
                                        //   ),
                                        // ),
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
                                    color: colortxt,
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
            Container(
              alignment: Alignment.centerRight,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    showLoc(context: context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.sort_by_alpha),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showLoc({BuildContext context}) {
    int tienship = 0;
    showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Chọn phương thức lọc:"),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      title: Text("Đơn hàng mới nhất"),
                      value: 10,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn hàng cũ nhất"),
                      value: 11,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Giá tăng dần"),
                      value: 1,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Giá giảm dần"),
                      value: 2,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn chưa duyệt"),
                      value: 3,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn chờ đóng gói"),
                      value: 4,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn chờ thanh toán"),
                      value: 5,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn đang giao hàng"),
                      value: 6,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn đã hoàn thành"),
                      value: 7,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn đã trả hàng"),
                      value: 8,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Đơn đã hủy"),
                      value: 9,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocgiatri(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
  void Search(text) {
    DatabaseReference searchRef =
        FirebaseDatabase.instance.reference().child("Order");
    searchRef.once().then((DataSnapshot snapshot) {
      orderList2.clear();
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
          values[key]["giomua"],
          values[key]["tongGiaVon"],
          values[key]["datetime"],
        );
        if (order.idKhachHang.toLowerCase().contains(text)) {
          orderList.add(order);
          orderList.sort((a, b) {
            DateTime adate = DateTime.parse(a.datetime);
            DateTime bdate = DateTime.parse(b.datetime);
            return bdate.compareTo(adate);
          });
        }
      }
      Timer(Duration(seconds: 1), () {
        setState(() {});
      });
    });
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
