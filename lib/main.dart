import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        accentColor: Colors.amber,
        primaryColor: Colors.white,
        brightness: Brightness.light,
      ),
      home: const DataApi(),
    ));

class DataApi extends StatefulWidget {
  const DataApi({Key? key}) : super(key: key);

  @override
  _DataApiState createState() => _DataApiState();
}
Future getFilesData() async {
  var response = await http.get(Uri.https('http://jsonplaceholder.typicode.com', 'users'));
  var jsonData = jsonDecode(response.body);
  List<Files> users = [];
  for (var u in jsonData){
    Files user = Files(u["name"], u["userName"], u["email"]);
    users.add(user);
    print(users.length);
    return users;
  }
  }
  class Files {
   String name;
   String userName;
   String email;

  Files(this.name, this.userName, this.email);
  factory Files.fromJson( dynamic json) {
    return Files(
      json["name"] as String,
      json["userName"] as String,
      json["email"] as String,
    );
  }
}
class _DataApiState extends State<DataApi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Data From API'),
        toolbarHeight: 60,
        iconTheme: const IconThemeData(
          color: Colors.black54,
        ),
      ),
      body: FutureBuilder(
          future: getFilesData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              print(snapshot.data);
              return Container(
                child: const Center(
                  child: Text('Connection to database successful'),
                ),
              );
            } else if(snapshot.hasData){

              return ListView.builder(
                itemCount: (snapshot.data as dynamic).length,
                shrinkWrap: true,
                itemBuilder: (context, index){

                  Files user = (snapshot.data as dynamic)[index];
                  return ListTile(
                    title: Text(user.name),
                  );
                },
              );
            }
            else {
              return Container(
              child: const Center(
              child: Text('Loading'),
              ),
              );
            }
            }
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          getFilesData();
        },
        child: const Text('Click'),

      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}



