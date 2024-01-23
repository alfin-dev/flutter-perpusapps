import 'dart:convert';
import 'dart:developer';

import 'package:banner_listtile/banner_listtile.dart';
import 'package:dio/dio.dart';
import 'package:drift/drift.dart' as drift;
import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:perpus_app/database/database.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/screen/page/tambah_kategori.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class KategoriBuku extends StatefulWidget {
  const KategoriBuku({Key? key}) : super(key: key);

  @override
  _KategoriBukuState createState() => _KategoriBukuState();
}

class _KategoriBukuState extends State<KategoriBuku> {
  final database = AppDatabase();
  List _listKategori = [];
  var dataLocal;
  String? _roles;
  bool _visible = false;
  int page = 1;
  String cek_prev = 'null';
  String cek_next = 'null';
  TextEditingController _searchController = TextEditingController();
  String _search = '';

  Future<List<Category>> getAll() {
    return database.select(database.categories).get();
  }

  Future<List<Category>> getAllUnsynced() {
    return (database.select(database.categories)
          ..where((t) => t.is_sync.not() | t.is_sync.isNull()))
        .get();
  }

  test() async {
    dataLocal = await getAllUnsynced();
    var jsonData = jsonEncode(dataLocal.map((e) => e.toJson()).toList());
    log(jsonData.toString());
  }

  insert(var data) async {
    var exist = await (database.select(database.categories)
          ..where((t) => t.nama_kategori.equals(data['nama_kategori'])))
        .get();
    var jsonData = jsonEncode(exist.map((e) => e.toJson()).toList());
    log(jsonData.toString());
    if (jsonData == '[]') {
      log('disini');
      await database.into(database.categories).insert(
          CategoriesCompanion.insert(
              nama_kategori: data['nama_kategori'],
              is_sync: drift.Value.ofNullable(true)));
    }
  }

  Future getKategori() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    setState(() {
      _listKategori = [];
    });
    if (isConnected == true) {
      try {
        var params = "category/all";
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? _token;
        _token = prefs.getString('token').toString();
        var dio = Dio();
        var queryParams = <String, dynamic>{
          "page": page,
          "search": _search,
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
            cek_prev =
                response.data['data']['categories']['prev_page_url'].toString();
            cek_next =
                response.data['data']['categories']['next_page_url'].toString();
            _listKategori = response.data['data']['categories']['data'];
          });
        } else {
          print('Error');
        }
      } catch (e) {
        print(e);
      }
    } else {
      dataLocal = await getAll();
      var jsonData = jsonEncode(dataLocal.map((e) => e.toJson()).toList());
      setState(() {
        _listKategori = json.decode(jsonData);
      });
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

  syncData() async {
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    _token = prefs.getString('token').toString();
    if (isConnected == true) {
      try {
        var params = "category/all/all";
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        String? _token;
        _token = prefs.getString('token').toString();
        var dio = Dio();
        var queryParams = <String, dynamic>{
          "page": page,
          "search": _search,
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
          Iterable responseData = response.data['data']['categories'];
          for (var data in responseData) {
            log(data.toString());
            insert(data);
          }
        } else {
          print('Error');
        }
      } catch (e) {
        print(e);
      }
      dataLocal = await getAllUnsynced();
      var jsonData = jsonEncode(dataLocal.map((e) => e.toJson()).toList());
      Iterable jsonDedoced = json.decode(jsonData);
      for (var data in jsonDedoced) {
        var params = "category/create";
        var dio = Dio();
        var formData = FormData.fromMap({
          'nama_kategori': data['nama_kategori'],
        });
        try {
          var response = await dio.post(
            sUrl + params,
            data: formData,
            options: Options(
              headers: {
                "Content-Type": "application/json",
                "Authorization": "Bearer ${_token}",
              },
            ),
          );
          print(response.data['status']);
          moveImportantTasksIntoCategory(data);
        } catch (e) {
          print(e);
        }
      }
    }
  }

  Future moveImportantTasksIntoCategory(var data) async {
    return await database.update(database.categories).replace(Category(
        id: data['id'], nama_kategori: data['nama_kategori'], is_sync: true));
  }

  @override
  void initState() {
    // insert();
    // test();
    syncData();
    getKategori();
    getRoles();
    super.initState();
  }

  void refresh() {
    if (mounted) {
      setState(() {
        getKategori();
      });
    }
  }

  Future search() async {
    setState(() {
      page = 1;
      _search = _searchController.text;
      log(_search.toString());
      getKategori();
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                      hintText: "Masukkan Kategori Buku Anda",
                      labelText: "Search Kategori",
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          setState(() {
                            _searchController.text = '';
                            page = 1;
                            _search = '';
                          });
                          getKategori();
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
                  backgroundColor: primaryButtonColor,
                  minimumSize: const Size(60, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
                onPressed: () {
                  search();
                },
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          _listKategori.length == 0
              ? Center(
                  child: CircularProgressIndicator(
                  valueColor:
                      new AlwaysStoppedAnimation<Color>(primaryButtonColor),
                ))
              : Expanded(
                  child: ListView.builder(
                    itemCount: _listKategori.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            BannerListTile(
                              bannerText: '',
                              bannerColor: Color(0xFFE7E7E7),
                              backgroundColor: Color(0xFFE7E7E7),
                              title: Text(
                                _listKategori[index]['nama_kategori'],
                                overflow: TextOverflow.ellipsis,
                                style:
                                    TextStyle(fontWeight: bold, fontSize: 16),
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => TambahKategori(
                                      mode: FormMode.edit,
                                      detail: _listKategori[index],
                                    ),
                                  ),
                                );
                                refresh();
                              },
                            ),
                            SizedBox(height: 5),
                          ],
                        ),
                      );
                    },
                  ),
                ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 10,
              ),
              if (cek_prev.toString() != 'null' &&
                  cek_next.toString() != 'null')
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: () {
                        page--;
                        getKategori();
                      },
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: () {
                        page++;
                        getKategori();
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              SizedBox(
                width: 10,
              ),
              if (cek_prev.toString() == 'null' &&
                  cek_next.toString() != 'null')
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: null,
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: () {
                        page++;
                        getKategori();
                      },
                      child: Text('Next'),
                    ),
                  ],
                ),
              if (cek_prev.toString() != 'null' &&
                  cek_next.toString() == 'null')
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: () {
                        page--;
                        getKategori();
                      },
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: null,
                      child: Text('Next'),
                    ),
                  ],
                ),
              if (cek_prev.toString() == 'null' &&
                  cek_next.toString() == 'null')
                Row(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: null,
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: primaryButtonColor),
                      onPressed: null,
                      child: Text('Next'),
                    ),
                  ],
                ),
            ],
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
