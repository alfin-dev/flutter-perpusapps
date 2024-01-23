import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:drift/drift.dart' as drift;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:perpus_app/database/database.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FormMode { create, edit }

class TambahKategori extends StatefulWidget {
  final FormMode mode;
  final Map? detail;
  TambahKategori({Key? key, required this.mode, this.detail}) : super(key: key);

  @override
  State<TambahKategori> createState() => _TambahKategoriState();
}

class _TambahKategoriState extends State<TambahKategori> {
  final database = AppDatabase();
  final TextEditingController _kategoriController = TextEditingController();
  final TextEditingController _idKategoriController = TextEditingController();
  late String? nama_kategori;

  _insertKategori() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final bool isConnected = await InternetConnectionChecker().hasConnection;
    String? _token;
    _token = prefs.getString('token').toString();
    if (isConnected == true) {
      setState(() {
        _kategoriController.text;
      });

      if (widget.mode == FormMode.create) {
        var params = "category/create";
        var dio = Dio();
        var formData = FormData.fromMap({
          'nama_kategori': _kategoriController.text,
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
          if (response.data['status'] == 201) {
            Navigator.pop(context);
          }
          print(response.data['status']);
        } catch (e) {
          print(e);
        }
      }
    } else {
      await database.into(database.categories).insert(
          CategoriesCompanion.insert(
              nama_kategori: _kategoriController.text,
              is_sync: drift.Value.ofNullable(false)));
      Navigator.pop(context);
    }

    if (widget.mode == FormMode.edit) {
      nama_kategori = widget.detail!['nama_kategori'];
      var params = "category/update/";
      var dio = Dio();
      var formData = FormData.fromMap({
        'nama_kategori': _kategoriController.text,
      });
      try {
        var response = await dio.post(
          sUrl + params + _idKategoriController.text,
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${_token}",
            },
          ),
        );
        if (response.data['status'] == 200) {
          Navigator.pop(context);
        }
        print(response.data['status']);
      } catch (e) {
        print(e);
      }
    }
  }

  _delete() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    _token = prefs.getString('token').toString();

    var params = "/delete";
    var dio = Dio();
    try {
      var response = await dio.delete(
        sUrl + 'category/' + _idKategoriController.text + params,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      if (response.data['status'] == 200) {
        Navigator.pop(context);
      }
    } catch (e) {}
  }

  @override
  void initState() {
    super.initState();
    if (widget.mode == FormMode.edit) {
      print(widget.detail);
      _idKategoriController.text = widget.detail!['id'].toString();
      _kategoriController.text = widget.detail!['nama_kategori'];
    }
  }

  Future<void> _showDelete() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Hapus Kategori'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('Apakah anda yakin ingin menghapus data ini ?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hapus'),
              onPressed: () async {
                await _delete();
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == FormMode.create ? 'Tambah Kategori' : 'Edit Kategori',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          if (widget.mode == FormMode.edit)
            IconButton(
              onPressed: () async {
                await _showDelete();
              },
              icon: Icon(Icons.delete),
            ),
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              TextFormField(
                controller: _kategoriController,
                decoration: InputDecoration(
                  hintText: "Masukkan Nama Kategori",
                  labelText: "Nama Kategori",
                  suffixIcon: Icon(Icons.category),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: primaryButtonColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(primary: primaryButtonColor),
                  onPressed: () async {
                    await _insertKategori();
                  },
                  child: Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
