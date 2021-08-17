import 'package:path_provider/path_provider.dart';
import 'package:performant_dat_fetching/src/resources/repository.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'dart:async';
import '../models/item_model.dart';

class NewsDbProvider implements Source, Cache {
  Database? db;

  NewsDbProvider() {
    print("NewsDB initialized!");
    init();
  }

  init() async {
    // initialize Database
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, 'flutter.db');
    db = await openDatabase(
      path,
      version: 1,
      onCreate: (Database newDb, int version) async {
        await newDb.execute("""
            CREATE TABLE items
            (
            id INTEGER PRIMARY KEY, 
            type TEXT, 
            text TEXT,
            by TEXT, 
            time INTEGER,
            parent INTEGER, 
            kids BLOB,
            dead INTEGER, 
            deleted INTEGER, 
            url TEXT,
            score INTEGER,
            title TEXT,
            descendants INTEGER
          )
        """); //kids are list, store something called `BLOB` => Arbitrary big set of data.
      },
    );
  }

  Future<ItemModel?> fetchItem(int id) async {
    if (db == null) {
      print("DB is null wait for initialization...");
    }
    final maps = await db!.query(
      "items",
      columns: null,
      where: "id = ?",
      whereArgs: [id],
    );

    if (maps.length > 0) {
      return ItemModel.fromDb(maps.first);
    }

    return null;
  }

  Future<int> addItem(ItemModel item) {
    print("Inserted items at $item");
    return db!.insert(
      "items",
      item.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  // Todo - store and fetch top ids
  Future<List<int>?>? fetchTopIds() {
    return null;
  }

  Future<int> clear() {
    return db!.delete("items");
  }
}

final newsDbProvider = NewsDbProvider();
