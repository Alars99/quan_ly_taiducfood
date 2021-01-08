import 'package:flutter/material.dart';
import 'dart:io';
import 'package:quan_ly_taiducfood/app_theme.dart';
import 'package:flutter/services.dart';
import 'package:quan_ly_taiducfood/customer_action/history_customer.dart';
import 'package:quan_ly_taiducfood/login_action/Login/login_screen.dart';
import 'package:quan_ly_taiducfood/login_action/Signup/signup_screen.dart';
import 'package:quan_ly_taiducfood/main_action/fitness_app_home_screen.dart';
import 'package:quan_ly_taiducfood/main_action/products/product_out_soluong/product_detail_SL.dart';
import 'package:quan_ly_taiducfood/main_action/products/products_search.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_detail_screen.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_list_screen.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_screen.dart';
import 'main_action/products/product_detail.dart';
import 'main_action/products/product_edit.dart';
import 'statistical_action/View/donhang_in_a_day.dart';

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
        home: FitnessAppHomeScreen(),
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
        });
  }
}

// class MyApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
//       statusBarColor: Colors.transparent,
//       statusBarIconBrightness: Brightness.dark,
//       statusBarBrightness: Platform.isAndroid ? Brightness.dark : Brightness.light,
//       systemNavigationBarColor: Colors.white,
//       systemNavigationBarDividerColor: Colors.grey,
//       systemNavigationBarIconBrightness: Brightness.dark,
//     ));
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         textTheme: AppTheme.textTheme,
//         platform: TargetPlatform.iOS,
//       ),
//       home: NavigationHomeScreen(),
//     );
//   }
// }

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
