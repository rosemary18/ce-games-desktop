import 'package:flutter/material.dart';

class ParticipantModel {

  String id;
  String name;
  bool available;
  bool defined_prize;

  ParticipantModel({
    required this.id,
    required this.name,
    required this.available,
    required this.defined_prize
  });

  factory ParticipantModel.fromJson(Map<String, dynamic> json) {
    return ParticipantModel(
      id: json['id'],
      name: json['name'],
      available: json['available'],
      defined_prize: json['defined_prize']
    );
  }
  
  toJson() {
    return {
      'id': id,
      'name': name,
      'available': available,
      'defined_prize': defined_prize
    };
  }

}

class PrizeModel {

  String id;
  String prize_name;
  int total;
  String image;
  List<ParticipantModel> winners;
  List<ParticipantModel?> defined_winners;

  PrizeModel({
    required this.id,
    required this.prize_name,
    required this.total,
    this.image = "",
    required this.winners,
    required this.defined_winners
  }); 

  factory PrizeModel.fromJson(Map<String, dynamic> json) {
    return PrizeModel(
      id: json['id'],
      prize_name: json['prize_name'],
      total: json['total'],
      image: json['image'],
      winners: List<ParticipantModel>.from(json['winners'].map((participant) => ParticipantModel.fromJson(participant))),
      defined_winners: List<ParticipantModel?>.from(json['defined_winners'].map((participant) {
        if (participant != null) return ParticipantModel.fromJson(participant);
        else return null;
      })),
    );
  }
  
  toJson() {
    return {
      'id': id,
      'prize_name': prize_name,
      'total': total,
      'image': image,
      'winners': winners,
      'defined_winners': defined_winners
    };
  }

}

class WinnerModel {
  
  String prize_id;
  String prize_name;
  String participant_id;
  String participant_name;

  WinnerModel({
    required this.participant_id,
    required this.participant_name,
    required this.prize_id,
    required this.prize_name
  });

  factory WinnerModel.fromJson(Map<String, dynamic> json) {
    return WinnerModel(
      participant_id: json['participant_id'],
      participant_name: json['participant_name'],
      prize_id: json['prize_id'],
      prize_name: json['prize_name']
    );
  }
  
  toJson() {
    return {
      'participant_id': participant_id,
      'participant_name': participant_name,
      'prize_id': prize_id,
      'prize_name': prize_name
    };
  }

}

class LuckyDrawGameModel {

  String id;
  DateTime date_play;
  DateTime date_last_play;
  List<ParticipantModel> participants;
  List<PrizeModel> prizes;
  List<WinnerModel> winners;

  LuckyDrawGameModel({
    required this.id,
    required this.date_play,
    required this.date_last_play,
    required this.participants,
    required this.prizes,
    required this.winners,
  });

  factory LuckyDrawGameModel.fromJson(Map<String, dynamic> json) {
    return LuckyDrawGameModel(
      id: json['id'],
      date_play: DateTime.parse(json['date_play']),
      date_last_play: DateTime.parse(json['date_last_play']),
      participants: List<ParticipantModel>.from(json['participants'].map((participant) => ParticipantModel.fromJson(participant))),
      prizes: List<PrizeModel>.from(json['prizes'].map((prize) => PrizeModel.fromJson(prize))),
      winners: List<WinnerModel>.from(json['winners'].map((winner) => WinnerModel.fromJson(winner)))
    );
  }

  toJson() {
    return {
      'id': id,
      'date_play': date_play.toString(),
      'date_last_play': date_last_play.toString(),
      'participants': participants.map((participant) => participant.toJson()).toList(),
      'prizes': prizes.map((prize) => prize.toJson()).toList(),
      'winners': winners.map((winner) => winner.toJson()).toList()
    };
  }

}

class LuckyDrawHistoryModel {

  List<LuckyDrawGameModel> history;

  LuckyDrawHistoryModel({
    required this.history
  });

  factory LuckyDrawHistoryModel.fromJson(Map<String, dynamic> json) {
    return LuckyDrawHistoryModel(
      history: List<LuckyDrawGameModel>.from(json['history'].map((game) => LuckyDrawGameModel.fromJson(game)))
    );
  }

  toJson() {
    return {
      'history': history.map((game) => game.toJson()).toList()
    };
  }
  
}

class WindowSpinSettingsModel {

  Color backgroundColor;
  String backgroundImage;
  BoxFit backgroundImageFit;

  double prizeImageHeight;
  double prizeImageWidth;
  double prizeImagePositionX;

  double slotHeight;
  double slotWidth;
  double slotSpacing;
  Color slotColor;

  bool withTitle;
  Color titleColor;
  double titleVerticalPosition;

  Color textColor;
  double textSize;
  double titleSize;

  bool enabledSpinSound;
  bool enabledWinSound;
  String spinSoundPath;
  String winSoundPath;
  double volumeSound;

  String labelSlot;


  WindowSpinSettingsModel({
    this.backgroundColor = Colors.white,
    this.slotHeight = 50,
    this.slotWidth = 180,
    this.slotSpacing = 8,
    this.slotColor = Colors.white,
    this.withTitle = true,
    this.titleColor = Colors.black,
    this.textColor = Colors.black,
    this.textSize = 20,
    this.titleSize = 48,
    this.titleVerticalPosition = 150,
    this.backgroundImage = "",
    this.backgroundImageFit = BoxFit.contain,
    this.prizeImageHeight = 300,
    this.prizeImageWidth = 300,
    this.prizeImagePositionX = 120,
    this.enabledSpinSound = true,
    this.enabledWinSound = true,
    this.spinSoundPath = "",
    this.winSoundPath = "",
    this.volumeSound = 50,
    this.labelSlot = "----"
  });

  factory WindowSpinSettingsModel.fromJson(Map<String, dynamic> json) {
    return WindowSpinSettingsModel(
      backgroundColor: Color(int.parse(json['backgroundColor'].toString().substring(1), radix: 16) + 0xFF000000),
      slotHeight: json['slotHeight'],
      slotWidth: json['slotWidth'],
      slotSpacing: json['slotSpacing'],
      slotColor: json['slotColor'] == null ? Colors.white : Color(int.parse(json['slotColor'].toString().substring(1), radix: 16) + 0xFF000000),
      withTitle: json['withTitle'],
      titleSize: json['titleSize'],
      titleVerticalPosition: json['titleVerticalPosition'] ?? 150,
      titleColor: Color(int.parse(json['titleColor'].toString().substring(1), radix: 16) + 0xFF000000),
      textColor: Color(int.parse(json['textColor'].toString().substring(1), radix: 16) + 0xFF000000),
      textSize: json['textSize'],
      backgroundImage: json['backgroundImage'],
      backgroundImageFit: _stringToBoxFit(json['backgroundImageFit']),
      prizeImageHeight: json['prizeImageHeight'],
      prizeImageWidth: json['prizeImageWidth'],
      prizeImagePositionX: json['prizeImagePositionX'],
      enabledSpinSound: json['enabledSpinSound'],
      enabledWinSound: json['enabledWinSound'],
      spinSoundPath: json['spinSoundPath'],
      winSoundPath: json['winSoundPath'],
      volumeSound: json['volumeSound'],
      // ignore: prefer_if_null_operators
      labelSlot: json['labelSlot'] ?? ""
    );
  }

  toJson() {
    return {
      'backgroundColor': '#${backgroundColor.value.toRadixString(16)}',
      'slotHeight': slotHeight,
      'slotWidth': slotWidth,
      'slotSpacing': slotSpacing,
      // ignore: unnecessary_null_comparison
      'slotColor': slotColor == null ? '#${Colors.white.value.toRadixString(16)}' : '#${slotColor.value.toRadixString(16)}',
      'withTitle': withTitle,
      'titleSize': titleSize,
      'titleVerticalPosition': titleVerticalPosition,
      'titleColor': '#${titleColor.value.toRadixString(16)}',
      'textColor': '#${textColor.value.toRadixString(16)}',
      'textSize': textSize,
      'backgroundImage': backgroundImage,
      'backgroundImageFit': _boxFitToString(backgroundImageFit),
      'prizeImageHeight': prizeImageHeight,
      'prizeImageWidth': prizeImageWidth,
      'prizeImagePositionX': prizeImagePositionX,
      'enabledSpinSound': enabledSpinSound,
      'enabledWinSound': enabledWinSound,
      'spinSoundPath': spinSoundPath,
      'winSoundPath': winSoundPath,
      'volumeSound': volumeSound,
      'labelSlot': labelSlot
    };
  }

  static BoxFit _stringToBoxFit(String value) {
    switch (value) {
      case 'fill':
        return BoxFit.fill;
      case 'contain':
        return BoxFit.contain;
      case 'cover':
        return BoxFit.cover;
      case 'fitWidth':
        return BoxFit.fitWidth;
      case 'fitHeight':
        return BoxFit.fitHeight;
      case 'none':
        return BoxFit.none;
      case 'scaleDown':
        return BoxFit.scaleDown;
      default:
        return BoxFit.fill;
    }
  }

  static String _boxFitToString(BoxFit boxFit) {
    switch (boxFit) {
      case BoxFit.fill:
        return 'fill';
      case BoxFit.contain:
        return 'contain';
      case BoxFit.cover:
        return 'cover';
      case BoxFit.fitWidth:
        return 'fitWidth';
      case BoxFit.fitHeight:
        return 'fitHeight';
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scaleDown';
    }
  }

}