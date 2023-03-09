import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/screen/page/detail_buku.dart';
import 'package:perpus_app/screen/page/export_buku.dart';
import 'package:perpus_app/screen/page/tambah_buku.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:banner_listtile/banner_listtile.dart';

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
  List listkategori = [];
  int page = 1;
  String search = '';
  TextEditingController _searchController = TextEditingController();
  bool endPage = false;
  bool firstLoad = true;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getBuku() async {
    try {
      var params = "book/all";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? _token;
      _token = prefs.getString('token').toString();
      var dio = Dio();
      var queryParams = <String, dynamic>{
        "page": page,
        "per_page": 9,
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
      log('page' + page.toString());
      if (response.data['status'] == 200) {
        setState(() {
          progress = false;
          firstLoad = false;
          page++;
          List temp = response.data['data']['books']['data'];
          if (temp.length != 0) {
            temp.forEach((element) => listbaru.add(element));
          }
          log(listbaru.length.toString());
          if (response.data['data']['books']['next_page_url'].toString() ==
              'null') {
            endPage = true;
          }
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }

  Future getBukuFiltered(filterkategori) async {
    log(filterkategori);
    try {
      setState(() {
        page = 1;
      });
      var params = "book/all";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? _token;
      _token = prefs.getString('token').toString();
      var dio = Dio();
      var queryParams = <String, dynamic>{
        "page": page,
        "per_page": 9,
        "search": _searchController.text,
      };
      if (filterkategori != 'null') {
        queryParams = <String, dynamic>{
          "page": page,
          "per_page": 9,
          "search": _searchController.text,
          "filter": filterkategori
        };
      }
      log(queryParams.toString());
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

  Future _getCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    var kategori = "category/all/all";
    _token = prefs.getString('token').toString();

    var dio = Dio();
    var response = await dio.get(
      sUrl + kategori,
      options: Options(
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${_token}",
        },
      ),
    );
    if (response.data['status'] == 200) {
      setState(() {
        listkategori = response.data['data']['categories'];
      });
    }
  }

  Future getBukuFirst() async {
    try {
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
        await launch(url + response.data['path']);
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
        await launch(url + response.data['path']);
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
    _getCategory();
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
    });
    getBuku();
  }

  bool progress = false;

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
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () async {
                await exportPdfBuku();
              },
              icon: new Image.asset("assets/pdf.png"),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => exportBuku(),
                  ),
                );
                refreshFirst();
              },
              icon: new Image.asset("assets/upload.png"),
            ),
          ),
          Transform.scale(
            scale: 0.8,
            child: IconButton(
              onPressed: () async {
                exportExcelBuku();
              },
              icon: new Image.asset("assets/download.png"),
            ),
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
                  getBukuFiltered('null');
                },
                icon: Icon(Icons.search),
                label: Text('Search'),
              ),
              SizedBox(
                width: 5,
              )
            ],
          ),
          Container(
            height: 32,
            margin: EdgeInsets.symmetric(horizontal: 5),
            child: ListView.builder(
              itemCount: listkategori.length,
              // This next line does the trick.
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext context, int index) {
                return Row(
                  children: [
                    Container(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: primaryButtonColor),
                        onPressed: () {
                          getBukuFiltered(listkategori[index]['id'].toString());
                        },
                        child: Text(listkategori[index]['nama_kategori']),
                      ),
                    ),
                    SizedBox(width: 5),
                  ],
                );
              },
            ),
          ),
          SizedBox(height: 5),
          (firstLoad)
              ? Center(child: CircularProgressIndicator())
              : Expanded(
                  child: LazyLoadScrollView(
                    onEndOfPage: () async {
                      if (!progress && !endPage) {
                        setState(() {
                          progress = true;
                        });
                        await getBuku();
                      }
                    },
                    child: ListView.builder(
                        itemCount: listbaru.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Column(
                              children: [
                                BannerListTile(
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
                                  bannerText: '',
                                  bannerColor: Color(0xFFE7E7E7),
                                  backgroundColor: Color(0xFFE7E7E7),
                                  borderRadius: BorderRadius.circular(8),
                                  imageContainerShapeZigzagIndex: index,
                                  imageContainer: Image(
                                      image: NetworkImage(url +
                                          'storage/' +
                                          listbaru[index]['path']),
                                      fit: BoxFit.cover),
                                  title: Text(
                                    listbaru[index]['judul'],
                                    style: TextStyle(
                                        fontSize: 20, fontWeight: bold),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 1,
                                  ),
                                  subtitle: Text(
                                    listbaru[index]['category']
                                        ['nama_kategori'],
                                    style: TextStyle(
                                      fontSize: 13,
                                    ),
                                  ),
                                  trailing: IconButton(
                                    onPressed: null,
                                    icon: Icon(
                                      Icons.arrow_forward_ios_outlined,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ),
                          );
                        }),
                  ),
                ),
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

  // @override
  // void dispose() {
  //   scrollController.dispose();
  //   super.dispose();
  // }
}
