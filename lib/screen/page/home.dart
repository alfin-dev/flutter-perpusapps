import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Image.asset(
              'assets/splash.png',
              fit: BoxFit.contain,
              height: 40,
            ),
            Text(
              'Dashboard',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Container(
            height: 190,
            decoration: BoxDecoration(color: Colors.red),
            child: GridView.count(
              primary: false,
              padding: const EdgeInsets.all(30),
              crossAxisSpacing: 38,
              mainAxisSpacing: 40,
              crossAxisCount: 2,
              children: <Widget>[
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff130160),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.red[100],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book),
                          Text(
                            "Total Buku",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Center(
                        child: Text(
                          '100',
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: const Color(0xff130160),
                      width: 3,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    color: Colors.red[200],
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.7),
                        spreadRadius: 5,
                        blurRadius: 6,
                        offset: Offset(0, 3), // changes position of shadow
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.book),
                          Text(
                            "Total Stok",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(height: 30),
                      Center(
                        child: Text(
                          '100',
                          style: TextStyle(fontSize: 50),
                        ),
                      ),
                    ],
                  ),
                ),
                //   Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: const Color(0xff130160),
                //         width: 3,
                //       ),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //       color: Colors.purple[50],
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.7),
                //           spreadRadius: 5,
                //           blurRadius: 6,
                //           offset: Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     padding: const EdgeInsets.all(8),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Icon(Icons.person),
                //             Text(
                //               "Total Member",
                //               style:
                //                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //             ),
                //           ],
                //         ),
                //         SizedBox(height: 30),
                //         Center(
                //           child: Text(
                //             '100',
                //             style: TextStyle(fontSize: 50),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: const Color(0xff130160),
                //         width: 3,
                //       ),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //       color: Colors.purple[100],
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.7),
                //           spreadRadius: 5,
                //           blurRadius: 6,
                //           offset: Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     padding: const EdgeInsets.all(8),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Icon(Icons.person),
                //             Text(
                //               "Total Pegawai",
                //               style:
                //                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //             ),
                //           ],
                //         ),
                //         SizedBox(height: 30),
                //         Center(
                //           child: Text(
                //             '100',
                //             style: TextStyle(fontSize: 50),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: const Color(0xff130160),
                //         width: 3,
                //       ),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //       color: Colors.purple[100],
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.7),
                //           spreadRadius: 5,
                //           blurRadius: 6,
                //           offset: Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     padding: const EdgeInsets.all(8),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Icon(Icons.person),
                //             Text(
                //               "Total Pegawai",
                //               style:
                //                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //             ),
                //           ],
                //         ),
                //         SizedBox(height: 30),
                //         Center(
                //           child: Text(
                //             '100',
                //             style: TextStyle(fontSize: 50),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                //   Container(
                //     decoration: BoxDecoration(
                //       border: Border.all(
                //         color: const Color(0xff130160),
                //         width: 3,
                //       ),
                //       borderRadius: BorderRadius.all(
                //         Radius.circular(10),
                //       ),
                //       color: Colors.purple[100],
                //       boxShadow: [
                //         BoxShadow(
                //           color: Colors.grey.withOpacity(0.7),
                //           spreadRadius: 5,
                //           blurRadius: 6,
                //           offset: Offset(0, 3), // changes position of shadow
                //         ),
                //       ],
                //     ),
                //     padding: const EdgeInsets.all(8),
                //     child: Column(
                //       children: [
                //         Row(
                //           children: [
                //             Icon(Icons.person),
                //             Text(
                //               "Total Pegawai",
                //               style:
                //                   TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                //             ),
                //           ],
                //         ),
                //         SizedBox(height: 30),
                //         Center(
                //           child: Text(
                //             '100',
                //             style: TextStyle(fontSize: 50),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
              ],
            ),
          ),
        ],
      ),
// Center(
//         child: Text('ini page home'),
//       ),
    );
  }
}
