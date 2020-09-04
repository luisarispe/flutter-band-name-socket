import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bandnames/models/band.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [
    Band(id: '1', name: 'Metallica', votes: 5),
    Band(id: '2', name: 'Quen', votes: 1),
    Band(id: '3', name: 'Heroes del Silencer', votes: 2),
    Band(id: '4', name: 'Bon Jovi', votes: 4),
    Band(id: '5', name: 'Likin Park', votes: 6),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('BandNames'),
        ),
        body: ListView.builder(
            itemCount: bands.length,
            itemBuilder: (context, i) => _bandTile(bands[i])),
        floatingActionButton: FloatingActionButton(
            elevation: 1, child: Icon(Icons.add), onPressed: adNewBand));
  }

  Widget _bandTile(Band band) {
    return Dismissible(
      background: Container(
        color: Colors.red,
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 10,
            ),
            Text(
              'Eliminar Band',
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
      direction: DismissDirection.startToEnd,
      onDismissed: (direction) {
        print(band.id.toString());
      },
      child: ListTile(
        onTap: () {
          print(band.name);
        },
        leading: CircleAvatar(
          backgroundColor: Colors.blue[100],
          child: Text(band.name.substring(0, 2)),
        ),
        title: Text(band.name),
        trailing: Text(
          '${band.votes}',
          style: TextStyle(fontSize: 20),
        ),
      ),
      key: Key(band.id),
    );
  }

  adNewBand() {
    final textController = new TextEditingController();

    if (Platform.isAndroid) {
      //ANDROID
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              title: Text('New band name:'),
              content: TextField(
                controller: textController,
              ),
              actions: <Widget>[
                MaterialButton(
                    textColor: Colors.blue,
                    elevation: 5,
                    child: Text('Add'),
                    onPressed: () {
                      addBandToList(textController.text);
                    })
              ],
            );
          });
    }
    showCupertinoDialog(
        context: context,
        builder: (_) {
          return CupertinoAlertDialog(
            title: Text('New band name:'),
            content: CupertinoTextField(
              controller: textController,
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Add'),
                onPressed: () => addBandToList(textController.text),
              ),
              CupertinoDialogAction(
                isDefaultAction: true,
                child: Text('Dismiss'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }

  void addBandToList(String name) {
    if (name.length > 1) {
      this
          .bands
          .add(new Band(id: DateTime.now().toString(), name: name, votes: 1));
    }
    Navigator.pop(context);
  }
}
