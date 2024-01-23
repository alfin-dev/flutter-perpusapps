import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/mastervariable.dart';
import 'package:perpus_app/template.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  // late Future<List> _listUser;
  List member = [];
  // ignore: non_constant_identifier_names
  String cek_prev = 'null';
  // ignore: non_constant_identifier_names
  String cek_next = 'null';
  int page = 1;

  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future getUsers() async {
    setState(() {
      member = [];
    });
    try {
      var params = "user/all";
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
          cek_prev = response.data['data']['users']['prev_page_url'].toString();
          cek_next = response.data['data']['users']['next_page_url'].toString();
          member = response.data['data']['users']['data'];
        });
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    getUsers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'List Member',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        // actions: <Widget>[
        //   Icon(Icons.person_add),
        //   SizedBox(width: 15),
        // ],
      ),
      body: member.length == 0
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: member.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        title: Text(member[index]['name']),
                        subtitle: Text(member[index]['email'] +
                            ' - ' +
                            member[index]['roles'][0]['name']),
                        leading: ClipOval(
                          child: SizedBox.fromSize(
                            size: Size.fromRadius(20),
                            child: Image.network(
                              'https://www.transparentpng.com/thumb/happy-person/VJdvLa-download-happy-blackman-png.png',
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    if (cek_prev.toString() != 'null' &&
                        cek_next.toString() != 'null')
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: () {
                              page--;
                              getUsers();
                            },
                            child: Text('Prev'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: () {
                              page++;
                              getUsers();
                            },
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    if (cek_prev.toString() == 'null' &&
                        cek_next.toString() != 'null')
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: null,
                            child: Text('Prev'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: () {
                              page++;
                              getUsers();
                            },
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    if (cek_prev.toString() != 'null' &&
                        cek_next.toString() == 'null')
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: () {
                              page--;
                              getUsers();
                            },
                            child: Text('Prev'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: null,
                            child: Text('Next'),
                          ),
                        ],
                      ),
                    if (cek_prev.toString() == 'null' &&
                        cek_next.toString() == 'null')
                      Row(
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: null,
                            child: Text('Prev'),
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: primaryButtonColor),
                            onPressed: null,
                            child: Text('Next'),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),

      // ListView(
      //   children: [
      //     ListTile(
      //       title: Text('Person 1'),
      //       subtitle: Text('Admin'),
      //       leading: ClipOval(
      //         child: SizedBox.fromSize(
      //           size: Size.fromRadius(20),
      //           child: Image.network(
      //             'https://www.transparentpng.com/thumb/happy-person/VJdvLa-download-happy-blackman-png.png',
      //             fit: BoxFit.cover,
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
