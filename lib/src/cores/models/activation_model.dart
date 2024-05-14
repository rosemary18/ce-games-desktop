class ActivationModel {

  DateTime lastCheck;
  String link;
  String activationCode;

  ActivationModel({
    required this.link,
    required this.activationCode,
    required this.lastCheck
  });

  factory ActivationModel.fromJson(Map<String, dynamic> json) {
    return ActivationModel(
      link: json['link'],
      activationCode: json['activation_code'],
      lastCheck: DateTime.parse(json['last_check'])
    );
  }

  toJson() {
    return {
      'link': link,
      'activation_code': activationCode,
      'last_check': lastCheck.toIso8601String()
    };
  }

}