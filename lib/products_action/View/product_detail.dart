import 'dart:ui';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_cate_data.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_detail_data.dart';

import 'product_edit.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({this.app, this.animationController});
  final FirebaseApp app;
  final AnimationController animationController;
  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
  static const routeName = '/product-detail';
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  List<ProductDetail> productDetailList = [];

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  ProductCate productCate;
  // ignore: non_constant_identifier_names
  List<ProductCate> data_cate = <ProductCate>[
    ProductCate(1, 'Thịt Bò Úc'),
    ProductCate(2, 'Thịt Gà'),
    ProductCate(3, 'Thịt Bò Mỹ'),
    ProductCate(4, 'Thịt Cừu'),
    ProductCate(5, 'Thịt Dê'),
    ProductCate(6, 'Thịt Heo'),
    ProductCate(7, 'Thịt Trâu'),
    ProductCate(8, 'Hải Sản'),
    ProductCate(9, 'Sản Phẩm Khác'),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Map data = ModalRoute.of(context).settings.arguments;
    var productId = data['idMain'];

    DatabaseReference referenceProduct = FirebaseDatabase.instance
        .reference()
        .child('productList')
        .child(productId)
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
      setState(() {
        //
      });
    });
  }

  void addAllListData() {
    // ignore: unused_local_variable
    const int count = 5;
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 50));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        title: Text(
          'Chi Tiết Sản Phẩm',
          style: new TextStyle(fontSize: 17.0, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height - 81,
                child: Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: productDetailList.length,
                          itemBuilder: (_, index) {
                            if (productDetailList[index].brand == null) {
                              productDetailList[index].brand = '';
                            }
                            return productDetailUI(
                                productDetailList[index].id,
                                productDetailList[index].brand,
                                productDetailList[index].name,
                                productDetailList[index].image,
                                productDetailList[index].price,
                                productDetailList[index].barcode,
                                productDetailList[index].weight,
                                productDetailList[index].cate,
                                productDetailList[index].priceNhap,
                                productDetailList[index].priceBuon,
                                productDetailList[index].amount,
                                productDetailList[index].desc,
                                productDetailList[index].allowSale,
                                productDetailList[index].tax,
                                productDetailList[index].priceVon);
                          }),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {},
      //   child: Icon(Icons.delete),
      //   backgroundColor: Colors.red,
      // ),
    );
  }

  Widget productDetailUI(
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
    final Map data = ModalRoute.of(context).settings.arguments;
    final idproduct = data['id'];
    final idMain = data['idMain'];
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
    final priceInt = int.parse(price.toString());
    final priceNhapInt = int.parse(priceNhap.toString());
    final priceBuonInt = int.parse(priceBuon.toString());
    final priceVonInt = int.parse(priceVon.toString());
    final weightInt = int.parse(weight.toString());
    final amountInt = int.parse(amount.toString());
    if (id == idproduct) {
      int idMainInt = int.parse(data['idMain'].toString()) - 1;
      productCate = data_cate[idMainInt];
      double mainWidth = MediaQuery.of(context).size.width * 1;
      double valueWidth = MediaQuery.of(context).size.width * 0.5;
      return Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 330,
              child: Image.network(image.contains("image_picker")
                  ? 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/' +
                      image +
                      '?alt=media&token=63435cda-cb54-4b82-bec7-08edadbb049e'
                  : image),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: new Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14.5),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: mainWidth,
                          child: new Text(
                            name.toUpperCase(),
                            style: new TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Roboto"),
                          ),
                        ),
                        SizedBox(height: 20),
                        new Row(children: <Widget>[
                          Text(
                            "Mã sản phẩm",
                            style: new TextStyle(
                              fontSize: 14.5,
                              color: Colors.black54,
                              fontFamily: "Roboto",
                            ),
                          ),
                          Text('     :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              id,
                              style: new TextStyle(
                                fontSize: 14.5,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        new Row(children: <Widget>[
                          Text(
                            "Hiệu",
                            style: new TextStyle(
                                fontSize: 14.5,
                                color: Colors.black54,
                                fontFamily: "Roboto"),
                          ),
                          Text('                     :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              brand,
                              style: new TextStyle(
                                  fontSize: 14.5, fontFamily: "Roboto"),
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        new Row(children: <Widget>[
                          Text(
                            "Barcode",
                            style: new TextStyle(
                              fontSize: 14.5,
                              color: Colors.black54,
                              fontFamily: "Roboto",
                            ),
                          ),
                          Text('               :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              barcode,
                              style: new TextStyle(
                                fontSize: 14.5,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        new Row(children: <Widget>[
                          Text(
                            "Khối lượng",
                            style: new TextStyle(
                              fontSize: 14.5,
                              color: Colors.black54,
                              fontFamily: "Roboto",
                            ),
                          ),
                          Text('           :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              weightInt.toString() + 'g',
                              style: new TextStyle(
                                fontSize: 14.5,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ]),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: new Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14.5),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Text(
                                "Tồn kho",
                                style: new TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                  fontFamily: "Roboto",
                                ),
                              ),
                              new Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Text(
                                      amountInt.toString(),
                                      style: new TextStyle(
                                        fontSize: 16,
                                        fontFamily: "Roboto",
                                      ),
                                    ),
                                    IconButton(
                                        icon: Icon(Icons.edit_road_rounded),
                                        color: HexColor('#54D3C2'),
                                        iconSize: 25,
                                        alignment: Alignment.topRight,
                                        padding:
                                            EdgeInsets.fromLTRB(0, 0, 0, 0),
                                        onPressed: () {}),
                                  ]),
                            ]),
                        new Row(children: <Widget>[
                          Text(
                            "Giá",
                            style: new TextStyle(
                              fontSize: 14.5,
                              color: Colors.black54,
                              fontFamily: "Roboto",
                            ),
                          ),
                          Text('                       :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              formatCurrency.format(priceInt),
                              style: new TextStyle(
                                fontSize: 16,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        new Row(children: <Widget>[
                          Text(
                            "Giá Nhập",
                            style: new TextStyle(
                              fontSize: 14.5,
                              color: Colors.black54,
                              fontFamily: "Roboto",
                            ),
                          ),
                          Text('            :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              formatCurrency.format(priceNhapInt),
                              style: new TextStyle(
                                fontSize: 16,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        new Row(children: <Widget>[
                          Text(
                            "Giá Bán Buôn",
                            style: new TextStyle(
                              fontSize: 14.5,
                              color: Colors.black54,
                              fontFamily: "Roboto",
                            ),
                          ),
                          Text('    :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              formatCurrency.format(priceBuonInt),
                              style: new TextStyle(
                                fontSize: 16,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ]),
                        SizedBox(height: 20),
                        new Row(children: <Widget>[
                          Text(
                            "Giá Vốn",
                            style: new TextStyle(
                              fontSize: 14.5,
                              color: Colors.black54,
                              fontFamily: "Roboto",
                            ),
                          ),
                          Text('               :   '),
                          Container(
                            width: valueWidth,
                            child: Text(
                              formatCurrency.format(priceVonInt),
                              style: new TextStyle(
                                fontSize: 16,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ),
                        ]),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: new Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14.5),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(children: <Widget>[
                          Text(
                            "Thông tin thêm",
                            style: new TextStyle(
                              fontSize: 16.5,
                              color: Colors.black,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ]),
                        Divider(),
                        SizedBox(height: 10),
                        new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Loại sản phẩm",
                                style: new TextStyle(
                                  fontSize: 14.5,
                                  color: Colors.black54,
                                  fontFamily: "Roboto",
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                "${productCate.name}",
                                style: new TextStyle(
                                  fontSize: 14.5,
                                  color: Colors.black,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ]),
                        SizedBox(height: 10),
                        Divider(),
                        SizedBox(height: 10),
                        new Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Mô tả",
                                style: new TextStyle(
                                  fontSize: 14.5,
                                  color: Colors.black54,
                                  fontFamily: "Roboto",
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                desc,
                                style: new TextStyle(
                                  fontSize: 14.5,
                                  color: Colors.black,
                                  fontFamily: "Roboto",
                                ),
                              ),
                            ]),
                        Divider(),
                        new Row(
                          children: [
                            allowSale.toString() == "true"
                                ? IconButton(
                                    icon: Icon(
                                        Icons.check_circle_outline_outlined),
                                    iconSize: 20,
                                    color: HexColor('#54D3C2'),
                                    onPressed: () {})
                                : IconButton(
                                    icon: Icon(
                                        Icons.check_circle_outline_outlined),
                                    iconSize: 20,
                                    color: Colors.grey,
                                    onPressed: () {}),
                            allowSale.toString() == "true"
                                ? Text('Cho phép bán!',
                                    style: new TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontFamily: "Roboto"))
                                : Text(
                                    'Không cho phép bán!',
                                    style: new TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontFamily: "Roboto"),
                                  ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(7.0),
              child: new Card(
                clipBehavior: Clip.antiAlias,
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(14.5),
                  child: new Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        new Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            tax.toString() == "true"
                                ? IconButton(
                                    icon: Icon(Icons.circle),
                                    color: HexColor('#54D3C2'),
                                    iconSize: 20,
                                    onPressed: () {})
                                : IconButton(
                                    icon: Icon(Icons.circle),
                                    color: Colors.grey,
                                    iconSize: 20,
                                    onPressed: () {}),
                            tax.toString() == "true"
                                ? Text(
                                    'Có tính thuế',
                                    style: new TextStyle(
                                        fontSize: 17,
                                        color: Colors.black,
                                        fontFamily: "Roboto"),
                                  )
                                : Text(
                                    'Không tính thuế',
                                    style: new TextStyle(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontFamily: "Roboto"),
                                  ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(7, 7, 7, 17),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    child: FlatButton(
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed(ProductEdit.routeName, arguments: {
                          'id': id,
                          'brand': brand,
                          'name': name,
                          'image': image,
                          'price': price,
                          'idMain': idMain,
                          'barcode': barcode,
                          'weight': weight,
                          'cate': cate,
                          'priceNhap': priceNhap,
                          'priceBuon': priceBuon,
                          'amount': amount,
                          'desc': desc,
                          'allowSale': allowSale,
                          'tax': tax,
                          'priceVon': priceVon
                        });
                      },
                      color: HexColor('#54D3C2'),
                      // ignore: missing_required_param
                      child: new IconButton(
                        icon: new Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: 50,
                    child: FlatButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (context) => AlertDialog(
                            title: Text("Chắc xóa không?"),
                            actions: <Widget>[
                              FlatButton(
                                onPressed: () {
                                  delete();
                                  deleteSearchList();
                                  Fluttertoast.showToast(
                                      msg: "Xóa sản phẩm thành công",
                                      toastLength: Toast.LENGTH_SHORT,
                                      gravity: ToastGravity.BOTTOM,
                                      timeInSecForIosWeb: 1,
                                      textColor: Colors.black87,
                                      fontSize: 16.0);
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text("Có"),
                              ),
                              FlatButton(
                                onPressed: () {
                                  Navigator.of(context).pop("Không");
                                },
                                child: Text("Không"),
                              ),
                            ],
                          ),
                        );
                      },
                      color: Colors.red,
                      // ignore: missing_required_param
                      child: new IconButton(
                        icon: new Icon(
                          Icons.delete,
                          color: Colors.white,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      );
    }
    return Container();
  }

  Future<void> delete() async {
    final Map data = ModalRoute.of(context).settings.arguments;
    final idFood = data['id'];
    final idFoodMain = data['idMain'];
    DatabaseReference referenceList = FirebaseDatabase.instance
        .reference()
        .child('productList')
        .child(idFoodMain)
        .child('Product');

    referenceList.child(idFood).remove();
  }

  Future<void> deleteSearchList() async {
    final Map data = ModalRoute.of(context).settings.arguments;
    final idFood = data['id'];
    DatabaseReference referenceList =
        FirebaseDatabase.instance.reference().child('SearchList');

    referenceList.child(idFood).remove();
  }

  // Future<void> edit() async {
  //   final Map data = ModalRoute.of(context).settings.arguments;
  //   String _controllerAmountString;
  //   String idFood = productCate.id.toString();
  //   final idFoodMain = data['idMain'];
  //   if (formKey.currentState.validate()) {
  //     DatabaseReference referenceList = FirebaseDatabase.instance
  //         .reference()
  //         .child('productList')
  //         .child(idFood)
  //         .child('Product');

  //     _controllerAmountString =
  //         _controllerAmount.text.toString().replaceAll(",", "");

  //     referenceList.child(idFoodMain).update({
  //       "amount": _controllerAmountString.toString(),
  //     });
  //   }
  // }
}
