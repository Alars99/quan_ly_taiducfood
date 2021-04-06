import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/customer_action/view/customer_Details.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/customer.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';
import 'package:quan_ly_taiducfood/repositories/customer_repository.dart';

class CustomerListView extends StatefulWidget {
  const CustomerListView({Key key, this.callBack}) : super(key: key);
  final Function callBack;
  @override
  _CustomerListViewState createState() => _CustomerListViewState();
}

class _CustomerListViewState extends State<CustomerListView>
    with TickerProviderStateMixin {
  List<Customer> customerList = [];
  var customer = Customer();
  var service = CustomerRespository();
  bool isLoading = false;
  APIResponse _apiResponse = APIResponse();

  _fetchCustomers() async {
    setState(() {
      isLoading = true;
    });

    _apiResponse = await service.getCustomersList();
    customerList = _apiResponse.data;
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    _fetchCustomers();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _fetchCustomers();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: FutureBuilder<bool>(
        builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
          if (isLoading) {
            return CircularProgressIndicator();
          } else {
            return ListView(
              padding: const EdgeInsets.all(8),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              children: List<Widget>.generate(
                customerList.length,
                (int index) {
                  return CategoryView(
                    getInfoCustomer: () {
                      Navigator.pop(context, index.toString());
                    },
                    callback: () {
                      setState(() {});
                    },
                    customer: customerList[index],
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
      {Key key, this.customer, this.callback, this.getInfoCustomer})
      : super(key: key);

  final VoidCallback callback;
  final VoidCallback getInfoCustomer;
  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 17.0),
      child: Builder(
        builder: (BuildContext context) {
          return InkWell(
            splashColor: Colors.transparent,
            onTap: () {},
            child: SizedBox(
              height: 120,
              child: Stack(
                alignment: AlignmentDirectional.bottomCenter,
                children: <Widget>[
                  Container(
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Container(
                            decoration: BoxDecoration(
                              color: HexColor('#D1FAFB'),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(16.0)),
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
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 8.0, left: 16),
                                            child: Text(
                                              "Họ tên: " +
                                                  customer.name.toUpperCase(),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(left: 16),
                                          child: customer.phone == null
                                              ? Text(
                                                  "Số diện thoại: " + "Empty")
                                              : Text(
                                                  "Số diện thoại: " +
                                                      customer.phone,
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.normal,
                                                      fontSize: 13),
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
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
