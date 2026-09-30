class ContactUser {
  String? id;
  String? name;
  String? phone;

  ContactUser({this.id, required this.name, required this.phone});

  Map<String, dynamic> toJson() {
    return {"name": name, "phone": phone};
  }

  ContactUser.fromJson(Map<String, dynamic> json) {
    id = json["id"];
    name = json["name"];
    phone = json["phone"];
  }
}
