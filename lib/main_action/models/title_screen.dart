class MealsListData {
  MealsListData({
    this.imagePath = '',
    this.titleTxt = '',
    this.startColor = '',
    this.endColor = '',
    this.uiId = 0,
  });

  String imagePath;
  String titleTxt;
  String startColor;
  String endColor;
  int uiId;

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
      uiId: 0,
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/004-tshirt.png',
      titleTxt: 'Thêm sản phẩm',
      uiId: 1,
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/013-truck.png',
      titleTxt: 'Tạo đơn nhập hàng',
      uiId: 2,
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/021-invoice.png',
      titleTxt: 'Danh sách đơn hàng',
      uiId: 3,
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/005-store.png',
      titleTxt: 'Quản lý kho',
      uiId: 4,
    ),
    MealsListData(
      imagePath: 'assets/fitness_app/019-headphone.png',
      titleTxt: 'Quản lý khách hàng',
      uiId: 5,
    ),
  ];
}
