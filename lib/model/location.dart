class Location {
  String id, name, description;
  late List<int> signals;

  Location(this.id, this.name, this.description, List<dynamic> signals){

    this.signals = signals.cast<int>();
  }

  factory Location.fromJson(Map<String, dynamic> json){
    return Location(
        json['id'] as String,
        json['name'] as String,
        json['description'] as String,
        json['signals'] as List<dynamic>
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'signals': signals.cast<dynamic>()
  };
}