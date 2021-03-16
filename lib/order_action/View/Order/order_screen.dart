import 'dart:collection';
import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';

import 'package:intl/intl.dart';

import 'package:quan_ly_taiducfood/customer_action/view/customer_screen.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/customer_action/models/quan.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_detail_data.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/OrderController.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quan_ly_taiducfood/order_action/model/test.dart';
import 'add_food.dart';
import 'order_list_screen.dart';
import 'order_theme.dart';
import 'order_list_view.dart';

class OrderScreen extends StatefulWidget {
  @override
  _OrderScreenState createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');

  String idGioHang;
  String idDonHang;
  String trangthaithanhtoan = "Chọn phương thức thanh toán";

  final ScrollController _scrollController = ScrollController();
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  String nameCustomer = "Thêm khách hàng";
  String idCustomer = "";

  var sanpham = Sanpham();
  var customer = Customer();
  var _orderService = OrderService();
  var _customerService = CustomerService();

  // ignore: deprecated_member_use
  List<Sanpham> orderList = List<Sanpham>();

  List<Quan> quanList = Quan.quanList;

  // ignore: deprecated_member_use
  List<Customer> customerList = List<Customer>();

  List<ProductDetail> productList = [];

  int paymethod = 0;

  double tongTienhang = 0;

  double tongTienVon = 0;
  double tong = 0;
  int tongSoluong = 0;
  double phiGiaohang = 0;
  int chietKhau = 0;
  int giaban = 0; //ban sỉ, lẻ

  getReset() {
    tongTienhang = 0;
    tongTienVon = 0;
    tong = 0;
    tongSoluong = 0;
    phiGiaohang = 0;
    chietKhau = 0;
    giaban = 0;
  }

  checkThongtin() {}

  getGiaban(int id) {
    if (id == 0) {
      return "Giá bán sỉ";
    } else {
      return "Giá bán lẻ";
    }
  }

  getAllOrderList() async {
    orderList.clear();
    var orders = await _orderService.readOrderList();
    orders.forEach((sanpham) {
      setState(() {
        var orderModel = new Sanpham();
        orderModel.id = sanpham['id'].toString();
        orderModel.name = sanpham['name'];
        orderModel.brand = sanpham['brand'];
        orderModel.price = sanpham['price'].toString();

        orderModel.priceVon = sanpham['priceVon'].toString();
        orderModel.priceBuon = sanpham['priceBuon'].toString();
        orderModel.amout = sanpham['amout'];
        orderList.add(orderModel);
      });
    });
    getTong();
  }

  gettAllCustomerList() async {
    customerList.clear();
    var customers = await _customerService.readCustomerList();
    customers.forEach((customer) {
      setState(() {
        var customerModel = new Customer();
        customerModel.idCustomer = customer['id'];
        customerModel.name = customer['name'];
        customerModel.phone = customer['phone'];
        customerModel.email = customer['email'];
        customerModel.address = customer['address'];
        customerModel.idship = customer['idShip'];
        customerList.add(customerModel);
      });
    });
  }

  getInfoCustomer(int index) {
    nameCustomer = customerList[index].name;
    customer.idCustomer = customerList[index].idCustomer;
    customer.address = customerList[index].address;
    customer.phone = customerList[index].phone;
    customer.idship = customerList[index].idship;
    print(customer.idship);
    for (var q in quanList) {
      print(q.price);
      if (customer.idship == q.id.toString()) {
        phiGiaohang = double.parse(q.price);
      }
    }
  }

  getTong() async {
    tong = 0;
    tongTienhang = 0;
    tongSoluong = 0;
    tongTienVon = 0;
    orderList.forEach((element) {
      tongSoluong += element.count;
      tong += double.parse(element.price) * element.count;
      tongTienVon += double.parse(element.priceVon) * element.count;
    });

    // if (chietKhau == 0) {
    //   tongTienhang = tong + phiGiaohang;
    // } else {
    //   tongTienhang = (tong + phiGiaohang) * chietKhau / 100;
    // }

    tongTienhang = tong - (tong * chietKhau / 100) + phiGiaohang;
  }

  // ignore: non_constant_identifier_names
  Future<void> getDathang_GioHang() async {
    if (customer.idCustomer.isEmpty) {
    } else {
      DateTime now = DateTime.now();
      DatabaseReference reference =
          FirebaseDatabase.instance.reference().child('Order');
      idDonHang = reference.push().key;
      idGioHang = reference.push().key;
      HashMap mapOrder = new HashMap();

      mapOrder["idDonHang"] = idDonHang.toString();
      mapOrder["idGioHang"] = idGioHang.toString();
      mapOrder["tongTienhang"] = tongTienhang.toString();
      mapOrder["tongSoluong"] = tongSoluong.toString();
      mapOrder["phiGiaohang"] = phiGiaohang.toString();
      mapOrder["chietKhau"] = chietKhau.toString();
      mapOrder["banSiLe"] = giaban.toString();
      mapOrder["paymethod"] = paymethod.toString();
      mapOrder["idKhachHang"] = customer.idCustomer.toString();
      mapOrder["ngaymua"] = DateFormat('dd/MM/yyyy').format(now).toString();
      mapOrder["giomua"] = DateFormat('kk:mm:ss').format(now).toString();
      mapOrder["datetime"] = now.toString();
      mapOrder["tongGiaVon"] = tongTienVon.toString();
      mapOrder["trangthai"] = "0";

      reference.child(idDonHang).set(mapOrder);

      ///////////////////////////////////////////////////////////

      DatabaseReference referenceCart =
          FirebaseDatabase.instance.reference().child('Cart');

      for (var sanpham in orderList) {
        String idSanpham = reference.push().key;
        HashMap mapCart = new HashMap();
        mapCart["idGioHang"] = idGioHang.toString();
        mapCart["id"] = sanpham.id.toString();
        mapCart["name"] = sanpham.name.toString();
        mapCart["brand"] = sanpham.brand.toString();
        mapCart["price"] = sanpham.price.toString();
        mapCart["count"] = sanpham.count.toString();
        mapCart["idKhachHang"] = customer.idCustomer.toString();
        mapCart["priceVon"] = sanpham.priceVon.toString();
        mapCart["priceBuon"] = sanpham.priceBuon.toString();
        mapCart["amout"] = sanpham.amout.toString();
        referenceCart.child(idGioHang).child(idSanpham).set(mapCart);
      }
    }
  }

  // if (sanpham.id.isNotEmpty) {
  //   referenceProduct.child(sanpham.id)
  //       .update({'amount': (sanpham.amout - sanpham.count).toString()});
  // } else {

  // }

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getAllOrderList();
    gettAllCustomerList();
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
    return Theme(
      data: OrderAppTheme.buildLightTheme(),
      child: Container(
        child: Scaffold(
          body: Stack(
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
                  children: <Widget>[
                    getAppBarUI(),
                    Expanded(
                      child: NestedScrollView(
                        controller: _scrollController,
                        headerSliverBuilder:
                            (BuildContext context, bool innerBoxIsScrolled) {
                          return <Widget>[
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                return Column(
                                  children: <Widget>[
                                    getSoLuongUI(), // ui so luong vs tong tien hang
                                    getTimeDateUI(),
                                    getKhachhangUI(),
                                    getThanhToanGhichuUI(),
                                  ],
                                );
                              }, childCount: 1),
                            ),
                            SliverPersistentHeader(
                              pinned: true,
                              floating: true,
                              delegate: ContestTabHeader(
                                getFilterBarUI(),
                              ),
                            ),
                          ];
                        },
                        body: Container(
                          color:
                              OrderAppTheme.buildLightTheme().backgroundColor,
                          child: ListView.builder(
                            itemCount: orderList.length,
                            padding: const EdgeInsets.only(top: 8),
                            scrollDirection: Axis.vertical,
                            itemBuilder: (BuildContext context, int index) {
                              final int count =
                                  orderList.length > 10 ? 10 : orderList.length;
                              final Animation<double> animation =
                                  Tween<double>(begin: 0.0, end: 1.0).animate(
                                      CurvedAnimation(
                                          parent: animationController,
                                          curve: Interval(
                                              (1 / count) * index, 1.0,
                                              curve: Curves.fastOutSlowIn)));
                              animationController.forward();
                              return OrderListView(
                                removeItem: () {
                                  setState(() {
                                    _orderService.deleteOneOrderList(
                                        orderList[index].id);
                                    getAllOrderList();
                                  });
                                },
                                callback: () {
                                  setState(() {
                                    getTong();
                                  });
                                },
                                sanpham: orderList[index],
                                animation: animation,
                                animationController: animationController,
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    getAppBar1UI(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget getListUI() {
  //   return Container(
  //     decoration: BoxDecoration(
  //       color: OrderAppTheme.buildLightTheme().backgroundColor,
  //       boxShadow: <BoxShadow>[
  //         BoxShadow(
  //             color: Colors.grey.withOpacity(0.2),
  //             offset: const Offset(0, -2),
  //             blurRadius: 8.0),
  //       ],
  //     ),
  //     child: Column(
  //       children: <Widget>[
  //         Container(
  //           height: MediaQuery.of(context).size.height - 156 - 50,
  //           child: FutureBuilder<bool>(
  //             future: getData(),
  //             builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
  //               if (!snapshot.hasData) {
  //                 return const SizedBox();
  //               } else {
  //                 return ListView.builder(
  //                   itemCount: orderList.length,
  //                   scrollDirection: Axis.vertical,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     final int count =
  //                         orderList.length > 10 ? 10 : orderList.length;
  //                     final Animation<double> animation =
  //                         Tween<double>(begin: 0.0, end: 1.0).animate(
  //                             CurvedAnimation(
  //                                 parent: animationController,
  //                                 curve: Interval((1 / count) * index, 1.0,
  //                                     curve: Curves.fastOutSlowIn)));
  //                     animationController.forward();

  //                     return OrderListView(
  //                       callback: () {
  //                         getAllOrderList();
  //                       },
  //                       sanpham: orderList[index],
  //                       animation: animation,
  //                       animationController: animationController,
  //                     );
  //                   },
  //                 );
  //               }
  //             },
  //           ),
  //         )
  //       ],
  //     ),
  //   );
  // }

  Widget getTimeDateUI() {
    int phiGiaohangInt = phiGiaohang.round();
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      setState(() {
                        showChietkhauDialog(context: context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Chiết khấu',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            chietKhau.toString() + " %",
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      showTienShipDialog(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Phí giao hàng',
                            style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 16,
                                color: Colors.grey.withOpacity(0.8)),
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            formatCurrency.format(phiGiaohangInt),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSoLuongUI() {
    int tongTienhangInt = tongTienhang.round();
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tổng số lượng',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.8)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        tongSoluong.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 8, top: 4, bottom: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Tổng tiền hàng',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            color: Colors.grey.withOpacity(0.8)),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      Text(
                        formatCurrency.format(tongTienhangInt),
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getKhachhangUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Column(
              children: <Widget>[
                Text("Khách hàng:"),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () async {
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CustomerScreen()),
                      );

                      setState(() {
                        getInfoCustomer(int.parse(result));
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            nameCustomer,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 1,
              height: 42,
              color: Colors.grey.withOpacity(0.8),
            ),
          ),
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      setState(() {
                        showGiaDialog(context: context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            getGiaban(giaban),
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void showPTTT({BuildContext context}) {
    showDialog<dynamic>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Phương thức thanh toán"),
              content: Text("Chọn phương thức thanh toán"),
              actions: [
                CupertinoDialogAction(
                  child: Text("Thanh toán khi nhận hàng COD"),
                  onPressed: () {
                    setState(() {
                      trangthaithanhtoan = "Thanh toán khi nhận hàng COD";
                      Navigator.pop(context);
                    });
                  },
                ),
                CupertinoDialogAction(
                  child: Text("Chuyển khoản qua ngân hàng"),
                  onPressed: () {
                    setState(() {
                      trangthaithanhtoan = "Chuyển khoản qua ngân hàng";
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }

  Widget getThanhToanGhichuUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 18, bottom: 16),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      showPTTT(context: context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 8, right: 8, top: 4, bottom: 4),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const SizedBox(
                            height: 8,
                          ),
                          Text(
                            trangthaithanhtoan,
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: OrderAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: OrderAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nhập tên, mã, Barcode...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: OrderAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 20,
                      color: OrderAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getFilterBarUI() {
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Container(
            height: 24,
            decoration: BoxDecoration(
              color: OrderAppTheme.buildLightTheme().backgroundColor,
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 8.0),
              ],
            ),
          ),
        ),
        Container(
          color: OrderAppTheme.buildLightTheme().backgroundColor,
          child: Padding(
            padding:
                const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 4),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      '',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      setState(() {
                        showDeleteDialog(context: context);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8, right: 16),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Xóa tất cả',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.delete,
                                color: OrderAppTheme.buildLightTheme()
                                    .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    focusColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.grey.withOpacity(0.2),
                    borderRadius: const BorderRadius.all(
                      Radius.circular(4.0),
                    ),
                    onTap: () {
                      FocusScope.of(context).requestFocus(FocusNode());
                      Navigator.push<dynamic>(
                        context,
                        MaterialPageRoute<dynamic>(
                            builder: (BuildContext context) => AddFood(),
                            fullscreenDialog: true),
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'Thêm sản phẩm',
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(Icons.add_box,
                                color: OrderAppTheme.buildLightTheme()
                                    .primaryColor),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Divider(
            height: 1,
          ),
        )
      ],
    );
  }

  void showDeleteDialog({BuildContext context}) {
    showDialog<dynamic>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Xóa tất cả"),
              content: Text("Xóa tất cả sản phẩm ?"),
              actions: [
                CupertinoDialogAction(
                  child: Text("Có"),
                  onPressed: () {
                    setState(() {
                      _orderService.deleteOrderList();
                      getAllOrderList();
                      getReset();
                      Navigator.pop(context);
                    });
                  },
                ),
                CupertinoDialogAction(
                  child: Text("Không"),
                  onPressed: () {
                    setState(() {
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }

  void showChietkhauDialog({BuildContext context}) {
    showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              "Chiết khấu (%)",
              textAlign: TextAlign.center,
            ),
            content: Container(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    onChanged: (value) {
                      if (value.isNotEmpty &&
                          int.parse(value) <= 100 &&
                          int.parse(value) >= 0) {
                        chietKhau = int.parse(value);
                      }
                    },
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    cursorHeight: 30,
                  ),
                  CupertinoDialogAction(
                    child: Container(
                      child: Column(
                        children: [
                          Text("Xong"),
                        ],
                      ),
                    ),
                    onPressed: () {
                      setState(() {});
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        });
  }

  void showGiaDialog({BuildContext context}) {
    showDialog<dynamic>(
        context: context,
        builder: (_) => CupertinoAlertDialog(
              title: Text("Chọn giá bán"),
              content: Text("Chọn giá bán sỉ hoặc bán lẻ ?"),
              actions: [
                CupertinoDialogAction(
                  child: Text("Bán sỉ"),
                  onPressed: () {
                    setState(() {
                      giaban = 0;
                      Navigator.pop(context);
                    });
                  },
                ),
                CupertinoDialogAction(
                  child: Text("Bán lẻ"),
                  onPressed: () {
                    setState(() {
                      giaban = 1;
                      Navigator.pop(context);
                    });
                  },
                )
              ],
            ));
  }

  void showTienShipDialog({BuildContext context}) {
    int tienship = 0;
    showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Chọn bên giao hàng:"),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      title: Text("Giao hàng Grab"),
                      value: 20000,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          tienship = value;
                          phiGiaohang = double.parse(tienship.toString());
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Giao hàng nhanh"),
                      value: 15000,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          tienship = value;
                          phiGiaohang = double.parse(tienship.toString());
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Giao hàng tiết kiệm"),
                      value: 10000,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          tienship = value;
                          phiGiaohang = double.parse(tienship.toString());
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Giao hàng NowShip"),
                      value: 35000,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          tienship = value;
                          phiGiaohang = double.parse(tienship.toString());
                          Navigator.pop(context);
                        });
                      },
                    )
                  ],
                ),
              ),
            ),
          );
        });
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
              width: AppBar().preferredSize.height + 40,
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
                  'Tạo đơn hàng',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 22,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
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
                      onTap: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => OrderListScreen()));
                      },
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

  Widget getAppBar1UI() {
    int tongInt = tong.round();
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
        padding: EdgeInsets.only(top: 8),
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                SizedBox(
                  width: 180,
                ),
                Padding(
                  padding: EdgeInsets.only(right: 0, bottom: 16),
                  child: Text(
                    "Tạm tính: " + formatCurrency.format(tongInt),
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Container(),
            RaisedButton(
              onPressed: () {
                if (customer.idCustomer.isEmpty || tongTienhang == 0.0) {
                } else {
                  getDathang_GioHang();
                  tongSoluong = 0;
                  tongTienhang = 0;
                  tongTienVon = 0;
                  tong = 0;
                  chietKhau = 0;
                  phiGiaohang = 0;

                  Navigator.of(context).pushNamed(OrderListScreen.routeName,
                      arguments: {
                        'idGioHang': idGioHang,
                        'idDonHang': idDonHang
                      });

                  _orderService.deleteOrderList();
                  nameCustomer = "Thêm khách hàng";
                }
              },
              textColor: Colors.black,
              padding: const EdgeInsets.all(0.0),
              child: Container(
                padding: const EdgeInsets.all(10.0),
                child: const Text(
                  "Tạo đơn hàng",
                  style: TextStyle(fontSize: 15),
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
