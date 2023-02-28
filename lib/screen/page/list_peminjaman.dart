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
  late Future<List> _listBuku;
  String? _roles;
  bool _visible = false;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List> getBuku() async {
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
        // print(response.data['data']['books']);
        return response.data['data']['peminjaman'];
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
    _listBuku = getBuku();
    getRoles();
    super.initState();
  }

  void refresh() {
    setState(() {
      _listBuku = getBuku();
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
        child: FutureBuilder<List>(
          future: _listBuku,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        snapshot.data![index]['book']['judul'],
                        overflow: TextOverflow.ellipsis,
                      ),
                      subtitle: Text('Ini adalah subtitle'),
                      leading: GestureDetector(
                        child: Container(
                          child: Image.network(
                            'http://192.168.0.142:8000/storage/' +
                                snapshot.data![index]['book']['path'],
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
                              snapshot.data![index],
                            ),
                          ),
                        );
                        refresh();
                      },
                    );
                  });
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
                builder: (context) => TambahBuku(mode: FormMode.create),
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
