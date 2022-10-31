import 'package:flutter/material.dart';
import 'package:hospital_management_system/config/responsive.dart';
import 'package:hospital_management_system/forms/login.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  bool _isSignedUp = true;
  bool _forgottenPassword = false;

  void _toggleSignedUp(){
    setState(() {
      _isSignedUp = !_isSignedUp;
    });
  }

  void _toggleForgottenPassword(){
    setState(() {
      _forgottenPassword = !_forgottenPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      //backgroundColor: Colors.white,
      body: SizedBox(
        height: height,
        width: width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Responsive.isMobile(context) ? const SizedBox() : Expanded(
              child: Container(
                height: height,
                color: Colors.green,
                child: Center(
                  child: Text(
                    'Hospital Management System',
                    style: ralewayStyle.copyWith(
                      fontSize: 48.0,
                      color: AppColors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Container(
                height: height,
                margin: EdgeInsets.symmetric(horizontal: Responsive.isMobile(context)? height * 0.032 : height * 0.12),
                //color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: height * 0.2),
                      RichText(text: TextSpan(
                        children: [
                          TextSpan(
                            text: 'Soyez les',
                            style: ralewayStyle.copyWith(
                              fontSize: 25.0,
                              color: AppColors.blueDarkColor,
                              fontWeight: FontWeight.normal,
                            )
                          ),
                          TextSpan(
                            text: ' Bienvenues',
                            style: ralewayStyle.copyWith(
                              fontWeight: FontWeight.w800,
                              color: AppColors.blueDarkColor,
                              fontSize: 25.0,
                            ),
                          ),
                        ]
                      )
                      ),
                      SizedBox(height: height * 0.02),
                      Text('Veuillez Entrer vos details pour accéder a votre espace.',
                        style: ralewayStyle.copyWith(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textColor,
                        ),
                      ),
                      SizedBox(height: height * 0.064),

                      const LoginForm()

                    ],
                  ),
                )
              )
            )
          ],
        ),
      ),
    );
  }
}

