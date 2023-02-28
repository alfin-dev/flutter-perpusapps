import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:perpus_app/register.dart';
import 'template.dart';
import 'package:perpus_app/screen/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Color(0xff140140),
      ),
      home: LoginPage(),
    );
  }
}

//   _logOut() async {
//   // final prefs = await SharedPreferences.getInstance();
//   prefs.setBool('slogin', false);
//   Navigator.push(
//     context,
//     PageRoute(builder: (context) => LoginPage()),
//   );
// }

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key, this.title, this.login}) : super(key: key);
  final String? title;
  final Login? login;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class Login {}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool visible = false;
  final String sUrl = "http://192.168.0.142:8000/api/";
  Login? login;
  String? _token;

  @override
  void initState() {
    super.initState();
    _cekToken();
  }

  _cekToken() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token').toString();
    print(_token!.length);
    if (_token!.length != 4) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Dashboard(),
        ),
      );
    }
  }

  _cekLogin() async {
    setState(() {
      visible = true;
      _userNameController.text;
      _passwordController.text;
    });

    var params = "login";

    var dio = Dio();
    try {
      setState(() {
        visible = false;
      });
      var response = await dio.post(sUrl + params, data: {
        'username': _userNameController.text,
        'password': _passwordController.text
      });

      final prefs = await SharedPreferences.getInstance();

      if (response.data['status'] == 200) {
        var idUser = response.data['data']['user']['id'];
        String? token = response.data['data']['token'];
        String? roles = response.data['data']['user']['roles'][0]['name'];
        print(response.data['data']['user']['roles'][0]['name']);
        await prefs.setString('idUser', idUser.toString());
        await prefs.setString('token', token.toString());
        await prefs.setString('roles', roles.toString());
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Dashboard(),
          ),
        );
      }
    } on DioError catch (e) {
      print(e);
      // _showAlertDialog(context, 'Wrong Username / Password');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome Back',
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 11),
            Text(
              'selamat datang kembali di perpusApps sekolah abcd.ac.id',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(
              height: 64,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFFFFFFF3),
                  ),
                  child: TextField(
                    controller: _userNameController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Masukkan Username Anda',
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                    ),
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  'Password',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFFFFFFFF3),
                  ),
                  child: TextField(
                    controller: _passwordController,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        contentPadding:
                            EdgeInsets.symmetric(horizontal: 16, vertical: 17),
                        suffixIcon: Icon(Icons.visibility_off)),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 24,
                          height: 24,
                          decoration: BoxDecoration(
                              color: Color(0xFFB9B9B9),
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        SizedBox(width: 10),
                        Text('Remember me',
                            style: TextStyle(
                              fontSize: 14,
                            ))
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => registerPage(),
                          ),
                        );
                      },
                      child: Text(
                        'Dont have account ?',
                        style: TextStyle(fontSize: 14, color: Colors.lightBlue),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  width: double.infinity,
                  height: 50,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: primaryButtonColor),
                    onPressed: () async {
                      await _cekLogin();
                    },
                    child: Text('LOGIN'),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    ));
  }
}
