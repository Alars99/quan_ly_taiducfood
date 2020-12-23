class Customer {
  Customer({
    this.idCustomer = '',
    this.idOrder = 0,
    this.name = '',
    this.phone = '',
    this.address = '',
    this.email = '',
  });

  String idCustomer;
  int idOrder;
  String name;
  String phone;
  String address;
  String email;

  customerMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = idCustomer;
    mapping['idOrder'] = idOrder;
    mapping['name'] = name;
    mapping['email'] = email;
    mapping['phone'] = phone;
    mapping['address'] = address;
    return mapping;
  }
}
