part of 'bloc.dart';

@immutable
final class AppState {
  
  const AppState({
    this.language = "en"
  });

  final String language;
}