import 'package:flutter/widgets.dart';

class PopularFilterListData {
  PopularFilterListData({
    this.titleTxt = '',
    this.isSelected = false,
    this.id = "",
  });

  String titleTxt;
  bool isSelected;
  String id;

  static List<PopularFilterListData> popularFList = <PopularFilterListData>[
    PopularFilterListData(
      titleTxt: "Apple",
      id: 'ap',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Samsung",
      id: 'sm',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "Xiaomi",
      id: 'xi',
      isSelected: false,
    ),
    PopularFilterListData(
      titleTxt: "VinSmart",
      id: 'vi',
      isSelected: false,
    ),
  ];
}
