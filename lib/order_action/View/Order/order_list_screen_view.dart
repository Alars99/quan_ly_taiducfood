// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:quan_ly_taiducfood/order_action/model/order_list.dart';
// import 'order_detail_screen.dart';
// import 'order_theme.dart';

// class OrderListScreenView extends StatelessWidget {
//   const OrderListScreenView({
//     Key key,
//     this.orderList,
//     this.animationController,
//     this.animation,
//     this.callback,
//     this.removeItem,
//   }) : super(key: key);
//   static String nameStatus = "";
//   getStatus(String id) {
//     if (id == "0") {
//       nameStatus = "Chưa giao hàng";
//     }
//   }

//   final VoidCallback callback;
//   final VoidCallback removeItem;
//   final OrderList orderList;
//   final AnimationController animationController;
//   final Animation<dynamic> animation;

//   @override
//   Widget build(BuildContext context) {
//     final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
//     int tongthInt = double.parse(orderList.tongTienhang).round();
//     getStatus(orderList.trangthai);
//     return AnimatedBuilder(
//       animation: animationController,
//       builder: (BuildContext context, Widget child) {
//         return FadeTransition(
//           opacity: animation,
//           child: Transform(
//             transform: Matrix4.translationValues(
//                 0.0, 50 * (1.0 - animation.value), 0.0),
//             child: Padding(
//               padding: const EdgeInsets.only(
//                   left: 24, right: 24, top: 8, bottom: 16),
//               child: InkWell(
//                 splashColor: Colors.transparent,
//                 onTap: () {
//                   Navigator.of(context)
//                       .pushNamed(OrderDetailScreen.routeName, arguments: {
//                     'idGioHang': orderList.idGioHang,
//                     'idDonHang': orderList.idDonHang,
//                     'banSiLe': orderList.banSiLe,
//                     'chietKhau': orderList.chietKhau,
//                     'idKhachHang': orderList.idKhachHang,
//                     'ngaymua': orderList.ngaymua,
//                     'paymethod': orderList.paymethod,
//                     'phiGiaohang': orderList.phiGiaohang,
//                     'trangthai': orderList.trangthai,
//                     'tongSoluong': orderList.tongSoluong,
//                     'tongTienhang': orderList.tongTienhang,
//                   });
//                 },
//                 child: Container(
//                   decoration: BoxDecoration(
//                     borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//                     boxShadow: <BoxShadow>[
//                       BoxShadow(
//                         color: Colors.grey.withOpacity(0.6),
//                         offset: const Offset(4, 4),
//                         blurRadius: 16,
//                       ),
//                     ],
//                   ),
//                   child: ClipRRect(
//                     borderRadius: const BorderRadius.all(Radius.circular(16.0)),
//                     child: Stack(
//                       children: <Widget>[
//                         Column(
//                           children: <Widget>[
//                             Container(
//                               color: OrderAppTheme.buildLightTheme()
//                                   .backgroundColor,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: <Widget>[
//                                   Expanded(
//                                     child: Container(
//                                       child: Padding(
//                                         padding: const EdgeInsets.only(
//                                             left: 16, top: 15, bottom: 8),
//                                         child: Column(
//                                           mainAxisAlignment:
//                                               MainAxisAlignment.center,
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: <Widget>[
//                                             Text(
//                                               "Mã: " + orderList.idDonHang,
//                                               textAlign: TextAlign.left,
//                                               style: TextStyle(
//                                                 fontWeight: FontWeight.w600,
//                                                 fontSize: 13,
//                                               ),
//                                             ),
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Padding(
//                                                   padding: EdgeInsets.only(
//                                                       top: 8, bottom: 8),
//                                                   child: Text(
//                                                     orderList.idKhachHang
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         fontSize: 11,
//                                                         color: Colors.black54),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 4,
//                                                 ),
//                                               ],
//                                             ),
//                                             Row(
//                                               crossAxisAlignment:
//                                                   CrossAxisAlignment.center,
//                                               mainAxisAlignment:
//                                                   MainAxisAlignment.start,
//                                               children: <Widget>[
//                                                 Padding(
//                                                   padding:
//                                                       EdgeInsets.only(top: 8),
//                                                   child: Text(
//                                                     orderList.ngaymua
//                                                         .toString(),
//                                                     style: TextStyle(
//                                                         fontSize: 14,
//                                                         color: Colors.black
//                                                             .withOpacity(1)),
//                                                   ),
//                                                 ),
//                                                 const SizedBox(
//                                                   width: 4,
//                                                 ),
//                                               ],
//                                             ),
//                                             Padding(
//                                               padding:
//                                                   const EdgeInsets.only(top: 4),
//                                               // them phan so luong
//                                             ),
//                                           ],
//                                         ),
//                                       ),
//                                     ),
//                                   ),
//                                   Column(
//                                     children: <Widget>[
//                                       Padding(
//                                         padding: EdgeInsets.only(top: 8),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.all(10),
//                                         child: Text(
//                                           formatCurrency.format(tongthInt),
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             fontSize: 16,
//                                           ),
//                                         ),
//                                       ),
//                                       Padding(
//                                         padding: EdgeInsets.all(10),
//                                         child: Text(
//                                           nameStatus,
//                                           textAlign: TextAlign.center,
//                                           style: TextStyle(
//                                             fontWeight: FontWeight.bold,
//                                             color: Colors.red[400],
//                                             fontSize: 14,
//                                           ),
//                                         ),
//                                       )
//                                     ],
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         );
//       },
//     );
  
//   }
// }
