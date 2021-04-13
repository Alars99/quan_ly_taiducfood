import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'demo10');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);

    return database;
  }

  //  id, name, categoryId, amout, barcode, costPrice, desc, img, importPrice, price, status, tax, updateDay, wholesalePrice
  //  id, name, categoryId, amout, barcode, costPrice, desc, img, importPrice, price, status, tax, updateDay, wholesalePrice, count

  _onCreatingDatabase(Database database, int version) async {
    await database.execute(
        "CREATE TABLE OrderList(id Text primary key, name Text, categoryId TEXT, desc TEXT, img TEXT, status TEXT, updateDay TEXT , price Double, count integer , amout integer, barcode integer ,wholesalePrice Double, costPrice Double ,importPrice Double, tax Double )");
    await database.execute(
        "CREATE TABLE customerList(id Text primary key, name Text, email TEXT, phone TEXT, address TEXT, idOrder TEXT, idShip TEXT)");
  }
}
