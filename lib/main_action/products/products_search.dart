import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quan_ly_taiducfood/main_action/custom_ui/hotel_app_theme.dart';
import 'package:quan_ly_taiducfood/main_action/models/product_detail_data.dart';
import 'package:quan_ly_taiducfood/main_action/models/product_search_data.dart';
import 'package:quan_ly_taiducfood/main_action/products/product_add.dart';

import '../../main.dart';
import 'product_detail.dart';
import 'product_out_soluong/product_out_amount.dart';

class ProductSearchScreen extends StatefulWidget {
  const ProductSearchScreen({this.app, this.animationController});
  final FirebaseApp app;
  final AnimationController animationController;
  @override
  _ProductSearchScreenState createState() => _ProductSearchScreenState();
  static const routeName = '/product-search';
}

class _ProductSearchScreenState extends State<ProductSearchScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  GlobalKey<RefreshIndicatorState> refreshKey;

  List<ProductSearch> productSearchList = [];

  List<ProductSearch> searchList = [];
  List<ProductDetail> productSearchList2 = [];
  List<ProductDetail> productSearchList3 = [];
  int slHet;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    slHet = 0;
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("SearchList");
    referenceProduct.once().then((DataSnapshot snapshot) {
      productSearchList.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;

      for (var key in keys) {
        ProductSearch product = new ProductSearch(
          values[key]["id"],
          values[key]["idMain"],
          values[key]["name"],
          values[key]["image"],
          values[key]["price"],
        );
        productSearchList.add(product);
      }
      setState(() {
        //
      });
    });
    getLocgiatri();
  }

  getLocgiatri() {
    for (int i = 1; i < 10; i++) {
      DatabaseReference referenceProduct = FirebaseDatabase.instance
          .reference()
          .child('productList')
          .child(i.toString())
          .child('Product');

      referenceProduct.once().then((DataSnapshot snapshot) {
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
          productSearchList2.add(productDetail);
        }
        slHet = 0;
        productSearchList3.clear();
        for (var sp in productSearchList2) {
          if (int.parse(sp.amount) <= 3) {
            productSearchList3.add(sp);
            slHet++;
            print(sp.id);
          }
        }
        setState(() {});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: new Scaffold(
        backgroundColor: Colors.white,
        appBar: new AppBar(
          title: new Text(
            'Sản Phẩm',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => ProductAdd()));
              },
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                child: new Stack(
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ProductOutAmount()));
                      },
                      color: Colors.white,
                    ),
                    slHet == 0
                        ? Container()
                        : new Positioned(
                            right: 10,
                            top: 11,
                            child: new Container(
                              padding: EdgeInsets.all(3),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 11,
                                minHeight: 11,
                              ),
                              child: new Text(
                                slHet.toString(),
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(left: 8, right: 8, top: 8, bottom: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0, bottom: 0),
                      child: Container(
                        decoration: BoxDecoration(
                          color:
                              HotelAppTheme.buildLightTheme().backgroundColor,
                          borderRadius: const BorderRadius.all(
                            Radius.circular(12.0),
                          ),
                          boxShadow: <BoxShadow>[
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                offset: const Offset(0, 2),
                                blurRadius: 4.0),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 16, right: 16, top: 4, bottom: 4),
                          child: TextField(
                            onChanged: (text) {
                              Search(text.toLowerCase());
                            },
                            style: const TextStyle(
                              fontSize: 18,
                            ),
                            cursorColor:
                                HotelAppTheme.buildLightTheme().primaryColor,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tên sản phẩm...',
                              icon: Icon(FontAwesomeIcons.search,
                                  size: 20, color: HexColor('#54D3C2')),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            productSearchList.length == 0
                ? Center(
                    child: Text(
                    "Không có sản phẩm",
                    style: TextStyle(fontSize: 20),
                  ))
                : Expanded(
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height - 155,
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: productSearchList.length,
                                itemBuilder: (_, index) {
                                  return ListUI(
                                    productSearchList[index].id,
                                    productSearchList[index].idMain,
                                    productSearchList[index].name,
                                    productSearchList[index].image,
                                    productSearchList[index].price,
                                  );
                                }),
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
  // RefreshIndicator(
  //         key: refreshKey,
  //         child: new
  //   onRefresh: () async {
  //     await refreshList();
  //   },
  // ),

  // ignore: non_constant_identifier_names
  Widget ListUI(
      String id, String idMain, String name, String image, String price) {
    // ignore: non_constant_identifier_names
    double c_width = MediaQuery.of(context).size.width * 0.6;
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
            arguments: {'id': id, 'idMain': idMain});
      },
      child: new Container(
        child: new Column(
          children: <Widget>[
            new Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    color: Colors.white,
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          new Container(
                            child: new Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.all(15),
                                          width: 100,
                                          height: 100,
                                          child: Image.network(image
                                                  .contains("image_picker")
                                              ? 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/' +
                                                  image +
                                                  '?alt=media&token=63435cda-cb54-4b82-bec7-08edadbb049e'
                                              : image),
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Container(
                                          width: c_width,
                                          child: new Text(
                                            "" + name.toUpperCase(),
                                            style: new TextStyle(
                                                fontSize: 14.0,
                                                color: Colors.black54,
                                                fontWeight: FontWeight.bold,
                                                fontFamily: "Roboto"),
                                          ),
                                        ),
                                      ]),
                                ]),
                            padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                            alignment: Alignment.center,
                          ),
                          new Divider(
                            color: Colors.black38,
                          ),
                        ]),
                  ),
                ]),
          ],
        ),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  void Search(String text) {
    DatabaseReference searchRef =
        FirebaseDatabase.instance.reference().child("SearchList");
    searchRef.once().then((DataSnapshot snapshot) {
      productSearchList.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;

      for (var key in keys) {
        ProductSearch product = new ProductSearch(
          values[key]["id"],
          values[key]["idMain"],
          values[key]["name"],
          values[key]["image"],
          values[key]["price"],
        );
        if (product.name.toLowerCase().contains(text)) {
          productSearchList.add(product);
        }
      }
      Timer(Duration(seconds: 1), () {
        setState(() {
          //
        });
      });
    });
  }
}
