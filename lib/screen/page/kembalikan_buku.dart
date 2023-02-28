import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:perpus_app/screen/dashboard.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class kembalikanBuku extends StatefulWidget {
  final Map dataBuku;
  kembalikanBuku(this.dataBuku);
  // const kembalikanBuku({ Key? key }) : super(key: key);

  @override
  State<kembalikanBuku> createState() => _kembalikanBukuState();
}

class _kembalikanBukuState extends State<kembalikanBuku> {
  DateTime _selectedDate = DateTime.now();
  DateTime _selectedDateBack = DateTime.now();
  TextEditingController _textDateController = TextEditingController();
  final String sUrl = "http://192.168.0.142:8000/api/";

  @override
  void initState() {
    super.initState();
    _textDateController..text = DateFormat.yMMMd().format(_selectedDate);
  }

  _insertPengembalian() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    var _id;
    _token = prefs.getString('token').toString();
    _id = prefs.getString('idUser').toString();

    setState(() {
      _textDateController.text;
    });

    var params = "peminjaman/book/";
    var dio = Dio();
    var formData = FormData.fromMap({
      'id_buku': widget.dataBuku['id'].toString(),
      'id_member': _id,
      'tanggal_pengembalian': _textDateController.text,
    });

    try {
      var response = await dio.post(
        sUrl + params + widget.dataBuku['id'].toString() + '/return',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${_token}",
          },
        ),
      );
      if (response.data['status'] == 200) {
        // log(response.data.toString());
        Navigator.of(context).pushAndRemoveUntil(
            MaterialPageRoute(builder: (c) => Dashboard()), (route) => false);
      }
      print(response.data['status']);
    } catch (e) {
      log(e.toString());
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
      _textDateController
        ..text = DateFormat.yMMMd().format(_selectedDate)
        ..selection = TextSelection.fromPosition(
          TextPosition(
              offset: _textDateController.text.length,
              affinity: TextAffinity.upstream),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Kembalikan Buku',
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
              'http://192.168.0.142:8000/storage/' +
                  widget.dataBuku['book']['path'],
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
                  controller: _textDateController,
                  decoration: InputDecoration(
                    hintText: "Masukkan Tanggal Pengembalian Buku Anda",
                    labelText: "Tanggal Pengembalian",
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
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(primary: primaryButtonColor),
                    onPressed: () async {
                      await _insertPengembalian();
                    },
                    child: Text('Kembalikan Buku'),
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
