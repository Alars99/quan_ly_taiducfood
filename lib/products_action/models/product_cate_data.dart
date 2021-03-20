class ProductCate {
  String name;
  String categoryId;

  ProductCate({this.categoryId, this.name});

  static List<ProductCate> listProductCate = <ProductCate>[
    ProductCate(categoryId: "ap", name: "Apple"),
  ];
}
