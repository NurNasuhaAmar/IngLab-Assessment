import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:inglab_assessment/controller/contacts_controller.dart';
import 'package:inglab_assessment/view/contact_page.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  final ContactController controller = ContactController.getInstance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<ContactController>(
          id: 'LoginPage',
          init: ContactController(),
          builder: (ctrl) {
            return SingleChildScrollView(
              child: Container(
                width: Get.width,
                height: Get.height,
                decoration: const BoxDecoration(
                    gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFCDF6FA),
                    Colors.white,
                  ],
                )),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 150),
                        child: Center(
                          child: Image.asset(
                            'assets/images/logo.png',
                            width: Get.width * 0.7,
                          ),
                        ),
                      ),
                      SizedBox(height: Get.height * 0.2),
                      const Text(
                        'Welcome To IngLab',
                        style: TextStyle(fontSize: 22, fontFamily: 'Poppins-B'),
                      ),
                      const Text(
                        'Please enter your details to continue',
                        style: TextStyle(fontSize: 14, fontFamily: 'Poppins'),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, bottom: controller.isShowUserNameError ? 10 : 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: controller.userNameController,
                          style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'User Name',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: controller.isShowUserNameError ? Colors.red : Colors.grey),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.isShowUserNameError,
                        child: const Padding(
                          padding: EdgeInsets.only(bottom: 10),
                          child: Text(
                            'User Name is required',
                            style: TextStyle(color: Colors.red, fontSize: 11, fontFamily: 'Poppins'),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          controller: controller.passwordController,
                          obscureText: !controller.isShowPassword,
                          style: const TextStyle(fontSize: 16, fontFamily: 'Poppins'),
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 10),
                            labelText: 'Password',
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: controller.isShowPasswordError ? Colors.red : Colors.grey),
                            ),
                            suffixIcon: IconButton(
                              onPressed: () {
                                controller.isShowPassword = !controller.isShowPassword;
                                controller.update(['LoginPage']);
                              },
                              icon: controller.isShowPassword ? const Icon(Icons.visibility_off) : const Icon(Icons.visibility),
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: controller.isShowPasswordError,
                        child: const Text(
                          'Password is required',
                          style: TextStyle(color: Colors.red, fontSize: 11, fontFamily: 'Poppins'),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: InkWell(
                          onTap: () {},
                          child: const Text(
                            'Forgot Password?',
                            style: TextStyle(color: Color(0xFF1A8C9E), fontSize: 12, fontFamily: 'Poppins-SB'),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () {
                          if (controller.userNameController.text.isNotEmpty && controller.passwordController.text.isNotEmpty) {
                            Get.to(() => ContactPage());
                          } else {
                            if (controller.userNameController.text.isEmpty) {
                              controller.isShowUserNameError = true;
                            } else {
                              controller.isShowUserNameError = false;
                            }

                            if (controller.passwordController.text.isEmpty) {
                              controller.isShowPasswordError = true;
                            } else {
                              controller.isShowPasswordError = false;
                            }

                            controller.update(['LoginPage']);
                          }
                        },
                        child: Container(
                          width: Get.width,
                          height: 50,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(color: const Color(0xFF1A8C9E), borderRadius: BorderRadius.circular(5)),
                          child: const Text(
                            'Login',
                            style: TextStyle(color: Colors.white, fontSize: 16, fontFamily: 'Poppins-SB'),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }
}
