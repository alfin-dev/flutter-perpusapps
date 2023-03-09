import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/register.dart';
// import 'package:rounded_loading_button/rounded_loading_button.dart';
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
        primaryColor: Color(0xFFFFFFFF),
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
  // final RoundedLoadingButtonController _btnController =
  //     RoundedLoadingButtonController();
  bool visible = false;
  Login? login;
  String? _token;

  @override
  void initState() {
    // _btnController.stateStream.listen((value) {
    //   print(value);
    // });
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
      log(response.data.toString());
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
      } else {
        final snackBar = SnackBar(
          content: Text(response.data['message'].toString()),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } on DioError catch (e) {
      print(e);
      // _showAlertDialog(context, 'Wrong Username / Password');
    }
  }

  bool show = false;
  void showPassword() {
    setState(() {
      if (show) {
        show = false;
      } else {
        show = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundPrimary,
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 64,
                  ),
                  Image.asset("assets/splash.png"),
                  Text(
                    'Welcome',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 11),
                  Text(
                    'selamat datang kembali di Perpus Apps sekolah abcd.ac.id',
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
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
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
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 17),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Password',
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
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
                          obscureText: show ? true : false,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            hintText: 'Masukkan Password Anda',
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 17),
                            suffixIcon: IconButton(
                              onPressed: () {
                                showPassword();
                              },
                              icon: show
                                  ? Icon(
                                      Icons.visibility_off,
                                      color: primaryButtonColor,
                                    )
                                  : Icon(
                                      Icons.visibility,
                                      color: primaryButtonColor,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // Row(
                          //   children: [
                          //     Container(
                          //       width: 24,
                          //       height: 24,
                          //       decoration: BoxDecoration(
                          //           color: Color(0xFFB9B9B9),
                          //           borderRadius: BorderRadius.circular(5)),
                          //     ),
                          //     SizedBox(width: 10),
                          //     Text('Remember me',
                          //         style: TextStyle(
                          //           fontSize: 14,
                          //         ))
                          //   ],
                          // ),
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
                              style: TextStyle(
                                  fontSize: 14, color: primaryButtonColor),
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
                          style: ElevatedButton.styleFrom(
                              primary: primaryButtonColor),
                          onPressed: () async {
                            await _cekLogin();
                          },
                          child: Text('LOGIN'),
                        ),
                      ),
                      //                 RoundedLoadingButton(
                      //                   color: Colors.amber,
                      //                   successColor: Colors.amber,
                      //                   controller: _btnController,
                      //                   onPressed: () {},
                      //                   valueColor: Colors.black,
                      //                   borderRadius: 10,
                      //                   child: Text(
                      //                     '''
                      // Tap me i have a huge text''',
                      //                     style: TextStyle(color: Colors.white),
                      //                   ),
                      //                 ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
