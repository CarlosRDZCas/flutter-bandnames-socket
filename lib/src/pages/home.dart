import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

import '../models/banda.dart';
import '../services/socket_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    final serverSocket = Provider.of<SocketService>(context, listen: false);
    serverSocket.socket!.on('active-bands', (payload) {
      bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    final serverSocket = Provider.of<SocketService>(context, listen: false);
    serverSocket.socket!.off('active-bands');
    super.dispose();
  }

  List<Band> bands = [];
  @override
  Widget build(BuildContext context) {
    final serverSocket = Provider.of<SocketService>(context);
    return Scaffold(
      appBar: AppBar(
        actions: [
          Container(
              margin: const EdgeInsets.only(right: 10),
              child: serverSocket.serverStatus == ServerStatus.online
                  ? const Icon(Icons.check_circle, color: Colors.blue)
                  : const Icon(Icons.offline_bolt, color: Colors.red))
        ],
        title: const Text(
          'Band Names',
          style: TextStyle(color: Colors.black87),
        ),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _showGraph(),
          Expanded(
            child: ListView.builder(
              itemCount: bands.length,
              itemBuilder: (context, i) => _bandTile(bands[i]),
            ),
          ),
        ],
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.isNotEmpty) {
      socketService.socket!.emit('add-band', {'name': name});
      setState(() {});
    }

    Navigator.pop(context);
  }

  Widget _bandTile(Band band) {
    final socketService = Provider.of<SocketService>(context, listen: false);
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (_) {
        socketService.socket!.emit('delete-band', {'id': band.id});
      },
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
        onTap: () {
          socketService.socket!.emit('vote-band', {'id': band.id!});
        },
      ),
    );
  }

  Widget _showGraph() {
    Map<String, double> datamap = {};
    bands.forEach((band) {
      datamap.putIfAbsent(band.name!, () => band.votes!.toDouble());
    });

    return Container(
      height: 200,
      width: double.infinity,
      child: PieChart(
        chartValuesOptions: const ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: false,
          decimalPlaces: 1,
        ),
        dataMap: datamap,
      ),
    );
  }
}
