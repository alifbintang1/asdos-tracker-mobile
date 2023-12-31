import 'package:asdos_tracker_mobile/model/Item.dart';
import 'package:asdos_tracker_mobile/screens/login.dart';
import 'package:asdos_tracker_mobile/screens/oneitem.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
// import 'package:<APP_NAME>/models/Item.dart';

import 'package:asdos_tracker_mobile/widgets/left_drawer.dart';

class ItemPage extends StatefulWidget {
  const ItemPage({Key? key}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  Future<List<Item>> fetchItem() async {
    // TODO: Ganti URL dan jangan lupa tambahkan trailing slash (/) di akhir URL!
    String uname = LoginPage.uname;

    var url = Uri.parse('http://127.0.0.1:8000/get-item-flutter/$uname/');
    // var url = Uri.parse('http://localhost:8000/get-items/');
    var response = await http.get(
      url,
      headers: {"Content-Type": "application/json"},
    );
    // print(response.body);
    // melakukan decode response menjadi bentuk json
    var data = jsonDecode(utf8.decode(response.bodyBytes));
    // melakukan konversi data json menjadi object Item
    List<Item> list_Item = [];
    for (var d in data) {
      if (d != null) {
        list_Item.add(Item.fromJson(d));
      }
    }
    return list_Item;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Item'),
        ),
        drawer: const LeftDrawer(),
        body: FutureBuilder(
            future: fetchItem(),
            builder: (context, AsyncSnapshot snapshot) {
              if (snapshot.data == null) {
                return const Center(child: CircularProgressIndicator());
              } else {
                // print(snapshot.data.length == 0);
                if (snapshot.data.length == 0) {
                  return const Column(
                    children: [
                      Text(
                        "Tidak ada data item.",
                        style: TextStyle(
                            color: Color.fromARGB(255, 19, 20, 21),
                            fontSize: 20),
                      ),
                      SizedBox(height: 8),
                    ],
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (_, index) => InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ItemDetailPage(
                                      item: snapshot.data![index],
                                    )));
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 12),
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${snapshot.data![index].fields.name}",
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.amount}"),
                            const SizedBox(height: 10),
                            Text("${snapshot.data![index].fields.description}"),
                          ],
                        ),
                      ),
                    ),
                  );
                }
              }
            }));
  }
}