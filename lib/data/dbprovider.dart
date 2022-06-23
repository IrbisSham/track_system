import 'dart:async';
import 'dart:io';

import 'package:path/path.dart'; //used to join paths
import 'package:path_provider/path_provider.dart'; //path_provider package
import 'package:score_system/model/board.dart'; //import model class
import 'package:sqflite/sqflite.dart'; //sqflite package

class BallSystDbProvider{

  Future<Database> init() async {
    Directory directory = await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path,"ballsyst.db"); //create path to database

    return await openDatabase( //open the database or create a database if there isn't any
        path,
        version: 1,
        onCreate: (Database db,int version) async {
          await db.execute("""
          CREATE TABLE Activiy(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          desc TEXT)"""
          );
          await db.execute("""
          CREATE TABLE Prize(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          desc TEXT,
          sum REAL)"""
          );
          await db.execute("""
          CREATE TABLE Person(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          family TEXT,
          secname TEXT)"""
          );
          await db.execute("""
          CREATE TABLE Board(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          fio TEXT,
          activity TEXT,
          prize TEXT,
          sum REAL)"""
          );
        });
  }

  Future<int> addBoard(Board item) async{ //returns number of items inserted as an integer
    final db = await init(); //open database
    return db.insert("Board", item.toMap(), //toMap() function from MemoModel
      conflictAlgorithm: ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
    );
  }

  Future<List<Board>> fetchBoards() async{ //returns the memos as a list (array)
    final db = await init();
    final all = await db.query("Board"); //query all the rows in a table as an array of maps

    return all.isNotEmpty ? all.map((c) => Board.fromMap(c)).toList() : [];
  }

  Future<int> deleteBoard(int id) async{ //returns number of items deleted
    final db = await init();

    int result = await db.delete(
        "Board", //table name
        where: "id = ?",
        whereArgs: [id] // use whereArgs to avoid SQL injection
    );

    return result;
  }


  Future<int> updateBoard(int id, Board item) async{ // returns the number of rows updated

    final db = await init();

    int result = await db.update(
        "Board",
        item.toMap(),
        where: "id = ?",
        whereArgs: [id]
    );
    return result;
  }

}
