import 'package:wifi_position/model/signal.dart';

class Location {
  String id, name, description;
  Signal signal;

  Location(this.id, this.name, this.description, this.signal);

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
        json['id'] as String,
        json['name'] as String,
        json['description'] as String,
        Signal.fromJson(json["signal"])
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'signal': signal
  };
}