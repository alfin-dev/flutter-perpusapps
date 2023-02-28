import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:perpus_app/screen/page/detail_buku.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late Future<List> _listUser;
  // final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<List> getUsers() async {
    try {
      final String sUrl = "http://192.168.0.142:8000/api/";
      var params = "user/all";
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
        // print(response.data['data']['books']);
        return response.data['data']['users'];
      } else {
        print('Error');
      }
    } catch (e) {
      print(e);
    }
    return [];
  }

  @override
  void initState() {
    _listUser = getUsers();
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: <Widget>[
          Icon(Icons.person_add),
          SizedBox(width: 15),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(2),
        child: FutureBuilder<List>(
          future: _listUser,
          builder: (BuildContext context, AsyncSnapshot<List> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(snapshot.data![index]['name']),
                      subtitle: Text(snapshot.data![index]['email'] +
                          ' - ' +
                          snapshot.data![index]['roles'][0]['name']),
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
                  });
            } else {
              return Center(child: const CircularProgressIndicator());
            }
          },
        ),
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
