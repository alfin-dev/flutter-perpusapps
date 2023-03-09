import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class exportBuku extends StatefulWidget {
  const exportBuku({Key? key}) : super(key: key);

  @override
  State<exportBuku> createState() => _exportBukuState();
}

// ignore: camel_case_types
class _exportBukuState extends State<exportBuku> {
  final TextEditingController txtFilePicker = TextEditingController();
  File? file;
  // fungsi untuk select file
  selectFile() async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['xlsx']);
    if (result != null) {
      setState(() {
        txtFilePicker.text = result.files.single.name;
        log(result.files.single.path.toString());
        file = File(result.files.single.path!);
      });
    } else {
      // User canceled the picker
    }
  }

  Future exportTemplateExcel() async {
    try {
      var params = "book/download/template";
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

  _insertExcel() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var params = "book/import/excel";
    String? _token;
    _token = prefs.getString('token').toString();
    var dio = Dio();
    FormData formData = FormData.fromMap({
      'file_import': await MultipartFile.fromFile(file!.path),
    });
    // log(file.toString());
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
      log(response.toString());
      if (response.data['status'] == 200) {
        Navigator.pop(context);
      }
      print(response.data['status']);
    } catch (e) {
      print(e);
    }
  }

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
          IconButton(
            onPressed: () async {
              await exportTemplateExcel();
            },
            icon: Icon(Icons.import_export),
          ),
        ],
      ),
      body: buildFilePicker(),
    );
  }

  Widget buildFilePicker() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: TextFormField(
                    readOnly: true,
                    validator: (String? value) {
                      if (value == null || value.isEmpty) {
                        return 'File harus diupload';
                      } else {
                        return null;
                      }
                    },
                    controller: txtFilePicker,
                    decoration: const InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(5.0),
                          ),
                          borderSide:
                              BorderSide(color: Colors.white, width: 2)),
                      hintText: 'Upload File',
                      contentPadding: EdgeInsets.all(10.0),
                    ),
                    style: const TextStyle(fontSize: 16.0)),
              ),
              const SizedBox(width: 5),
              ElevatedButton.icon(
                icon: const Icon(
                  Icons.upload_file,
                  color: Colors.white,
                  size: 24.0,
                ),
                label:
                    const Text('Pilih File', style: TextStyle(fontSize: 16.0)),
                onPressed: () {
                  selectFile();
                },
                style: ElevatedButton.styleFrom(
                  primary: primaryButtonColor,
                  minimumSize: const Size(122, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
          ElevatedButton.icon(
            icon: Icon(
              Icons.upload_file,
              color: Colors.white,
              size: 24.0,
            ),
            label: Text('Upload File', style: TextStyle(fontSize: 16.0)),
            onPressed: () {
              _insertExcel();
            },
            style: ElevatedButton.styleFrom(
              primary: primaryButtonColor,
              minimumSize: const Size(122, 48),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
