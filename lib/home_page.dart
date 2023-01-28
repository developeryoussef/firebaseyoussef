// ignore_for_file: use_build_context_synchronously, unused_local_variable, avoid_print, avoid_function_literals_in_foreach_calls, prefer_const_constructors, unrelated_type_equality_checks, prefer_const_literals_to_create_immutables, unused_import, unnecessary_null_comparison, unnecessary_new, prefer_typing_uninitialized_variables, avoid_single_cascade_in_expression_statements, unnecessary_cast

import 'dart:math';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase/SignUp.dart';
import 'package:firebase/addNote.dart';
import 'package:firebase/controller/firebase_controller.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<QuerySnapshot<Map<String, dynamic>>> getData() async {
    return await FirebaseFirestore.instance.collection('notes').get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Get.to(AddNote());
        },
      ),
      appBar: AppBar(
        title: Text('home page'),
        actions: [
          IconButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                AwesomeDialog(
                  alignment: Alignment.center,
                  context: context,
                  body: Text(
                      'please.... restart the app to change the auth state'),
                  title: 'Auth System',
                )..show();
              },
              icon: Icon(Icons.ac_unit_sharp))
        ],
      ),
      body: GetBuilder<FirebaseController>(
        init: FirebaseController(),
        builder: (controller) {
          return FutureBuilder<DocumentSnapshot>(
            future: FirebaseFirestore.instance
                .collection('notes')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .get(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                print(FirebaseAuth.instance.currentUser!.uid);
                print(snapshot.data!);
                return Text('');

                // return ListView.builder(
                //   // itemCount: 1,
                //   // itemBuilder: (context, index) {
                //   //   return Column(
                //   //     children: [
                //   //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                //   //       Text('title : ${da['title']}'),
                //   //     ],
                //   //   );
                //   // },
                // );
              }
              return Text('error');
            },
          );
        },
      ),
    );
  }
}
