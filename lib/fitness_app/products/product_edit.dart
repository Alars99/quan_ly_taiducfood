import 'dart:collection';
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
import 'package:quan_ly_taiducfood/fitness_app/models/product_cate_data.dart';

import '../../constants.dart';

class ProductEdit extends StatefulWidget {
  @override
  _ProductEditState createState() => _ProductEditState();
  static const routeName = '/product-edit';
}

class _ProductEditState extends State<ProductEdit> {
  String id,
      brand,
      name,
      image,
      price,
      barcode,
      weight,
      cate,
      priceNhap,
      priceBuon,
      priceVon,
      amount,
      desc;
  String _data = "";
  bool tax = false;
  bool allowSale = false;

  String _downloadImgUrl;
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

  _scan() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#FF0000", "Cancel", true, ScanMode.DEFAULT)
        .then((value) => setState(() => {
              if (value == "-1") {_data = '0'} else {_data = value}
            }));
    print(_data);
  }

  ProductCate productCate;
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
    Future.delayed(Duration.zero, () {
      final Map data = ModalRoute.of(this.context).settings.arguments;
      _controllerEditId.text = data['id'];
      _controllerEditName.text = data['name'];
      _controllerEditBrand.text = data['brand'];
      _controllerEditImage.text = data['image'];
      _controllerPrice.text = data['price'];
      int idMainInt = int.parse(data['idMain'].toString()) - 1;
      productCate = data_cate[idMainInt];
    });
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

    Future downdloadImage() async {
      await Firebase.initializeApp();
      Reference imgReference =
          FirebaseStorage.instance.ref().child(_controllerEditImage.text);
      String downloadImg = await imgReference.getDownloadURL();
      setState(() {
        _downloadImgUrl = downloadImg;
      });
    }

    final node = FocusScope.of(context);
    return Scaffold(
      backgroundColor: Color(0xFFF2F2F2),
      appBar: AppBar(
        title: Text("Sửa sản phẩm"),
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
            height: MediaQuery.of(context).size.height * 1.75,
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
                              //print(Image.file(_image));
                            },
                            child: Container(
                              width: 250,
                              height: 230,
                              child: (_image != null)
                                  ? Image.file(
                                      _image,
                                      fit: BoxFit.fill,
                                    )
                                  //  ==
                                  // null
                                  // ? Image(
                                  //     image: new NetworkImageWithRetry(
                                  //         _downloadImgUrl),
                                  //     fit: BoxFit.fill,
                                  //   )
                                  // : Image(
                                  //     image: new NetworkImageWithRetry(
                                  //         _downloadImgUrl),
                                  //     fit: BoxFit.fill,
                                  //   )
                                  : Image(
                                      image: new NetworkImageWithRetry(
                                          _controllerEditImage.text),
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            //     Container(
                            //   width: 250,
                            //   height: 230,
                            //   child: (_downloadImgUrl == null)
                            //       ? Container()
                            //       : Image(
                            //           image: new NetworkImageWithRetry(
                            //               _downloadImgUrl),
                            //           fit: BoxFit.fill,
                            //         ),
                            // )
                            //: Container(),
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
                              validator: (value) {
                                if (value.isEmpty) {
                                  return 'Chưa nhập Tên sản phẩm';
                                } else {
                                  name = value;
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
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Chưa nhập Mã sản phẩm';
                                  } else {
                                    id = value;
                                  }
                                },
                                autocorrect: true,
                                textInputAction: TextInputAction.next,
                                onEditingComplete: () => node.nextFocus(),
                                decoration: InputDecoration(
                                  labelText: 'Mã sản phẩm',
                                )),
                            // new TextFormField(
                            //     validator: (value) {
                            //       if (value.isEmpty) {
                            //         return 'Chưa nhập Barcode sản phẩm';
                            //       } else {
                            //         barcode = value;
                            //       }
                            //     },
                            //     keyboardType: TextInputType.number,
                            //     key: Key(_data), // <- Magic!
                            //     initialValue: _data,
                            //     //controller: _controller,
                            //     //onChanged: (text) {},
                            //     autocorrect: true,
                            //     decoration: InputDecoration(
                            //       labelText: 'Barcode',
                            //       suffixIcon: IconButton(
                            //           autofocus: false,
                            //           onPressed: () => _scan(),
                            //           icon:
                            //               Icon(Icons.qr_code_scanner_outlined)),
                            //     )),
                            // new TextFormField(
                            //   validator: (value) {
                            //     if (value.isEmpty || value == '0') {
                            //       return 'Chưa nhập Khối lượng sản phẩm';
                            //     } else {
                            //       weight = value;
                            //     }
                            //   },
                            //   controller: _controllerWeight,
                            //   autocorrect: true,
                            //   keyboardType: TextInputType.number,
                            //   textInputAction: TextInputAction.next,
                            //   onEditingComplete: () => node.nextFocus(),
                            //   decoration: InputDecoration(
                            //     labelText: 'Khối lượng (g)',
                            //   ),
                            // ),
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
                                // Container(
                                //   width: 140,
                                //   child: new TextFormField(
                                //     validator: (value) {
                                //       if (value.isEmpty || value == '0') {
                                //         return 'Chưa nhập Tồn kho sản phẩm';
                                //       } else {
                                //         amount = value;
                                //       }
                                //     },
                                //     controller: _controllerAmount,
                                //     decoration: InputDecoration(
                                //       labelText: 'Tồn kho',
                                //     ),
                                //     keyboardType: TextInputType.number,
                                //     autocorrect: true,
                                //     textInputAction: TextInputAction.next,
                                //     onEditingComplete: () => node.nextFocus(),
                                //   ),
                                // ),
                                // Container(
                                //   width: 140,
                                //   child: new TextFormField(
                                //     validator: (value) {
                                //       if (value.isEmpty || value == '0') {
                                //         return 'Chưa nhập Giá vốn sản phẩm';
                                //       } else {
                                //         priceVon = value;
                                //       }
                                //     },
                                //     controller: _controllerPriceVon,
                                //     autocorrect: true,
                                //     keyboardType: TextInputType.number,
                                //     textInputAction: TextInputAction.next,
                                //     onEditingComplete: () => node.nextFocus(),
                                //     decoration: InputDecoration(
                                //       labelText: 'Giá vốn',
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 140,
                                  child: new TextFormField(
                                    validator: (value) {
                                      if (value.isEmpty || value == '0') {
                                        return 'Chưa nhập Giá bán lẻ sản phẩm';
                                      } else {
                                        price = value;
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
                                // Container(
                                //   width: 140,
                                //   child: new TextFormField(
                                //     validator: (value) {
                                //       if (value.isEmpty || value == '0') {
                                //         return 'Chưa nhập Giá bán buôn sản phẩm';
                                //       } else {
                                //         priceBuon = value;
                                //       }
                                //     },
                                //     controller: _controllerPriceBuon,
                                //     autocorrect: true,
                                //     keyboardType: TextInputType.number,
                                //     textInputAction: TextInputAction.next,
                                //     onEditingComplete: () => node.nextFocus(),
                                //     decoration: InputDecoration(
                                //       labelText: 'Giá bán buôn',
                                //     ),
                                //   ),
                                // ),
                              ],
                            ),
                            // Container(
                            //   child: new TextFormField(
                            //     validator: (value) {
                            //       if (value.isEmpty || value == '0') {
                            //         return 'Chưa nhập Giá nhập sản phẩm';
                            //       } else {
                            //         priceNhap = value;
                            //       }
                            //     },
                            //     controller: _controllerPriceNhap,
                            //     autocorrect: true,
                            //     keyboardType: TextInputType.number,
                            //     textInputAction: TextInputAction.next,
                            //     onEditingComplete: () => node.nextFocus(),
                            //     decoration: InputDecoration(
                            //       labelText: 'Giá nhập',
                            //     ),
                            //   ),
                            // ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   mainAxisSize: MainAxisSize.max,
                            //   children: [
                            //     Container(
                            //         child: new Text(
                            //       'Áp dụng thuế',
                            //       style: new TextStyle(fontSize: 17),
                            //     )),
                            //     Container(
                            //         child: new Switch(
                            //             value: tax,
                            //             onChanged: (bool s) {
                            //               setState(() {
                            //                 tax = s;
                            //                 print(tax);
                            //               });
                            //             }))
                            //   ],
                            // )
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
                                            "Loại: ${productCate.name}  ----  Id : ${productCate.id}");
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
                            new Text(
                                "Loại: ${productCate.name}  ----  Id : ${productCate.id}"),
                            Container(
                              child: new TextFormField(
                                controller: _controllerEditBrand,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    brand = 'Không có thương hiệu';
                                  } else {
                                    brand = value;
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
                            // Container(
                            //   child: new TextFormField(
                            //     validator: (value) {
                            //       if (value.isEmpty) {
                            //         desc = 'Không có mô tả';
                            //       } else {
                            //         desc = value;
                            //       }
                            //     },
                            //     decoration: InputDecoration(
                            //       labelText: 'Mô tả',
                            //     ),
                            //     autocorrect: true,
                            //     textInputAction: TextInputAction.next,
                            //     onEditingComplete: () => node.nextFocus(),
                            //   ),
                            // ),
                            // Row(
                            //   crossAxisAlignment: CrossAxisAlignment.center,
                            //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            //   mainAxisSize: MainAxisSize.max,
                            //   children: [
                            //     Container(
                            //         child: new Text(
                            //       'Cho phép bán',
                            //       style: new TextStyle(fontSize: 17),
                            //     )),
                            //     Container(
                            //         child: new Switch(
                            //             value: allowSale,
                            //             onChanged: (bool s) {
                            //               setState(() {
                            //                 allowSale = s;
                            //                 print(allowSale);
                            //               });
                            //             })),
                            //   ],
                            // ),
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
            // print(_controllerEditName.text);
            // print(_controllerPrice.text);
            // print(_controllerEditImage.text);
            // print(_controllerEditBrand.text);
            // print(_controllerEditId.text);
            // print('${productCate.name}');
            // print('${productCate.id}');
            edit();
            editSearchList();
          },
          backgroundColor: kPrimaryColor,
          label: Text('Lưu'),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

  // checkId(BuildContext context) {
  //   String idFood = productCate.id.toString();
  //   DatabaseReference referenceList = FirebaseDatabase.instance
  //       .reference()
  //       .child('productList')
  //       .child(idFood)
  //       .child('Product');
  //   referenceList.once().then((DataSnapshot snapshot) {
  //     var keys = snapshot.value.keys;
  //     var values = snapshot.value;

  //     bool cId() {
  //       if (formKey.currentState.validate()) {
  //         for (var key in keys) {
  //           if (values[key]["id"] == id) {
  //             Fluttertoast.showToast(
  //                 msg: "Sản phẩm đã thêm rồi",
  //                 toastLength: Toast.LENGTH_SHORT,
  //                 gravity: ToastGravity.BOTTOM,
  //                 timeInSecForIosWeb: 1,
  //                 textColor: Colors.black87,
  //                 fontSize: 16.0);
  //             print('a');
  //             return true;
  //           }
  //         }
  //         print('b');
  //         return false;
  //       }
  //     }

  //     if (cId() == false) {
  //       print('-----------------');
  //       print('chưa có sp thím ơi');
  //       editImg();
  //       editSearchList();
  //       edit();
  //       Navigator.pop(context);
  //     }
  //     if (cId() == true) {
  //       print('-----------------');
  //       print('có sp r thím ơi');
  //     }
  //   });
  // }

  // Future<void> editImg() async {
  //   await Firebase.initializeApp();
  //   String fileName = basename(_image.path);
  //   Reference imgReference = FirebaseStorage.instance.ref().child(fileName);
  //   UploadTask uploadTask = imgReference.putFile(_image);
  //   TaskSnapshot taskSnapshot = await uploadTask;
  //   setState(() {
  //     print('uploaded');
  //   });
  // }

  Future<void> edit() async {
    // String fileName = basename(_image.path);
    String idFood = productCate.id.toString();
    if (formKey.currentState.validate()) {
      DatabaseReference referenceList = FirebaseDatabase.instance
          .reference()
          .child('productList')
          .child(idFood)
          .child('Product');
      // String uploadId = reference.push().key;
      // HashMap mapProList = new HashMap();

      // weight = weight.replaceAll(",", "");
      // price = price.replaceAll(",", "");
      // priceBuon = priceBuon.replaceAll(",", "");
      // priceNhap = priceNhap.replaceAll(",", "");
      // priceVon = priceVon.replaceAll(",", "");
      // amount = amount.replaceAll(",", "");

      // mapProList["id"] = _controllerEditId.text;
      // mapProList["brand"] = _controllerEditBrand.text;
      // mapProList["image"] = fileName;
      // (fileName != null)?'a':'s'
      // mapProList["name"] = _controllerEditName.text;
      // mapProList["price"] = _controllerPrice.text;
      // mapProList["barcode"] = barcode;
      // mapProList["weight"] = weight;
      // mapProList["cate"] = productCate.id.toString();
      // mapProList["priceNhap"] = priceNhap;
      // mapProList["priceBuon"] = priceBuon;
      // mapProList["priceVon"] = priceVon;
      // mapProList["amount"] = amount;
      // mapProList["desc"] = desc;
      // mapProList["allowSale"] = allowSale;
      // mapProList["tax"] = tax;

      referenceList.child(_controllerEditId.text.toString()).update({
        "name": _controllerEditName.text.toString(),
        "id": _controllerEditId.text.toString(),
        "brand": _controllerEditBrand.text.toString(),
        "price": _controllerPrice.text.toString(),
        // "image": _controllerEditImage.text.toString(),
      });
    }
  }

  Future<void> editSearchList() async {
    // String fileName = basename(_image.path);
    if (formKey.currentState.validate()) {
      DatabaseReference referenceSearch =
          FirebaseDatabase.instance.reference().child('SearchList');

      // HashMap mapSearch = new HashMap();

      // price = price.replaceAll(",", "");

      // mapSearch["id"] = id;
      // mapSearch["image"] = fileName;
      // mapSearch["brand"] = brand;
      // mapSearch["name"] = name;
      // mapSearch["price"] = price;
      // mapSearch["idMain"] = productCate.id.toString();

      // referenceSearch.child(id).set(mapSearch);
      referenceSearch.child(_controllerEditId.text.toString()).update({
        "name": _controllerEditName.text.toString(),
        "id": _controllerEditId.text.toString(),
        "brand": _controllerEditBrand.text.toString(),
        "price": _controllerPrice.text.toString(),
        // "image": _controllerEditImage.text.toString(),
      });
    }
  }
}
