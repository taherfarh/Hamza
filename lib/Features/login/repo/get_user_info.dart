import 'package:dio/dio.dart';
import 'package:hamza/Features/home/data/get_user_model.dart';

class GetUserInfo {
  
 Dio dio=Dio();
late List<GetUserModel>   get;
Future<List<GetUserModel>> getuser(String phone) async {
  try {
    var respon = await dio.get("https://hamzandlove.com/getusercourses.php?phone=$phone");
   
    if (respon.statusCode == 200 && respon.data is List) {
      get=(respon.data as List)
          .map((userJson) => GetUserModel.fromJson(userJson))
          .toList();
      // Parse the list of users
      return (respon.data as List)
          .map((userJson) => GetUserModel.fromJson(userJson))
          .toList();
    } else {
      return []; // Return an empty list in case of error
    }
  } catch (e) {
    print("Error occurred: $e");
    return []; // Return an empty list in case of exception
  }
}
}