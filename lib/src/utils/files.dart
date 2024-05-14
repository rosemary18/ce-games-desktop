import 'dart:io';
import 'package:flutter/material.dart';

Future<String?> readFile(String path) async {
    try {
      File file = File(path);
      String contents = await file.readAsString();
      return contents;
    } catch (e) {
      debugPrint("Gagal membaca file: $e");
      return null;
    }
  }