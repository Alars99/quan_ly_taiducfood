class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.meals,
    this.kacl = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  List<String> meals;
  int kacl;

  // static List<MealsListData> tabIconsList = <MealsListData>[
  //   MealsListData(
  //     imagePath: 'assets/fitness_app/breakfast.png',
  //     titleTxt: 'Breakfast',
  //     meals: <String>['Bread,', 'Peanut butter,', 'Apple'],
  //     startColor: '#FA7D82',
  //     endColor: '#FFB295',
  //   ),
  static List<MealsListData> tabIconsList = <MealsListData>[
    MealsListData(
      imagePath: 'assets/fitness_app/001-bill.png',
      titleTxt: 'Tạo hóa đơn và giao hàng',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/004-tshirt.png',
      titleTxt: 'Thêm sản phẩm',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/013-truck.png',
      titleTxt: 'Tạo đơn nhập hàng',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/021-invoice.png',
      titleTxt: 'Tạo phiếu thu chi',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/005-store.png',
      titleTxt: 'Quản lý kho',
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/019-headphone.png',
      titleTxt: 'Quản lý nhân viên',
    ),
  ];
}
