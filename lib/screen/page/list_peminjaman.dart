import 'dart:developer';

import 'package:banner_listtile/banner_listtile.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/screen/page/detail_peminjaman.dart';
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
  bool endPage = false;
  bool progress = false;
  bool firstLoad = true;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getBuku() async {
    try {
      var params = "peminjaman";
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

      if (response.data['status'] == 200) {
        setState(() {
          firstLoad = false;
          progress = false;
          List temp = response.data['data']['peminjaman']['data'];
          if (temp.length != 0) {
            temp.forEach((element) => _listBuku.add(element));
            page++;
          }
          if (response.data['data']['peminjaman']['next_page_url'].toString() ==
              'null') {
            endPage = true;
          }
        });
      } else {
        print('Error');
      }
    } catch (e) {
      log(e.toString());
    }
  }

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
    refreshFirst();
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
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: (firstLoad)
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
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
                      itemCount: _listBuku.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 5),
                          child: Column(
                            children: [
                              SizedBox(height: 7),
                              BannerListTile(
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
                                bannerText: '',
                                bannerColor: Color(0xFFE7E7E7),
                                backgroundColor: Color(0xFFE7E7E7),
                                borderRadius: BorderRadius.circular(8),
                                imageContainerShapeZigzagIndex: index,
                                imageContainer: Image(
                                    image: NetworkImage(url +
                                        'storage/' +
                                        _listBuku[index]['book']['path']),
                                    fit: BoxFit.cover),
                                title: Text(
                                  _listBuku[index]['book']['judul'],
                                  style:
                                      TextStyle(fontSize: 20, fontWeight: bold),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                subtitle: Text(
                                  _listBuku[index]['tanggal_peminjaman'] +
                                      ' - ' +
                                      _listBuku[index]['tanggal_pengembalian'],
                                  style: TextStyle(
                                    fontSize: 13,
                                  ),
                                  maxLines: 1,
                                ),
                                trailing: IconButton(
                                  onPressed: null,
                                  icon: Icon(
                                    Icons.arrow_forward_ios_outlined,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                Visibility(
                  child: Center(child: CircularProgressIndicator()),
                  visible: progress == true ? true : false,
                )
              ],
            ),
    );
  }
}
