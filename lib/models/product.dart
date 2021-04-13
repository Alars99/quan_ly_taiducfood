import 'dart:math';

class Product {
  String id;
  String name;
  String categoryId;
  int amout;
  int barcode;
  String desc;
  String img;
  String updateDay;
  double price;
  double wholesalePrice;
  double importPrice;
  double costPrice;
  double tax;
  bool status;
  bool isSelected;
  int count;

  Product(
      {this.id,
      this.name,
      this.categoryId,
      this.amout,
      this.barcode,
      this.costPrice,
      this.desc,
      this.img,
      this.importPrice,
      this.price,
      this.status,
      this.tax,
      this.updateDay,
      this.isSelected = false,
      this.wholesalePrice,
      this.count = 1});

  factory Product.fromJson(Map<String, dynamic> json) => Product(
      id: json["id"],
      name: json["name"],
      categoryId: json["categoryId"],
      amout: json["amout"],
      barcode: json["barcode"],
      costPrice: json["costPrice"],
      desc: json["desc"],
      img: json["img"],
      importPrice: json["importPrice"],
      price: json["price"],
      status: json["status"],
      tax: json["tax"],
      updateDay: json["updateDay"],
      wholesalePrice: json["wholesalePrice"],
      count: json['count']);

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "categoryId": categoryId,
      "amout": amout,
      "barcode": barcode,
      "costPrice": costPrice,
      "desc": desc,
      "img": img,
      "importPrice": importPrice,
      "price": price,
      "status": true,
      "tax": 10,
      "updateDay": updateDay,
      "wholesalePrice": wholesalePrice,
      'count': count,
    };
  }
}
