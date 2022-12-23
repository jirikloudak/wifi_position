import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';
import 'package:wifi_position/pages/LocationsPage.dart';

import 'model/locations.dart';

void main() {
  runApp(MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();
  Color buttonCollor = Colors.lightBlue;
  Color buttonColorPressed = Colors.red;

  Future<void> huntWiFis() async {
    setState(() => buttonCollor = buttonColorPressed);

    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      print(exception.toString());
    }

    if (!mounted) return;

    setState(() => buttonColorPressed = Colors.lightBlue);
  }

  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text("Name"),
      content: const TextField(
        decoration: InputDecoration(hintText: "Enter name of position"),
      ),
      actions: [
        TextButton(
          child: Text("Save"),
          onPressed: () {},
        )
      ],
    )
  );


  Future<File> get _jsonFile async {
    return File('assets/sample.json');
  }


  Future<locations> writejsonFile() async {
    final locations location = locations("15", "Write test", "Write test", "ssid test");
    File file = await _jsonFile;
    await file.writeAsString(json.encode(location));
    return location;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('WiFi position framework'),
        ),
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const BouncingScrollPhysics(),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonCollor)),
                    onPressed: () => huntWiFis(),
                    child: const Text('Show wifis')
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonCollor)),
                    onPressed: () {
                      //openDialog();
                      writejsonFile();
                      },
                    child: const Text('Save position')
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all<Color>(buttonCollor)),
                    onPressed: () {
                      locationsPage(context);
                    },
                    child: const Text('Show positions')
                ),
              ),
              wiFiHunterResult.results.isNotEmpty ? Container(
                margin: const EdgeInsets.only(bottom: 20.0, left: 30.0, right: 30.0),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(wiFiHunterResult.results.length, (index) =>
                        Container(
                          margin: const EdgeInsets.symmetric(vertical: 10.0),
                          child: ListTile(
                              leading: Text(wiFiHunterResult.results[index].level.toString() + ' dbm'),
                              title: Text(wiFiHunterResult.results[index].SSID),
                              subtitle: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('BSSID : ' + wiFiHunterResult.results[index].BSSID),
                                    Text('Capabilities : ' + wiFiHunterResult.results[index].capabilities),
                                    Text('Frequency : ' + wiFiHunterResult.results[index].frequency.toString()),
                                    Text('Channel Width : ' + wiFiHunterResult.results[index].channelWidth.toString()),
                                    Text('Timestamp : ' + wiFiHunterResult.results[index].timestamp.toString())
                                  ]
                              )
                          ),
                        )
                    )
                ),
              ) : Container()
            ],
          ),
        ),
      ),
    );
  }

  void locationsPage (BuildContext context){
    Navigator.push(context, MaterialPageRoute(builder: (context){return LocationsPage();}));
  }
}