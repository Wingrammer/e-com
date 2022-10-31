

import 'dart:convert';

import 'package:encrypted_shared_preferences/encrypted_shared_preferences.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/auth/user_gateway.dart';
import 'package:flutter/cupertino.dart';
import 'package:hospital_management_system/firebase_options.dart';
import 'package:hospital_management_system/providers/token_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier{
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  final EncryptedSharedPreferences encryptedSharedPreferences =
  EncryptedSharedPreferences();

  final Future<PreferencesStore> _authprefs = PreferencesStore.create();

  late Map<String, dynamic> _currentUser = {};
  User? _user;
  late Map<String, dynamic> _token = {};
  late bool _isSignedIn = false;
  bool _loadedResources = false;
  final String _apikey = DefaultFirebaseOptions.web.apiKey;

  Map<String, dynamic> get currentUser => _currentUser;
  User? get user => _user;

  bool get isSignedIn => _isSignedIn;
  Map<String, dynamic> get token => _token;
  bool get loadedResources => _loadedResources;

  AuthProvider(){
     /*_prefs.then((SharedPreferences prefs) {
      Map<String, dynamic> userPrefs = {};
      try{
        if(prefs.getString('user')!.isNotEmpty){
          print(prefs.getString('user'));
          userPrefs = jsonDecode('${prefs.getString('user')}');
        }
      } catch(e) {
        print('Could not fetch user string from persistence storage. ${e.toString()}');
      }
      _currentUser = userPrefs;

    });*/
    _authprefs.then((authprefs){
      var firebaseAuth = FirebaseAuth(_apikey, authprefs);
      firebaseAuth.getUser().then((value){
        _user = value;
        _currentUser = value.toMap();
      });
      _isSignedIn = firebaseAuth!.isSignedIn;
      _token = authprefs.read()!.toMap();
    });
  }

  void setCurrentUser(user) {
    _currentUser = user;
    _prefs.then(
            (SharedPreferences prefs) => prefs.setString('user', jsonEncode(user))
                .then((value) => 1)
                .catchError((e) => 1)
    );
    notifyListeners();
  }

  set token(newToken) => _token = newToken;

  void setLoadedResources(){
    _loadedResources = true;
  }

  Future<User> login(email, password) async {
    var firebaseAuth = FirebaseAuth(_apikey, await PreferencesStore.create());

    await firebaseAuth.signIn(email, password);
    var user = await firebaseAuth.getUser();
    _isSignedIn = firebaseAuth.isSignedIn;
    setCurrentUser(user.toMap());
    return user;
  }

  void logout() async {
    var firebaseAuth = FirebaseAuth(_apikey, await PreferencesStore.create());
    firebaseAuth.signOut();
    _isSignedIn = firebaseAuth.isSignedIn;
    notifyListeners();
  }

}