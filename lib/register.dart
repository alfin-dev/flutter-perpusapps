import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/main.dart';
import 'package:perpus_app/template.dart';
import 'package:perpus_app/mastervariable.dart';

class registerPage extends StatefulWidget {
  const registerPage({Key? key}) : super(key: key);

  @override
  State<registerPage> createState() => _registerPageState();
}

class _registerPageState extends State<registerPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _retypePasswordController =
      TextEditingController();
  bool visible = false;
  Login? login;

  @override
  void initState() {
    super.initState();
  }

  _cekLogin() async {
    setState(() {
      visible = true;
      _nameController.text;
      _userNameController.text;
      _passwordController.text;
      _retypePasswordController.text;
    });

    var params = "register";

    var dio = Dio();
    try {
      setState(() {
        visible = false;
      });
      var response = await dio.post(sUrl + params, data: {
        'name': _nameController.text,
        'username': _userNameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'confirm_password': _retypePasswordController.text,
      });

      if (response.data['status'] == 200) {
        _submit(context);
      }
    } on DioError catch (e) {
      print(e);
      // _showAlertDialog(context, 'Wrong Username / Password');
    }
  }

  void _submit(BuildContext context) {
    AlertDialog alert = AlertDialog(
      title: Text("Registrasi Berhasil"),
      content: Container(
        child: Text("Selamat Anda Registrasi"),
      ),
      actions: [
        TextButton(
          child: Text('Ok'),
          onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (c) => LoginPage()), (route) => false),
        ),
      ],
    );

    showDialog(context: context, builder: (context) => alert);
    return;
  }

  bool showpass = false;
  void showPassword() {
    setState(() {
      if (showpass) {
        showpass = false;
      } else {
        showpass = true;
      }
    });
  }

  bool showretypepass = false;
  void showRetypePassword() {
    setState(() {
      if (showretypepass) {
        showretypepass = false;
      } else {
        showretypepass = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundPrimary,
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Image.asset("assets/splash.png"),
                  Text(
                    'Register Perpus Apps',
                    style: TextStyle(fontSize: 30, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 11),
                  Text(
                    'silahkan melakukan pendaftaran untuk dapat mengakses perpusApps sekolah abcd.ac.id',
                    style: TextStyle(fontSize: 14),
                  ),
                  SizedBox(
                    height: 60,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text(
                        'Name',
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
                          controller: _nameController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Masukkan Nama Anda',
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 17),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
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
                        'Email',
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
                          controller: _emailController,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Masukkan Email Anda',
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
                          obscureText: showpass ? false : true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 17),
                            suffixIcon: IconButton(
                              onPressed: () {
                                showPassword();
                              },
                              icon: showpass
                                  ? Icon(
                                      Icons.visibility,
                                      color: primaryButtonColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: primaryButtonColor,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 15),
                      Text(
                        'Re-type Password',
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
                          controller: _retypePasswordController,
                          obscureText: showretypepass ? false : true,
                          enableSuggestions: false,
                          autocorrect: false,
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                                horizontal: 16, vertical: 17),
                            suffixIcon: IconButton(
                              onPressed: () {
                                showRetypePassword();
                              },
                              icon: showretypepass
                                  ? Icon(
                                      Icons.visibility,
                                      color: primaryButtonColor,
                                    )
                                  : Icon(
                                      Icons.visibility_off,
                                      color: primaryButtonColor,
                                    ),
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => LoginPage(),
                                ),
                              );
                            },
                            child: Text(
                              'Have account ?',
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
                              foregroundColor: primaryButtonColor),
                          onPressed: () async {
                            await _cekLogin();
                          },
                          child: Text('Register'),
                        ),
                      ),
                      SizedBox(height: 20),
                    ],
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
