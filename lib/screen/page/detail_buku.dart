import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/mastervariable.dart';
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
  String sinopsis =
      'Contrary to popular belief, Lorem Ipsum is not simply random text. It has roots in a piece of classical Latin literature from 45 BC, making it over 2000 years old. Richard McClintock, a Latin professor at Hampden-Sydney College in Virginia, looked up one of the more obscure Latin words, consectetur, from a Lorem Ipsum passage, and going through the cites of the word in classical literature, discovered the undoubtable source. Lorem Ipsum comes from sections 1.10.32 and 1.10.33 of "de Finibus Bonorum et Malorum" (The Extremes of Good and Evil) by Cicero, written in 45 BC. This book is a treatise on the theory of ethics, very popular during the Renaissance. The first line of Lorem Ipsum, "Lorem ipsum dolor sit amet..", comes from a line in section 1.10.32.The standard chunk of Lorem Ipsum used since the 1500s is reproduced below for those interested. Sections 1.10.32 and 1.10.33 from "de Finibus Bonorum et Malorum" by Cicero are also reproduced in their exact original form, accompanied by English versions from the 1914 translation by H. Rackham.';
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
    // String sUrl = url;
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
          title: const Text('Hapus Buku'),
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
              url + 'storage/' + widget.dataBuku['path'],
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
            margin: EdgeInsets.all(5),
            child: Text(
              sinopsis,
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
