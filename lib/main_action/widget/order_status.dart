import 'package:firebase_database/firebase_database.dart';
import 'package:quan_ly_taiducfood/main_action/theme/home_theme.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_list_screen.dart';

final db = FirebaseDatabase.instance.reference().child("productList");

class OrderStatus extends StatelessWidget {
  const OrderStatus(
      {Key key,
      this.animationController,
      this.animation,
      this.donchuaduyet,
      this.chothanhtoan,
      this.choxuatkho,
      this.danggiaohang})
      : super(key: key);
  final AnimationController animationController;
  final Animation animation;
  final int donchuaduyet;
  final int chothanhtoan;
  final int choxuatkho;
  final int danggiaohang;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
        animation: animationController,
        builder: (BuildContext context, Widget child) {
          return FadeTransition(
            opacity: animation,
            child: new Transform(
              transform: new Matrix4.translationValues(
                  0.0, 30 * (1.0 - animation.value), 0.0),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 24, right: 24, top: 16, bottom: 16),
                child: Container(
                  decoration: BoxDecoration(
                    color: HomeTheme.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0),
                        topRight: Radius.circular(8.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                          color: HomeTheme.grey.withOpacity(0.2),
                          offset: Offset(1.1, 1.1),
                          blurRadius: 10.0),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => OrderListScreen()));
                    },
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Chưa duyệt",
                                      style: TextStyle(
                                          fontFamily: HomeTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              HomeTheme.grey.withOpacity(0.8),
                                          fontSize: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        donchuaduyet.toString(),
                                        style: TextStyle(
                                            fontFamily: HomeTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Chờ thanh toán",
                                      style: TextStyle(
                                          fontFamily: HomeTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              HomeTheme.grey.withOpacity(0.8),
                                          fontSize: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        chothanhtoan.toString(),
                                        style: TextStyle(
                                            fontFamily: HomeTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Chờ xuất kho",
                                      style: TextStyle(
                                          fontFamily: HomeTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              HomeTheme.grey.withOpacity(0.8),
                                          fontSize: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        choxuatkho.toString(),
                                        style: TextStyle(
                                            fontFamily: HomeTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  children: [
                                    Text(
                                      "Đang giao hàng",
                                      style: TextStyle(
                                          fontFamily: HomeTheme.fontName,
                                          fontWeight: FontWeight.w500,
                                          color:
                                              HomeTheme.grey.withOpacity(0.8),
                                          fontSize: 12),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.only(top: 8),
                                      child: Text(
                                        danggiaohang.toString(),
                                        style: TextStyle(
                                            fontFamily: HomeTheme.fontName,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }
}
