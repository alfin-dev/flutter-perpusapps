import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/screen/page/kembalikan_buku.dart';
import 'package:perpus_app/screen/page/pinjam_buku.dart';
import 'package:perpus_app/screen/page/tambah_buku.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class detailPeminjaman extends StatefulWidget {
  final Map dataBuku;
  detailPeminjaman(this.dataBuku);
  // const detailPeminjaman({ Key? key }) : super(key: key);

  @override
  State<detailPeminjaman> createState() => _detailPeminjamanState();
}

class _detailPeminjamanState extends State<detailPeminjaman> {
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
          'Detail Peminjaman',
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
              url + 'storage/' + widget.dataBuku['book']['path'],
              width: 200,
              height: 250,
            ),
          ),
          Container(
            child: Text(
              widget.dataBuku['book']['judul'],
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
                if (widget.dataBuku['status'].toString() != '3')
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(primary: primaryButtonColor),
                      onPressed: () async {
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                kembalikanBuku(widget.dataBuku),
                          ),
                        );
                      },
                      child: Text('Kembalikan Buku'),
                    ),
                  ),
                if (widget.dataBuku['status'].toString() == '3')
                  Container(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'Pengembalian : ' +
                          widget.dataBuku['tanggal_pengembalian'],
                      style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
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
