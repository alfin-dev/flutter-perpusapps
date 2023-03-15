import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class pinjamBuku extends StatefulWidget {
  // const pinjamBuku({ Key? key }) : super(key: key);
  final Map dataBuku;
  pinjamBuku(this.dataBuku);
  @override
  State<pinjamBuku> createState() => _pinjamBukuState();
}

class _pinjamBukuState extends State<pinjamBuku> {
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDateBack = DateTime.now();
  TextEditingController _textDateStartController = TextEditingController();
  TextEditingController _textDateEndController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _textDateStartController..text = DateFormat.yMMMd().format(_selectedDate);
  }

  _insertPeminjaman() async {
    setState(() {
      isLoading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    var _id;
    _token = prefs.getString('token').toString();
    _id = prefs.getString('idUser').toString();

    setState(() {
      _textDateStartController.text;
      _textDateEndController.text;
    });

    var params = "peminjaman/book/";
    var dio = Dio();
    var formData = FormData.fromMap({
      'id_buku': widget.dataBuku['id'].toString(),
      'id_member': _id,
      'tanggal_peminjaman': _textDateStartController.text,
      'tanggal_pengembalian': _textDateEndController.text,
      'bypass': '1'
    });

    try {
      var response = await dio.post(
        sUrl + params + widget.dataBuku['id'].toString() + '/member/' + _id,
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      if (response.data['status'] == 201) {
        final snackBar = SnackBar(
          content: Text(response.data['message'].toString()),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.pop(context);
      } else {
        final snackBar = SnackBar(
          content: Text(response.data['message']['message'].toString()),
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      print(response.data['status']);
    } catch (e) {
      print(e);
    }
  }

  _selectDate(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate != null ? _selectedDate : DateTime.now(),
      firstDate: _selectedDate,
      lastDate: _selectedDate,
    );
    if (newSelectedDate != null) {
      _selectedDate = newSelectedDate;
      _textDateStartController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _textDateStartController.text.length,
              affinity: TextAffinity.upstream),
        );
    }
  }

  _selectDateBack(BuildContext context) async {
    final DateTime? newSelectedDate = await showDatePicker(
      context: context,
      initialDate:
          _selectedDateBack != null ? _selectedDateBack : DateTime.now(),
      firstDate: _selectedDate,
      lastDate: DateTime(2040),
    );
    if (newSelectedDate != null) {
      _selectedDateBack = newSelectedDate;
      _textDateEndController
        ..text = DateFormat.yMMMd().format(_selectedDateBack)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _textDateStartController.text.length,
              affinity: TextAffinity.upstream),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Pinjam Buku',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
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
            child: Text(
              'ini adalah deskripsi dari buku 1',
              style: TextStyle(fontSize: 16),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextFormField(
                  readOnly: true,
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: _textDateStartController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Tanggal Peminjaman Buku Anda",
                    labelText: "Tanggal Peminjaman",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        _selectDate(context);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                TextFormField(
                  readOnly: true,
                  // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                  controller: _textDateEndController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Tanggal Pengembalian Buku Anda",
                    labelText: "Tanggal Pengembalian",
                    suffixIcon: IconButton(
                      icon: Icon(Icons.date_range),
                      onPressed: () {
                        _selectDateBack(context);
                      },
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  alignment: Alignment.bottomCenter,
                  child: ElevatedButton.icon(
                    style:
                        ElevatedButton.styleFrom(primary: primaryButtonColor),
                    onPressed: (isLoading)
                        ? null
                        : () async {
                            await _insertPeminjaman();
                          },
                    icon: (isLoading)
                        ? Container(
                            width: 24,
                            height: 24,
                            padding: const EdgeInsets.all(2.0),
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 3,
                            ),
                          )
                        : const Icon(Icons.playlist_add_rounded),
                    label: const Text('Pinjam Buku'),
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
