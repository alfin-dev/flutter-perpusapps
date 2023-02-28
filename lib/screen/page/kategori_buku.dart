import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/tambah_kategori.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KategoriBuku extends StatefulWidget {
  const KategoriBuku({Key? key}) : super(key: key);

  @override
  _KategoriBukuState createState() => _KategoriBukuState();
}

class _KategoriBukuState extends State<KategoriBuku> {
  late Future<List> _listKategori;
  String? _roles;
  bool _visible = false;

  Future<List> getKategori() async {
    try {
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "category/all";
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
        return response.data['data']['categories'];
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
    return [];
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
    _listKategori = getKategori();
    getRoles();
    super.initState();
  }

  void refresh() {
    setState(() {
      _listKategori = getKategori();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Kategori Buku',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(2),
        child: FutureBuilder<List>(
          future: _listKategori,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data!.length,
                itemBuilder: (BuildContext context, int index) {
                  // print(snapshot.data![index]);
                  return ListTile(
                    title: Text(
                      snapshot.data![index]['nama_kategori'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TambahKategori(
                            mode: FormMode.edit,
                            detail: snapshot.data![index],
                          ),
                        ),
                      );
                      refresh();
                    },
                  );
                },
              );
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
      ),
      floatingActionButton: Visibility(
        visible: _visible,
        child: FloatingActionButton(
          onPressed: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TambahKategori(mode: FormMode.create),
              ),
            );
            refresh();
          },
          backgroundColor: primaryButtonColor,
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}
