import 'dart:developer';

import 'package:banner_listtile/banner_listtile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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
  List _listKategori = [];
  String? _roles;
  bool _visible = false;
  int page = 1;
  String cek_prev = 'null';
  String cek_next = 'null';
  TextEditingController _searchController = TextEditingController();
  String _search = '';

  Future getKategori() async {
    setState(() {
      _listKategori = [];
    });
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

      // log(response.data.toString());
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
                  primary: primaryButtonColor,
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
                      // print(snapshot.data![index]);
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
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
                      onPressed: () {
                        page--;
                        getKategori();
                      },
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
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
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
                      onPressed: null,
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
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
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
                      onPressed: () {
                        page--;
                        getKategori();
                      },
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
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
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
                      onPressed: null,
                      child: Text('Prev'),
                    ),
                    SizedBox(width: 10),
                    ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
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
