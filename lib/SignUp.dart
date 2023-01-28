// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, unused_import, unnecessary_null_comparison, unnecessary_new, prefer_typing_uninitialized_variables

import 'dart:math';
import 'dart:io';
import 'package:firebase/controller/firebase_controller.dart';
import 'package:firebase/home_page.dart';
import 'package:firebase/signIn.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  showLoading(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Wait'),
          content: CircularProgressIndicator(),
        );
      },
    );
  }

  var email, username, password;

  signUp() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();

      try {
        showLoading(context);
        UserCredential credential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak.');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email.');
        }
      } catch (e) {
        print(e);
      }
    } else {
      print('not validated');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('App Notes'),
      ),
      body: ListView(
        children: [
          SizedBox(
            height: 20,
          ),
          Image.network(
              'https://static.wixstatic.com/media/998325_23e1c09675af4e5fb5f80f04e9278d05~mv2.png/v1/fill/w_580,h_572,al_c,q_85,usm_0.66_1.00_0.01,enc_auto/visual_24_image_edited.png'),
          Form(
              key: formState,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextFormField(
                      onSaved: ((newValue) {
                        username = newValue;
                      }),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'username',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onSaved: ((newValue) {
                        email = newValue;
                      }),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'email',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      onSaved: ((newValue) {
                        password = newValue;
                      }),
                      decoration: InputDecoration(
                          prefixIcon: Icon(Icons.person),
                          hintText: 'password',
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          )),
                    ),
                    Row(
                      children: [
                        Text('If you already have account '),
                        TextButton(
                            onPressed: () {
                              Get.to(SignIn());
                            },
                            child: Text('Sign In'))
                      ],
                    ),
                    MaterialButton(
                        child: Text(
                          'Sign Up',
                          style: TextStyle(),
                        ),
                        onPressed: () async {
                          var response = await signUp();
                          if (response != null) {
                            Get.to(HomePage());
                            await FirebaseFirestore.instance
                                .collection('users')
                                .add({
                              'username': username,
                              'email': email,
                              'password': password,
                            });
                          } else {
                            print('failed');
                          }
                        })
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
