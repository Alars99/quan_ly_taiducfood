import 'dart:collection';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluttertoast/fluttertoast.dart';

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

class ProductAdd extends StatefulWidget {
  @override
  _ProductAddState createState() => _ProductAddState();
}

class _ProductAddState extends State<ProductAdd> {
  Product _product = Product();
  bool tax = false;
  String _data = "";

  File _image;

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
  // ignore: non_constant_identifier_names
  List<ProductCate> data_cate = ProductCate.listProductCate;

  @override
  void initState() {
    super.initState();
    productCate = data_cate[0];
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
                              // ignore: missing_return
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Chưa nhập Mã sản phẩm';
                                } else {
                                  _product.id = value;
                                }
                              },
                              autocorrect: true,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () => node.nextFocus(),
                              decoration: InputDecoration(
                                labelText: 'Mã sản phẩm',
                              ),
                            ),
                            new TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Chưa nhập Barcode sản phẩm';
                                  } else {
                                    _product.barcode = value;
                                  }
                                },
                                keyboardType: TextInputType.number,
                                key: Key(_data), // <- Magic!
                                initialValue: _data,
                                //controller: _controller,
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
                                        _product.amout = value as int;
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
                                        _product.costPrice = value as double;
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
                                        _product.price = value as double;
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
                                        _product.costPrice = value as double;
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
                                    _product.importPrice = value as double;
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
                                        print(
                                            "Loại: ${productCate.name}  ----  Id : ${productCate.categoryId}");
                                      });
                                    },
                                    items: data_cate.map((ProductCate pdCate) {
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
                            // new Text(
                            //     "Loại: ${productCate.name}  ----  Id : ${productCate.id}"),
                            Container(
                              child: new TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                  if (value.isEmpty) {
                                    _product.categoryId =
                                        'Không có thương hiệu';
                                  } else {
                                    _product.categoryId = value;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'Thương Hiệu',
                                ),
                                autocorrect: true,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),
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
                checkId(context);
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

  checkId(BuildContext context) {
    String idFood = productCate.categoryId.toString();
    DatabaseReference referenceList = FirebaseDatabase.instance
        .reference()
        .child('productList')
        .child(idFood)
        .child('Product');
    referenceList.once().then((DataSnapshot snapshot) {
      var keys = snapshot.value.keys;
      var values = snapshot.value;

      // ignore: missing_return
      bool cId() {
        if (formKey.currentState.validate()) {
          for (var key in keys) {
            if (values[key]["id"] == _product.id) {
              Fluttertoast.showToast(
                  msg: "Sản phẩm đã thêm rồi",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  textColor: Colors.black87,
                  fontSize: 16.0);
              print('a');
              return true;
            }
          }
          print('b');
          return false;
        }
      }

      if (cId() == false) {
        print('-----------------');
        print('chưa có sp thím ơi');
        uploadImg();
        //uploadSearchList();

        Fluttertoast.showToast(
            msg: "Thêm sản phẩm thành công",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            textColor: Colors.black87,
            fontSize: 16.0);
        Navigator.pop(context);
      }
      if (cId() == true) {
        print('-----------------');
        print('có sp r thím ơi');
      }
    });
  }

  Future<void> uploadImg() async {
    await Firebase.initializeApp();
    String fileName = basename(_image.path);
    Reference imgReference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = imgReference.putFile(_image);
    // ignore: unused_local_variable
    TaskSnapshot taskSnapshot = await uploadTask;
    setState(() {
      print('uploaded');
    });
  }

  // Future<void> uploadSearchList() async {
  //   String fileName = basename(_image.path);
  //   DateTime now = DateTime.now();
  //   if (formKey.currentState.validate()) {
  //     DatabaseReference referenceSearch =
  //         FirebaseDatabase.instance.reference().child('SearchList');

  //     HashMap mapSearch = new HashMap();

  //     price = price.replaceAll(",", "");

  //     mapSearch["id"] = id;
  //     mapSearch["image"] = fileName;
  //     mapSearch["brand"] = brand;
  //     mapSearch["name"] = name;
  //     mapSearch["price"] = price;
  //     mapSearch["idMain"] = productCate.id.toString();
  //     mapSearch["dateUp"] = now.toString();

  //     referenceSearch.child(id).set(mapSearch);
  //   }
  // }
}
