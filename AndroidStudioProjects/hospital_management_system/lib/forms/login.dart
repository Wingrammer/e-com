import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:firedart/firedart.dart';
import 'package:flutter/material.dart';
import 'package:hospital_management_system/apiclient.dart';
import 'package:hospital_management_system/firebase_options.dart';
import 'package:hospital_management_system/providers/auth_provider.dart';
import 'package:hospital_management_system/providers/token_preferences.dart';
import 'package:hospital_management_system/style/colors.dart';
import 'package:hospital_management_system/style/style.dart';
import 'package:provider/provider.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {

  final _formKey = GlobalKey<FormState>();
  bool _visiblePassword = false;
  bool _emailValid = false;

  void _updateEmailValid(){
    setState(() {
      _emailValid = RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+").hasMatch(emailController.text);
    });
  }

  void _toggleVisiblePassword(){
    setState(() {
      _visiblePassword = !_visiblePassword;
    });
  }

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

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
                  controller: emailController,
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueDarkColor,
                    fontSize: 15.0,
                  ),
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: const Icon(Icons.mail),
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
                  controller: passwordController,
                  style: ralewayStyle.copyWith(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blueDarkColor,
                    fontSize: 15.0,
                  ),
                  obscureText: !_visiblePassword,
                  validator: (value){
                    if (value == null || value.isEmpty) {
                      return 'Ce champ est obligatoire';
                    }
                    return null;
                  },
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    suffixIcon: IconButton(onPressed: (){_toggleVisiblePassword();}, icon: Icon(_visiblePassword ? Icons.visibility_off : Icons.visibility)),
                    prefixIcon: const Icon(Icons.lock),
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
              _emailValid ? Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Traitement en cours')
                      ),
                    );
                    Client().getResetLink(emailController.text)
                    .then((value) => null, onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          backgroundColor: Colors.green,
                          content: Text('Une erreur est survenue: ${e.toString()}')
                      ),
                    )).catchError((e){
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('Une erreur est survenue: ${e.toString()}')
                        ),
                      );
                      return null;
                    });
                  },
                  child: Text('Mot de Passe oublié?',
                    style: ralewayStyle.copyWith(
                      fontSize: 12.0,
                      color: AppColors.mainBlueColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ):const SizedBox(),

              SizedBox(height: height * 0.05),
              Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: (){
                    if (_formKey.currentState!.validate()) {

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          backgroundColor: Colors.green,
                            content: Text('Traitement en cours')
                        ),
                      );
                      Provider.of<AuthProvider>(context, listen:false).login(emailController.text, passwordController.text)
                          .then(
                              (user) => Provider.of<AuthProvider>(context, listen: false).setCurrentUser(user.toMap()),
                          onError: (e) => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                                backgroundColor: Colors.green,

                                content: Text('Une erreur est survenue: ${e.toString()}')
                            ),
                          )
                      ).catchError((e) => ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            backgroundColor: Colors.green,

                            content: Text('Une erreur est survenue: ${e.toString()}')
                        ),
                      ));
                    }
                  },
                  borderRadius: BorderRadius.circular(16.0),
                  child: Ink(
                    padding: const EdgeInsets.symmetric(horizontal: 70.0, vertical: 18.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16.0),
                      color: AppColors.mainBlueColor,
                    ),
                    child: Text('Se Connecter',
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