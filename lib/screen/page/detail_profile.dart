import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/main.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class detailProfile extends StatefulWidget {
  const detailProfile({Key? key}) : super(key: key);

  @override
  State<detailProfile> createState() => _detailProfileState();
}

class _detailProfileState extends State<detailProfile> {
  String? _name = 'Name';
  String? _email = 'mail@example.com';

  Future<Map> _getDetail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    var _id;
    _token = prefs.getString('token').toString();
    _id = prefs.getString('idUser').toString();

    var params = "user/";
    var dio = Dio();
    try {
      var response = await dio.get(
        sUrl + params + _id,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      if (response.data['status'] == 200) {
        setState(() {
          _name = response.data['data']['user']['name'];
          _email = response.data['data']['user']['email'];
        });
      }
    } catch (e) {
      print(e);
    }
    return {};
  }

  _logOut() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final success = await prefs.remove('token');
    print(success);
    if (success == true)
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
  }

  @override
  void initState() {
    _getDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Detail Profile',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: 10,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Icon(
                Icons.person,
                size: 200,
              ),
            ),
            Container(
              child: Text(
                _name!,
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Container(
              child: Text(
                _email!,
                style: TextStyle(fontSize: 12),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _logOut();
        },
        backgroundColor: deleteColor,
        child: Icon(Icons.login_outlined),
      ),
    );
  }
}
