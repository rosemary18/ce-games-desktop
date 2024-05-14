import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'app_state/index.dart';

export 'app_state/index.dart';

class ProviderBlocs extends StatelessWidget {
  
  final Widget child;

  const ProviderBlocs({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [BlocProvider(create: (context) => AppStateBloc())],
      child: child
    );
  }
}