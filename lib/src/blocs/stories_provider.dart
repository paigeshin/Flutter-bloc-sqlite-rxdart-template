import 'package:flutter/material.dart';
import './stories_bloc.dart';

//InheritedWidget allows us to reach out context
class StoriesProvider extends InheritedWidget {
  final StoriesBloc bloc;

  StoriesProvider({Key? key, required Widget child})
      : bloc = StoriesBloc(),
        super(key: key, child: child);

  bool updateShouldNotify(_) => true;

  static StoriesBloc of(BuildContext context) {
    return (context.dependOnInheritedWidgetOfExactType<StoriesProvider>()
            as StoriesProvider)
        .bloc;
  }
}
