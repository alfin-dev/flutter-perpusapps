import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/detail_buku.dart';
import 'package:perpus_app/screen/page/detail_peminjaman.dart';
import 'package:perpus_app/screen/page/tambah_buku.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class listPeminjaman extends StatefulWidget {
  const listPeminjaman({Key? key}) : super(key: key);

  @override
  State<listPeminjaman> createState() => _listPeminjamanState();
}

class _listPeminjamanState extends State<listPeminjaman> {
  List _listBuku = [];
  String? _roles;
  int page = 1;
  bool _visible = false;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getBuku() async {
    try {
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "peminjaman";
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

      if (response.data['status'] == 200) {
        setState(() {
          progress = false;
          List temp = response.data['data']['peminjaman']['data'];
          if (temp.length != 0) {
            temp.forEach((element) => _listBuku.add(element));
            page++;
          }
        });
        // print(response.data['data']['books']);
        // return response.data['data']['peminjaman']['data'];
      } else {
        print('Error');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  bool progress = false;
  ScrollController scrollController = ScrollController();
  bool onNotification(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              10) {
        setState(() {
          progress = true;
          getBuku();
        });
        return true;
      }
    }
    return false;
  }

  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _roles = prefs.getString('roles').toString();
      if (_roles == 'admin') _visible = true;
    });
  }

  @override
  void initState() {
    getBuku();
    getRoles();
    super.initState();
  }

  void refresh() {
    setState(() {
      getBuku();
    });
  }

  void refreshFirst() {
    setState(() {
      log('refresh first');
      _listBuku = [];
      page = 1;
      getBuku();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'List Peminjaman Buku',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(2),
        child: ListView.builder(
          itemCount: _listBuku.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                _listBuku[index]['book']['judul'],
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text('Ini adalah subtitle'),
              leading: GestureDetector(
                child: Container(
                  child: Image.network(
                    'http://192.168.0.142:8000/storage/' +
                        _listBuku[index]['book']['path'],
                    height: 50,
                    width: 50,
                  ),
                ),
              ),
              onTap: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => detailPeminjaman(
                      _listBuku[index],
                    ),
                  ),
                );
                refreshFirst();
              },
            );
          },
        ),
      ),
    );
  }
}
