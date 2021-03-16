import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';
import 'package:quan_ly_taiducfood/statistical_action/theme/stat&cus_theme.dart';

class UpdateCustomer extends StatefulWidget {
  const UpdateCustomer({Key key, this.customer}) : super(key: key);

  @override
  _UpdateCustomer createState() => _UpdateCustomer(customer);

  final Customer customer;
}

class _UpdateCustomer extends State<UpdateCustomer> {
  var customer = Customer();
  var _customerService = CustomerService();

  _UpdateCustomer(this.customer);

  @override
  void initState() {
    super.initState();
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
                      getInfoUI(),
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

  Widget getInfoUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16),
      child: Container(
          child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: <Widget>[
              Container(
                width: 330,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TextFormField(
                              onChanged: (value) {
                                customer.name = value;
                              },
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: customer.name,
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 8,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 8,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                              onEditingComplete: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.person, color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 330,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TextFormField(
                              onChanged: (value) {
                                customer.phone = value;
                              },
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: customer.phone,
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.phone, color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 330,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TextFormField(
                              onChanged: (value) {
                                customer.address = value;
                              },
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: customer.address,
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                              onEditingComplete: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.location_city,
                              color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 330,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: TextFormField(
                              onChanged: (value) {
                                customer.email = value;
                              },
                              style: TextStyle(
                                fontFamily: 'WorkSans',
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: DesignCourseAppTheme.nearlyBlue,
                              ),
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                                hintText: customer.email,
                                border: InputBorder.none,
                                helperStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: HexColor('#B9BABC'),
                                ),
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  letterSpacing: 0.2,
                                  color: HexColor('#B9BABC'),
                                ),
                              ),
                              onEditingComplete: () {},
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: Icon(Icons.email, color: HexColor('#B9BABC')),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 330,
                height: 64,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
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
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: RaisedButton(
                              onPressed: () {
                                _customerService.updateCustomer(customer);
                                Navigator.pop(context);
                              },
                              child: Text("Cập nhật"),
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              color: Colors.green[300],
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            padding: const EdgeInsets.only(left: 16, right: 16),
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Hủy"),
                              padding: EdgeInsets.only(top: 8, bottom: 8),
                              color: Colors.red[300],
                              textColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const Expanded(
                child: SizedBox(),
              )
            ],
          ),
        ],
      )),
    );
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
            padding: EdgeInsets.only(left: 70, right: 40),
            child: Row(
              children: <Widget>[
                Text(
                  'Cập nhật khách hàng',
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
                onTap: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.person_search,
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
