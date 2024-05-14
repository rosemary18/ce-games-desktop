import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';
import 'cores/index.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return ProviderBlocs(
      child: BlocBuilder<AppStateBloc, AppState>(
        builder: (context, state) => 
          MaterialApp.router(
            builder: (BuildContext context, Widget? widget) {
              if (widget == null) return Container();
              return OKToast(child: widget);
            },
            routerConfig: router,
            debugShowCheckedModeBanner: false,
            theme: appTheme(context),
            supportedLocales: L10n.all,
            locale: const Locale('en'),
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate
            ],
          )
      )
    );
  }
}
