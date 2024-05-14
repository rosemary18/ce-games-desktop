import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PopUpSpinTheme extends StatefulWidget { 

  final WindowSpinThemeModel? windowSpinTheme;
  final Function(WindowSpinThemeModel?)? handlerSaveWindowSpinTheme;

  const PopUpSpinTheme({
    super.key, 
    required this.windowSpinTheme,
    required this.handlerSaveWindowSpinTheme
  });

  @override
  State<PopUpSpinTheme> createState() => _PopUpSpinThemeState();
}

class _PopUpSpinThemeState extends State<PopUpSpinTheme> {

  final WindowSpinThemeModel _windowSpinTheme = WindowSpinThemeModel();
  final storage = const FlutterSecureStorage();

  final titleSizeController = TextEditingController();
  final prizeImageHeightController = TextEditingController();
  final prizeImageWidthController = TextEditingController();
  final prizeImagePositionXController = TextEditingController();
  final slotHeightController = TextEditingController();
  final slotWidthController = TextEditingController();
  final slotSpacingController = TextEditingController();
  final textSizeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    handlerlerAssignToTemp();
  }

  @override
  void didUpdateWidget(covariant PopUpSpinTheme oldWidget) {
    super.didUpdateWidget(oldWidget);
    handlerlerAssignToTemp();
  }

  void handlerlerAssignToTemp() {
    setState(() {
      _windowSpinTheme.backgroundColor = widget.windowSpinTheme!.backgroundColor;
      _windowSpinTheme.backgroundImage = widget.windowSpinTheme!.backgroundImage;
      _windowSpinTheme.prizeImageHeight = widget.windowSpinTheme!.prizeImageHeight;
      _windowSpinTheme.prizeImageWidth = widget.windowSpinTheme!.prizeImageWidth;
      _windowSpinTheme.prizeImagePositionX = widget.windowSpinTheme!.prizeImagePositionX;
      _windowSpinTheme.slotHeight = widget.windowSpinTheme!.slotHeight;
      _windowSpinTheme.slotWidth = widget.windowSpinTheme!.slotWidth;
      _windowSpinTheme.slotSpacing = widget.windowSpinTheme!.slotSpacing;
      _windowSpinTheme.textColor = widget.windowSpinTheme!.textColor;
      _windowSpinTheme.textSize = widget.windowSpinTheme!.textSize;
      _windowSpinTheme.withTitle = widget.windowSpinTheme!.withTitle;
      _windowSpinTheme.titleColor = widget.windowSpinTheme!.titleColor;

      titleSizeController.text = _windowSpinTheme.titleSize.toString();
      prizeImageHeightController.text = _windowSpinTheme.prizeImageHeight.toString();
      prizeImageWidthController.text = _windowSpinTheme.prizeImageWidth.toString();
      prizeImagePositionXController.text = _windowSpinTheme.prizeImagePositionX.toString();
      slotHeightController.text = _windowSpinTheme.slotHeight.toString();
      slotWidthController.text = _windowSpinTheme.slotWidth.toString();
      slotSpacingController.text = _windowSpinTheme.slotSpacing.toString();
      textSizeController.text = _windowSpinTheme.textSize.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Atur Tampilan Window SPIN", style: TextStyle(color: Colors.white, fontSize: 20),),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child:  Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               const Text(
                                "Judul", 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                                )
                              ),
                              if (_windowSpinTheme.withTitle) PickerColor(
                                margin: const EdgeInsets.only(top: 8),
                                value: _windowSpinTheme.titleColor, 
                                onSubmit: (color) => setState(() => _windowSpinTheme.titleColor = color)
                              ),
                              Input(
                                label: "Ukuran Huruf",
                                controller: titleSizeController,
                                margin: const EdgeInsets.only(top: 8),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  _windowSpinTheme.titleSize = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.titleSize;
                                }),
                              ),
                            ],
                          )
                        ),
                        Switch(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: _windowSpinTheme.withTitle,
                          onChanged: (value) => setState(() => _windowSpinTheme.withTitle = value),
                        )
                      ],
                    ),
                  ),

                  const Divider(
                    color: Colors.white,
                    thickness: 0.5,
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Background", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        PickerColor(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          value: _windowSpinTheme.backgroundColor, 
                          onSubmit: (color) => setState(() => _windowSpinTheme.backgroundColor = color)
                        ),
                        const Text(
                          "Pilih Gambar: ", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 10,
                          )
                        ),
                        PickerImage(
                          margin: const EdgeInsets.only(top: 8),
                          path: _windowSpinTheme.backgroundImage,
                          onChange: (image) => setState(() => _windowSpinTheme.backgroundImage = image)
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    color: Colors.white,
                    thickness: 0.5,
                  ),
                  
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Gambar Hadiah", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        Input(
                          label: "Tinggi",
                          controller: prizeImageHeightController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                             _windowSpinTheme.prizeImageHeight = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.prizeImageHeight;
                          }),
                        ),
                        Input(
                          label: "Lebar",
                          controller: prizeImageWidthController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinTheme.prizeImageWidth = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.prizeImageWidth;
                          }),
                        ),
                        Input(
                          label: "Jarak dari kiri",
                          controller: prizeImagePositionXController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinTheme.prizeImagePositionX = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.prizeImagePositionX;
                          }),
                        )
                      ],
                    ),
                  ),

                  const Divider(
                    color: Colors.white,
                    thickness: 0.5,
                  ),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Slot", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 14,
                            fontWeight: FontWeight.w700
                          )
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Warna Huruf ", 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10,
                                )
                              ),
                              PickerColor(
                                margin: const EdgeInsets.only(top: 2),
                                value: _windowSpinTheme.textColor, 
                                onSubmit: (color) => setState(() => _windowSpinTheme.textColor = color)
                              )
                            ],
                          ),
                        ),
                        Input(
                          label: "Ukuran Huruf",
                          controller: textSizeController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinTheme.textSize = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.textSize;
                          }),
                        ),
                        Input(
                          label: "Tinggi",
                          controller: slotHeightController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                             _windowSpinTheme.slotHeight = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.slotHeight;
                          }),
                        ),
                        Input(
                          label: "Lebar",
                          controller: slotWidthController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinTheme.slotWidth = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.slotWidth;
                          }),
                        ),
                        Input(
                          label: "Space",
                          controller: slotSpacingController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinTheme.slotSpacing = double.tryParse(value) != null ? double.parse(value) : _windowSpinTheme.slotSpacing;
                          }),
                        ),
                      ],
                    ),
                  ),
                  
                ]
              )
            )
          ),
          const Divider(
            color: Colors.white,
            thickness: 0.5,
          ),
          Center(
            child: TouchableOpacity(
              onPress: () {
                Navigator.of(context).pop();
                widget.handlerSaveWindowSpinTheme!(_windowSpinTheme);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 24),
                margin: const EdgeInsets.only(top: 12),
                decoration: const BoxDecoration(
                  color:  Color.fromARGB(255, 189, 65, 211),
                  borderRadius: BorderRadius.all(Radius.circular(4))
                ),
                child: Text("Simpan", style: appStyles["text"]!["bold1White"]),
              )
            ),
          ),
        ],
      ),
    );
  }
}