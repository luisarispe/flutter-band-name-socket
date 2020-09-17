import 'dart:io';

import 'package:bandnames/services/socket_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:bandnames/models/band.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Band> bands = [];

  @override
  void initState() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.on('active-bands', (payload) {
      this.bands = (payload as List).map((band) => Band.fromMap(band)).toList();
      setState(() {});
    });
    super.initState();
  }

  @override
  void dispose() {
    final socketService = Provider.of<SocketService>(context, listen: false);
    socketService.socket.off('active-bands');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final socketService = Provider.of<SocketService>(context);

    return Scaffold(
        appBar: AppBar(
          actions: [
            Container(
                margin: EdgeInsets.only(right: 10),
                child: (socketService.serverStatus == ServerStatus.Online)
                    ? Icon(Icons.check_circle, color: Colors.blue[300])
                    : Icon(
                        Icons.offline_bolt,
                        color: Colors.red,
                      )),
          ],
          elevation: 1,
          centerTitle: true,
          title: Text(
            'BandNames',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
        ),
        body: Column(
          children: [
            _showGrafica(),
            Expanded(
              child: ListView.builder(
                  itemCount: bands.length,
                  itemBuilder: (context, i) =>
                      _bandTile(bands[i], socketService)),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            elevation: 1, child: Icon(Icons.add), onPressed: adNewBand));
  }

  Widget _bandTile(Band band, socketService) {
    final socketService = Provider.of<SocketService>(context, listen: false);

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
        socketService.socket.emit('delete-band', {'id': band.id.toString()});
      },
      child: ListTile(
        onTap: () {
          socketService.socket.emit('vote-band', {'id': band.id});
          print(band.id);
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
    final socketService = Provider.of<SocketService>(context, listen: false);
    if (name.length > 1) {
      socketService.socket.emit('add-band', {'name': name});
    }
    Navigator.pop(context);
  }

  Widget _showGrafica() {
    Map<String, double> dataMap = new Map();
    bands.forEach((element) {
      dataMap.putIfAbsent(element.name, () => element.votes.toDouble());
    });
    List<Color> colorList = [
      Colors.lightGreenAccent,
      Colors.blue,
      Colors.brown,
      Colors.amber,
    ];
    return dataMap.isNotEmpty
        ? Container(
            height: 200,
            child: PieChart(
              dataMap: dataMap,
              animationDuration: Duration(milliseconds: 800),
              chartLegendSpacing: 32,
              chartRadius: MediaQuery.of(context).size.width / 3.2,
              colorList: colorList,
              initialAngleInDegree: 0,
              chartType: ChartType.ring,
              ringStrokeWidth: 32,
              legendOptions: LegendOptions(
                showLegendsInRow: false,
                legendPosition: LegendPosition.right,
                showLegends: true,
                legendShape: BoxShape.circle,
                legendTextStyle: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              chartValuesOptions: ChartValuesOptions(
                showChartValueBackground: true,
                showChartValues: true,
                showChartValuesInPercentage: false,
                showChartValuesOutside: false,
              ),
            ),
          )
        : LinearProgressIndicator();
  }
}
