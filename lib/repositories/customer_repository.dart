import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/customer.dart';

final url = 'http://www.spcable.somee.com/api/customers/';

class CustomerRespository {
  http.Client httpClient = new http.Client();
  List<Customer> customerList = <Customer>[];

  Future<List> loadData() async {
    final response = await this.httpClient.get(url);
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list;
    } else {
      throw Exception('error');
    }
  }

  Future<APIResponse<List<Customer>>> getCustomersList() async {
    final list = await loadData();
    customerList.clear();
    list.forEach((element) {
      Customer customer = new Customer();
      customer.id = element["id"];
      customer.name = element["name"];
      customer.phone = element["phone"];
      customer.mail = element["mail"];
      customer.address = element["address"];
      customer.point = element["point"];

      customerList.add(customer);
    });
    return APIResponse<List<Customer>>(data: customerList);
  }

  Future addCustomer(Customer customer) async {
    final response = await this.httpClient.post((url),
        body: json.encode(customer.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 201) {
      Customer customer = Customer.fromJson(jsonDecode(response.body));
      return customer;
    } else
      return null;
  }

  Future updateCustomer(Customer customer, String id) async {
    final response = await this.httpClient.put((url + "/" + id), body: {});
    if (response.statusCode == 204) {
    } else
      return null;
  }

  Future<void> deleteCustomer(Customer customer) async {
    final response = await this.httpClient.delete(url + "/" + customer.id);
    if (response.statusCode == 200) {
      Customer customer = Customer.fromJson(jsonDecode(response.body));

      return customer;
    } else {
      throw Exception('error');
    }
  }
}
