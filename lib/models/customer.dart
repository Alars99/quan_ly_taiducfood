import 'package:quan_ly_taiducfood/repositories/customer_repository.dart';

class Customer {
  var _rep = CustomerRespository();

  String id;
  String name;
  String phone;
  String mail;
  String address;
  int point;

  Customer(
      {this.id, this.name, this.phone, this.mail, this.address, this.point});

  List<Customer> _listCustomer = <Customer>[];

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        mail: json["mail"],
        address: json["address"],
        point: json["point"],
      );

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "phone": phone,
      "mail": mail,
      "address": address,
      "point": point,
    };
  }

  void addCustomer(Customer customer) {
    final e = _rep.addCustomer(customer);
  }

  void updateCustomer(Customer customer) {
    final e = _rep.updateCustomer(customer, customer.id);
  }

  
}
