import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<List<User>> _getUser() async {
    var data =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/users'));
    var jsonData = jsonDecode(data.body);
    List<User> users = [];
    for (var getUser in jsonData) {
      User user = User(name: getUser['name'], email: getUser['email']);
      users.add(user);
    }
    print(users.length);
    return users;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
      ),
      body: Container(
        child: FutureBuilder(
          future: _getUser(),
          builder: (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: ListTile(
                        title: Text(snapshot.data![index].name.toString()),
                      ),
                    );
                  });
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

class User {
  final String name;
  final String email;

  User({required this.name, required this.email});
}
