class Signal{
  String ssid1, ssid2, ssid3;
  int strength1,strength2,strength3;

  Signal(this.ssid1, this.strength1, this.ssid2, this.strength2, this.ssid3, this.strength3,);

  factory Signal.fromJson(Map<String, dynamic> json){
    return Signal(
      json["ssid1"] as String,
      json["strength1"] as int,
      json["ssid2"] as String,
      json["strength2"] as int,
      json["ssid3"] as String,
      json["strength3"] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'ssid1': ssid1,
    'strength1': strength1,
    'ssid2': ssid2,
    'strength2': strength2,
    'ssid3': ssid3,
    'strength3': strength3,
  };
}