import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamza/Features/home/cubit/get_user_states.dart';
import 'package:hamza/Features/home/data/get_user_model.dart';

class GetCoursesCubit extends Cubit<GetCourseStates> {
  GetCoursesCubit() : super(GetCourseinitState());

  Dio dio = Dio();
  late List<GetUserModel> get=[];
  Future<List<GetUserModel>> getuser(String phone) async {
    emit(GetCourseloading());
    try {
      var respon = await dio.get(
          "https://hamzandlove.com/getusercourses.php?phone=$phone");

      if (respon.statusCode == 200 && respon.data is List) {
        get = (respon.data as List)
            .map((userJson) => GetUserModel.fromJson(userJson))
            .toList();
        emit(GetCourseSuccessful());
        // Parse the list of users
        return (respon.data as List)
            .map((userJson) => GetUserModel.fromJson(userJson))
            .toList();
      } else {
        emit(GetCourseError());
        return [];

        // Return an empty list in case of error
      }
    } catch (e) {
      emit(GetCourseError());
      print("Error occurred: $e");
      return []; // Return an empty list in case of exception
    }
  }
}
