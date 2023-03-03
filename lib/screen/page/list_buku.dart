import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/detail_buku.dart';
import 'package:perpus_app/screen/page/export_buku.dart';
import 'package:perpus_app/screen/page/tambah_buku.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

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
  int page = 1;
  String search = '';
  TextEditingController _searchController = TextEditingController();

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getBuku() async {
    try {
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "book/all";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? _token;
      _token = prefs.getString('token').toString();
      var dio = Dio();
      var queryParams = <String, dynamic>{
        "page": page,
      };
      var response = await dio.get(
        sUrl + params,
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      // log(response.data.toString());
      if (response.data['status'] == 200) {
        setState(() {
          progress = false;
          List temp = response.data['data']['books']['data'];
          if (temp.length != 0) {
            temp.forEach((element) => listbaru.add(element));
            page++;
          }
          log(listbaru.length.toString());
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future getBukuFiltered() async {
    try {
      setState(() {
        page = 1;
      });
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "book/all";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? _token;
      _token = prefs.getString('token').toString();
      var dio = Dio();
      var queryParams = <String, dynamic>{
        "page": page,
        "search": _searchController.text,
      };
      var response = await dio.get(
        sUrl + params,
        queryParameters: queryParams,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      if (response.data['status'] == 200) {
        setState(() {
          listbaru = [];
          progress = false;
          List temp = response.data['data']['books']['data'];
          if (temp.length != 0) {
            temp.forEach((element) => listbaru.add(element));
          }
          log(listbaru.length.toString());
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future getBukuFirst() async {
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
          listbaru = response.data['data']['books']['data'];
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future exportPdfBuku() async {
    try {
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "book/export/pdf";
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
        await launch("http://192.168.0.142:8000/" + response.data['path']);
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  Future exportExcelBuku() async {
    try {
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "book/export/excel";
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
        await launch("http://192.168.0.142:8000/" + response.data['path']);
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
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
    refreshFirst();
    getRoles();
    super.initState();
  }

  void refresh() {
    if (mounted) {
      setState(() {
        log('refresh');
        getBuku();
      });
    }
  }

  void refreshFirst() {
    setState(() {
      log('refresh first');
      listbaru = [];
      page = 1;
      getBuku();
    });
  }

  bool progress = false;
  ScrollController scrollController = ScrollController();
  bool onNotification(ScrollNotification scrollNotification) {
    if (scrollNotification is ScrollUpdateNotification) {
      if (scrollController.position.maxScrollExtent > scrollController.offset &&
          scrollController.position.maxScrollExtent - scrollController.offset <=
              9) {
        setState(() {
          progress = true;
          getBuku();
        });
        return true;
      }
    }
    return false;
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
        actions: <Widget>[
          IconButton(
            onPressed: () async {
              await exportPdfBuku();
            },
            icon: Icon(Icons.picture_as_pdf),
          ),
          IconButton(
            onPressed: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => exportBuku(),
                ),
              );
              refreshFirst();
            },
            icon: Icon(Icons.explicit_outlined),
          ),
          IconButton(
            onPressed: () async {
              exportExcelBuku();
            },
            icon: Icon(Icons.import_export),
          ),
        ],
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Container(
                  margin: EdgeInsets.all(7),
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Masukkan Judul Buku Anda",
                      labelText: "Search Judul",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.text = '';
                          });
                          refreshFirst();
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  primary: primaryButtonColor,
                  minimumSize: const Size(50, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  getBukuFiltered();
                },
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          listbaru.length == 0
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: NotificationListener(
                    onNotification: onNotification,
                    child: ListView.builder(
                        controller: scrollController,
                        itemCount: listbaru.length,
                        itemBuilder: (BuildContext context, int index) {
                          // if (listbaru.length != 10) {
                          return ListTile(
                            title: Text(
                              listbaru[index]['judul'],
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                                listbaru[index]['category']['nama_kategori']),
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
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailBuku(
                                    listbaru[index],
                                  ),
                                ),
                              );
                              refreshFirst();
                            },
                          );
                          // } else {
                          //   return const CircularProgressIndicator();
                          // }
                        }),
                  ),
                ),

          // ElevatedButton(
          //   onPressed: () {
          //     page++;
          //     getBuku();
          //   },
          //   child: Text('next'),
          // ),
          progress == true
              ? Visibility(
                  child: Center(child: CircularProgressIndicator()),
                  visible: true,
                )
              : Visibility(
                  child: Center(child: CircularProgressIndicator()),
                  visible: false,
                )
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
            refreshFirst();
          },
          backgroundColor: primaryButtonColor,
          child: Icon(Icons.add),
        ),
      ),
    );
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }
}
