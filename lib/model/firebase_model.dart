// ignore_for_file: unused_import, must_be_immutable, avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

class Button extends StatelessWidget {
  String? text;
  void Function()? onPressed;
  Button({super.key, required this.text, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.network(
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTCIl2w_G1DS7FZOIhnO-r0y4DIpz0OnOwiIg&usqp=CAU',
        ),
        SizedBox(
          height: 50,
        ),
        MaterialButton(
          onPressed: onPressed!,
          child: Container(
            child: Text(text!),
          ),
        ),
      ],
    );
  }
}
