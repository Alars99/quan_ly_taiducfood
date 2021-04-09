import 'package:flutter/material.dart';

import 'package:quan_ly_taiducfood/customer_action/view/add_customer.dart';
import 'package:quan_ly_taiducfood/customer_action/view/customer_list_view.dart';
import 'package:quan_ly_taiducfood/helper/search_delegate.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';

import 'package:quan_ly_taiducfood/models/customer.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_theme.dart';
import 'package:quan_ly_taiducfood/repositories/customer_repository.dart';
import 'package:quan_ly_taiducfood/statistical_action/theme/stat&cus_theme.dart';

class CustomerScreen extends StatefulWidget {
  @override
  _CustomerScreenState createState() => _CustomerScreenState();
}

class _CustomerScreenState extends State<CustomerScreen> {
  var _apiResponse = APIResponse();
  List<Customer> customerList = [];
  var service = CustomerRespository();

  _fetchCustomers() async {
    _apiResponse = await service.getCustomersList();
    customerList = _apiResponse.data;
  }

  @override
  void initState() {
    _fetchCustomers();
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
                      Flexible(
                        child: getPopularCourseUI(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: FloatingActionButton(
                    backgroundColor: DesignCourseAppTheme.grey,
                    child: Icon(
                      Icons.search,
                    ),
                    onPressed: () {
                      print(customerList.length);
                      showSearch(
                          context: context, delegate: Search(customerList));
                    },
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget getPopularCourseUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            child: CustomerListView(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(right: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
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
            padding: EdgeInsets.only(left: 8, right: 8),
            child: Row(
              children: <Widget>[
                Text(
                  'Danh sách khách hàng',
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
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => AddCustomer()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.add_box_outlined,
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
