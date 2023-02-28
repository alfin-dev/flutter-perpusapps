import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/pinjam_buku.dart';
import 'package:perpus_app/screen/page/tambah_buku.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DetailBuku extends StatefulWidget {
  // const DetailBuku({Key? key}) : super(key: key);
  final Map dataBuku;
  DetailBuku(this.dataBuku);

  @override
  _DetailBukuState createState() => _DetailBukuState();
}

class _DetailBukuState extends State<DetailBuku> {
  String? _roles;
  getRoles() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _roles = prefs.getString('roles').toString();
    });
  }

  @override
  void initState() {
    super.initState();
    getRoles();
  }

  _delete() async {
    final String sUrl = "http://192.168.0.142:8000/api/";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    var _id;
    _token = prefs.getString('token').toString();
    _id = widget.dataBuku['id'];

    var params = "/delete";
    var dio = Dio();
    try {
      var response = await dio.delete(
        sUrl + 'book/' + _id.toString() + params,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      print(response.data);
      if (response.data['status'] == 200) {
        // print('sukses');
        Navigator.pop(context);
      }
    } catch (e) {
      print(e);
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
    double _screen = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Book Detail',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          if (_roles == 'admin')
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TambahBuku(
                        mode: FormMode.edit, detail: widget.dataBuku),
                  ),
                );
              },
              icon: Icon(Icons.edit),
            ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: Image.network(
              'http://192.168.0.142:8000/storage/' + widget.dataBuku['path'],
              width: 200,
              height: 250,
            ),
          ),
          Container(
            child: Text(
              widget.dataBuku['judul'],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              widget.dataBuku['category']['nama_kategori'],
              style: TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            child: Text(
              'ini adalah deskripsi dari buku 1',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: primaryButtonColor),
                    onPressed: () async {
                      await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => pinjamBuku(widget.dataBuku),
                        ),
                      );
                    },
                    child: Text('Pinjam Buku'),
                  ),
                ),
                if (_roles == 'admin')
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: deleteColor),
                      onPressed: () async {
                        await _showDelete();
                      },
                      child: Text('Hapus Buku'),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }
}
