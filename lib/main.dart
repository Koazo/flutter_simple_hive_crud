import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); //Загугли что это
  Directory document = await getApplicationDocumentsDirectory();
  Hive.init(document.path);
  await Hive.openBox<String>('friends');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hive CRUD',
      home: MyHomePage(),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Box<String> friendsBox;

  final TextEditingController _idController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    friendsBox = Hive.box('friends');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hive CRUD'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
              valueListenable: friendsBox.listenable(),
              builder: (context, Box<String> friends, _) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      final key = friends.keys.toList()[index];
                      final value = friends.get(key);
                      return ListTile(
                        title: Text(value.toString()),
                        subtitle: Text(key),
                      );
                    },
                    separatorBuilder: (_, index) => Divider(),
                    itemCount: friendsBox.keys.toList().length);
              },
            ),
          ),
          Container(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _idController,
                                    autofocus: true,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(
                                    controller: _nameController,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final key = _idController.text;
                                      final value = _nameController.text;

                                      friendsBox.put(key, value);
                                      _idController.clear();
                                      _nameController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('submit'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text('Add'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _idController,
                                    autofocus: true,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  TextField(controller: _nameController),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final key = _idController.text;
                                      final value = _nameController.text;

                                      friendsBox.put(key, value);
                                      _idController.clear();
                                      _nameController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('submit'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text('Update'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return Dialog(
                            child: Container(
                              padding: const EdgeInsets.all(32.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  TextField(
                                    controller: _idController,
                                    autofocus: true,
                                  ),
                                  const SizedBox(
                                    height: 16,
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      final key = _idController.text;
                                      friendsBox.delete(key);
                                      _idController.clear();
                                      Navigator.pop(context);
                                    },
                                    child: const Text('submit'),
                                  ),
                                ],
                              ),
                            ),
                          );
                        });
                  },
                  child: const Text('Delete'),
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all(Colors.greenAccent),
                    foregroundColor: MaterialStateProperty.all(Colors.black),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
