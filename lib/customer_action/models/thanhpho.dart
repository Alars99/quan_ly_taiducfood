class ThanhPho {
  ThanhPho({
    this.id = 0,
    this.name = '',
    this.price = '',
  });

  int id;
  String name;
  String price;

  static List<ThanhPho> tpList = <ThanhPho>[
    ThanhPho(id: 1, name: "TP. Hồ Chí Minh", price: "30000"),
    ThanhPho(id: 2, name: "Hà nội", price: "30000"),
    ThanhPho(id: 3, name: "Bình Thuận", price: "25000"),
  ];
}
