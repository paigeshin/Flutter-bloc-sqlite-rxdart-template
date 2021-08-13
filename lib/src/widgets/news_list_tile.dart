import 'package:flutter/material.dart';
import '../models/item_model.dart';
import '../blocs/stories_provider.dart';

class NewsListTile extends StatelessWidget {
  final int itemId;

  NewsListTile({required this.itemId});

  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);

    return StreamBuilder(
      stream: bloc.items,
      builder: (context, AsyncSnapshot<Map<int, Future<ItemModel?>>> snapshot) {
        if (!snapshot.hasData) {
          // print("\nStill Loading... Stream Builder...");
          return Text('Stream still loading...');
        }
        return FutureBuilder(
          future: snapshot.data![itemId],
          builder: (context, AsyncSnapshot<ItemModel?> itemSnapshot) {
            if (!itemSnapshot.hasData) {
              return Text('Still loading item $itemId');
            }
            return Text(itemSnapshot.data!.title);
          },
        );
      },
    );
  }
}
