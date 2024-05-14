part of 'bloc.dart';

sealed class AppStateEvents {}

class UpdateAppState extends AppStateEvents {

  UpdateAppState({
    this.language
  });

  String? language;
}