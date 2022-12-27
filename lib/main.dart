import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:wifi_hunter/wifi_hunter.dart';
import 'package:wifi_hunter/wifi_hunter_result.dart';
import 'package:wifi_position/pages/LocationsPage.dart';

void main() {
  runApp(const MaterialApp(home: MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  WiFiHunterResult wiFiHunterResult = WiFiHunterResult();

  ///GlobalKey to identify input form
  final _formKey = GlobalKey<FormState>();

  ///Variables to store text from text fields
  String positionNameText = "";
  String descriptionText = "";

  ///Controlers for text fields
  final positionNameTextFieldController = TextEditingController();
  final positionDescriptionTextFieldController = TextEditingController();

  ///method to clear text fields
  void clearTextFields(){
    positionDescriptionTextFieldController.text = "";
    positionNameTextFieldController.text = "";
  }

  ///Method to save data from text fields into variables
  void getFormResult(){
    positionNameText = positionNameTextFieldController.text;
    descriptionText = positionDescriptionTextFieldController.text;
  }

  ///Scan wifi networks
  Future<void> huntWiFis() async {
    try {
      wiFiHunterResult = (await WiFiHunter.huntWiFiNetworks)!;
    } on PlatformException catch (exception) {
      print(exception.toString());
    }
    if (!mounted) return;
  }

  ///Dialog for adding new location
  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("New position"),
      content: Stack(
        clipBehavior: Clip.none, children: <Widget>[
          Positioned(
            right: -40.0,
            top: -40.0,
            left: 40.0,
            bottom: 40.0,
            child: InkResponse(
              onTap: () {
                Navigator.of(context).pop();
              },
            ),
          ),
          Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "Enter name of position"),
                    controller: positionNameTextFieldController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    decoration: const InputDecoration(hintText: "Enter description"),
                    controller: positionDescriptionTextFieldController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    child: const Text("Submit"),
                    onPressed: () {
                      getFormResult();
                      Navigator.pop(context);
                      clearTextFields();
                    },
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    )
  );

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
                    onPressed: () => huntWiFis(),
                    child: const Text('Show wifis')
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
                    onPressed: () {
                      openDialog();
                      },
                    child: const Text('Save position')
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10.0),
                child: ElevatedButton(
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
    Navigator.push(context, MaterialPageRoute(builder: (context){return const LocationsPage();}));
  }
}