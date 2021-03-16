import 'package:flutter/material.dart';
import 'dart:io';
import 'package:quan_ly_taiducfood/nhaphang_action/theme/nhaphang_theme.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_taiducfood/customer_action/view/history_customer.dart';
import 'package:quan_ly_taiducfood/main_action/widget/home_widget.dart';
import 'package:quan_ly_taiducfood/products_action/View/product_out_soluong/product_detail_SL.dart';
import 'package:quan_ly_taiducfood/products_action/View/products_search.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_detail_screen.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_list_screen.dart';
import 'products_action/View/product_detail.dart';
import 'products_action/View/product_edit.dart';
import 'statistical_action/View/bao_cao_chi_tiet/loi_nhuan_in_a_day.dart';
import 'statistical_action/View/bao_cao_chi_tiet/doanh_thu_in_a_day.dart';
import 'statistical_action/View/bao_cao_chi_tiet/thanh_toan_in_a_day.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) => runApp(MyApp()));
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          Platform.isAndroid ? Brightness.dark : Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarDividerColor: Colors.grey,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Quản Lý Bán Hàng TaiDucFood',
        theme: ThemeData(
          primaryColor: HexColor('#54D3C2'),
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: Colors.blue,
          textTheme: AppTheme.textTheme,
          platform: TargetPlatform.iOS,
        ),
        home: HomeWidget(),
        routes: {
          ProductDetailScreen.routeName: (ctxPD) => ProductDetailScreen(),
          ProductEdit.routeName: (ctxPE) => ProductEdit(),
          ProductSearchScreen.routeName: (ctxPS) => ProductSearchScreen(),
          OrderListScreen.routeName: (ctxOLS) => OrderListScreen(),
          OrderDetailScreen.routeName: (ctxODS) => OrderDetailScreen(),
          HistoryCustomer.routeName: (ctxHC) => HistoryCustomer(),
          DonhangInADay.routeName: (ctxDIAD) => DonhangInADay(),
          ProductDetailNotification.routeName: (ctxPDN) =>
              ProductDetailNotification(),
          DonhangInADay1.routeName: (ctxDIADA) => DonhangInADay1(),
          DonhangInADay2.routeName: (ctxDIADB) => DonhangInADay2(),
        });
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
