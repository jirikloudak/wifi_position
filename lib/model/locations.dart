class locations {
  final String id;
  final String name;
  final String description;
  final String ssid;

  locations(this.id, this.name, this.description, this.ssid);

  locations.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        ssid = json['SSID'];

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'description': description,
    'ssid': ssid,
  };
}