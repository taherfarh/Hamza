

//import 'package:call/services/phonedio.dart';
import 'package:sqflite/sqflite.dart';
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
  /// Defines a callback that will handle all background incoming events
/// Be sure to annotate @pragma('vm:entry-point') your callback function to avoid issues in release mode on Flutter >= 3.3.0

class Datachick {
  
 static  Database? database;
  

 Future< void> creatdatapase(String name) async {
    print("rrrrrrrrrrrrrrr");
    // ignore: duplicate_ignore
    database = await openDatabase(
      '$name',
      version: 1,
      // ignore: avoid_types_as_parameter_names
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE $name(lict TEXT,name TEXT)')
            .then((value) {
          // ignore: avoid_print
          print('table created $name');
        });
        
      },
      onOpen: (database) {
        // ignore: avoid_print
        print('opend database $name');
      },
    );
  }

  Future inserttodatabase({
    required String lict,
    required String name, 
    required String videoname, 
    
  }) async {
    return await database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO $name(lict ,name) VALUES("$lict","$videoname")')
          .then((value) {
        print('$value done');
      });
    });
  }

  Future<List<Map<String, dynamic>>> getdatabase(String name) async {
    creatdatapase(name);
    List<Map<String, dynamic>>  mm= await database!.rawQuery('SELECT * FROM $name');
    return mm;
  }

  Future<void> updatadata(String name, String videoname, String lict) async {
  await database!.update(
    name,
    {"lict": lict},
    where: "name = ?",
    whereArgs: [videoname],
  );
}
   

  Future<void> deleteAllTasks() async {
    database!.delete('TASKES');
    print('delet data');
  }

}