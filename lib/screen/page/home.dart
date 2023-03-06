import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  TextEditingController _totalBuku = TextEditingController();
  TextEditingController _totalStok = TextEditingController();
  TextEditingController _totalMember = TextEditingController();
  TextEditingController _totalPegawai = TextEditingController();
  TextEditingController _totalDipinjam = TextEditingController();
  TextEditingController _totalDikembalikan = TextEditingController();
  final String sUrl = "http://192.168.0.142:8000/api/";

  Future getDashboard() async {
    try {
      var params = "book/dashboard";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? _token;
      _token = prefs.getString('token').toString();
      var dio = Dio();
      var response = await dio.get(
        sUrl + params,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      // log(response.data.toString());
      if (response.data['status'] == 200) {
        log(response.data['data']['dashboard'].toString());
        log((_totalBuku.text == '').toString());
        setState(() {
          _totalBuku.text =
              response.data['data']['dashboard']['totalBuku'].toString();
          _totalStok.text =
              response.data['data']['dashboard']['totalStok'].toString();
          _totalMember.text =
              response.data['data']['dashboard']['totalMember'].toString();
          _totalPegawai.text =
              response.data['data']['dashboard']['totalPegawai'].toString();
          _totalDipinjam.text =
              response.data['data']['dashboard']['totalDipinjam'].toString();
          _totalDikembalikan.text = response.data['data']['dashboard']
                  ['totalDikembalikan']
              .toString();
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }

  void initState() {
    super.initState();
    _totalBuku.text = '';
    _totalStok.text = '';
    _totalMember.text = '';
    _totalPegawai.text = '';
    _totalDipinjam.text = '';
    _totalDikembalikan.text = '';
    getDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/splash.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 190,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              padding: const EdgeInsets.all(30),
              crossAxisSpacing: 38,
              mainAxisSpacing: 40,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      // color: const Color(0xff9ebecb),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: const Color(0xFFD8DAF0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          FaIcon(
                            Icons.menu_book,
                            // size: 100,
                          ),
                          Text(
                            "Total Buku",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: (_totalBuku.text == '')
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryButtonColor),
                              )
                            : Text(
                                _totalBuku.text,
                                style: TextStyle(fontSize: 50),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      // color: const Color(0xff130160),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: const Color(0xFFAEB2DC),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.my_library_books),
                          Text(
                            "Total Stok",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: (_totalStok.text == '')
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryButtonColor),
                              )
                            : Text(
                                _totalStok.text,
                                style: TextStyle(fontSize: 50),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 190,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              padding: const EdgeInsets.all(30),
              crossAxisSpacing: 38,
              mainAxisSpacing: 40,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff130160),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.red[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.credit_card),
                          Text(
                            "Total Member",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: (_totalMember.text == '')
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryButtonColor),
                              )
                            : Text(
                                _totalMember.text,
                                style: TextStyle(fontSize: 50),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff130160),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.red[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.people_outline_outlined),
                          Text(
                            "Total Pegawai",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: (_totalPegawai.text == '')
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryButtonColor),
                              )
                            : Text(
                                _totalPegawai.text,
                                style: TextStyle(fontSize: 50),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 190,
            child: GridView.count(
              physics: NeverScrollableScrollPhysics(),
              primary: false,
              padding: const EdgeInsets.all(30),
              crossAxisSpacing: 38,
              mainAxisSpacing: 40,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff130160),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.red[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.collections_bookmark),
                          Text(
                            "Dipinjam",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: (_totalDipinjam.text == '')
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryButtonColor),
                              )
                            : Text(
                                _totalDipinjam.text,
                                style: TextStyle(fontSize: 50),
                              ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff130160),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.red[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(FontAwesomeIcons.book),
                          Text(
                            "Dikembalikan",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: (_totalDikembalikan.text == '')
                            ? CircularProgressIndicator(
                                valueColor: new AlwaysStoppedAnimation<Color>(
                                    primaryButtonColor),
                              )
                            : Text(
                                _totalDikembalikan.text,
                                style: TextStyle(fontSize: 50),
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
