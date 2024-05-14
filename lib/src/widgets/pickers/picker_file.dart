import 'package:cegames/src/index.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:iconly/iconly.dart';

class PickerFile extends StatefulWidget {

  final EdgeInsets margin;
  final EdgeInsets padding;
  final String path;
  final String title;
  final Function(String path) onChange;
  final List<String> extensions;
  final bool disable;

  const PickerFile({
    super.key,
    this.margin = const EdgeInsets.only(bottom: 4),
    this.padding = const EdgeInsets.all(10),
    this.path = "",
    this.title = "",
    required this.onChange,
    this.extensions = const ["txt"],
    this.disable = false
  });

  @override
  State<PickerFile> createState() => _PickerFileState();
}

class _PickerFileState extends State<PickerFile> {

  String _path = "";
  String _fileName = "Pilih file";

  @override
  void initState() {
    super.initState();
    _path = widget.path;
    _fileName = _path.isNotEmpty ? _path.split('/').last : "Pilih file";
  }

  void handlerSelectFile() async {
    final FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: widget.extensions);
    if (result != null) {
      setState(() {
        _path = result.files.first.path!;
        _fileName = _path.split('/').last;
      });
      widget.onChange(_path);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.title.isNotEmpty) Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(widget.title, style: const TextStyle(color: Colors.white, fontSize: 10),),
          ),
          TouchableOpacity(
            onPress: handlerSelectFile,
            disable: widget.disable,
            child: Container(
              padding: widget.padding,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1, 
                  color: Colors.white30
                ),
                borderRadius: const BorderRadius.all(Radius.circular(4)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_fileName, style: const TextStyle(color: Colors.white, fontSize: 12),),
                  const Icon(IconlyBroken.arrow_down_2, color: Colors.white, size: 16,),
                ],
              ),
            ), 
          )
        ],
      ), 
    );
  }
}