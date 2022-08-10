import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../models/banda.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Band> bands = [
    Band(id: '1', name: 'The Beatles', votes: 0),
    Band(id: '2', name: 'The Rolling Stones', votes: 0),
    Band(id: '3', name: 'The Who', votes: 0),
    Band(id: '4', name: 'The Doors', votes: 0),
    Band(id: '5', name: 'The Smiths', votes: 0),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: bands.length,
        itemBuilder: (context, i) => _bandTile(bands[i]),
      ),
      floatingActionButton: FloatingActionButton(
          elevation: 1, onPressed: addNewBand, child: const Icon(Icons.add)),
    );
  }

  addNewBand() {
    final textController = TextEditingController();

    Platform.isAndroid
        ? showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text('Add a new band'),
                content: TextField(
                  controller: textController,
                ),
                actions: [
                  MaterialButton(
                    onPressed: () => addBandToList(textController.text),
                    textColor: Colors.blue,
                    elevation: 5,
                    child: const Text('Add'),
                  ),
                ],
              );
            })
        : showCupertinoDialog(
            context: context,
            builder: (context) {
              return CupertinoAlertDialog(
                title: const Text('Add a new band'),
                content: CupertinoTextField(
                  controller: textController,
                ),
                actions: [
                  CupertinoDialogAction(
                    isDefaultAction: true,
                    onPressed: () => addBandToList(textController.text),
                    child: const Text('Add'),
                  ),
                  CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Dismiss'),
                  ),
                ],
              );
            });
  }

  void addBandToList(String name) {
    if (name.isNotEmpty) {
      bands.add(Band(id: DateTime.now().toString(), name: name, votes: 0));
      setState(() {});
    }

    Navigator.pop(context);
  }

  Dismissible _bandTile(Band band) {
    return Dismissible(
      key: Key(band.id!),
      direction: DismissDirection.startToEnd,
      background: Container(
        padding: const EdgeInsets.only(left: 8),
        color: Colors.red,
        child: const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Delete Band',
              style: TextStyle(color: Colors.white),
            )),
      ),
      child: ListTile(
        leading: CircleAvatar(
            backgroundColor: Colors.blue[100],
            child: Text(band.name!.substring(0, 2))),
        title: Text(band.name!),
        trailing:
            Text(band.votes!.toString(), style: const TextStyle(fontSize: 20)),
        onTap: () {},
      ),
    );
  }
}
