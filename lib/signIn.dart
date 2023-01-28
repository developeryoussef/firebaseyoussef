// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, unused_import, unnecessary_null_comparison, unnecessary_new, prefer_typing_uninitialized_variables, avoid_single_cascade_in_expression_statements

import 'dart:math';
import 'dart:io';
import 'package:firebase/SignUp.dart';
import 'package:firebase/controller/firebase_controller.dart';
import 'package:firebase/home_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:awesome_dialog/awesome_dialog.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  GlobalKey<FormState> formState = new GlobalKey<FormState>();

  var email, password;

  getUser() async {
    var user = FirebaseAuth.instance.currentUser;
    print(user?.email);
  }

  signIn() async {
    var formData = formState.currentState;
    if (formData!.validate()) {
      formData.save();

      try {
        final credential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: email.toString().trim(),
                password: password.toString().trim());
      } on FirebaseAuthException catch (e) {
        if (e.code == 'user-not-found') {
          AwesomeDialog(context: context, body: Text('no user'))..show();
        } else if (e.code == 'wrong-password') {
          AwesomeDialog(context: context, body: Text('wrong password'))..show();
        } else {
          AwesomeDialog(context: context, body: Text('errorr'))..show();
        }
      }
    }
  }

  @override
  void initState() {
    getUser();
    super.initState();
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
                    MaterialButton(
                        child: Text(
                          'Sign In',
                          style: TextStyle(),
                        ),
                        onPressed: () async {
                          var user = await signIn();
                          if (user != null) {
                            Get.to(HomePage());
                            print(user);
                          } else if (user == null) {
                          } else {
                            print('error');
                          }
                        }),
                    TextButton(
                        onPressed: () => Get.to(SignUp()),
                        child: Text('sign up'))
                  ],
                ),
              )),
        ],
      ),
    );
  }
}
