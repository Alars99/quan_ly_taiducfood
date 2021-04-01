import 'dart:io';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_taiducfood/main.dart';
import 'package:quan_ly_taiducfood/models/product.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_cate_data.dart';
import 'package:quan_ly_taiducfood/repositories/product_repository.dart';

class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  Product _product = Product();
  bool tax = false;
  String _data = "";
  File _image;
  String fileName;
  final datetime = DateTime.now();

  var formKey = GlobalKey<FormState>();
  final _controllerAmount = MoneyMaskedTextController(
      precision: 0, decimalSeparator: '', thousandSeparator: ',');
  final _controllerWeight = MoneyMaskedTextController(
      precision: 0, decimalSeparator: '', thousandSeparator: ',');
  final _controllerPriceVon = MoneyMaskedTextController(
      precision: 0, decimalSeparator: '', thousandSeparator: ',');
  final _controllerPrice = MoneyMaskedTextController(
      precision: 0, decimalSeparator: '', thousandSeparator: ',');
  final _controllerPriceNhap = MoneyMaskedTextController(
      precision: 0, decimalSeparator: '', thousandSeparator: ',');
  final _controllerPriceBuon = MoneyMaskedTextController(
      precision: 0, decimalSeparator: '', thousandSeparator: ',');

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FF0000", "Cancel", true, ScanMode.DEFAULT)
        .then((value) => setState(() => {
              if (value == "-1") {_data = '0'} else {_data = value}
            }));
    print(_data);
  }

  ProductCate productCate;
  List<ProductCate> dataCate = ProductCate.listProductCate;
  ProductRespository service = ProductRespository();

  String createID(String category) {
    int number = Random().nextInt(1000000000);
    String id = category + number.toString();
    return id;
  }

  @override
  void initState() {
    super.initState();
    productCate = dataCate[0];
  }

  @override
  Widget build(BuildContext context) {
    Future getImage() async {
      // ignore: deprecated_member_use
      var image = await ImagePicker.pickImage(source: ImageSource.gallery);
      setState(() {
        _image = image;
        print(_image);
      });
    }

    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          'Thêm sản phẩm',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
        // actions: [
        //   IconButton(
        //     icon: Icon(Icons.check),
        //     onPressed: () {},
        //     color: Colors.white,
        //   ),
        // ],
      ),
      body: Form(
        key: formKey,
        child: SingleChildScrollView(
          child: Container(
            height: 1000,
            padding: EdgeInsets.only(top: 0),
            child: Column(
              children: [
                new Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(0),
                    child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              getImage();
                            },
                            child: Container(
                              width: 200,
                              height: 150,
                              child: (_image != null)
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    )
                                  : Image.network(
                                      "https://nameproscdn.com/a/2018/05/106343_82907bfea9fe97e84861e2ee7c5b4f5b.png",
                                      fit: BoxFit.fill,
                                    ),
                            ),
                          ),
                        ]),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: new Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            new TextFormField(
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Chưa nhập Tên sản phẩm';
                                } else {
                                  _product.name = value;
                                }
                              },
                              autocorrect: true,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                labelText: 'Tên sản phẩm',
                              ),
                            ),
                            new TextFormField(
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Chưa nhập Barcode sản phẩm';
                                  } else {
                                    _product.barcode = int.parse(value);
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                key: Key(_data), // <- Magic!
                                initialValue: _data,

                                //onChanged: (text) {},
                                autocorrect: true,
                                decoration: InputDecoration(
                                  labelText: 'Barcode',
                                  suffixIcon: IconButton(
                                      autofocus: false,
                                      onPressed: () => _scan(),
                                      icon:
                                          Icon(Icons.qr_code_scanner_outlined)),
                                )),
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: new Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 140,
                                  child: new TextFormField(
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty || value == '0') {
                                        return 'Chưa nhập Tồn kho sản phẩm';
                                      } else {
                                        _product.amout = int.parse(value);
                                      }
                                    },
                                    controller: _controllerAmount,
                                    decoration: InputDecoration(
                                      labelText: 'Tồn kho',
                                    ),
                                    keyboardType: TextInputType.number,
                                    autocorrect: true,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  child: new TextFormField(
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty || value == '0') {
                                        return 'Chưa nhập Giá vốn sản phẩm';
                                      } else {
                                        _product.wholesalePrice =
                                            _controllerPriceVon.numberValue
                                                .toDouble();
                                      }
                                    },
                                    controller: _controllerPriceVon,
                                    autocorrect: true,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    decoration: InputDecoration(
                                      labelText: 'Giá vốn',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 140,
                                  child: new TextFormField(
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty || value == '0') {
                                        return 'Chưa nhập Giá bán lẻ sản phẩm';
                                      } else {
                                        _product.price = _controllerPrice
                                            .numberValue
                                            .toDouble();
                                      }
                                    },
                                    controller: _controllerPrice,
                                    decoration: InputDecoration(
                                      labelText: 'Giá bán lẻ',
                                    ),
                                    keyboardType: TextInputType.number,
                                    autocorrect: true,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                  ),
                                ),
                                Container(
                                  width: 140,
                                  child: new TextFormField(
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty || value == '0') {
                                        return 'Chưa nhập Giá bán buôn sản phẩm';
                                      } else {
                                        _product.costPrice =
                                            _controllerPriceBuon.numberValue
                                                .toDouble();
                                      }
                                    },
                                    controller: _controllerPriceBuon,
                                    autocorrect: true,
                                    keyboardType: TextInputType.number,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    decoration: InputDecoration(
                                      labelText: 'Giá bán buôn',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              child: new TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty || value == '0') {
                                    return 'Chưa nhập Giá nhập sản phẩm';
                                  } else {
                                    _product.importPrice = _controllerPriceNhap
                                        .numberValue
                                        .toDouble();
                                  }
                                },
                                controller: _controllerPriceNhap,
                                autocorrect: true,
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),
                                decoration: InputDecoration(
                                  labelText: 'Giá nhập',
                                ),
                              ),
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Container(
                                    child: new Text(
                                  'Áp dụng thuế',
                                  style: new TextStyle(fontSize: 17),
                                )),
                                Container(
                                    child: new Switch(
                                        activeColor: HexColor('#54D3C2'),
                                        value: tax,
                                        onChanged: (bool s) {
                                          setState(() {
                                            tax = s;
                                            print(tax);
                                          });
                                        }))
                              ],
                            )
                          ]),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(7.0),
                  child: new Card(
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            new Text('Loại sản phẩm'),
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: Row(
                                children: [
                                  new DropdownButton<ProductCate>(
                                    value: productCate,
                                    onChanged: (ProductCate newValue) {
                                      setState(() {
                                        productCate = newValue;
                                        _product.categoryId =
                                            productCate.categoryId;
                                      });
                                    },
                                    items: dataCate.map((ProductCate pdCate) {
                                      return new DropdownMenuItem<ProductCate>(
                                        value: pdCate,
                                        child: new Text(
                                          pdCate.name,
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              child: new TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    _product.desc = 'Không có mô tả';
                                  } else {
                                    _product.desc = value;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Mô tả',
                                ),
                                autocorrect: true,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),
                              ),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 33,
        child: FloatingActionButton.extended(
          onPressed: () {
            if (_image == null) {
              Fluttertoast.showToast(
                  msg: "Sản phẩm chưa có ảnh",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.black87,
                  fontSize: 16.0);
            } else {
              if (formKey.currentState.validate()) {
                _product.id = createID(_product.categoryId);
                _product.img = basename(_image.path);
                _product.updateDay = datetime.toString();
                service.addProduct(_product);
                uploadImg();
                Navigator.pop(context);
              }
            }
          },
          backgroundColor: HexColor('#54D3C2'),
          label: Text('Lưu'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  Future<void> uploadImg() async {
    await Firebase.initializeApp();
    fileName = basename(_image.path);
    Reference imgReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = imgReference.putFile(_image);
    TaskSnapshot taskSnapshot = await uploadTask;
    setState(() {
      print('uploaded');
    });
  }
}
