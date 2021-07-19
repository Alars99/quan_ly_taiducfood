class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.id = 0,
  });

  String titleTxt;
  bool isSelected;
  int id;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: "Thịt Bò Úc",
      id: 1,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Thịt Gà",
      id: 2,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Thịt Bò Mỹ",
      id: 3,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Thịt Cừu",
      id: 4,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Thịt Dê",
      id: 5,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Thịt Heo",
      id: 6,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Thịt Trâu",
      id: 7,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Hải sản",
      id: 8,
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Sản phẩm khác",
      id: 9,
      isSelected: false,
    ),
  ];
}
