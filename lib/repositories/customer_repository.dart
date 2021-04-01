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
    final response = await this.httpClient.post((url), body: {
      'id': customer.id,
      'name': customer.name,
    });
    if (response.statusCode == 201) {
      Customer customer = Customer.fromJson(jsonDecode(response.body));

      return customer;
    } else
      return null;
  }

  Future updateCustomer(Customer customer, String id) async {
    final response = await this.httpClient.put((url + "/" + id), body: {
      'id': customer.id,
      'name': customer.name,
    });
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

  Future<void> upload() async {
    final now = DateTime.now();
    // String fileName = basename(_image.path);
    String fileName = "";

    // // String uploadId = reference.push().key;
    // HashMap mapProList = new HashMap();

    // weight = weight.replaceAll(",", "");
    // price = price.replaceAll(",", "");
    // priceBuon = priceBuon.replaceAll(",", "");
    // priceNhap = priceNhap.replaceAll(",", "");
    // priceVon = priceVon.replaceAll(",", "");
    // amount = amount.replaceAll(",", "");

    // mapProList["id"] = id;
    // mapProList["brand"] = brand;
    // mapProList["image"] = fileName;
    // mapProList["name"] = name;
    // mapProList["price"] = price;
    // mapProList["barcode"] = barcode;
    // mapProList["weight"] = weight;
    // mapProList["cate"] = customerCate.id.toString();
    // mapProList["priceNhap"] = priceNhap;
    // mapProList["priceBuon"] = priceBuon;
    // mapProList["priceVon"] = priceVon;
    // mapProList["amount"] = amount;
    // mapProList["desc"] = desc;
    // mapProList["allowSale"] = allowSale;
    // mapProList["tax"] = tax;
    // mapProList["ngayUp"] = DateFormat('dd/MM/yyyy').format(now).toString();
    // mapProList["daban"] = "0";

    // referenceList.child(id).set(mapProList);
  }
}
