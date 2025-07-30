import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamza/Features/video%20List/cubit/List_States.dart';
import 'package:hamza/Features/video%20List/data/Video%20List%20model.dart';

class ListCubit extends Cubit<ListStates>{
  ListCubit() :super(InitListStates());
  var dio=Dio();

 late List<VideoListModel>   get;


Future<List<VideoListModel>> getuser(String coursename) async {
  emit(LoadingListStates());
  try {
    print("mmmmmmmmmmmmmmmmm");
    var respon = await dio.get("https://hamzandlove.com/$coursename.php");
    print(respon.statusCode);
    if (respon.statusCode == 200 && respon.data is List) {
      emit(SuccessfulListStates());
      get=(respon.data as List)
          .map((userJson) => VideoListModel.fromJson(userJson))
          .toList();
      // Parse the list of users
      return (respon.data as List)
          .map((userJson) => VideoListModel.fromJson(userJson))
          .toList();
    } else {
      emit(ErrorListStates());
      return []; // Return an empty list in case of error
    }
  } catch (e) {
    print("Error occurred: $e");
    emit(ErrorListStates());
    return []; // Return an empty list in case of exception
  }
}
}