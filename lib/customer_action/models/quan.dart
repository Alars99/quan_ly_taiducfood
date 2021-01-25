class Quan {
  Quan({
    this.id = 0,
    this.name = '',
    this.price = '',
  });

  int id;
  String name;
  String price;

  static List<Quan> quanList = <Quan>[
    Quan(id: 1, name: "Quận 1", price: "30000"),
    Quan(id: 2, name: "Quận 2", price: "30000"),
    Quan(id: 3, name: "Quận 3", price: "25000"),
    Quan(id: 4, name: "Quận 4", price: "50000"),
    Quan(id: 5, name: "Quận 5", price: "50000"),
    Quan(id: 6, name: "Quận 6", price: "50000"),
    Quan(id: 7, name: "Quận 7", price: "60000"),
    Quan(id: 8, name: "Quận 8", price: "60000"),
    Quan(id: 9, name: "Quận 9", price: "60000"),
    Quan(id: 10, name: "Quận 10", price: "50000"),
    Quan(id: 11, name: "Quận 11", price: "60000"),
    Quan(id: 12, name: "Quận 12", price: "70000"),
    Quan(id: 13, name: "Quận Bình Thạnh", price: "15000"),
    Quan(id: 14, name: "Quận Bình Tân", price: "70000"),
    Quan(id: 15, name: "Quận Phú Nhuận", price: "30000"),
  ];
}
