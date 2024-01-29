import 'dart:developer';
import 'dart:io';
import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/template.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum FormMode { create, edit }

class TambahBuku extends StatefulWidget {
  final FormMode mode;
  final Map? detail;
  const TambahBuku({Key? key, required this.mode, this.detail})
      : super(key: key);

  @override
  State<TambahBuku> createState() => _TambahBukuState();
}

class _TambahBukuState extends State<TambahBuku> {
  late Future<List> _listCategory;
  final TextEditingController _idBukuController = TextEditingController();
  final TextEditingController _judulController = TextEditingController();
  final TextEditingController _pengarangController = TextEditingController();
  final TextEditingController _tahunTerbitController = TextEditingController();
  final TextEditingController _stokController = TextEditingController();
  var params = "book/create";
  var kategori = "category/all/all";
  var file;
  bool loading = false;
  // Initial Selected Value
  String? _dropdownValue;
  // var year = DateTime.now();

  // Gambar upload
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var img = await picker.pickImage(source: media);
    setState(() {
      image = img;
      // file = File(img!.path);
      log(image!.path.toString());
    });
  }

  Future<List> _getCategory() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
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
    return response.data['data']['categories'];
  }

  _insertBuku() async {
    setState(() {
      loading = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? _token;
    _token = prefs.getString('token').toString();
    setState(() {
      _judulController.text;
      _pengarangController.text;
      _tahunTerbitController.text;
      _stokController.text;
      // print(_tahunTerbitController.text);
    });

    var dio = Dio();
    if (widget.mode == FormMode.create) {
      FormData formData = FormData.fromMap({
        'judul': _judulController.text,
        'category_id': _dropdownValue,
        'pengarang': _pengarangController.text,
        'tahun': _tahunTerbitController.text,
        'stok': _stokController.text,
        'path':
            image != null ? await MultipartFile.fromFile(image!.path) : null,
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
          setState(() {
            loading = false;
          });
          Navigator.pop(context);
        }
        print(response.data['status']);
      } catch (e) {
        print(e);
      }
    }

    if (widget.mode == FormMode.edit) {
      var params = "/update";
      // var formData;
      var formData = FormData.fromMap({
        'judul': _judulController.text,
        'category_id': _dropdownValue,
        'pengarang': _pengarangController.text,
        'tahun': _tahunTerbitController.text,
        'stok': _stokController.text,
        // 'path':
        //     image != null ? await MultipartFile.fromFile(image!.path) : null,
      });
      if (image != null) {
        formData = FormData.fromMap({
          'judul': _judulController.text,
          'category_id': _dropdownValue,
          'pengarang': _pengarangController.text,
          'tahun': _tahunTerbitController.text,
          'stok': _stokController.text,
          'path':
              image != null ? await MultipartFile.fromFile(image!.path) : null,
        });
      }

      try {
        var response = await dio.post(
          sUrl + 'book/' + _idBukuController.text + params,
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "application/json",
              "Authorization": "Bearer ${_token}",
            },
          ),
        );
        log(response.toString());
        if (response.data['status'] == 200) {
          Navigator.of(context)
            ..pop()
            ..pop();
        }
        print(response.data['status']);
      } catch (e) {
        log(e.toString());
      }
    }
  }

  //show popup dialog
  void myAlert() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Pilih cover buku'),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          content: ElevatedButton(
            style:
                ElevatedButton.styleFrom(foregroundColor: primaryButtonColor),
            //if user click this button, user can upload image from gallery
            onPressed: () {
              Navigator.pop(context);
              getImage(ImageSource.gallery);
            },
            child: Row(
              children: [
                Icon(Icons.image),
                Text('From Gallery'),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void initState() {
    _listCategory = _getCategory();
    if (widget.mode == FormMode.edit) {
      _idBukuController.text = widget.detail!['id'].toString();
      _judulController.text = widget.detail!['judul'].toString();
      _dropdownValue = widget.detail!['category_id'].toString();
      _pengarangController.text = widget.detail!['pengarang'].toString();
      _tahunTerbitController.text = widget.detail!['tahun'].toString();
      _stokController.text = widget.detail!['stok'].toString();
      // _idKategoriController.text = widget.detail!['id'].toString();
      // _kategoriController.text = widget.detail!['nama_kategori'];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mode == FormMode.create ? 'Tambah Buku' : 'Edit Buku',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 7),
          child: Column(
            children: <Widget>[
              SizedBox(height: 10),
              TextFormField(
                controller: _judulController,
                decoration: InputDecoration(
                  hintText: "Masukkan Judul Buku Anda",
                  labelText: "Judul Buku",
                  suffixIcon: Icon(Icons.book),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide: BorderSide(
                      color: primaryButtonColor,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _pengarangController,
                decoration: InputDecoration(
                  hintText: "Masukkan Pengarang Buku Anda",
                  labelText: "Pengarang Buku",
                  suffixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 10),
              FutureBuilder<List>(
                  future: _listCategory,
                  builder:
                      (BuildContext context, AsyncSnapshot<List> snapshot) {
                    if (snapshot.hasData) {
                      var data = snapshot.data;
                      return DropdownButtonFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          suffixIcon: Icon(Icons.book_online),
                        ),
                        hint: Text('Pilih Penerbit'),
                        value: _dropdownValue,
                        items: data!.map((value) {
                          return DropdownMenuItem<String>(
                            value: value['id'].toString(),
                            child: Text(value['nama_kategori']),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          setState(() {
                            _dropdownValue = value;
                          });
                        },
                      );
                    } else {
                      return CircularProgressIndicator(
                        valueColor: new AlwaysStoppedAnimation<Color>(
                            primaryButtonColor),
                      );
                    }
                  }),
              SizedBox(height: 10),
              TextFormField(
                // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                controller: _tahunTerbitController,
                decoration: InputDecoration(
                  hintText: "Masukkan Tahun Terbit Buku Anda",
                  labelText: "Tahun Terbit",
                  suffixIcon: Icon(Icons.date_range),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _stokController,
                // inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  hintText: "Masukkan Stok Buku Anda",
                  labelText: "Stok",
                  suffixIcon: Icon(Icons.web_stories),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
              SizedBox(height: 10),
              // CheckboxListTileFormField(
              //   title: Text('Buku Tersedia?'),
              //   onSaved: (bool? value) {
              //     print(value);
              //   },
              //   validator: (bool? value) {
              //     if (value!) {
              //       return 'Ya';
              //     } else {
              //       return 'Tidak';
              //     }
              //   },
              //   onChanged: (value) {},
              //   autovalidateMode: AutovalidateMode.always,
              //   contentPadding: EdgeInsets.all(1),
              // ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 40,
                margin: EdgeInsets.symmetric(horizontal: 50),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: primaryButtonColor),
                  onPressed: () {
                    myAlert();
                  },
                  child: Row(
                    children: [
                      Icon(Icons.image),
                      Text('Upload Image'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 10),
              image != null
                  ? Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.file(
                          //to show image, you type like this.
                          File(image!.path),
                          fit: BoxFit.cover,
                          width: 200,
                          height: 250,
                        ),
                      ),
                    )
                  : (widget.mode == FormMode.edit)
                      ? image != null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  //to show image, you type like this.
                                  File(image!.path),
                                  fit: BoxFit.cover,
                                  width: 200,
                                  height: 250,
                                ),
                              ),
                            )
                          : Center(
                              child: Image.network(
                                url +
                                    'storage/' +
                                    widget.detail!['path'].toString(),
                                width: 200,
                                height: 250,
                              ),
                            )
                      : Center(
                          child: Text(
                            "No Image Selected",
                            style: TextStyle(fontSize: 20),
                          ),
                        ),
              SizedBox(height: 50),
              Container(
                alignment: Alignment.bottomCenter,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      foregroundColor: primaryButtonColor),
                  onPressed: loading
                      ? null
                      : () async {
                          await _insertBuku();
                        },
                  child: loading
                      ? Container(
                          width: 15,
                          height: 15,
                          child: CircularProgressIndicator(
                            valueColor: new AlwaysStoppedAnimation<Color>(
                                primaryButtonColor),
                          ),
                        )
                      : Text('Simpan'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
