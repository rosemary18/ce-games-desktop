import 'dart:io';

import 'package:cegames/src/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class PickerImage extends StatefulWidget {

  final EdgeInsets margin;
  final EdgeInsets padding;
  final double heigth;
  final double width;
  final String path;
  final String title;
  final Function(String path) onChange;

  const PickerImage({
    super.key,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.path = "",
    this.title = "",
    this.heigth = 80, 
    this.width = 80,
    required this.onChange, 
  });

  @override
  State<PickerImage> createState() => _PickerImageState();
}

class _PickerImageState extends State<PickerImage> {

  String _path = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      _path = widget.path;
    });
  }

  @override
  void didUpdateWidget(covariant PickerImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      _path = widget.path;
    });
  }

  void handlerSelectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['png', 'jpg', 'jpeg']);
    if (result != null) {
      setState(() {
        _path = result.files.first.path!;
      });
      widget.onChange(_path);
    }
  }

  void handlerRemoveFile() {
    setState(() {
      _path = "";
    });
    widget.onChange(_path);
  }

  @override
  Widget build(BuildContext context) {
    return TouchableOpacity(
      onPress: handlerSelectFile,
      child: Stack(
        children: [
          Container(
            padding: widget.padding,
            margin: widget.margin,
            height: widget.heigth,
            width: widget.width,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(4)),
            ),
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: _path != "" ? 
            Image.file(
              File(_path),
              fit: BoxFit.cover,
            ) : Image.asset(
              appImages["IMG_DEFAULT"]!,
              fit: BoxFit.cover,
            ),
          ),
          if (_path != "") Positioned(
            top: 0,
            right: -8,
            child: IconButton(
              icon: const Icon(
                Icons.close, 
                size: 14,
                color: Colors.white
              ),
              onPressed: handlerRemoveFile
            ),
          )
        ],
      ) 
    );
  }
}