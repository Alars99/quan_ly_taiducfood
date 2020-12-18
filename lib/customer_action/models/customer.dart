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

  static List<Customer> popularCourseList = <Customer>[
    Customer(
        idCustomer: "cus1",
        address: "277/ Nguyễn Tất Thành/ Chợ Lầu/ Bắc Bình/ Bình Thuận",
        name: "Nhật Trường",
        phone: '0943502207',
        email: 'nnhattruong23@gmail.com'),
    Customer(
        idCustomer: "cus1",
        address: "277/ Nguyễn Tất Thành/ Chợ Lầu/ Bắc Bình/ Bình Thuận",
        name: "Nhật Trường",
        phone: '0943502207',
        email: 'nnhattruong23@gmail.com'),
    Customer(
        idCustomer: "cus1",
        address: "277/ Nguyễn Tất Thành/ Chợ Lầu/ Bắc Bình/ Bình Thuận",
        name: "Nhật Trường",
        phone: '0943502207',
        email: 'nnhattruong23@gmail.com'),
  ];
}
