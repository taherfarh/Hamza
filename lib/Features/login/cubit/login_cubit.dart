import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamza/Features/home/data/get_user_model.dart';
import 'package:hamza/Features/login/cubit/login_states.dart';
import 'package:hamza/Features/login/repo/get_user_info.dart';
import 'package:hamza/Features/login/repo/update_user_login.dart';
import 'package:hamza/Features/splash/database.dart';

class LoginCubit extends Cubit<LoginStates>{
  LoginCubit() : super(LoginInitStates());
  Dio dio=Dio();
late List<GetUserModel>   get;
late Map<String,dynamic> m;
late String phonee;
void checkuser(String phone,password) async{
emit(LoginLoading());
 
  try {
    var requst=await dio.post("https://hamzandlove.com/usersuth.php?phone=$phone&password=$password",data: {});

         List<GetUserModel> Login= await GetUserInfo().getuser(phone);
     if (requst.statusCode == 200 && requst.data == phone+password) {
      await  GetUserInfo().getuser(phone);
       if (requst.data == phone+password ) { 
      phonee=phone;
         print(requst.statusCode);
         print(Login);
         if (Login[0].login == "no") {
          UpdateUserLogin().updatauser(phone);
          localdata().inserttodatabase(phone: phone, auth: "true");
           emit(LoginSuccessfull());
         }else{
          emit(scendLogin());
         }
         
       }
     }else{
      emit(LoginErrorStates());
     }
  } catch (e) {
    print(e);
    emit(LoginErrorStates());
  }


}





}