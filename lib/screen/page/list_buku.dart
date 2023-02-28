import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/detail_buku.dart';
import 'package:perpus_app/screen/page/tambah_buku.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListBuku extends StatefulWidget {
  const ListBuku({Key? key}) : super(key: key);

  @override
  _ListBukuState createState() => _ListBukuState();
}

class _ListBukuState extends State<ListBuku> {
  late Future<List> _listBuku;
  String? _roles;
  bool _visible = false;
  List listbaru = [];
  List listbaru1 = [];
  int page = 1;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getBuku() async {
    try {
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "book/all";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? _token;
      _token = prefs.getString('token').toString();
      var dio = Dio();
      var response = await dio.get(
        sUrl + params,
        queryParameters: {
          "page": page,
        },
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );

      if (response.data['status'] == 200) {
        setState(() {
          List temp = response.data['data']['books']['data'];
          listbaru = response.data['data']['books']['data'];
          // temp.forEach((element) => listbaru.add(element));
          // listbaru1.addAll(temp);
          // log(listbaru.toString());
        });
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
    getBuku();
    // listbaru = getBuku() as List?;

    // setState(() async {
    //   listbaru = await getBuku();
    //   listbaru!.add(listbaru);
    //   log(listbaru.toString());
    // });
    // _listBuku = getBuku();
    getRoles();
    // refresh();
    super.initState();
  }

  void refresh() {
    setState(() {
      listbaru = getBuku() as List;
      listbaru.add(listbaru);
      log(listbaru.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'List Buku',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            // padding: EdgeInsets.all(2),
            child: ListView.builder(
                itemCount: listbaru.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      listbaru[index]['judul'],
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: Text('Ini adalah subtitle'),
                    leading: GestureDetector(
                      child: Container(
                        child: Image.network(
                          'http://192.168.0.142:8000/storage/' +
                              listbaru[index]['path'],
                          height: 50,
                          width: 50,
                        ),
                      ),
                    ),
                    onTap: () async {
                      // await Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => DetailBuku(
                      //       snapshot.data![index],
                      //     ),
                      //   ),
                      // );
                      refresh();
                    },
                  );
                }),
          ),
          ElevatedButton(
            onPressed: () {
              page++;
              getBuku();
            },
            child: Text('next'),
          ),
        ],
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
