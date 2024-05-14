import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconly/iconly.dart';

class Input extends StatefulWidget {

  final EdgeInsets margin;
  final String placeholder;
  final String? errorText;
  final String? label;
  final double? width;
  final TextEditingController? controller;
  final TextStyle textStyle;
  final int? maxCharacter;
  final bool enabled;
  final bool obscure;
  final Widget? prefixIcon;
  final Function(String)? onChanged;
  final Function(String)? onSubmitted;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;

  const Input(
      {super.key,
      this.margin = const EdgeInsets.only(bottom: 4),
      this.placeholder = "Placeholder",
      this.errorText,
      this.label,
      this.width,
      this.controller,
      this.textStyle = const TextStyle(color: Colors.white),
      this.maxCharacter,
      this.enabled = true,
      this.obscure = false,
      this.prefixIcon,
      this.onChanged,
      this.onSubmitted, 
      this.keyboardType,
      this.inputFormatters
    });

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late bool obscureText = widget.obscure;

  Widget buildIconObscure() {
    return TouchableOpacity(
      child: (obscureText) ? const Icon(
        IconlyBold.show,
        color: Colors.white12,
        size: 20,
      ) : const Icon(
        IconlyBold.hide,
        size: 20,
        color: Colors.white70,
      ),
      onPress: () {
        setState(() {
          obscureText = !obscureText;
        });
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: widget.margin,
      width: widget.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.label != null ) Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(widget.label ?? "", style: const TextStyle(color: Colors.white, fontSize: 10),),
          ),
          TextField(
            controller: widget.controller,
            onChanged: widget.onChanged,
            onSubmitted: widget.onSubmitted,
            cursorColor: Colors.white60,
            enabled: widget.enabled,
            keyboardType: widget.keyboardType,
            inputFormatters: widget.inputFormatters,
            decoration: InputDecoration(
              prefixIcon: widget.prefixIcon,
              contentPadding: const EdgeInsets.all(14),
              hintText: widget.placeholder,
              hintStyle: const TextStyle(color: Colors.white30),
              fillColor: Colors.white10,
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  style: BorderStyle.solid,
                  color: Color.fromARGB(255, 219, 219, 219)
                )
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6.0),
                borderSide: const BorderSide(
                  style: BorderStyle.solid,
                  color: Color.fromARGB(255, 189, 65, 211),
                  // color: Color.fromARGB(255, 219, 219, 219)
                )
              ),
              filled: true,
              counterStyle: const TextStyle(fontSize: 0, height: 0),
              errorText: widget.errorText,
              suffixIcon: widget.obscure ? buildIconObscure() : null
            ),
            style: widget.textStyle,
            obscureText: obscureText,
            maxLength: widget.maxCharacter,
            maxLengthEnforcement: MaxLengthEnforcement.enforced,
          )
        ],
      ),
    );
  }
}