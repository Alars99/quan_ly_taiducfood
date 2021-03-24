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

  TextEditingController _controllerEditId = TextEditingController();
  TextEditingController _controllerEditName = TextEditingController();
  TextEditingController _controllerEditBrand = TextEditingController();
  TextEditingController _controllerEditImage = TextEditingController();
  TextEditingController _controllerEditDesc = TextEditingController();
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
  List<ProductCate> data_cate = ProductCate.listProductCate;

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
                                                _controllerPriceVon.numberValue
                                                    .toDouble();
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
                                            product.price = _controllerPrice
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
                                                _controllerPriceBuon.numberValue
                                                    .toDouble();
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
                                            _controllerPriceNhap.numberValue
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
            editSearchList();
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
    String fileName;
    if (_image != null) {
      fileName = basename(_image.path);
      print(fileName);
    } else {
      fileName = _controllerEditImage.text.toString();
      print(fileName);
    }
    String _controllerPriceString;
    String _controllerPriceVonString;
    String _controllerPriceBuonString;
    String _controllerPriceNhapString;
    String _controllerAmountString;
    String _controllerWeightString;
    String idFood = productCate.categoryId.toString();
    if (formKey.currentState.validate()) {
      DatabaseReference referenceList = FirebaseDatabase.instance
          .reference()
          .child('productList')
          .child(idFood)
          .child('Product');

      _controllerPriceString =
          _controllerPrice.text.toString().replaceAll(",", "");
      _controllerPriceVonString =
          _controllerPriceVon.text.toString().replaceAll(",", "");
      _controllerPriceNhapString =
          _controllerPriceNhap.text.toString().replaceAll(",", "");
      _controllerPriceBuonString =
          _controllerPriceBuon.text.toString().replaceAll(",", "");
      _controllerAmountString =
          _controllerAmount.text.toString().replaceAll(",", "");
      _controllerWeightString =
          _controllerWeight.text.toString().replaceAll(",", "");
    }
  }

  Future<void> editSearchList() async {
    String _controllerPriceString;
    String fileName;
    if (_image != null) {
      fileName = basename(_image.path);
    } else {
      fileName = _controllerEditImage.text.toString();
    }

    if (formKey.currentState.validate()) {
      DatabaseReference referenceSearch =
          FirebaseDatabase.instance.reference().child('SearchList');

      _controllerPriceString =
          _controllerPrice.text.toString().replaceAll(",", "");
      print(_controllerPriceString);
      referenceSearch.child(_controllerEditId.text.toString()).update({
        "name": _controllerEditName.text.toString(),
        // "id": _controllerEditId.text.toString(),
        "brand": _controllerEditBrand.text.toString(),
        "price": _controllerPriceString.toString(),
        "image": fileName.toString(),
      });
    }
  }
}
