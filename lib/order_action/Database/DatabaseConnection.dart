import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'demo6');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);

    return database;
  }

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE OrderList(id Text primary key, name Text, brand TEXT, price Double, count integer, amout integer,priceBuon Double,priceVon Double )");
    await database.execute(
        "CREATE TABLE customerList(id Text primary key, name Text, email TEXT, phone TEXT, address TEXT, idOrder TEXT, idShip TEXT)");
  }
}
