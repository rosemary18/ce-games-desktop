import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

part 'state.dart';
part 'events.dart';

class AppStateBloc extends Bloc<AppStateEvents, AppState> {
  AppStateBloc() : super(const AppState()) {
    on<UpdateAppState>((event, emit) {
      if (event.language != null) emit(AppState(language: event.language!));
    });
  }
}