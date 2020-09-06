import 'package:flutter/material.dart';

const textInputDecoration = InputDecoration(
  hintText: '',
  prefixIcon: Icon(Icons.email, color: Colors.grey),
  hintStyle: TextStyle(color: Colors.grey, fontSize: 17),
  filled: true,
  fillColor: Colors.white70,
  focusedBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Colors.black38,
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(
      color: Colors.black12,
    ),
  ),
);
