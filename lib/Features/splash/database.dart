

//import 'package:call/services/phonedio.dart';
import 'package:sqflite/sqflite.dart';
// Be sure to annotate your callback function to avoid issues in release mode on Flutter >= 3.3.0
  /// Defines a callback that will handle all background incoming events
/// Be sure to annotate @pragma('vm:entry-point') your callback function to avoid issues in release mode on Flutter >= 3.3.0

class localdata {
  static Database? database;
  

 Future< void> creatdatapase() async {
    print("rrrrrrrrrrrrrrr");
    // ignore: duplicate_ignore
    database = await openDatabase(
      'data',
      version: 1,
      // ignore: avoid_types_as_parameter_names
      onCreate: (database, version) {
        database
            .execute(
                'CREATE TABLE login(phone TEXT,auth TEXT)')
            .then((value) {
          // ignore: avoid_print
          print('table created');
        });
      },
      onOpen: (database) {
        // ignore: avoid_print
        print('opend database');
      },
    );
  }

  Future inserttodatabase({
    required String phone,
    required String auth,
    
  }) async {
    return await database!.transaction((txn) {
      return txn
          .rawInsert(
              'INSERT INTO login(phone ,auth) VALUES("$phone","$auth")')
          .then((value) {
        print('$value done');
      });
    });
  }

  Future<List<Map<String, dynamic>>> getdatabase() async {
    creatdatapase();
    List<Map<String, dynamic>>  mm= await database!.rawQuery('SELECT * FROM login');
    return mm;
  }
  Future<void> updatadata(String auth,phone) async {
    database!.update("login", {"auth" : auth ,},where: "phone = $phone");
  }
   

  Future<void> deleteAllTasks() async {
    database!.delete('TASKES');
    print('delet data');
  }

}