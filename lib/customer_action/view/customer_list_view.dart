import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/customer_action/view/customer_Details.dart';
import 'package:quan_ly_taiducfood/customer_action/models/customer.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/CustomerController.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_screen.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';

class CustomerListView extends StatefulWidget {
  const CustomerListView({Key key, this.callBack}) : super(key: key);

  final Function callBack;

  @override
  _CustomerListViewState createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView>
    with TickerProviderStateMixin {
  // ignore: deprecated_member_use
  List<Customer> customerList = List<Customer>();

  var sanpham = Customer();
  var customerSer = CustomerService();
  var orderScreen = OrderScreen();
  AnimationController animationController;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    getAllCustomerList();
    super.didChangeDependencies();
  }

  getAllCustomerList() async {
    customerList.clear();
    var customers = await customerSer.readCustomerList();
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

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<bool>(
        future: getData(),
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (!snapshot.hasData) {
            return const SizedBox();
          } else {
            return ListView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                customerList.length,
                (int index) {
                  final int count = customerList.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                    CurvedAnimation(
                      parent: animationController,
                      curve: Interval((1 / count) * index, 1.0,
                          curve: Curves.fastOutSlowIn),
                    ),
                  );
                  animationController.forward();
                  return CategoryView(
                    getInfoCustomer: () {
                      Navigator.pop(context, index.toString());
                    },
                    callback: () {
                      setState(() {
                        customerSer
                            .deleteOneOrderList(customerList[index].idCustomer);
                        getAllCustomerList();
                      });
                    },
                    customer: customerList[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}

class CategoryView extends StatelessWidget {
  const CategoryView(
      {Key key,
      this.customer,
      this.animationController,
      this.animation,
      this.callback,
      this.getInfoCustomer})
      : super(key: key);

  final VoidCallback callback;
  final VoidCallback getInfoCustomer;
  final Customer customer;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: Transform(
              transform: Matrix4.translationValues(
                  0.0, 50 * (1.0 - animation.value), 0.0),
              child: InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  getInfoCustomer();
                },
                child: SizedBox(
                  height: 150,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                decoration: BoxDecoration(
                                  color: HexColor('#F8FAFB'),
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(16.0)),
                                  // border: new Border.all(
                                  //     color: DesignCourseAppTheme.notWhite),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                      width: 400,
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 16.0, left: 16),
                                                  child: Text(
                                                    customer.name,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 16),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    top: 8, right: 16),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(32.0),
                                                    ),
                                                    onTap: () {
                                                      callback();
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.close,
                                                        color: OrderAppTheme
                                                                .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 8.0, left: 16),
                                                  child: Text(
                                                    "Số diện thoại: " +
                                                        customer.phone,
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.normal,
                                                        fontSize: 13),
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding:
                                                    EdgeInsets.only(right: 16),
                                                child: Material(
                                                  color: Colors.transparent,
                                                  child: InkWell(
                                                    borderRadius:
                                                        const BorderRadius.all(
                                                      Radius.circular(32.0),
                                                    ),
                                                    onTap: () {
                                                      Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  DetailsCustomer(
                                                                    customer:
                                                                        customer,
                                                                  )));
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Icon(
                                                        Icons.person_search,
                                                        color: OrderAppTheme
                                                                .buildLightTheme()
                                                            .primaryColor,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          Container(
                                            width: 345,
                                            child: Padding(
                                              padding: EdgeInsets.only(
                                                  top: 8, left: 16, bottom: 8),
                                              child: Text(
                                                "Địa chỉ: " + customer.address,
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    fontSize: 13),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
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
            ),
          );
        },
      ),
    );
  }
}
