import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/detail_profile.dart';
import 'package:perpus_app/screen/page/list_buku.dart';
import 'package:perpus_app/screen/page/kategori_buku.dart';
import 'package:perpus_app/screen/page/list_peminjaman.dart';
import 'package:perpus_app/screen/page/profile.dart';
import 'package:perpus_app/template.dart';
import 'package:perpus_app/screen/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  // String? token;
  // Dashboard({this.token});
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  Future<List>? _listBuku;
  String? _roles;
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  late List<Widget> _children;

  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _roles = prefs.getString('roles').toString();
    log(_roles.toString());
    if (_roles == 'admin') {
      setState(() {
        _children = [
          ListBuku(),
          KategoriBuku(),
          Home(),
          Profile(),
          detailProfile(),
        ];
      });
    } else {
      setState(() {
        _children = [
          ListBuku(),
          Home(),
          listPeminjaman(),
          detailProfile(),
        ];
      });
    }
  }

  @override
  void initState() {
    init();
    //  getRoles();
    // setState(() {
    //   _roles = _roles;
    // });
    super.initState();
  }

  Future init() async {
    await getRoles();
  }

  int _selectedNavbar = 2;

  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: _children[_selectedNavbar],
        bottomNavigationBar: (_roles != 'admin')
            ? Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      title: Text('List Buku'),
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(Icons.catching_pokemon),
                    //   title: Text('Kategori Buku'),
                    // ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.bookmark_added_rounded),
                      title: Text('List Peminjaman'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text('Profile'),
                    )
                  ],
                  currentIndex: _selectedNavbar,
                  selectedItemColor: Color(0xff130160),
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  onTap: _changeSelectedNavBar,
                ),
              )
            : Container(
                decoration: BoxDecoration(
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                        color: Colors.black54,
                        blurRadius: 10.0,
                        offset: Offset(0.0, 0.75))
                  ],
                ),
                child: BottomNavigationBar(
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.book),
                      title: Text('List Buku'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.catching_pokemon),
                      title: Text('Kategori Buku'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      title: Text('Home'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person_add),
                      title: Text('List User'),
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.person),
                      title: Text('Profile'),
                    )
                  ],
                  currentIndex: _selectedNavbar,
                  selectedItemColor: Color(0xff130160),
                  unselectedItemColor: Colors.grey,
                  showUnselectedLabels: true,
                  onTap: _changeSelectedNavBar,
                ),
              ));
  }
}
