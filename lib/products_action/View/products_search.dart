import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/product.dart';
import 'package:quan_ly_taiducfood/products_action/View/product_detail.dart';
import 'package:quan_ly_taiducfood/products_action/theme/order&pro_theme.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_detail_data.dart';
import 'package:quan_ly_taiducfood/products_action/models/product_search_data.dart';
import 'package:quan_ly_taiducfood/products_action/View/product_add.dart';
import 'package:quan_ly_taiducfood/repositories/product_repository.dart';
import '../../main.dart';
import 'product_out_soluong/product_out_amount.dart';

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
  List<ProductSearch> productSearchList = [];
  List<ProductSearch> productSearchListSort = [];
  List<ProductSearch> searchList = [];
  List<ProductDetail> productSearchList2 = [];
  List<ProductDetail> productSearchList3 = [];
  List<Product> productList = [];
  int slHet;
  DateTime _dateTime, startDate, endDate;
  final ScrollController scrollController = ScrollController();
  double topBarOpacity = 0.0;
  GlobalKey<RefreshIndicatorState> reKey;

  //new
  APIResponse<List<Product>> _apiResponse;
  bool isLoading = false;
  ProductRespository service = ProductRespository();

  @override
  void initState() {
    reKey = GlobalKey<RefreshIndicatorState>();
    endDate = DateTime.now();
    startDate = DateTime.utc(endDate.year, endDate.month, endDate.day - 7);
    slHet = 0;
    _fetchProducts();
    getLocgiatri();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _fetchProducts();
  }

  _fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    _apiResponse = await service.getProductsList();

    setState(() {
      isLoading = false;
    });
  }

  Future<Null> refreshList() async {
    await Future.delayed(Duration(seconds: 1));
    return null;
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
        slHet = 0;
        productSearchList3.clear();
        for (var sp in productSearchList2) {
          if (int.parse(sp.amount) <= 3) {
            slHet++;
          }
        }
        String m = "";
        for (var sp in productSearchList2) {
          m = "";
          for (int i = 0; i <= 31; i++) {
            _dateTime = DateTime.utc(
                startDate.year, startDate.month, startDate.day + i);

            if (sp.ngayUp == DateFormat("dd/MM/yyyy").format(_dateTime)) {
              m = sp.ngayUp;
              break;
            }
          }
          if (m == "") {
            if (int.parse(sp.amount) >= 10) {
              slHet++;
            }
          }
        }
        for (var sp in productSearchList2) {
          for (int i = 0; i <= 8; i++) {
            _dateTime = DateTime.utc(
                startDate.year, startDate.month, startDate.day + i);

            if (sp.ngayUp == DateFormat("dd/MM/yyyy").format(_dateTime)) {
              slHet++;
            }
          }
        }

        setState(() {});
      });
    }
  }

  getLocList(int i) {
    DatabaseReference referenceProduct =
        FirebaseDatabase.instance.reference().child("SearchList");
    referenceProduct.once().then((DataSnapshot snapshot) {
      productSearchList.clear();
      productSearchListSort.clear();
      var keys = snapshot.value.keys;
      var values = snapshot.value;

      for (var key in keys) {
        ProductSearch product = new ProductSearch(
          values[key]["id"],
          values[key]["idMain"],
          values[key]["name"],
          values[key]["image"],
          values[key]["price"],
          values[key]["dateUp"],
        );
        productSearchList.add(product);
        productSearchListSort.add(product);
        // productSearchList.sort((a, b) {
        //   DateTime adate = DateTime.parse(a.dateUp);
        //   DateTime bdate = DateTime.parse(b.dateUp);
        //   return bdate.compareTo(adate);
        // });
      }

      if (i == 1) {
        productSearchList.clear();
        productSearchListSort.sort((a, b) {
          var adate = int.parse(a.price);
          var bdate = int.parse(b.price);
          return adate.compareTo(bdate);
        });
        for (var t in productSearchListSort) {
          productSearchList.add(t);
          print(t.price);
        }
      } else if (i == 3) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "1") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 2) {
        productSearchList.clear();
        productSearchListSort.sort((a, b) {
          var adate = int.parse(a.price);
          var bdate = int.parse(b.price);
          return bdate.compareTo(adate);
        });
        for (var t in productSearchListSort) {
          productSearchList.add(t);
          print(t.price);
        }
      } else if (i == 4) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "2") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 5) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "3") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 6) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "4") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 7) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "5") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 8) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "6") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 9) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "7") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 10) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "8") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 11) {
        productSearchList.clear();

        for (var sp in productSearchListSort) {
          if (sp.idMain == "9") {
            productSearchList.add(sp);
            productSearchList.sort((a, b) {
              DateTime adate = DateTime.parse(a.dateUp);
              DateTime bdate = DateTime.parse(b.dateUp);
              return bdate.compareTo(adate);
            });
          }
        }
      } else if (i == 12) {
        productSearchList.sort((a, b) {
          DateTime adate = DateTime.parse(a.dateUp);
          DateTime bdate = DateTime.parse(b.dateUp);
          return bdate.compareTo(adate);
        });
      } else if (i == 13) {
        productSearchList.sort((a, b) {
          DateTime adate = DateTime.parse(a.dateUp);
          DateTime bdate = DateTime.parse(b.dateUp);
          return adate.compareTo(bdate);
        });
      }
      setState(() {});
    });
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
          actions: [
            IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (context) => ProductAdd()));
              },
              color: Colors.white,
            ),
            IconButton(
              icon: Icon(Icons.sort),
              onPressed: () {
                showLoc(context: context);
              },
              color: Colors.white,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Container(
                child: new Stack(
                  children: <Widget>[
                    new IconButton(
                      icon: Icon(Icons.notifications),
                      onPressed: () {
                        Navigator.push(
                            context,
                            new MaterialPageRoute(
                                builder: (context) => ProductOutAmount()));
                      },
                      color: Colors.white,
                    ),
                    slHet == 0
                        ? Container()
                        : new Positioned(
                            right: 10,
                            top: 11,
                            child: new Container(
                              padding: EdgeInsets.all(3),
                              decoration: new BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: BoxConstraints(
                                minWidth: 11,
                                minHeight: 11,
                              ),
                              child: new Text(
                                slHet.toString(),
                                style: new TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ],
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

          return Column(
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
                            color: OrderProductTheme.buildLightTheme()
                                .backgroundColor,
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
                              cursorColor: OrderProductTheme.buildLightTheme()
                                  .primaryColor,
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Tên sản phẩm...',
                                icon: Icon(FontAwesomeIcons.search,
                                    size: 20, color: HexColor('#54D3C2')),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              _apiResponse.data.length == 0
                  ? Column(
                      children: [
                        Text(
                          "Không có sản phẩm",
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  : Expanded(
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height - 155,
                        child: Column(
                          children: [
                            Expanded(
                              child: RefreshIndicator(
                                key: reKey,
                                onRefresh: () async {
                                  await refreshList();
                                },
                                child: isLoading
                                    ? CircularProgressIndicator()
                                    : ListView.builder(
                                        scrollDirection: Axis.vertical,
                                        shrinkWrap: true,
                                        itemCount: _apiResponse.data.length,
                                        itemBuilder: (context, index) {
                                          return listUI(
                                              _apiResponse.data[index]);
                                        }),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
            ],
          );
        }),
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

  Widget listUI(Product product) {
    return ListTile(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ProductDetailScreen(
                      id: product.id,
                    )));
      },
      subtitle: Text(product.id),
      leading: Container(
        width: 80,
        height: 200,
        child: Image.network(product.img.toString().startsWith("image_picker")
            ? 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/' +
                product.img +
                '?alt=media&token=63435cda-cb54-4b82-bec7-08edadbb049e'
            : 'https://firebasestorage.googleapis.com/v0/b/app-quan-ly-taiducfood.appspot.com/o/image_picker00000.png?alt=media&token=0a7279d8-2d2e-46aa-aeee-2874a520b0fe'),
      ),
      title: Text(product.name),
    );
  }

  void showLoc({BuildContext context}) {
    int tienship = 0;
    showDialog<dynamic>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Chọn phương thức lọc:"),
            content: SingleChildScrollView(
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RadioListTile(
                      title: Text("Sản phẩm mới nhất"),
                      value: 12,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocList(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Sản phẩm cũ nhất"),
                      value: 13,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocList(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Giá tăng dần"),
                      value: 1,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocList(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                    RadioListTile(
                      title: Text("Giá giảm dần"),
                      value: 2,
                      groupValue: tienship,
                      onChanged: (value) {
                        setState(() {
                          getLocList(value);
                          Navigator.pop(context);
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  // ignore: non_constant_identifier_names
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
          values[key]["dateUp"],
        );
        if (product.name.toLowerCase().contains(text)) {
          productSearchList.add(product);
          productSearchList.sort((a, b) {
            DateTime adate = DateTime.parse(a.dateUp);
            DateTime bdate = DateTime.parse(b.dateUp);
            return bdate.compareTo(adate);
          });
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
