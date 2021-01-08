import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:quan_ly_taiducfood/main_action/custom_ui/hotel_app_theme.dart';
import 'package:quan_ly_taiducfood/main_action/models/product_detail_data.dart';
import 'package:quan_ly_taiducfood/main_action/models/product_search_data.dart';

import '../product_detail.dart';
import 'product_detail_SL.dart';

class ProductOutAmount extends StatefulWidget {
  @override
  _ProductOutAmountState createState() => _ProductOutAmountState();
}

class _ProductOutAmountState extends State<ProductOutAmount>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  List<ProductSearch> searchList = [];
  List<ProductDetail> productSearchList2 = [];
  List<ProductDetail> productSearchList3 = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);

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
        productSearchList3.clear();
        for (var sp in productSearchList2) {
          if (int.parse(sp.amount) <= 3) {
            productSearchList3.add(sp);
            print(sp.id);
          }
        }
        setState(() {});
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
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
        ),
        body: Column(
          children: [
            productSearchList3.length == 0
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
                                itemCount: productSearchList3.length,
                                itemBuilder: (_, index) {
                                  return ListUI(
                                    productSearchList3[index].id,
                                    productSearchList3[index].brand,
                                    productSearchList3[index].name,
                                    productSearchList3[index].image,
                                    productSearchList3[index].price,
                                    productSearchList3[index].barcode,
                                    productSearchList3[index].weight,
                                    productSearchList3[index].cate,
                                    productSearchList3[index].priceNhap,
                                    productSearchList3[index].priceBuon,
                                    productSearchList3[index].amount,
                                    productSearchList3[index].desc,
                                    productSearchList3[index].allowSale,
                                    productSearchList3[index].tax,
                                    productSearchList3[index].priceVon,
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

  // ignore: non_constant_identifier_names
  Widget ListUI(
      String id,
      String brand,
      String name,
      String image,
      String price,
      String barcode,
      String weight,
      String cate,
      String priceNhap,
      String priceBuon,
      String amount,
      String desc,
      String allowSale,
      String tax,
      String priceVon) {
    // ignore: non_constant_identifier_names
    double c_width = MediaQuery.of(context).size.width * 0.6;
    return GestureDetector(
      onTap: () {
        Navigator.of(context)
            .pushNamed(ProductDetailNotification.routeName, arguments: {
          "id": id,
          "brand": brand,
          "name": name,
          "image": image,
          "price": price,
          "barcode": barcode,
          "weight": weight,
          "cate": cate,
          "priceNhap": priceNhap,
          "priceBuon": priceBuon,
          "amount": amount,
          "desc": desc,
          "allowSale": allowSale,
          "tax": tax,
          "priceVon": priceVon
        });
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
}
