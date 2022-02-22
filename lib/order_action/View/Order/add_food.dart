import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/product.dart';
import 'package:quan_ly_taiducfood/order_action/Controller/OrderController.dart';
import 'package:quan_ly_taiducfood/order_action/model/popular_filter_list.dart';
import 'package:quan_ly_taiducfood/order_action/model/test.dart';
import 'package:quan_ly_taiducfood/repositories/product_repository.dart';
import 'order_theme.dart';

class AddFood extends StatefulWidget {
  @override
  _AddFoodState createState() => _AddFoodState();
}

class _AddFoodState extends State<AddFood> {
  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
  var product = Product();
  var _orderService = OrderService();
  List<Sanpham> orderList = [];

  //APIResponse<List<Product>> _apiResponse;
  bool isLoading = false;
  //ProductRespository service = ProductRespository();

  @override
  void initState() {
    _fetchProduct();
    super.initState();
  }

  checkOderList(Product product) async {
    bool flag = false;
    final list1 = await _orderService.readOrderList();
    list1.forEach((element) {
      Product pro = Product();
      pro.id = element['id'];
      if (product.id == pro.id) {
        flag = true;
      }
    });
    if (flag == false) {
      _orderService.saveOrderList(product);
    } else {
      print("Show message box");
      flag = false;
    }
  }

  List<Product> list = [];

  doSomething(String id) {
    list.clear();
    // _apiResponse.data.forEach((element) {
    //   if (element.categoryId == id) {
    //     list.add(element);
    //   }
    // });
  }

  _fetchProduct() async {
    setState(() {
      isLoading = true;
    });

    // _apiResponse = await service.getProductsList();

    setState(() {
      isLoading = false;
    });
  }

  List<PopularFilterListData> popularFilterListData =
      PopularFilterListData.popularFList;
  List<Sanpham> productList = [];
  DatabaseReference ref = FirebaseDatabase.instance.reference();
  double distValue = 50.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: OrderAppTheme.buildLightTheme().backgroundColor,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            getAppBarUI(),
            // getSearchBarUI(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    popularFilter(),

                    const Divider(
                      height: 1,
                    ),
                    priceBarFilter(),
                    const Divider(
                      height: 1,
                    ),
                    const Divider(
                      height: 1,
                    ),
                    // allAccommodationUI()
                  ],
                ),
              ),
            ),
            const Divider(
              height: 1,
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 16, right: 16, bottom: 16, top: 8),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: OrderAppTheme.buildLightTheme().primaryColor,
                  borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.6),
                      blurRadius: 8,
                      offset: const Offset(4, 4),
                    ),
                  ],
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(24.0)),
                    highlightColor: Colors.transparent,
                    onTap: () async {
                      for (var sp in list) {
                        if (sp.isSelected) {
                          checkOderList(sp);
                        }
                      }
                      Navigator.pop(context);
                    },
                    child: Center(
                      child: Text(
                        'Apply',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 18,
                            color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 8),
      child: Row(
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: OrderAppTheme.buildLightTheme().backgroundColor,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(38.0),
                  ),
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        offset: const Offset(0, 2),
                        blurRadius: 8.0),
                  ],
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 16, right: 16, top: 4, bottom: 4),
                  child: TextField(
                    onChanged: (String txt) {},
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    cursorColor: OrderAppTheme.buildLightTheme().primaryColor,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Nhập tên, mã, Barcode...',
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: OrderAppTheme.buildLightTheme().primaryColor,
              borderRadius: const BorderRadius.all(
                Radius.circular(38.0),
              ),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.withOpacity(0.4),
                    offset: const Offset(0, 2),
                    blurRadius: 8.0),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: const BorderRadius.all(
                  Radius.circular(32.0),
                ),
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Icon(FontAwesomeIcons.search,
                      size: 20,
                      color: OrderAppTheme.buildLightTheme().backgroundColor),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget popularFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding:
              const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 8),
          child: Text(
            'Danh mục sản phẩm',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 16, left: 16),
          child: Column(
            children: getPList(),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
      ],
    );
  }

  String danhmuc = '';
  List<Widget> getPList() {
    final List<Widget> noList = <Widget>[];

    int count = 0;
    const int columnCount = 2;
    for (int i = 0; i < popularFilterListData.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final PopularFilterListData a = popularFilterListData[count];
          listUI.add(Expanded(
            child: Row(
              children: <Widget>[
                Material(
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      Radio(
                        value: a.id,
                        groupValue: danhmuc,
                        onChanged: (value) {
                          setState(() {
                            danhmuc = value;
                            doSomething(danhmuc);
                          });
                        },
                      ),
                      Text(
                        a.titleTxt,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
          if (count < popularFilterListData.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget priceBarFilter() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Tất cả sản phẩm',
            textAlign: TextAlign.left,
            style: TextStyle(
                color: Colors.grey,
                fontSize: MediaQuery.of(context).size.width > 360 ? 18 : 16,
                fontWeight: FontWeight.normal),
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        (isLoading)
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.only(right: 16, left: 16),
                child: Column(
                  children: getProList(),
                ),
              ),
      ],
    );
  }

  List<Widget> getProList() {
    final List<Widget> noList = <Widget>[];
    int count = 0;
    const int columnCount = 1;
    for (int i = 0; i < list.length / columnCount; i++) {
      final List<Widget> listUI = <Widget>[];
      for (int i = 0; i < columnCount; i++) {
        try {
          final Product date = list[count];
          int priceInt = double.parse(date.price.toString()).round();
          listUI.add(Expanded(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 8),
                  child: Container(
                    height: 2,
                    width: 370,
                    color: Colors.grey.withOpacity(0.8),
                  ),
                ),
                Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: const BorderRadius.all(Radius.circular(4.0)),
                    onTap: () {
                      setState(() {
                        date.isSelected = !date.isSelected;
                      });
                    },
                    child: Container(
                      height: 125,
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: EdgeInsets.only(left: 8, right: 8),
                                    width: 300,
                                    child: Text(date.name),
                                  ),
                                  Row(
                                    children: [
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              top: 8,
                                            ),
                                            child: Text(
                                                "Mã: " + date.id.toString()),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              top: 8,
                                            ),
                                            child: Text("Giá: " +
                                                formatCurrency
                                                    .format(priceInt)),
                                          ),
                                          Padding(
                                            padding: EdgeInsets.only(
                                              left: 8,
                                              top: 8,
                                            ),
                                            child: Text("Số lượng: " +
                                                date.amout.toString()),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                          padding: EdgeInsets.only(right: 50)),
                                      Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          (date.img == null)
                                              ? Container(
                                                  height: 50,
                                                  width: 50,
                                                  color: Colors.red,
                                                )
                                              : Image.network(
                                                  date.img.contains(
                                                          "image_picker")
                                                      ? 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/' +
                                                          date.img +
                                                          '?alt=media&token=63435cda-cb54-4b82-bec7-08edadbb049e'
                                                      : date.img,
                                                  height: 50,
                                                ),
                                          Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 80),
                                            child: Icon(
                                              date.isSelected
                                                  ? Icons.check_box
                                                  : Icons
                                                      .check_box_outline_blank,
                                              color: date.isSelected
                                                  ? OrderAppTheme
                                                          .buildLightTheme()
                                                      .primaryColor
                                                  : Colors.grey
                                                      .withOpacity(0.6),
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ));
          if (count < list.length - 1) {
            count += 1;
          } else {
            break;
          }
        } catch (e) {
          print(e);
        }
      }
      noList.add(Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: listUI,
      ));
    }
    return noList;
  }

  Widget getAppBarUI() {
    return Container(
      decoration: BoxDecoration(
        color: OrderAppTheme.buildLightTheme().backgroundColor,
        boxShadow: <BoxShadow>[
          BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              offset: const Offset(0, 2),
              blurRadius: 4.0),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top, left: 8, right: 8),
        child: Row(
          children: <Widget>[
            Container(
              alignment: Alignment.centerLeft,
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(32.0),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(Icons.close),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Text(
                  'Thêm sản phẩm',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                  ),
                ),
              ),
            ),
            Container(
              width: AppBar().preferredSize.height + 40,
              height: AppBar().preferredSize.height,
            )
          ],
        ),
      ),
    );
  }
}
