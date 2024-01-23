import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/detail_profile.dart';
import 'package:perpus_app/screen/page/list_buku.dart';
import 'package:perpus_app/screen/page/kategori_buku.dart';
import 'package:perpus_app/screen/page/list_peminjaman.dart';
import 'package:perpus_app/screen/page/profile.dart';
import 'package:perpus_app/screen/page/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  // String? token;
  // Dashboard({this.token});
  @override
  _Dashboard createState() => _Dashboard();
}

class _Dashboard extends State<Dashboard> {
  String? _roles;
  List<Widget>? _children;

  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _roles = prefs.getString('roles').toString();
    log(_roles.toString());
    if (_roles == 'admin') {
      setState(() {
        _selectedNavbar = 2;
        _children = [
          ListBuku(),
          KategoriBuku(),
          Home(),
          listPeminjaman(),
          Profile(),
          detailProfile(),
        ];
      });
    } else {
      setState(() {
        _selectedNavbar = 1;
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
    super.initState();
    init();
  }

  init() async {
    await getRoles();
  }

  int _selectedNavbar = 2;

  getNav() {}
  void _changeSelectedNavBar(int index) {
    setState(() {
      _selectedNavbar = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          body: _children![_selectedNavbar],
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
                        label: 'List Buku',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bookmark_added_rounded),
                        label: 'List Peminjaman',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
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
                        label: 'List Buku',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.catching_pokemon),
                        label: 'Kategori Buku',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.bookmark_added_rounded),
                        label: 'List Peminjaman',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_add),
                        label: 'List User',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person),
                        label: 'Profile',
                      )
                    ],
                    currentIndex: _selectedNavbar,
                    selectedItemColor: Color(0xff130160),
                    unselectedItemColor: Colors.grey,
                    showUnselectedLabels: true,
                    onTap: _changeSelectedNavBar,
                  ),
                )),
    );
  }
}
