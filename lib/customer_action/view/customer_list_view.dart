import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/customer.dart';
import 'package:quan_ly_taiducfood/repositories/customer_repository.dart';

import 'customer_Details.dart';

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

  _deleteCustomer(Customer cus) async {
    setState(() {
      isLoading = true;
    });
    await service.deleteCustomer(cus);
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
            return ListView.builder(
              itemCount: customerList.length,
              itemBuilder: (context, index) {
                return CategoryView(
                  customer: customerList[index],
                  callback: () {
                    _deleteCustomer(customerList[index]);
                    _fetchCustomers();
                  },
                );
              },
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
    return ListTile(
      mouseCursor: MouseCursor.defer,
      isThreeLine: true,
      leading: Icon(Icons.person),
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailsCustomer(
              customer: customer,
            ),
          )),
      title: Text(
        customer.name,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Phone: " + customer.phone),
          Text("Address: " + customer.address),
        ],
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          InkWell(
            child: Icon(Icons.close),
            onTap: () => showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  content: Text("Bạn có muốn Xóa ${customer.name} ?",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      )),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(2.0))),
                  actions: [
                    ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.green[900]),
                        onPressed: () {
                          callback();
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.check),
                        label: Text("Có")),
                    ElevatedButton.icon(
                        style:
                            ElevatedButton.styleFrom(primary: Colors.red[900]),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Icon(Icons.close),
                        label: Text("Không")),
                  ],
                );
              },
            ),
            radius: 32,
          ),
          Padding(padding: EdgeInsets.symmetric(vertical: 2)),
          Text(
            customer.point.toString(),
            style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 20,
                fontWeight: FontWeight.w700),
          )
        ],
      ),
    );
  }
}
