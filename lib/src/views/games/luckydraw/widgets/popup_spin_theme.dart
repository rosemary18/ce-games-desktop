import 'dart:math';

import 'package:cegames/src/index.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PopUpSpinTheme extends StatefulWidget { 

  final WindowSpinSettingsModel? windowSpinSetting;
  final Function(WindowSpinSettingsModel?)? handlerSaveWindowSpinSetting;

  const PopUpSpinTheme({
    super.key, 
    required this.windowSpinSetting,
    required this.handlerSaveWindowSpinSetting
  });

  @override
  State<PopUpSpinTheme> createState() => _PopUpSpinThemeState();
}

class _PopUpSpinThemeState extends State<PopUpSpinTheme> {

  final WindowSpinSettingsModel _windowSpinSetting = WindowSpinSettingsModel();
  final storage = const FlutterSecureStorage();

  final titleSizeController = TextEditingController();
  final titleVerticalPositionController = TextEditingController();
  final prizeImageHeightController = TextEditingController();
  final prizeImageWidthController = TextEditingController();
  final prizeImagePositionXController = TextEditingController();
  final slotHeightController = TextEditingController();
  final slotWidthController = TextEditingController();
  final slotSpacingController = TextEditingController();
  final textSizeController = TextEditingController();
  final volumeSoundController = TextEditingController();
  final List<PickerListItemModel> boxFitItems = List.generate(BoxFit.values.length, (index) => PickerListItemModel(value: BoxFit.values[index].name, data: BoxFit.values[index]));

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
      _windowSpinSetting.backgroundColor = widget.windowSpinSetting!.backgroundColor;
      _windowSpinSetting.backgroundImage = widget.windowSpinSetting!.backgroundImage;
      _windowSpinSetting.backgroundImageFit = widget.windowSpinSetting!.backgroundImageFit;
      _windowSpinSetting.prizeImageHeight = widget.windowSpinSetting!.prizeImageHeight;
      _windowSpinSetting.prizeImageWidth = widget.windowSpinSetting!.prizeImageWidth;
      _windowSpinSetting.prizeImagePositionX = widget.windowSpinSetting!.prizeImagePositionX;
      _windowSpinSetting.slotHeight = widget.windowSpinSetting!.slotHeight;
      _windowSpinSetting.slotWidth = widget.windowSpinSetting!.slotWidth;
      _windowSpinSetting.slotSpacing = widget.windowSpinSetting!.slotSpacing;
      _windowSpinSetting.slotColor = widget.windowSpinSetting!.slotColor;
      _windowSpinSetting.textColor = widget.windowSpinSetting!.textColor;
      _windowSpinSetting.textSize = widget.windowSpinSetting!.textSize;
      _windowSpinSetting.withTitle = widget.windowSpinSetting!.withTitle;
      _windowSpinSetting.titleColor = widget.windowSpinSetting!.titleColor;
      _windowSpinSetting.titleSize = widget.windowSpinSetting!.titleSize;
      _windowSpinSetting.titleVerticalPosition = widget.windowSpinSetting!.titleVerticalPosition;
      _windowSpinSetting.volumeSound = widget.windowSpinSetting!.volumeSound;
      _windowSpinSetting.spinSoundPath = widget.windowSpinSetting!.spinSoundPath;
      _windowSpinSetting.winSoundPath = widget.windowSpinSetting!.winSoundPath;
      _windowSpinSetting.enabledSpinSound = widget.windowSpinSetting!.enabledSpinSound;
      _windowSpinSetting.enabledWinSound = widget.windowSpinSetting!.enabledWinSound;
      _windowSpinSetting.enableLabelSlot = widget.windowSpinSetting!.enableLabelSlot;

      titleSizeController.text = _windowSpinSetting.titleSize.toString();
      titleVerticalPositionController.text = _windowSpinSetting.titleVerticalPosition.toString();
      prizeImageHeightController.text = _windowSpinSetting.prizeImageHeight.toString();
      prizeImageWidthController.text = _windowSpinSetting.prizeImageWidth.toString();
      prizeImagePositionXController.text = _windowSpinSetting.prizeImagePositionX.toString();
      slotHeightController.text = _windowSpinSetting.slotHeight.toString();
      slotWidthController.text = _windowSpinSetting.slotWidth.toString();
      slotSpacingController.text = _windowSpinSetting.slotSpacing.toString();
      textSizeController.text = _windowSpinSetting.textSize.toString();
      volumeSoundController.text = _windowSpinSetting.volumeSound.toString();

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
          Container(
            height: MediaQuery.of(context).size.height * 0.5,
            clipBehavior: Clip.hardEdge,
            decoration: const BoxDecoration(),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Suara", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: PickerFile(
                                disable: !_windowSpinSetting.enabledSpinSound,
                                title: "Ubah Suara Spin",
                                extensions: const ["mp3", "wav", "ogg"],
                                path: _windowSpinSetting.spinSoundPath,
                                onChange: (path) => setState(() => _windowSpinSetting.spinSoundPath = path),
                                margin: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
                              child: Switch(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: _windowSpinSetting.enabledSpinSound,
                                onChanged: (value) => setState(() => _windowSpinSetting.enabledSpinSound = value),
                              ),
                            )
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: PickerFile(
                                disable: !_windowSpinSetting.enabledWinSound,
                                title: "Ubah Suara Kemenangan",
                                extensions: const ["mp3", "wav", "ogg"],
                                path: _windowSpinSetting.winSoundPath,
                                onChange: (path) => setState(() => _windowSpinSetting.winSoundPath = path),
                                margin: const EdgeInsets.only(top: 4, bottom: 4, right: 4),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
                              child: Switch(
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                value: _windowSpinSetting.enabledWinSound,
                                onChanged: (value) => setState(() => _windowSpinSetting.enabledWinSound = value),
                              ),
                            )
                          ],
                        ),
                        Input(
                          label: "Volume",
                          controller: volumeSoundController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinSetting.volumeSound = min(double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.volumeSound, 100);
                            volumeSoundController.text = min(double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.volumeSound, 100).toString();
                          }),
                        ),
                      ],
                    )
                  ),

                  const Divider(
                    color: Colors.white,
                    thickness: 0.5,
                  ),

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
                                  fontWeight: FontWeight.bold
                                )
                              ),
                              if (_windowSpinSetting.withTitle) PickerColor(
                                margin: const EdgeInsets.only(top: 8),
                                value: _windowSpinSetting.titleColor, 
                                onSubmit: (color) => setState(() => _windowSpinSetting.titleColor = color)
                              ),
                              Input(
                                label: "Ukuran Huruf",
                                controller: titleSizeController,
                                margin: const EdgeInsets.only(top: 8),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  _windowSpinSetting.titleSize = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.titleSize;
                                }),
                              ),
                              Input(
                                label: "Jarak Dari Atas",
                                controller: titleVerticalPositionController,
                                margin: const EdgeInsets.only(top: 8),
                                width: 200,
                                onChanged: (value) => setState(() {
                                  _windowSpinSetting.titleVerticalPosition = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.titleVerticalPosition;
                                }),
                              ),
                            ],
                          )
                        ),
                        Switch(
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          value: _windowSpinSetting.withTitle,
                          onChanged: (value) => setState(() => _windowSpinSetting.withTitle = value),
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
                            fontWeight: FontWeight.bold
                          )
                        ),
                        PickerColor(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          value: _windowSpinSetting.backgroundColor, 
                          onSubmit: (color) => setState(() => _windowSpinSetting.backgroundColor = color)
                        ),
                        const Text(
                          "Pilih Gambar: ", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 10,
                          )
                        ),
                        PickerImage(
                          margin: const EdgeInsets.only(top: 8, bottom: 12),
                          path: _windowSpinSetting.backgroundImage,
                          onChange: (image) => setState(() => _windowSpinSetting.backgroundImage = image)
                        ),
                        const Text(
                          "Penyesuaian Gambar: ", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 10,
                          )
                        ),
                        PickerList(
                          width: 140,
                          value: boxFitItems[
                            boxFitItems.indexWhere((e) => e.data == _windowSpinSetting.backgroundImageFit) != -1 ? 
                            boxFitItems.indexWhere((e) => e.data == _windowSpinSetting.backgroundImageFit) 
                            : 0
                          ],
                          list: boxFitItems,
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          onChange: (item, index) {
                            setState(() {
                              _windowSpinSetting.backgroundImageFit = item.data;
                            });
                          },
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
                          "Gambar Hadiah", 
                          style: TextStyle(
                            color: Colors.white, 
                            fontSize: 14,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Input(
                          label: "Tinggi",
                          controller: prizeImageHeightController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                             _windowSpinSetting.prizeImageHeight = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.prizeImageHeight;
                          }),
                        ),
                        Input(
                          label: "Lebar",
                          controller: prizeImageWidthController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinSetting.prizeImageWidth = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.prizeImageWidth;
                          }),
                        ),
                        Input(
                          label: "Jarak dari kiri",
                          controller: prizeImagePositionXController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinSetting.prizeImagePositionX = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.prizeImagePositionX;
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
                            fontWeight: FontWeight.bold
                          )
                        ),
                        Container(
                          margin: const EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(bottom: 2),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text(
                                      "Label slot", 
                                      style: TextStyle(
                                        color: Colors.white, 
                                        fontSize: 18,
                                      )
                                    ),
                                    Container(
                                      padding: const EdgeInsets.only(top: 4, bottom: 4, left: 4),
                                      child: Switch(
                                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                        value: _windowSpinSetting.enableLabelSlot,
                                        onChanged: (value) => setState(() => _windowSpinSetting.enableLabelSlot = value),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              const Text(
                                "Warna Huruf ", 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10,
                                )
                              ),
                              PickerColor(
                                margin: const EdgeInsets.only(top: 2, bottom: 12),
                                value: _windowSpinSetting.textColor, 
                                onSubmit: (color) => setState(() => _windowSpinSetting.textColor = color)
                              ),
                              const Text(
                                "Warna Slot ", 
                                style: TextStyle(
                                  color: Colors.white, 
                                  fontSize: 10,
                                )
                              ),
                              PickerColor(
                                margin: const EdgeInsets.only(top: 2),
                                value: _windowSpinSetting.slotColor, 
                                onSubmit: (color) => setState(() => _windowSpinSetting.slotColor = color)
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
                            _windowSpinSetting.textSize = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.textSize;
                          }),
                        ),
                        Input(
                          label: "Tinggi",
                          controller: slotHeightController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                             _windowSpinSetting.slotHeight = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.slotHeight;
                          }),
                        ),
                        Input(
                          label: "Lebar",
                          controller: slotWidthController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinSetting.slotWidth = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.slotWidth;
                          }),
                        ),
                        Input(
                          label: "Space",
                          controller: slotSpacingController,
                          margin: const EdgeInsets.only(top: 8),
                          width: 200,
                          onChanged: (value) => setState(() {
                            _windowSpinSetting.slotSpacing = double.tryParse(value) != null ? double.parse(value) : _windowSpinSetting.slotSpacing;
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
                widget.handlerSaveWindowSpinSetting!(_windowSpinSetting);
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