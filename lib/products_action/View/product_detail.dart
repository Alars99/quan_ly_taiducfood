import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/format.dart';
import 'package:quan_ly_taiducfood/models/product.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_cate_data.dart';
import 'package:quan_ly_taiducfood/repositories/product_repository.dart';
import 'product_edit.dart';

class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({this.app, this.animationController, this.id});
  final FirebaseApp app;
  final AnimationController animationController;
  final String id;

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState(id);
  static const routeName = '/product-detail';
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with TickerProviderStateMixin {
  Animation<double> topBarAnimation;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  ProductCate productCate;
  List<ProductCate> data_cate = ProductCate.listProductCate;
  final String id;

  //new
  APIResponse<Product> _apiResponse;
  bool isLoading = false;
  ProductRespository service = ProductRespository();
  Product productDetailList;
  FormatCurrency formatCurrency;

  _ProductDetailScreenState(this.id);

  _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    _apiResponse = await service.getSingleProduct(id);

    setState(() {
      isLoading = false;
      productDetailList = _apiResponse.data;
    });
  }

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  void addAllListData() {
    // ignore: unused_local_variable
    const int count = 5;
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
        body: Builder(builder: (_) {
          if (isLoading) {
            return CircularProgressIndicator();
          }
          if (_apiResponse.error) {
            return Center(
              child: Text("Error"),
            );
          }
          return SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height - 81,
                    child: Column(
                      children: [
                        Expanded(
                            child: CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return productDetailUI(productDetailList);
                                },
                                childCount: 1,
                              ),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        }));
  }

  Widget productDetailUI(Product product) {
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
            child: Image.network(product.img
                    .toString()
                    .startsWith("image_picker")
                ? 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/' +
                    product.img +
                    '?alt=media&token=63435cda-cb54-4b82-bec7-08edadbb049e'
                : 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/image_picker00000.png?alt=media&token=0a7279d8-2d2e-46aa-aeee-2874a520b0fe'),
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
                          product.name.toUpperCase(),
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
                            product.id,
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
                        Text('                     :   '), //????
                        Container(
                          width: valueWidth,
                          child: Text(
                            product.categoryId,
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
                            product.barcode.toString(),
                            style: new TextStyle(
                              fontSize: 14.5,
                              fontFamily: "Roboto",
                            ),
                          ),
                        ),
                      ]),
                      SizedBox(height: 20),
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
                                    product.amout.toString(),
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
                                      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
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
                            product.price.toString(),
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
                            product.importPrice.toString(),
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
                            product.costPrice.toString(),
                            // final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
                            // final priceInt = int.parse(price.toString());
                            // formatCurrency.format(priceInt),
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
                            product.wholesalePrice.toString(),
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
                              "Apple",
                              style: new TextStyle(
                                fontSize: 14.5,
                                color: Colors.black,
                                fontFamily: "Roboto",
                              ),
                            ),
                          ]),
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
                              product.desc,
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
                          product.status.toString() == "true"
                              ? IconButton(
                                  icon:
                                      Icon(Icons.check_circle_outline_outlined),
                                  iconSize: 20,
                                  color: HexColor('#54D3C2'),
                                  onPressed: () {})
                              : IconButton(
                                  icon:
                                      Icon(Icons.check_circle_outline_outlined),
                                  iconSize: 20,
                                  color: Colors.grey,
                                  onPressed: () {}),
                          product.status.toString() == "true"
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
                          product.tax.toString() != null
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
                          product.tax.toString() != null
                              ? Text(
                                  'Đã tính thuế',
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
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductEdit(
                                    id: product.id,
                                  )));
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
                                service.deleteProduct(product);
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
}
