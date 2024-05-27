import 'package:flutter/material.dart';

class PickerListItemModel {

  String value;
  dynamic data;

  PickerListItemModel({required this.value, required this.data});
}

class PickerList extends StatefulWidget {

  final List<PickerListItemModel> list;
  final double width;
  final double height;
  final PickerListItemModel? value;
  final Function(PickerListItemModel, int id)? onChange;
  final bool disable;
  final bool firstItemDisable;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const PickerList({
    super.key, 
    required this.list,
    this.width = 100,
    this.height = 40,
    this.onChange,
    this.value,
    this.disable = false,
    this.firstItemDisable = false,
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.padding = const EdgeInsets.only(left: 18, right: 12)
  });

  @override
  State<PickerList> createState() => _PickerListState();
}

class _PickerListState extends State<PickerList> {
  
  PickerListItemModel? _value;

  @override
  void initState() {
    super.initState();
    setState(() {
      _value = widget.value;
    });
  }

  @override
  void didUpdateWidget(covariant PickerList oldWidget) {
    
    super.didUpdateWidget(oldWidget);
    setState(() {
      _value = widget.value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(10)
      ),
      child: DropdownButton<PickerListItemModel>(
        value: _value,
        isExpanded: true,
        underline: const SizedBox(),
        iconSize: 24,
        iconEnabledColor: const Color.fromARGB(255, 204, 105, 222),
        iconDisabledColor: Colors.transparent,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        dropdownColor: const Color.fromARGB(255, 34, 43, 55),
        borderRadius: BorderRadius.circular(10),
        menuMaxHeight: 300,
        padding: widget.padding,
        hint: const Text("Pilih", 
          overflow: TextOverflow.ellipsis, 
          maxLines: 1,
          style: TextStyle(color: Colors.white, fontSize: 14)
        ),
        items: widget.list.map((PickerListItemModel item) {
          return DropdownMenuItem<PickerListItemModel>(
            enabled: !(widget.firstItemDisable && item == widget.list.first),
            value: item,
            child: Text(
              item.value, 
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(color: !(widget.firstItemDisable && item == widget.list.first) ? Colors.white : Colors.white60, fontSize: 14)
            ),
          );
        }).toList(),
        onChanged: widget.disable ? null : (PickerListItemModel? value) {
          setState(() {
            _value = value;
          });
          int index = widget.list.indexOf(_value!);
          widget.onChange!(value!, index);
        },
        elevation: 12,
      ),
    );
  }
}