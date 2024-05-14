import 'package:flutter/material.dart';

class PickerNumber extends StatefulWidget {

  final List<int> numberRange;
  final double width;
  final double height;
  final int? initialValue;
  final Function(int)? onChange;
  final EdgeInsets? margin;
  final EdgeInsets? padding;

  const PickerNumber({
    super.key, 
    required this.numberRange,
    this.width = 100,
    this.height = 40,
    this.onChange,
    this.initialValue = 0,
    this.margin = const EdgeInsets.symmetric(horizontal: 0),
    this.padding = const EdgeInsets.only(left: 18, right: 12)
  });

  @override
  State<PickerNumber> createState() => _PickerNumberState();
}

class _PickerNumberState extends State<PickerNumber> {
  
  int? selectedNumber = 0;

  @override
  void initState() {
    super.initState();
    setState(() {
      selectedNumber = widget.initialValue;
    });
  }

  @override
  void didUpdateWidget(covariant PickerNumber oldWidget) {
    
    super.didUpdateWidget(oldWidget);
    setState(() {
      selectedNumber = widget.initialValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      padding: widget.padding,
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(
        color: Colors.white12,
        borderRadius: BorderRadius.circular(100)
      ),
      child: DropdownButton<int>(
        value: selectedNumber,
        isExpanded: true,
        underline: const SizedBox(),
        iconSize: 24,
        iconEnabledColor: const Color.fromARGB(255, 204, 105, 222),
        iconDisabledColor: Colors.transparent,
        style: const TextStyle(color: Colors.white, fontSize: 14),
        dropdownColor: const Color(0xFF1F2937),
        borderRadius: BorderRadius.circular(10),
        menuMaxHeight: 300,
        items: widget.numberRange.map((int value) {
          return DropdownMenuItem<int>(
            value: value,
            child: Text(value.toString()),
          );
        }).toList(),
        onChanged: (int? value) {
          setState(() {
            selectedNumber = value;
          });
          widget.onChange!(value!);
        },
      ),
    );
  }
}