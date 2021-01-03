class Product {
  String name;
  String img;
  String id;
  bool isSelected;
  double price;
  int amout;
  Product({
    this.id = '',
    this.name = '',
    this.img = '',
    this.isSelected = false,
    this.price = 0,
    this.amout = 0,
  });

  static List<Product> productList = <Product>[
    Product(
      id: '1',
      name: 'Grand Royal Hotel',
      img: 'Wembley, London',
      amout: 2,
      price: 1000000,
      isSelected: false,
    ),
    Product(
      id: '1',
      name: 'Grand Royal Hotel',
      img: 'Wembley, London',
      amout: 2,
      price: 1000000,
      isSelected: false,
    ),
    Product(
      id: '1',
      name: 'Grand Royal Hotel',
      img: 'Wembley, London',
      amout: 2,
      price: 1000000,
      isSelected: false,
    ),
    Product(
      id: '1',
      name: 'Grand Royal Hotel',
      img: 'Wembley, London',
      amout: 2,
      price: 1000000,
      isSelected: true,
    ),
  ];
}
