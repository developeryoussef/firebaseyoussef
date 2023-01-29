// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, unused_import, unnecessary_null_comparison, unnecessary_new, prefer_typing_uninitialized_variables, sort_child_properties_last, prefer_interpolation_to_compose_strings, depend_on_referenced_packages, unnecessary_string_interpolations, await_only_futures

import 'dart:math';
import 'dart:io';
import 'package:firebase/SignUp.dart';
import 'package:firebase/controller/firebase_controller.dart';
import 'package:firebase/home_page.dart';
import 'package:firebase/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'firebase_options.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class AddNote extends StatefulWidget {
  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  File? file;

  String? title;

  String? content;

  String? imageURL;

  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  addNote() async {
    var formData = formState.currentState;

    if (formData!.validate()) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Wait'),
            content: CircularProgressIndicator(),
          );
        },
      );
      formData.save();
      Reference ref = await FirebaseStorage.instance.ref('images');
      await ref.putFile(file!);
      imageURL = await ref.getDownloadURL();

      await FirebaseFirestore.instance
          .collection('notes')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
        'title': title,
        'content': content,
        'imageURL': imageURL,
      });
      // });
      Get.to(HomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<FirebaseController>(
        init: FirebaseController(),
        builder: (controller) {
          return ListView(
            children: [
              Row(
                children: [
                  BackButton(),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () async {
                        await addNote();
                      },
                      child: Text('save',
                          style: TextStyle(
                            color: Colors.blue.shade800,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  MaterialButton(
                    onPressed: () {
                      showModalBottomSheet(
                        context: context,
                        builder: (context) {
                          return Container(
                            height: 200,
                            padding: EdgeInsets.all(22),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text('Choose the image source',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    )),
                                SizedBox(
                                  height: 30,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    var imageP = await ImagePicker();
                                    var picked = await imageP.pickImage(
                                        source: ImageSource.gallery);

                                    if (picked != null) {
                                      file = File(picked.path);

                                      var random = Random().nextInt(1000000);

                                      var imagename =
                                          '$random' + p.basename(picked.path);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      Icon(Icons.wallpaper),
                                      SizedBox(
                                        width: 15,
                                      ),
                                      Text('Choose image from gallery',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          )),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: CircleAvatar(
                      radius: 30,
                      child: Icon(
                        Icons.add_a_photo,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.grey.shade500,
                    ),
                  ),
                  Spacer()
                ],
              ),
              Form(
                  key: formState,
                  child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onSaved: ((newValue) {
                            title = newValue;
                          }),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'title',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          onSaved: ((newValue) {
                            content = newValue;
                          }),
                          decoration: InputDecoration(
                              prefixIcon: Icon(Icons.person),
                              hintText: 'content',
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              )),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ])))
            ],
          );
        },
      ),
    );
  }
}
