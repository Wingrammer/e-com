import 'package:flutter/material.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Form(
        key: _formKey,
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Email',
                  style: ralewayStyle.copyWith(
                    fontSize: 12.0,
                    color: AppColors.blueDarkColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                height: 50.0,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.whiteColor,
                ),
                child: TextFormField(

                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueDarkColor,
                    fontSize: 15.0,
                  ),

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: IconButton(
                      onPressed: (){},
                      icon: Image.asset('assets/email.png'),
                    ),
                    contentPadding: const EdgeInsets.only(top: 16.0),
                    hintText: 'Entrer votre Email',
                    hintStyle: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueDarkColor.withOpacity(0.5),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.014),
              Padding(
                padding: const EdgeInsets.only(left: 16.0),
                child: Text('Mot de Passe',
                  style: ralewayStyle.copyWith(
                    fontSize: 15.0,
                    color: AppColors.blueDarkColor,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(height: 6.0),
              Container(
                height: 50.0,
                width: width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.whiteColor,
                ),
                child: TextFormField(

                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueDarkColor,
                    fontSize: 15.0,
                  ),
                  obscureText: true,

                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: (){},
                      icon: Image.asset('assets/eye.png'),
                    ),
                    prefixIcon: IconButton(
                      onPressed: (){},
                      icon: Image.asset('assets/lock.png'),
                    ),
                    contentPadding: const EdgeInsets.only(top: 16.0),
                    hintText: 'Entrer votre mot de Passe',
                    hintStyle: ralewayStyle.copyWith(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blueDarkColor.withOpacity(0.5),
                      fontSize: 15.0,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.03),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){},
                  child: Text('Forgot Password?',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: AppColors.mainBlueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              SizedBox(height: height * 0.05),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){},
                  borderRadius: BorderRadius.circular(16.0),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.mainBlueColor,
                    ),
                    child: Text('Sign In',
                      style: ralewayStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppColors.whiteColor,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              )
            ]));
  }
}