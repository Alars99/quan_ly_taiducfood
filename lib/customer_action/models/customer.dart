class Customer {
  Customer({
    this.idCustomer = '',
    this.idOrder = 0,
    this.name = '',
    this.phone = '',
    this.address = '',
    this.email = '',
    this.idship = '',
  });

  String idCustomer;
  int idOrder;
  String name;
  String phone;
  String address;
  String email;
  String idship;

  customerMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = idCustomer;
    mapping['idOrder'] = idOrder;
    mapping['name'] = name;
    mapping['email'] = email;
    mapping['phone'] = phone;
    mapping['address'] = address;
    mapping['idShip'] = idship;
    return mapping;
  }
}
