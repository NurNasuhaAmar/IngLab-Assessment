class Contacts {
  String? name;
  String? email;
  String? id;

  Contacts({this.name, this.email, this.id});

  Contacts.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['id'] = id;
    return data;
  }
}


class ContactsList {
  final List<Contacts>? contactList;

  ContactsList({
    this.contactList,
  });

  factory ContactsList.fromJson(List<dynamic> parsedJson) {
    List<Contacts> contactList = [];
    contactList = parsedJson.map((i) => Contacts.fromJson(i)).toList();

    return ContactsList(
      contactList: contactList,
    );
  }
}