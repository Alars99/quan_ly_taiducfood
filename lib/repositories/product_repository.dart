import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quan_ly_taiducfood/models/api_repository.dart';
import 'package:quan_ly_taiducfood/models/product.dart';

final url = 'https://www.spcable.somee.com/api/Products/';

class ProductRespository {
  http.Client httpClient = new http.Client();
  List<Product> productList = <Product>[];

  Future<List> loadData() async {
    final response = await this.httpClient.get(url);
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list;
    } else {
      throw Exception('error');
    }
  }

  Future<APIResponse<List<Product>>> getProductsList() async {
    final list = await loadData();
    productList.clear();
    list.forEach((element) {
      Product product = new Product();
      product.id = element["id"];
      product.name = element["name"];
      product.categoryId = element["categoryId"];
      product.amout = element["amout"];
      product.barcode = element["barcode"];
      product.costPrice = element["costPrice"];
      product.desc = element["desc"];
      product.img = element["img"];
      product.importPrice = element["importPrice"];
      product.price = element["price"];
      product.status = element["status"];
      product.tax = element["tax"];
      product.updateDay = element["updateDay"];
      product.wholesalePrice = element["wholesalePrice"];
      productList.add(product);
    });
    return APIResponse<List<Product>>(data: productList);
  }

  Future<APIResponse<Product>> getSingleProduct(String id) async {
    final reponse = await this.httpClient.get(url + id);
    if (reponse.statusCode == 200) {
      Product product = Product.fromJson(jsonDecode(reponse.body));
      return APIResponse<Product>(data: product);
    }
    return null;
  }

  Future<APIResponse<Product>> addProduct(Product product) async {
    final response = await this.httpClient.post((url),
        body: json.encode(product.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 201) {
      APIResponse<bool>(data: true);
    } else {
      print(response.request.toString());
    }
    return null;
  }

  Future updateProduct(Product product, String id) async {
    final response = await this.httpClient.put((url + "/" + id), body: {
      'id': product.id,
      'name': product.name,
      'categoryId': product.categoryId,
    });
    if (response.statusCode == 204) {
    } else
      return null;
  }

  Future<void> deleteProduct(Product product) async {
    final response = await this.httpClient.delete(url + "/" + product.id);
    if (response.statusCode == 200) {
      Product product = Product.fromJson(jsonDecode(response.body));

      return product;
    } else {
      throw Exception('error');
    }
  }

  Future<void> upload() async {
    final now = DateTime.now();
    // String fileName = basename(_image.path);
    String fileName = "";

    // // String uploadId = reference.push().key;
    // HashMap mapProList = new HashMap();

    // weight = weight.replaceAll(",", "");
    // price = price.replaceAll(",", "");
    // priceBuon = priceBuon.replaceAll(",", "");
    // priceNhap = priceNhap.replaceAll(",", "");
    // priceVon = priceVon.replaceAll(",", "");
    // amount = amount.replaceAll(",", "");

    // mapProList["id"] = id;
    // mapProList["brand"] = brand;
    // mapProList["image"] = fileName;
    // mapProList["name"] = name;
    // mapProList["price"] = price;
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
    // mapProList["ngayUp"] = DateFormat('dd/MM/yyyy').format(now).toString();
    // mapProList["daban"] = "0";

    // referenceList.child(id).set(mapProList);
  }
}
