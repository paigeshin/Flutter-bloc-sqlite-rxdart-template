import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';

class Refresh extends StatelessWidget {
  final Widget child;

  Refresh({required this.child});

  Widget build(context) {
    final bloc = StoriesProvider.of(
      context,
    ); //You don't need to pass bloc to widget, because we can have access to it through context.
    return RefreshIndicator(
      child: child,
      onRefresh: () async {
        await bloc.clearCache();
        await bloc.fetchTopIds();
      },
    );
  }
}
