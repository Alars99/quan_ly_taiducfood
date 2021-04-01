import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_image/network.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/product.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_cate_data.dart';
import 'package:quan_ly_taiducfood/repositories/product_repository.dart';

import '../../main.dart';

class ProductEdit extends StatefulWidget {
  const ProductEdit({Key key, this.id}) : super(key: key);

  @override
  _ProductEditState createState() => _ProductEditState(id);
  final String id;
  static const routeName = '/product-edit';
}

class _ProductEditState extends State<ProductEdit> {
  final String id;
  Product product;
  String _downloadImgUrl;
  String _data;
  File _image;

  var formKey = GlobalKey<FormState>();
  // MoneyMaskedTextController(
  //     precision: 0, decimalSeparator: '', thousandSeparator: ',');
  final _controllerAmount = TextEditingController();
  final _controllerPriceVon = TextEditingController();
  final _controllerPrice = TextEditingController();
  final _controllerPriceNhap = TextEditingController();
  final _controllerPriceBuon = TextEditingController();

  TextEditingController _controllerEditId = TextEditingController();
  TextEditingController _controllerEditName = TextEditingController();
  TextEditingController _controllerEditImage = TextEditingController();
  TextEditingController _controllerEditDesc = TextEditingController();
  TextEditingController _controllerEditBarcode = TextEditingController();
  _ProductEditState(this.id);

  //new
  bool isLoading = false;
  APIResponse _apiResponse = APIResponse();
  ProductRespository service = ProductRespository();

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FF0000", "Cancel", true, ScanMode.DEFAULT)
        .then((value) => setState(() => {
              if (value == "-1") {_data = '0'} else {_data = value}
            }));
    // print(_data);
  }

  ProductCate productCate;
  List<ProductCate> cate = ProductCate.listProductCate;

  Future downdloadImage() async {
    await Firebase.initializeApp();
    Reference imgReference =
        FirebaseStorage.instance.ref().child(_controllerEditImage.text);
    String downloadImg = await imgReference.getDownloadURL();
    setState(() {
      _downloadImgUrl = downloadImg;
    });
  }

  _fetchProducts() async {
    setState(() {
      isLoading = true;
    });
    _apiResponse = await service.getSingleProduct(id);
    setState(() {
      isLoading = false;
      product = _apiResponse.data;
      _controllerPrice.text = product.price.toString();
      _controllerPriceBuon.text = product.costPrice.toString();
      _controllerPriceNhap.text = product.importPrice.toString();
      _controllerPriceVon.text = product.wholesalePrice.toString();
      _controllerAmount.text = product.amout.toString();
      _controllerEditName.text = product.name.toString();
      _controllerEditId.text = product.id.toString();
      _controllerEditBarcode.text = product.barcode.toString();
      _controllerEditImage.text = product.img.toString();
      downdloadImage();
    });
  }

  @override
  void initState() {
    _fetchProducts();
    super.initState();
  }

  Future getImage() async {
    // ignore: deprecated_member_use
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      // print(_image);
    });
  }

  @override
  Widget build(BuildContext context) {
    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text(
          "Sửa sản phẩm",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close),
          onPressed: () {
            Navigator.pop(context);
          },
          color: Colors.white,
        ),
      ),
      body: Builder(
        builder: (context) {
          if (isLoading) {
            return CircularProgressIndicator();
          }
          return Form(
            key: formKey,
            child: SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height * 1.85,
                padding: EdgeInsets.only(top: 10),
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
                                  width: 250,
                                  height: 230,
                                  child: (_image == null)
                                      ? Image(
                                          image: new NetworkImageWithRetry(
                                              _downloadImgUrl == null
                                                  ? _controllerEditImage.text
                                                  : _downloadImgUrl),
                                          fit: BoxFit.fill,
                                        )
                                      : Image.file(
                                          _image,
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
                                  controller: _controllerEditName,
                                  // ignore: missing_return
                                  validator: (value) {
                                    if (value.isEmpty) {
                                      return 'Chưa nhập Tên sản phẩm';
                                    } else {
                                      product.name = value;
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
                                    controller: _controllerEditId,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Chưa nhập Mã sản phẩm';
                                      } else {
                                        product.id = value;
                                      }
                                    },
                                    enabled: false,
                                    autocorrect: true,
                                    textInputAction: TextInputAction.next,
                                    onEditingComplete: () => node.nextFocus(),
                                    decoration: InputDecoration(
                                      labelText: 'Mã sản phẩm',
                                    )),
                                new TextFormField(
                                    controller: _controllerEditBarcode,
                                    // ignore: missing_return
                                    validator: (value) {
                                      if (value.isEmpty) {
                                        return 'Chưa nhập Barcode sản phẩm';
                                      } else {
                                        product.barcode = int.parse(value);
                                      }
                                    },
                                    keyboardType: TextInputType.number,
                                    key: Key(_data),
                                    initialValue: _data,
                                    autocorrect: true,
                                    decoration: InputDecoration(
                                      labelText: 'Barcode',
                                      suffixIcon: IconButton(
                                          autofocus: false,
                                          onPressed: () {
                                            setState(() {
                                              _data = "0";
                                              _scan();
                                            });
                                          },
                                          icon: Icon(
                                              Icons.qr_code_scanner_outlined)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 140,
                                      child: new TextFormField(
                                        // ignore: missing_return
                                        validator: (value) {
                                          if (value.isEmpty || value == '0') {
                                            return 'Chưa nhập Tồn kho sản phẩm';
                                          } else {
                                            product.amout = int.parse(value);
                                          }
                                        },
                                        controller: _controllerAmount,
                                        decoration: InputDecoration(
                                          labelText: 'Tồn kho',
                                        ),
                                        keyboardType: TextInputType.number,
                                        autocorrect: true,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            node.nextFocus(),
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
                                            product.wholesalePrice =
                                                double.parse(value);
                                          }
                                        },
                                        controller: _controllerPriceVon,
                                        autocorrect: true,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            node.nextFocus(),
                                        decoration: InputDecoration(
                                          labelText: 'Giá vốn',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      width: 140,
                                      child: new TextFormField(
                                        // ignore: missing_return
                                        validator: (value) {
                                          if (value.isEmpty || value == '0') {
                                            return 'Chưa nhập Giá bán lẻ sản phẩm';
                                          } else {
                                            product.price = double.parse(value);
                                          }
                                        },
                                        controller: _controllerPrice,
                                        decoration: InputDecoration(
                                          labelText: 'Giá bán lẻ',
                                        ),
                                        keyboardType: TextInputType.number,
                                        autocorrect: true,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            node.nextFocus(),
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
                                            product.costPrice =
                                                double.parse(value);
                                          }
                                        },
                                        controller: _controllerPriceBuon,
                                        autocorrect: true,
                                        keyboardType: TextInputType.number,
                                        textInputAction: TextInputAction.next,
                                        onEditingComplete: () =>
                                            node.nextFocus(),
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
                                        product.importPrice =
                                            double.parse(value);
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: [
                                    Container(
                                        child: new Text(
                                      'Áp dụng thuế',
                                      style: new TextStyle(fontSize: 17),
                                    )),
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: MediaQuery.of(context).size.width - 33,
        child: FloatingActionButton.extended(
          onPressed: () {
            edit();
            if (_image != null) {
              editImg();
            }
            Fluttertoast.showToast(
                msg: "Sửa sản phẩm thành công",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIosWeb: 1,
                textColor: Colors.black87,
                fontSize: 16.0);
            Navigator.of(context).pop();
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

  Future<void> editImg() async {
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

  Future<void> edit() async {
    if (_image != null) {
      product.img = basename(_image.path);
    }
    if (formKey.currentState.validate()) {
      print(product.id);
      print(product.amout);
      print(product.barcode);
      print(product.categoryId);
      print(product.costPrice);
      print(product.desc);
      print(product.img);
      print(product.importPrice);
      print(product.name);
      print(product.price);
      print(product.status);
      print(product.tax);
      print(product.wholesalePrice);
      service.updateProduct(product, product.id);
    }
  }
}
