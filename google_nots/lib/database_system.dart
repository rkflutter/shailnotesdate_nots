import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class system {
  Future<Database> initlizedata() async {
    var databasesPath = await getDatabasesPath();
    String path = join(databasesPath, 'notee.db');

    // open the database
    Database database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
      await db.execute(
          'Create table contactbook (id integer primary key Autoincrement,title Text , note Text , date Text )');
    });

    return database;
  }

  Future<List<Map>> viewdata(Database database) async {
    String qry = "select * from contactbook";
    List<Map> user = await database.rawQuery(qry);
    return user;
  }

  Future<void> insert(String title, String text, String date, Database database) async {
    String qry =
        "insert into contactbook   (title,note,date)  values('$title','$text','$date')";

    int cnt = await database.rawInsert(qry);
    print("cnt ====== $cnt");
  }
}
