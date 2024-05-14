import 'dart:math';

import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';

class PickerColor extends StatefulWidget {

  final Color value;
  final String title;
  final Function(Color)? onSubmit;
  final EdgeInsets margin;
  final EdgeInsets padding;

  const PickerColor({
    super.key,
    required this.value,
    this.title = "Pilih Warna",
    this.onSubmit,
    this.margin = EdgeInsets.zero,
    this.padding = EdgeInsets.zero
  });

  @override
  State<PickerColor> createState() => _PickerColorState();
}

class _PickerColorState extends State<PickerColor> {

  Color _value = Colors.white;

  @override
  void initState() {
    super.initState();
    _value = widget.value;
  }

  @override
  void didUpdateWidget(covariant PickerColor oldWidget) {
    super.didUpdateWidget(oldWidget);
    _value = widget.value;
  }

  void showPicker() {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          contentPadding: const EdgeInsets.all(20),
          insetPadding: EdgeInsets.symmetric(vertical: 100, horizontal: min((MediaQuery.of(context).size.width*.275), 400)),
          title: const Text("Pilih Warna Background", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: MaterialColorPicker(
            selectedColor: _value,
            onColorChange: (color) => setState(() => _value = color),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                widget.onSubmit!(_value);
              },
              child: const Text('Simpan', style: TextStyle(color: Colors.green, fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Pilih Warna:", style: TextStyle(color: Colors.white, fontSize: 10)),
          TouchableOpacity(
            onPress: showPicker,
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              height: 20,
              width: 20,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.white, width: .5)
              ),
              child: Container(
                margin: const EdgeInsets.all(1.3),
                decoration: BoxDecoration(
                  color: _value,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )
          )
        ],
      ),
    );
  }

}