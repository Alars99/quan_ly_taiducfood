import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_detail_data.dart';
import 'package:quan_ly_taiducfood/statistical_action/View/category_list_view.dart';
import 'package:quan_ly_taiducfood/statistical_action/theme/stat&cus_theme.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreen createState() => _MainScreen();
}

class _MainScreen extends State<MainScreen> {
  CategoryType categoryType = CategoryType.ui;
  ProductDetail productDetail;

  final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');

  double tongTien, tiennhapky, tienxuatky, tondauky, ketqua;
  int soluong = 0;

  DateTime endDate;
  DateTime startDate;
  DateTime _dateTime;

  GlobalKey<RefreshIndicatorState> reKey;

  // ignore: deprecated_member_use
  List<ProductDetail> productDetailList = List();
  getData() {
    int dem = 0;
    int dem1 = 0;
    int dem2 = 0;
    tiennhapky = 0;
    tienxuatky = 0;
    tondauky = 0;

    int dem3 = 0;
    double t = 0;
    double test = 0;

    for (int i = 1; i < 10; i++) {
      DatabaseReference referenceProduct = FirebaseDatabase.instance
          .reference()
          .child('productList')
          .child(i.toString())
          .child('Product');

      referenceProduct.once().then((DataSnapshot snapshot) {
        productDetailList.clear();
        var keys = snapshot.value.keys;
        var values = snapshot.value;

        for (var key in keys) {
          ProductDetail productDetail = new ProductDetail(
            values[key]["id"],
            values[key]["brand"],
            values[key]["name"],
            values[key]["image"],
            values[key]["price"],
            values[key]["barcode"],
            values[key]["weight"],
            values[key]["cate"],
            values[key]["priceNhap"],
            values[key]["priceBuon"],
            values[key]["amount"],
            values[key]["desc"],
            values[key]["allowSale"].toString(),
            values[key]["tax"].toString(),
            values[key]["priceVon"],
            values[key]["ngayUp"],
            values[key]["daban"],
          );
          productDetailList.add(productDetail);
        }

        for (var sp in productDetailList) {
          dem1 += double.parse(sp.amount).round();
          for (int i = 0; i <= 31; i++) {
            _dateTime = DateTime.utc(
                startDate.year, startDate.month, startDate.day + i);

            if (sp.ngayUp == DateFormat("dd/MM/yyyy").format(_dateTime)) {
              dem2 += double.parse(sp.amount).round();

              tiennhapky += double.parse(sp.priceVon) * double.parse(sp.amount);
              if (sp.daban != "0") {
                tienxuatky +=
                    double.parse(sp.priceVon) * double.parse(sp.daban);
              }
            }
          }
        }

        String m = "";
        for (var sp in productDetailList) {
          m = "";
          for (int i = 0; i <= 31; i++) {
            _dateTime = DateTime.utc(
                startDate.year, startDate.month, startDate.day + i);

            if (sp.ngayUp == DateFormat("dd/MM/yyyy").format(_dateTime)) {
              m = sp.ngayUp;
              break;
            }
          }
          if (m == "") {
            tondauky += double.parse(sp.priceVon) * double.parse(sp.amount);
            dem += double.parse(sp.amount).round();
          }
        }

        ketqua = tondauky + tiennhapky - tienxuatky;
        tongTien = ketqua;
        soluong = dem + dem2;
        print("tong" + dem1.toString());
        print("tong1" + dem.toString());
        print("tong2" + dem2.toString());
        setState(() {});
      });
    }
  }

  @override
  void initState() {
    reKey = GlobalKey<RefreshIndicatorState>();
    soluong = 0;
    tongTien = 0;
    tiennhapky = 0;
    tienxuatky = 0;
    tondauky = 0;
    endDate = DateTime.now();
    startDate = DateTime.utc(endDate.year, endDate.month - 1, endDate.day);

    super.initState();
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    getData();
    return null;
  }

  @override
  void didChangeDependencies() {
    getData();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: DesignCourseAppTheme.nearlyWhite,
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: <Widget>[
            SizedBox(
              height: MediaQuery.of(context).padding.top,
            ),
            getAppBarUI(),
            Expanded(
              child: RefreshIndicator(
                key: reKey,
                onRefresh: () async {
                  await refreshList();
                },
                child: SingleChildScrollView(
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      children: <Widget>[
                        getBanHangUI(),
                        getKhoUI(),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget getBanHangUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Bán hàng',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        CategoryListView(
          callBack: () {
            setState(() {});
          },
        ),
      ],
    );
  }

  Widget getKhoUI() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
          child: Text(
            'Kho',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              letterSpacing: 0.27,
              color: DesignCourseAppTheme.darkerText,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 18, right: 16),
        ),
        Container(
          width: 400,
          height: 250,
          decoration: BoxDecoration(
              color: HexColor('#F8FAFB'),
              borderRadius: BorderRadius.all(Radius.circular(16))),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Icon(
                  Icons.payments,
                  color: Colors.green[400],
                ),
              ),
              Expanded(
                child: Text("Tồn kho cuối kỳ"),
              ),
              Expanded(
                child: Text(startDate.day.toString() +
                    "/" +
                    startDate.month.toString() +
                    " - " +
                    endDate.day.toString() +
                    "/" +
                    endDate.month.toString()),
              ),
              Expanded(
                child: Text(
                  formatCurrency.format(tongTien),
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              Expanded(
                child: Text(
                  "SL: " + soluong.toString(),
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  print("Chi tiết");
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(),
                      child: Text(
                        "Chi tiết",
                        style: TextStyle(color: Colors.blue[300]),
                      ),
                    ),
                    Icon(Icons.chevron_right)
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Divider(
                  color: Colors.black87,
                ),
              ),
              Row(
                children: [
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text("Tồn đầu kỳ"),
                            Text(formatCurrency.format(tondauky)),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 60,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text("Nhập trong kỳ"),
                            Text(formatCurrency.format(tiennhapky)),
                          ],
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 40,
                  ),
                  Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text("Xuất trong kỳ"),
                            Text(formatCurrency.format(tienxuatky)),
                          ],
                        ),
                      )
                    ],
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: 8, right: 8),
                child: Divider(
                  color: Colors.black87,
                ),
              ),
              Expanded(
                child: Text(
                  "Giá trị tồn kho = Số lượng * Giá vốn",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget getButtonUI(CategoryType categoryTypeData, bool isSelected) {
    String txt = '';
    if (CategoryType.ui == categoryTypeData) {
      txt = 'Ui/Ux';
    } else if (CategoryType.coding == categoryTypeData) {
      txt = 'Coding';
    } else if (CategoryType.basic == categoryTypeData) {
      txt = 'Basic UI';
    }
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
            color: isSelected
                ? DesignCourseAppTheme.nearlyBlue
                : DesignCourseAppTheme.nearlyWhite,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            border: Border.all(color: DesignCourseAppTheme.nearlyBlue)),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.white24,
            borderRadius: const BorderRadius.all(Radius.circular(24.0)),
            onTap: () {
              setState(() {
                categoryType = categoryTypeData;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(
                  top: 12, bottom: 12, left: 18, right: 18),
              child: Center(
                child: Text(
                  txt,
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                    letterSpacing: 0.27,
                    color: isSelected
                        ? DesignCourseAppTheme.nearlyWhite
                        : DesignCourseAppTheme.nearlyBlue,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getSearchBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width * 0.75,
            height: 64,
            child: Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8),
              child: Container(
                decoration: BoxDecoration(
                  color: HexColor('#F8FAFB'),
                  borderRadius: const BorderRadius.only(
                    bottomRight: Radius.circular(13.0),
                    bottomLeft: Radius.circular(13.0),
                    topLeft: Radius.circular(13.0),
                    topRight: Radius.circular(13.0),
                  ),
                ),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.only(left: 16, right: 16),
                        child: TextFormField(
                          style: TextStyle(
                            fontFamily: 'WorkSans',
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: DesignCourseAppTheme.nearlyBlue,
                          ),
                          keyboardType: TextInputType.text,
                          decoration: InputDecoration(
                            labelText: 'Search for course',
                            border: InputBorder.none,
                            helperStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: HexColor('#B9BABC'),
                            ),
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              letterSpacing: 0.2,
                              color: HexColor('#B9BABC'),
                            ),
                          ),
                          onEditingComplete: () {},
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(Icons.search, color: HexColor('#B9BABC')),
                    )
                  ],
                ),
              ),
            ),
          ),
          const Expanded(
            child: SizedBox(),
          )
        ],
      ),
    );
  }

  Widget getAppBarUI() {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 18, right: 18),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8),
            child: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: Icon(
                Icons.arrow_back,
                size: 16,
              ),
            ),
          ),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Báo cáo',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    letterSpacing: 0.2,
                    color: DesignCourseAppTheme.grey,
                  ),
                ),
                Text(
                  'Kinh doanh',
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    letterSpacing: 0.27,
                    color: DesignCourseAppTheme.darkerText,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 60,
            height: 60,
          )
        ],
      ),
    );
  }
}

enum CategoryType {
  ui,
  coding,
  basic,
}
