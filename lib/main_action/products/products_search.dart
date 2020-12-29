import 'dart:async';
import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_image/network.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:quan_ly_taiducfood/main_action/custom_ui/hotel_app_theme.dart';
import 'package:quan_ly_taiducfood/main_action/models/product_search_data.dart';
import 'package:quan_ly_taiducfood/main_action/products/product_add.dart';

import 'product_detail.dart';

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

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  @override
  void initState() {
    super.initState();
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
    print(productSearchList.length);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      backgroundColor: Colors.white,
      appBar: new AppBar(
        title: new Text('Sản Phẩm'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (context) => ProductAdd()));
            },
            color: Colors.white,
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
                        color: HotelAppTheme.buildLightTheme().backgroundColor,
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
                                size: 20, color: Colors.purple),
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
              : Container(
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
        ],
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

  Widget ListUI(
      String id, String idMain, String name, String image, String price) {
    bool _validURL = Uri.parse(image).isAbsolute;
    if (_validURL != true) {
      Future downdloadImage() async {
        await Firebase.initializeApp();
        Reference imgReference = FirebaseStorage.instance.ref().child(image);
        Future<String> downloadImg =
            (await imgReference.getDownloadURL()) as Future<String>;
        setState(() {
          image = downloadImg as String;
          print(image);
        });
      }
    }

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
                                          child: Image(
                                            image: new NetworkImageWithRetry(
                                                image),
                                            fit: BoxFit.fill,
                                          ),
                                          // new Image(
                                          //   image: new NetworkImageWithRetry(
                                          //       image),
                                          //   fit: BoxFit.fill,
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
