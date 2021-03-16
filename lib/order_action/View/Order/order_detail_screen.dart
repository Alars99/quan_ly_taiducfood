import 'dart:ui';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_detail_data.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/order_action/model/test.dart';
import 'order_theme.dart';

class OrderDetailScreen extends StatefulWidget {
  const OrderDetailScreen({Key key}) : super(key: key);

  @override
  _OrderDetailScreenState createState() => _OrderDetailScreenState();
  static const routeName = '/order-detail-screen';
}

class _OrderDetailScreenState extends State<OrderDetailScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;

  final formatCurrency = new NumberFormat.simpleCurrency(
      locale: 'vi', name: "đ", decimalDigits: 0);

  var formKey = GlobalKey<FormState>();

  bool isClose = true;
  bool changetxt = false;
  String trangthai = "";

  var colortxt;
  String nameStatus = "";

  String ttTxt = "";
  int tt;

  List<Sanpham> orderList = [];
  List<Customer> customerList = [];
  List<ProductDetail> productList = [];
  var customerSer = CustomerService();
  String name = "";
  String idDonHangFB;
  String ck;

  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 5));

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
  }

  getStatus(String id) {
    if (id == "0") {
      nameStatus = "Chưa duyệt";
      colortxt = Colors.blue[300];
    } else if (id == "1") {
      nameStatus = "Chờ đóng gói";
      colortxt = Colors.blue[500];
    } else if (id == "2") {
      nameStatus = "Đã đóng gói";
      colortxt = Colors.blue[700];
    } else if (id == "3") {
      nameStatus = "Đã Xuất kho";
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
    var customers = await customerSer.readCustomerList();
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

  gettt() {
    if (tt == 0) {
      ttTxt = "Duyệt Đơn";
    } else if (tt == 1) {
      ttTxt = "Đóng gói và Giao hàng";
    } else if (tt == 2) {
      ttTxt = "Xuất kho";
    } else if (tt == 3) {
      ttTxt = "Thanh Toán";
    } else if (tt == 4) {
      updateDaban();
      ttTxt = "Hoàn thành / Trả hàng";
    } else if (tt == 5) {
      trangthai = "Đơn hàng đã trả";
      isClose = false;

      // hồi lại số lượng hàng hóa;
    } else if (tt == 6) {
      isClose = false;
      trangthai = "Đơn hàng đã hủy";
    }
    updateTrangthai();
  }

  updateDaban() {
    final Map data = ModalRoute.of(context).settings.arguments;
    String idgiohang = data['idGioHang'].toString();
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Cart").child(idgiohang);
    referenceProduct.once().then((DataSnapshot snapshot) {
      orderList.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      for (var key in keys) {
        Sanpham sanpham = new Sanpham(
          id: values[key]["id"],
          name: values[key]["name"],
          price: values[key]["price"],
          count: int.parse(values[key]["count"]),
        );
        orderList.add(sanpham);
      }

      for (var sanpham in orderList) {
        for (int i = 0; i < 10; i++) {
          DatabaseReference referenceProduct = FirebaseDatabase.instance
              .reference()
              .child('productList')
              .child(i.toString())
              .child('Product');
          referenceProduct.once().then((DataSnapshot snapshot) {
            productList.clear();
            var keys = snapshot.value.keys;
            var values = snapshot.value;

            for (var key in keys) {
              ProductDetail productDetail = new ProductDetail(
                values[key]["id"],
                values[key]["brand"],
                values[key]["name"],
                values[key]["image"],
                values[key]["price"],
                values[key]["barcode"],
                values[key]["weight"],
                values[key]["cate"],
                values[key]["priceNhap"],
                values[key]["priceBuon"],
                values[key]["amount"],
                values[key]["desc"],
                values[key]["allowSale"].toString(),
                values[key]["tax"].toString(),
                values[key]["priceVon"],
                values[key]["ngayUp"],
                values[key]["daban"],
              );
              productList.add(productDetail);
            }
            for (var a in productList) {
              if (sanpham.id == a.id) {
                referenceProduct.child(a.id).update({
                  'amount': (sanpham.amout - sanpham.count).toString(),
                  'daban': sanpham.count.toString()
                });
              }
            }
          });
        }
      }
    });
  }

  updateTraHang() {
    final Map data = ModalRoute.of(context).settings.arguments;
    String idgiohang = data['idGioHang'].toString();
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Cart").child(idgiohang);
    referenceProduct.once().then((DataSnapshot snapshot) {
      orderList.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      for (var key in keys) {
        Sanpham sanpham = new Sanpham(
          id: values[key]["id"],
          name: values[key]["name"],
          price: values[key]["price"],
          count: int.parse(values[key]["count"]),
        );
        orderList.add(sanpham);
      }

      for (var sanpham in orderList) {
        for (int i = 0; i < 10; i++) {
          DatabaseReference referenceProduct = FirebaseDatabase.instance
              .reference()
              .child('productList')
              .child(i.toString())
              .child('Product');
          referenceProduct.once().then((DataSnapshot snapshot) {
            productList.clear();
            var keys = snapshot.value.keys;
            var values = snapshot.value;

            for (var key in keys) {
              ProductDetail productDetail = new ProductDetail(
                values[key]["id"],
                values[key]["brand"],
                values[key]["name"],
                values[key]["image"],
                values[key]["price"],
                values[key]["barcode"],
                values[key]["weight"],
                values[key]["cate"],
                values[key]["priceNhap"],
                values[key]["priceBuon"],
                values[key]["amount"],
                values[key]["desc"],
                values[key]["allowSale"].toString(),
                values[key]["tax"].toString(),
                values[key]["priceVon"],
                values[key]["ngayUp"],
                values[key]["daban"],
              );
              productList.add(productDetail);
            }
            print("a" + sanpham.count.toString());
            for (var a in productList) {
              if (sanpham.id == a.id) {
                referenceProduct.child(a.id).update({
                  'amount': (int.parse(a.amount) + sanpham.count).toString(),
                  'daban': (int.parse(a.daban) - sanpham.count).toString()
                });
              }
            }
          });
        }
      }
    });
  }

  getList() {
    final Map data = ModalRoute.of(context).settings.arguments;
    String idgiohang = data['idGioHang'].toString();
    String idCustomer = data['idCustomer'].toString();
    String idcus = data['idKhachHang'].toString();

    if (idcus == "null") {
      idcus = idCustomer;
    }
    getAllCustomerList(idcus);
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("Cart").child(idgiohang);
    referenceProduct.once().then((DataSnapshot snapshot) {
      orderList.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;
      for (var key in keys) {
        setState(() {
          Sanpham sanpham = new Sanpham(
            id: values[key]["id"],
            name: values[key]["name"],
            price: values[key]["price"],
            count: int.parse(values[key]["count"]),
          );
          orderList.add(sanpham);
        });
      }
    });
  }

  @override
  void didChangeDependencies() {
    final Map data = ModalRoute.of(context).settings.arguments;
    tt = int.parse(data['trangthai'].toString());
    gettt();
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
    getStatus(tt.toString());
    final Map data = ModalRoute.of(context).settings.arguments;
    double mainWidth = MediaQuery.of(context).size.width * 1;
    int tthInt = double.parse(data['tongTienhang']).round();

    // if (data['chietKhau'].toString() == "0") {
    //   ck = formatCurrency.format((double.parse(data['tongTienhang']) -
    //           double.parse(data['phiGiaohang']))
    //       .round());
    // } else {
    //   ck = formatCurrency.format(((double.parse(data['tongTienhang']) -
    //               double.parse(data['phiGiaohang'])) /
    //           (1 - int.parse(data['chietKhau']) * 100))
    //       .round());
    // }
    int a = ((double.parse(data['tongTienhang']) -
                double.parse(data['phiGiaohang'])) /
            (1 - int.parse(data['chietKhau']) / 100))
        .round();
    // if (a < 0) {
    //   a = 0;
    // }
    ck = formatCurrency.format(a);
    print(ck);
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
                    child: customerList.first.name == null
                        ? Center(
                            child: Text("Không có dữ liệu!"),
                          )
                        : AnimatedBuilder(
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
                                              padding: EdgeInsets.all(14.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.max,
                                                children: [
                                                  Text(
                                                    formatCurrency
                                                        .format(tthInt),
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 33,
                                                    ),
                                                  ),
                                                  SizedBox(height: 10),
                                                  Text(
                                                      "Bán bởi Nhân viên quản lý"),
                                                  SizedBox(height: 10),
                                                  Text("Chi nhánh mặc định"),
                                                  SizedBox(height: 10),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.circle,
                                                        size: 15,
                                                        color: colortxt,
                                                      ),
                                                      SizedBox(width: 5),
                                                      Text(nameStatus),
                                                    ],
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                      top: 8.0,
                                                      bottom: 8.0,
                                                    ),
                                                    child: Divider(
                                                      color: Colors.black,
                                                    ),
                                                  ),
                                                  Row(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      Icon(Icons.person),
                                                      SizedBox(width: 5),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                              'Tên khách hàng'),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            customerList
                                                                .first.name,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15),
                                                          Text(
                                                              'Địa chỉ giao hàng: '),
                                                          SizedBox(height: 5),
                                                          Container(
                                                            width: 280,
                                                            child: Text(
                                                              customerList.first
                                                                  .address,
                                                              style: TextStyle(
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                fontSize: 17,
                                                              ),
                                                            ),
                                                          ),
                                                          SizedBox(height: 15),
                                                          Text(
                                                              'Số điện thoại:'),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            customerList
                                                                .first.phone,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 18,
                                                            ),
                                                          ),
                                                          SizedBox(height: 15),
                                                          Text('Email: '),
                                                          SizedBox(height: 5),
                                                          Text(
                                                            customerList
                                                                .first.email,
                                                            style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              fontSize: 17,
                                                            ),
                                                          ),
                                                          SizedBox(height: 5),
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
                                          top: 0, left: 7.0, right: 7.0),
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
                                                        fontWeight:
                                                            FontWeight.w500,
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                        ck.toString(),
                                                        style: new TextStyle(
                                                          color:
                                                              Colors.blue[600],
                                                          fontSize: 17.5,
                                                          fontFamily: "Roboto",
                                                        ),
                                                      ),
                                                    ]),
                                                SizedBox(height: 20),
                                                new Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                        data['chietKhau']
                                                                .toString() +
                                                            "%",
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                        formatCurrency.format(
                                                            double.parse(data[
                                                                    'phiGiaohang'])
                                                                .round()),
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
                                                    mainAxisSize:
                                                        MainAxisSize.max,
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
                                                        formatCurrency.format(
                                                            double.parse(data[
                                                                    'tongTienhang'])
                                                                .round()),
                                                        style: new TextStyle(
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          color:
                                                              Colors.blue[900],
                                                          fontSize: 18.5,
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
                  isClose
                      ? Positioned(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                          child: Container(
                            color: Colors.white,
                            height: 60,
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Form(
                                  key: formKey,
                                  child: Container(
                                    width: 280,
                                    //220
                                    height: 47,
                                    child: RaisedButton(
                                      onPressed: () {
                                        setState(() {
                                          tt++;
                                          if (tt == 5) {
                                            showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (context) => AlertDialog(
                                                title: Text(
                                                    "Bạn có muốn trả hàng không?"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                    onPressed: () {
                                                      updateTraHang();
                                                      gettt();
                                                      Fluttertoast.showToast(
                                                          msg:
                                                              "Trả hàng thành công",
                                                          toastLength: Toast
                                                              .LENGTH_SHORT,
                                                          gravity: ToastGravity
                                                              .BOTTOM,
                                                          timeInSecForIosWeb: 1,
                                                          textColor:
                                                              Colors.black87,
                                                          fontSize: 16.0);
                                                      setState(() {});
                                                      Navigator.pop(context);
                                                    },
                                                    child: Text("Có"),
                                                  ),
                                                  FlatButton(
                                                    onPressed: () {
                                                      setState(() {
                                                        tt--;
                                                        gettt();
                                                      });

                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                    child: Text("Không"),
                                                  ),
                                                ],
                                              ),
                                            );
                                          } else {
                                            gettt();
                                          }
                                        });
                                      },
                                      child: changetxt
                                          ? Text(ttTxt,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              ))
                                          : Text(ttTxt,
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 17,
                                              )),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.red,
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (context) => AlertDialog(
                                          title: Text("Bạn có muốn hủy không?"),
                                          actions: <Widget>[
                                            FlatButton(
                                              onPressed: () {
                                                // deleteCart();
                                                deleteOrder();
                                                Fluttertoast.showToast(
                                                    msg:
                                                        "Xóa đơn hàng thành công",
                                                    toastLength:
                                                        Toast.LENGTH_SHORT,
                                                    gravity:
                                                        ToastGravity.BOTTOM,
                                                    timeInSecForIosWeb: 1,
                                                    textColor: Colors.black87,
                                                    fontSize: 16.0);
                                                Navigator.pop(context);
                                                Navigator.pop(context);
                                              },
                                              child: Text("Có"),
                                            ),
                                            FlatButton(
                                              onPressed: () {
                                                Navigator.of(context)
                                                    .pop("Không");
                                              },
                                              child: Text("Không"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> updateTrangthai() async {
    final Map data = ModalRoute.of(context).settings.arguments;
    idDonHangFB = data['idDonHang'].toString();
    if (formKey.currentState.validate()) {
      DatabaseReference referenceTTDH = FirebaseDatabase.instance
          .reference()
          .child('Order')
          .child(idDonHangFB);

      String trangthaiFB = tt.toString();

      referenceTTDH.update({
        "trangthai": trangthaiFB,
      });
    }
  }

  Future<void> deleteOrder() async {
    final Map data = ModalRoute.of(context).settings.arguments;
    final idDonHang = data['idDonHang'];
    DatabaseReference referenceList =
        FirebaseDatabase.instance.reference().child('Order');

    referenceList.child(idDonHang).update({
      "trangthai": "6",
    });
  }

  // Future<void> deleteCart() async {
  //   final Map data = ModalRoute.of(context).settings.arguments;
  //   final idGioHang = data['idGioHang'];
  //   DatabaseReference referenceList =
  //       FirebaseDatabase.instance.reference().child('Cart');

  //   referenceList.child(idGioHang).remove();
  // }

  Widget orderUIList(String name, int count, String price) {
    int priceInt = double.parse(price).round();
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24, top: 0, bottom: 8),
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
                                            formatCurrency.format(priceInt),
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
            top: MediaQuery.of(context).padding.top, left: 8, right: 55),
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
                  'Chi tiết đơn hàng',
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
