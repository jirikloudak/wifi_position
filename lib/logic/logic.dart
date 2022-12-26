import 'dart:convert';
import 'dart:convert' show json;
import 'dart:io' show File;
import 'dart:io';

import 'package:wifi_position/model/location.dart';

/// Path variable is a path to you directory with jsons
/// jsonFile is a name of a json file
String path = '',
    jsonFile = '',
    locationsImportFile = path + jsonFile,
    locationsExportFile = path + jsonFile;

/// This method read json file and save all data from it to a list
List<Location> getAllLocationsFromFile() {
  var stringContent = File(locationsImportFile).readAsStringSync();
  List jsonList = json.decode(stringContent);
  return List<Location>.from(jsonList.map((json) => Location.fromJson(json)).toList()
  );
}

///This method export list to a json file
void exportLocations(List<Location> data) {
  try{
    data.sort((a,b) => a.id.compareTo(b.id));
    List jsonList = [];
    data.forEach((item) => jsonList.add(json.encode(item.toJson())));
    File(locationsExportFile).writeAsStringSync(jsonList.toString());
    print('Saved data successfully!');
  } catch (e) {
    print('Error: $e');
  }
}

/// use this method to set path to directory with jsons files
/// setPath (Users\User\AndroidStudioProjects\Project\assets)
void setPath (String newPath){
  path = newPath;
}

/// Use this method to specifi json file
/// setJsonFile(sample.json)
void setJsonFile (String newJsonFile){
  jsonFile = newJsonFile;
}