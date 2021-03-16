import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_detail_screen.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';
import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
import 'package:quan_ly_taiducfood/statistical_action/theme/stat&cus_theme.dart';

class HistoryCustomer extends StatefulWidget {
  @override
  _HistoryCustomerScreen createState() => _HistoryCustomerScreen();
  static const routeName = '/history-customer';
}

class _HistoryCustomerScreen extends State<HistoryCustomer> {
  var customer = Customer();
  var _customerService = CustomerService();

  String nameStatus = "";
  var colortxt;

  List<OrderList> orderList = [];
  List<Customer> customerList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map data = ModalRoute.of(context).settings.arguments;
    var idCus = data['idCustomer'];
    getAllCustomerList(idCus);
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
      }
      setState(() {});
    });
  }

  getStatus(String id) {
    if (id == "0") {
      nameStatus = "Chưa duyệt";
      colortxt = Colors.blue[300];
    } else if (id == "1") {
      nameStatus = "Chờ xuất kho";
      colortxt = Colors.blue[500];
    } else if (id == "2") {
      nameStatus = "Đang giao hàng";
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

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: <Widget>[
                      orderList.length == 0
                          ? Center(
                              child: Text(
                              "Không có lịch sử mua hàng",
                              style: TextStyle(fontSize: 17),
                            ))
                          : Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height - 213,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: orderList.length,
                                        itemBuilder: (_, index) {
                                          return getInfoUI(
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
                                        }),
                                  ),
                                ],
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
    );
  }

  Widget getInfoUI(
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
    if (customerList.first.idCustomer == idKhachHang) {
      getStatus(trangthai);
      return GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            OrderDetailScreen.routeName,
            arguments: {
              'idCustomer': customerList.first.idCustomer,
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
            },
          );
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 8),
          child: Container(
              child: Column(
            children: [
              Row(
                children: <Widget>[
                  Container(
                    width: MediaQuery.of(context).size.width * 0.95,
                    height: 85,
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: HexColor('#F8FAFB'),
                          borderRadius: const BorderRadius.only(
                            bottomRight: Radius.circular(13.0),
                            bottomLeft: Radius.circular(13.0),
                            topLeft: Radius.circular(13.0),
                            topRight: Radius.circular(13.0),
                          ),
                        ),
                        child: Column(
                          children: <Widget>[
                            Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 10, right: 8),
                                  child: Container(
                                    width: 50,
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      idDonHang,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 8, right: 16),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      customerList.first.name,
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 8, left: 8, right: 8),
                                  child: Container(
                                    padding: EdgeInsets.zero,
                                    child: Text(
                                      ngaymua.toString(),
                                      style: TextStyle(
                                        fontFamily: 'WorkSans',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: DesignCourseAppTheme.nearlyBlue,
                                      ),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(top: 8),
                                  child: Icon(Icons.chevron_right),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                // Padding(
                                //   padding: EdgeInsets.only(right: 16, top: 8),
                                //   child: Text(
                                //     trangthai.toString(),
                                //     style: TextStyle(
                                //       fontWeight: FontWeight.bold,
                                //       fontFamily: 'WorkSans',
                                //     ),
                                //   ),
                                // )
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
                    ),
                  ),
                ],
              ),
            ],
          )),
        ),
      );
    }
    return Container();
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8, left: 8),
      child: Row(
        children: <Widget>[
          Container(
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
                  child: Icon(
                    Icons.arrow_back,
                    color: OrderAppTheme.buildLightTheme().primaryColor,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 65, right: 45),
            child: Row(
              children: <Widget>[
                Text(
                  'Lịch sử mua hàng',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
              ],
            ),
          ),
          Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.filter_list_alt,
                    color: OrderAppTheme.buildLightTheme().primaryColor,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
