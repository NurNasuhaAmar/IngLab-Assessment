import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:inglab_assessment/model/contacts.dart';

class ContactController extends GetxController {
  dynamic context = Get.context;

  static ContactController getInstance = Get.isRegistered<ContactController>() ? Get.find<ContactController>() : Get.put(ContactController());

  final TextEditingController userNameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController searchController = TextEditingController();

  bool isShowUserNameError = false;
  bool isShowPasswordError = false;
  bool isShowPassword = false;
  bool isLoadingContact = false;

  List<Contacts> contactList = [];
  List<Contacts> filteredList = [];

  String getInitials(String fullName) {
    List<String> nameSplit = fullName.split(' ');
    if (nameSplit.length > 1) {
      return '${nameSplit[0][0]}${nameSplit[1][0]}';
    } else {
      return nameSplit[0][0];
    }
  }

  void filterContacts(String query) {
    if (query.isEmpty) {
      filteredList.clear();
      update(['ContactPage']);
    } else {
      filteredList = contactList.where((contact) => contact.name!.toLowerCase().contains(query.toLowerCase()) || contact.email!.toLowerCase().contains(query.toLowerCase())).toList();
      update(['ContactPage']);
    }
  }

  Future<List<Contacts>> getContacts() async {
    isLoadingContact = true;
    update(['ContactPage']);

    try {
      var url = Uri.parse('https://655c6a1325b76d9884fd2f3c.mockapi.io/contacts');
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        contactList = ContactsList.fromJson(jsonResponse).contactList!;
        contactList.sort((a, b) => a.name!.toLowerCase().compareTo(b.name!.toLowerCase()));
        isLoadingContact = false;
        update(['ContactPage']);

        return contactList;
      }
    } catch (e) {
      if (kDebugMode) {
        print('Caught error getContacts: $e');
      }
    }
    return contactList;
  }
}
