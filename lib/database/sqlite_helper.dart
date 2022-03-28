import 'package:path/path.dart' as Path;
import 'package:sqflite/sqflite.dart';
import '../model/image_model.dart';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SqlitHelper {
  SqlitHelper._();

  static final SqlitHelper db = SqlitHelper._();

  final TABLE_NAME = 'image_detail';
  static Database? _database;

  // Future<Database> get database async {
  //   if (_database != null)
  //     return _database;
  //   // if _database is null we instantiate it
  //   _database = await initDB();
  //   return _database;
  // }
  Future<Database> get database async =>
      _database ??= await initDB();

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = Path.join(documentsDirectory.path, "Petli.db");
    return await openDatabase(path, version: 2, onOpen: (db) {},
        onCreate: (Database db, int version) async {
      // await db.execute(
      //   "CREATE TABLE image_detail(pid INTEGER PRIMARY KEY, id INTEGER, albumId INTEGER, title TEXT, url TEXT, thumbnailUrl TEXT)",
          await db.execute("CREATE TABLE $TABLE_NAME ("
              "pid INTEGER PRIMARY KEY,"
              "id INTEGER,"
              "albumId INTEGER,"
              "title TEXT,"
              "url TEXT,"
              "thumbnailUrl TEXT"
              ")");

     // );
    });
  }

  Future<List<ImageModel>> getAllProducts() async {
    final db = await database;
    var res = await db.query(TABLE_NAME);
    List<ImageModel> list =
        res.isNotEmpty ? res.map((c) => ImageModel.fromJson(c)).toList() : [];
    return list;
  }

  insertProductIntoDatabase(ImageModel detail) async {
    final db = await database;
    await db.insert(TABLE_NAME, detail.toJson());
  }

  updateProducts(ImageModel detail) async {
    final db = await database;
    var res = await db.update(TABLE_NAME, detail.toJson(),
        where: "id = ?", whereArgs: [detail.id]);
    return res;
  }

  Future<bool> isProductAvailable(ImageModel detail) async {
    bool productAvailable = true;
    final db = await database;
    var res = await db
        .rawQuery('SELECT * FROM $TABLE_NAME WHERE id = ?', [detail.id]);

    if (res == null || res.length <= 0) {
      productAvailable = false;
    } else {
      productAvailable = true;
    }
    //  detail.toMap(),
    //     where: "name = ?", whereArgs: [detail.name]);
    return productAvailable;
  }

  deleteProduct(int id) async {
    final db = await database;
    return db.delete(TABLE_NAME, where: "id = ?", whereArgs: [id]);
  }

  deleteAll() async {
    final db = await database;
    db.delete(TABLE_NAME);
  }
}
