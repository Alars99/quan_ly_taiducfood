import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

import 'DatabaseConnection.dart';

class Repository {
  DatabaseConnection _databaseConnection;
  Repository() {
    _databaseConnection = DatabaseConnection();
  }

  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _databaseConnection.setDatabase();
    return _database;
  }

  //add data
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  //read data

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }

  deleteData(table) async {
    var connection = await database;
    return await connection.delete(table);
  }

  deleteOneData(table, itemId) async {
    var connection = await database;
    return await connection
        .rawDelete("Delete From $table where id = '$itemId'");
  }

  readOneData(table, itemId) async {
    var connection = await database;
    return await connection.query(table, where: 'id=?', whereArgs: [itemId]);
  }

  updateData(table, data) async {
    var connection = await database;
    return await connection.update(table, data);
  }

  updateAData(table, String id, int count) async {
    var connection = await database;
    String sql = "Update $table SET count = '$count' WHERE id = '$id'";
    return await connection.rawUpdate(sql);
  }
}
