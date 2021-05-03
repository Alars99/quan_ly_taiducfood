import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:quan_ly_taiducfood/models/admin.dart';
import 'package:quan_ly_taiducfood/models/api_repository.dart';

final url = 'https://www.spcable.somee.com/api/admins';

class AdminRepository {
  http.Client httpClient = new http.Client();
  List<Admin> adminList = [];

  Future<List> loadData() async {
    final response = await this.httpClient.get(url);
    if (response.statusCode == 200) {
      final list = jsonDecode(response.body) as List;
      return list;
    } else {
      throw Exception('error');
    }
  }

  Future<APIResponse<List<Admin>>> getAdminList() async {
    final list = await loadData();
    adminList.clear();
    list.forEach((element) {
      Admin admin = new Admin();
      admin.id = element["id"];
      admin.user = element["user"];
      admin.pass = element["pass"];
      admin.role = element["role"];
      admin.birth = element["birth"];
      admin.name = element["name"];
      admin.mail = element["mail"];
      admin.phone = element["phone"];
      admin.sex = element["sex"];
      admin.address = element["address"];

      adminList.add(admin);
    });
    return APIResponse<List<Admin>>(data: adminList);
  }

  Future addAdmin(Admin admin) async {
    final response = await this.httpClient.post((url),
        body: json.encode(admin.toJson()),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        });
    if (response.statusCode == 201) {
      Admin admin = Admin.fromJson(jsonDecode(response.body));
      return admin;
    } else
      return null;
  }

  Future<APIResponse<bool>> updateAdmin(Admin admin, String id) async {
    final response = await this.httpClient.put((url + "/" + id),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(admin.toJson()));

    if (response.statusCode == 204) {
      return APIResponse<bool>(data: true);
    } else {
      return null;
    }
  }

  Future<void> deleteAdmin(Admin admin) async {
    final response = await this.httpClient.delete(url + "/" + admin.id);
    if (response.statusCode == 200) {
      Admin admin = Admin.fromJson(jsonDecode(response.body));

      return admin;
    } else {
      throw Exception('error');
    }
  }
}