import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inglab_assessment/controller/contacts_controller.dart';
import 'package:shimmer/shimmer.dart';

class ContactPage extends StatelessWidget {
  ContactPage({super.key});

  final ContactController controller = ContactController.getInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEDEDED),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        title: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: const Color(0xFFD8EDF0),
          ),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Image.asset(
                  'assets/images/search-icon.png',
                  height: 18,
                ),
              ),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  style: const TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                  cursorColor: Colors.black,
                  decoration: const InputDecoration(
                    isDense: true,
                    hintText: 'Search..',
                    hintStyle: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
                  ),
                  onChanged: (value) {
                    controller.filterContacts(value);
                  },
                ),
              ),
              InkWell(
                onTap: () {
                  controller.searchController.clear();
                  controller.filterContacts('');
                },
                child: Container(
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.5),
                    shape: BoxShape.circle,
                  ),
                  child: Image.asset(
                    'assets/images/cancel-icon.png',
                    height: 7,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: GetBuilder(
          id: 'ContactPage',
          init: ContactController(),
          initState: (_) {
            controller.getContacts();
          },
          builder: (ctrl) {
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Text(
                        'Contacts',
                        style: TextStyle(fontSize: 20, fontFamily: 'Poppins-B'),
                      ),
                    ),
                    controller.isLoadingContact
                        ? skeleton()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: controller.filteredList.isNotEmpty ? controller.filteredList.length : controller.contactList.length,
                            padding: const EdgeInsets.only(top: 10),
                            itemBuilder: (BuildContext context, int index) {
                              String name = controller.filteredList.isNotEmpty ? controller.filteredList[index].name ?? '-' : controller.contactList[index].name ?? '-';
                              String email = controller.filteredList.isNotEmpty ? controller.filteredList[index].email ?? '-' : controller.contactList[index].email ?? '-';

                              TextSpan highlightMatches(String text, double? fontSize, String? fontFamily, TextStyle style) {
                                RegExp regex = RegExp('(${controller.searchController.text.toLowerCase()})', caseSensitive: false);
                                List<TextSpan> spans = [];

                                int start = 0;
                                for (RegExpMatch match in regex.allMatches(text)) {
                                  if (match.start > start) {
                                    spans.add(TextSpan(
                                      text: text.substring(start, match.start),
                                      style: style,
                                    ));
                                  }

                                  spans.add(TextSpan(
                                    text: match.group(0),
                                    style: TextStyle(color: const Color(0xFF1A8C9E), fontSize: fontSize ?? 16, fontFamily: fontFamily ?? 'Poppins-SB'),
                                  ));

                                  start = match.end;
                                }

                                if (start < text.length) {
                                  spans.add(TextSpan(
                                    text: text.substring(start),
                                    style: style,
                                  ));
                                }

                                return TextSpan(children: spans);
                              }

                              return Container(
                                margin: const EdgeInsets.only(bottom: 10),
                                padding: const EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(15),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 3,
                                      offset: Offset(3, 3),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFFFA8AC),
                                        shape: BoxShape.circle,
                                        boxShadow: const [
                                          BoxShadow(
                                            color: Colors.grey,
                                            spreadRadius: 1,
                                            blurRadius: 1,
                                            offset: Offset(0, 3),
                                          ),
                                        ],
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 2,
                                        ),
                                      ),
                                      margin: const EdgeInsets.only(right: 15),
                                      child: Text(
                                        controller.getInitials(controller.filteredList.isNotEmpty ? controller.filteredList[index].name ?? '' : controller.contactList[index].name ?? ''),
                                        style: const TextStyle(fontSize: 16, color: Colors.white, fontFamily: 'Poppins-B'),
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        RichText(
                                          text:
                                              highlightMatches(name, 16, 'Poppins-SB', const TextStyle(color: Colors.black, fontSize: 16, fontFamily: 'Poppins-SB')),
                                        ),
                                        RichText(
                                          text:
                                          highlightMatches(email, 12, 'Poppins', const TextStyle(color: Colors.black, fontSize: 12, fontFamily: 'Poppins')),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Widget skeleton() {
    return ListView.builder(
      itemCount: 10,
      shrinkWrap: true,
      padding: const EdgeInsets.only(top: 10),
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (BuildContext context, int index) {
        return Shimmer.fromColors(
          baseColor: Colors.grey[400]!,
          highlightColor: Colors.grey[350]!,
          child: Container(
            height: 70,
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: const [
                BoxShadow(
                  color: Colors.grey,
                  blurRadius: 3,
                  offset: Offset(3, 3),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
