class Sanpham {
  String brand;
  String id;
  String name;
  String price;
  int amout;
  bool isSelected;
  String img;
  int count;

  Sanpham({
    this.brand = '',
    this.id = '',
    this.name = '',
    this.price = '',
    this.amout = 5,
    this.img = '',
    this.isSelected = false,
    this.count = 1,
  });

  sanphamMap() {
    var mapping = Map<String, dynamic>();
    mapping['id'] = id;
    mapping['name'] = name;
    mapping['brand'] = brand;
    mapping['price'] = price;
    mapping['count'] = count;
    mapping['amout'] = amout;
    return mapping;
  }
}
