import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/products_action/View/product_edit.dart';

class ProductDetailNotification extends StatefulWidget {
  @override
  _ProductDetailNotificationState createState() =>
      _ProductDetailNotificationState();
  static const routeName = '/product-detail-notifi';
}

class _ProductDetailNotificationState extends State<ProductDetailNotification>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;

  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;

  // ProductCate productCate;
  // // ignore: non_constant_identifier_names
  // List<ProductCate> data_cate = <ProductCate>[
  //   ProductCate(1, 'Thịt Bò Úc'),
  //   ProductCate(2, 'Thịt Gà'),
  //   ProductCate(3, 'Thịt Bò Mỹ'),
  //   ProductCate(4, 'Thịt Cừu'),
  //   ProductCate(5, 'Thịt Dê'),
  //   ProductCate(6, 'Thịt Heo'),
  //   ProductCate(7, 'Thịt Trâu'),
  //   ProductCate(8, 'Hải Sản'),
  //   ProductCate(9, 'Sản Phẩm Khác'),
  // ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

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
                      child: productDetailUI(),
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

  Widget productDetailUI() {
    final Map data = ModalRoute.of(context).settings.arguments;
    if (data['brand'] == null) {
      data['brand'] = " ";
    }
    final formatCurrency = new NumberFormat.simpleCurrency(locale: 'vi');
    final priceInt = int.parse(data['price'].toString());
    final priceNhapInt = int.parse(data['priceNhap'].toString());
    final priceBuonInt = int.parse(data['priceBuon'].toString());
    final priceVonInt = int.parse(data['priceVon'].toString());
    final weightInt = int.parse(data['weight'].toString());
    final amountInt = int.parse(data['amount'].toString());

    // int idMainInt = int.parse(data['idMain'].toString()) - 1;
    // productCate = data_cate[idMainInt];
    double mainWidth = MediaQuery.of(context).size.width * 1;
    double valueWidth = MediaQuery.of(context).size.width * 0.5;
    return SingleChildScrollView(
      child: Container(
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              width: 330,
              child: Image.network(data['image'].contains("image_picker")
                  ? 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/' +
                      data['image'] +
                      '?alt=media&token=63435cda-cb54-4b82-bec7-08edadbb049e'
                  : data['image']),
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
                            data['name'].toUpperCase(),
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
                              data['id'],
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
                              data['brand'],
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
                              data['barcode'],
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
                        // Divider(),
                        // SizedBox(height: 10),
                        // new Column(
                        //     crossAxisAlignment: CrossAxisAlignment.start,
                        //     mainAxisAlignment: MainAxisAlignment.start,
                        //     children: <Widget>[
                        //       Text(
                        //         "Loại sản phẩm",
                        //         style: new TextStyle(
                        //           fontSize: 14.5,
                        //           color: Colors.black54,
                        //           fontFamily: "Roboto",
                        //         ),
                        //       ),
                        //       SizedBox(height: 20),
                        //       Text(
                        //         "${productCate.name}",
                        //         style: new TextStyle(
                        //           fontSize: 14.5,
                        //           color: Colors.black,
                        //           fontFamily: "Roboto",
                        //         ),
                        //       ),
                        //     ]),
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
                                data['desc'],
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
                            data['allowSale'].toString() == "true"
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
                            data['allowSale'].toString() == "true"
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
                            data['tax'].toString() == "true"
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
                            data['tax'].toString() == "true"
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
                          'id': data['id'],
                          'brand': data['brand'],
                          'name': data['name'],
                          'image': data['image'],
                          'price': data['price'],
                          'idMain': data['idMain'],
                          'barcode': data['barcode'],
                          'weight': data['weight'],
                          'cate': data['cate'],
                          'priceNhap': data['priceNhap'],
                          'priceBuon': data['priceBuon'],
                          'amount': data['amount'],
                          'desc': data['desc'],
                          'allowSale': data['allowSale'],
                          'tax': data['tax'],
                          'priceVon': data['priceVon']
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
      ),
    );
  }

  Future<void> delete() async {
    final Map data = ModalRoute.of(context).settings.arguments;
    final idFood = data['id'];
    for (int i = 1; i < 10; i++) {
      DatabaseReference referenceList = FirebaseDatabase.instance
          .reference()
          .child('productList')
          .child(i.toString())
          .child('Product');
      referenceList.once().then((DataSnapshot snapshot) {
        var keys = snapshot.value.keys;

        for (var key in keys) {
          if (key == idFood) {
            referenceList.child(idFood).remove();
          }
        }
      });
    }
  }

  Future<void> deleteSearchList() async {
    final Map data = ModalRoute.of(context).settings.arguments;
    final idFood = data['id'];
    DatabaseReference referenceList =
        FirebaseDatabase.instance.reference().child('SearchList');

    referenceList.child(idFood).remove();
  }
}
