import 'package:quan_ly_taiducfood/main_action/theme/home_theme.dart';
import 'package:quan_ly_taiducfood/main_action/models/title_screen.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/products_action/View/product_add.dart';
import 'package:quan_ly_taiducfood/products_action/View/products_search.dart';
import 'package:quan_ly_taiducfood/order_action/View/Order/order_list_screen.dart';
import 'package:quan_ly_taiducfood/nhaphang_action/view/tao_don_nhap_hang.dart';
import 'package:quan_ly_taiducfood/customer_action/view/customer_screen.dart';

import '../../order_action/View/Order/order_screen.dart';

class ListSubScreen extends StatefulWidget {
  const ListSubScreen(
      {Key key, this.mainScreenAnimationController, this.mainScreenAnimation})
      : super(key: key);

  final AnimationController mainScreenAnimationController;
  final Animation<dynamic> mainScreenAnimation;

  @override
  _ListSubScreenState createState() => _ListSubScreenState();
}

class _ListSubScreenState extends State<ListSubScreen>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List<MealsListData> mealsListData = MealsListData.tabIconsList;

  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.mainScreenAnimationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: widget.mainScreenAnimation,
          child: Transform(
            transform: Matrix4.translationValues(
                0.0, 30 * (1.0 - widget.mainScreenAnimation.value), 0.0),
            child: Container(
              height: 108,
              width: double.infinity,
              child: ListView.builder(
                padding: const EdgeInsets.only(
                    top: 0, bottom: 0, right: 16, left: 16),
                itemCount: mealsListData.length,
                scrollDirection: Axis.horizontal,
                itemBuilder: (BuildContext context, int index) {
                  final int count =
                      mealsListData.length > 10 ? 10 : mealsListData.length;
                  final Animation<double> animation =
                      Tween<double>(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animationController,
                              curve: Interval((1 / count) * index, 1.0,
                                  curve: Curves.fastOutSlowIn)));
                  animationController.forward();

                  return MealsView(
                    mealsListData: mealsListData[index],
                    animation: animation,
                    animationController: animationController,
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}

class MealsView extends StatelessWidget {
  const MealsView(
      {Key key, this.mealsListData, this.animationController, this.animation})
      : super(key: key);

  final MealsListData mealsListData;
  final AnimationController animationController;
  final Animation<dynamic> animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return FadeTransition(
          opacity: animation,
          child: Transform(
            transform: Matrix4.translationValues(
                100 * (1.0 - animation.value), 0.0, 0.0),
            child: SizedBox(
              width: 60,
              child: Stack(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        color: HomeTheme.nearlyWhite.withOpacity(1),
                        shape: BoxShape.circle,
                      ),
                      child: InkWell(
                        splashColor: HomeTheme.white.withOpacity(0.1),
                        highlightColor: HomeTheme.grey,
                        focusColor: HomeTheme.grey,
                        onTap: () {
                          if (mealsListData.uiId == 0) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderScreen()));
                          }
                          if (mealsListData.uiId == 1) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ProductAdd()));
                          }
                          if (mealsListData.uiId == 2) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => NhapHangScreen()));
                          }
                          if (mealsListData.uiId == 3) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => OrderListScreen()));
                          }
                          if (mealsListData.uiId == 4) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ProductSearchScreen()));
                          }
                          if (mealsListData.uiId == 5) {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CustomerScreen()));
                          }
                        },
                        child: Center(
                          child: Image.asset(
                            mealsListData.imagePath,
                            height: 32.0,
                            width: 32.0,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 64),
                    child: Text(
                      mealsListData.titleTxt,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: HomeTheme.fontName,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: HomeTheme.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
