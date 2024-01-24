import 'dart:io';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wakul2/controller/users/userController.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final UserController controller = UserController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController restaurantNameController =
      TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController imageController = TextEditingController();

  @override
  void initState() {
    super.initState();

    controller.onImageChanged = () {
      setState(() {});
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan Akun'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: UserController().getDataUser(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                // Handle loading state, for example, show a loading indicator.
                return CircularProgressIndicator();
              }

              final user = snapshot.data?.data() ?? {};
              usernameController.text = user['username'] ?? '';
              emailController.text = user['email'] ?? '';
              restaurantNameController.text = user['name_restaurant'] ?? '';
              addressController.text = user['address'] ?? '';
              imageController.text = user['imageUrls'] ?? '';

              print(user);
              return Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Stack(
                      children: [
                        // GestureDetector(
                        //   onTap: () {
                        //     // Add your onTap action for AvatarGlow here
                        //     controller.pickImage();
                        //   },
                        //   child: AvatarGlow(
                        //     glowColor: Colors.black,
                        //     endRadius: 80,
                        //     duration: const Duration(seconds: 2),
                        //     repeat: true,
                        //     repeatPauseDuration: Duration(milliseconds: 100),
                        //     child: Container(
                        //       margin: const EdgeInsets.all(15),
                        //       width: 175,
                        //       height: 175,
                        //       decoration: BoxDecoration(
                        //         borderRadius: BorderRadius.circular(100),
                        //         boxShadow: [
                        //           BoxShadow(
                        //             color: Colors.blueAccent.withOpacity(0.5),
                        //             spreadRadius: 5,
                        //             blurRadius: 15,
                        //             offset: Offset(0, 3),
                        //           ),
                        //         ],
                        //       ),
                        //       child: CircleAvatar(
                        //         backgroundColor: Colors.transparent,
                        //         backgroundImage: controller.image != null
                        //             ? FileImage(File(controller.image!.path))
                        //                 as ImageProvider<Object>?
                        //             : const AssetImage('images/user3.png'),
                        //         radius: 75.0,
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        GestureDetector(
                          onTap: () {
                            // Add your onTap action for AvatarGlow here
                            controller.pickImage();
                          },
                          child: Builder(
                            builder: (BuildContext context) {
                              return AvatarGlow(
                                glowColor: Colors.black,
                                endRadius: 80,
                                duration: const Duration(seconds: 2),
                                repeat: true,
                                repeatPauseDuration:
                                    Duration(milliseconds: 100),
                                child: Container(
                                  margin: const EdgeInsets.all(15),
                                  width: 175,
                                  height: 175,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color:
                                            Colors.blueAccent.withOpacity(0.5),
                                        spreadRadius: 5,
                                        blurRadius: 15,
                                        offset: Offset(0, 3),
                                      ),
                                    ],
                                  ),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    backgroundImage: controller.image != null
                                        ? FileImage(
                                                File(controller.image!.path))
                                            as ImageProvider<Object>?
                                        : NetworkImage(imageController.text),
                                    radius: 75.0,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              controller.pickImage();
                            },
                            child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  width: 4,
                                  color: Colors.white,
                                ),
                                color: Colors.blue,
                              ),
                              child: Icon(
                                Icons.edit,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: usernameController,
                      decoration: InputDecoration(
                        labelText: 'Username',
                        icon: const Icon(Icons.person),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        icon: const Icon(Icons.email),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                    SizedBox(height: 10),
                    StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                      stream: UserController().streamRole(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        }

                        String? role = snapshot.data!.data()!["roles"];

                        if (role == "seller") {
                          return TextField(
                            controller: restaurantNameController,
                            decoration: InputDecoration(
                              labelText: 'Nama Restaurant',
                              icon: const Icon(Icons.store),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 16.0,
                              ),
                            ),
                          );
                        } else {
                          // Return an empty container or null if the user is not a seller
                          return SizedBox();
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: addressController,
                      readOnly: true,
                      decoration: InputDecoration(
                        labelText: 'Alamat',
                        icon: const Icon(Icons.location_on),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 16.0),
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: ElevatedButton(
                        onPressed: () {
                          controller.updateProfile(usernameController.text,
                              emailController.text, imageController.text);
                        },
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all<Color>(Colors.amber),
                        ),
                        child: Text(
                          'Simpan Perubahan',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
