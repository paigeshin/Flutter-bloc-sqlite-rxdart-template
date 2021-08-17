import 'package:flutter/material.dart';
import 'dart:async';

import 'package:performant_dat_fetching/src/models/item_model.dart';
import 'package:performant_dat_fetching/src/widgets/loading_container.dart';

//Recursive Comment
class Comment extends StatelessWidget {
  final int itemId;
  final Map<int, Future<ItemModel?>> itemMap;
  final int depth;

  Comment({required this.itemId, required this.itemMap, required this.depth});

  Widget build(context) {
    return FutureBuilder(
        future: itemMap[itemId],
        builder: (context, AsyncSnapshot<ItemModel?> snapshot) {
          if (!snapshot.hasData) {
            return LoadingContainer();
          }
          final item = snapshot.data;
          final children = <Widget>[
            ListTile(
              title: buildText(item),
              subtitle: Text(item?.by ?? ""),
              contentPadding: EdgeInsets.only(
                right: 16.0,
                left: depth * 16.0,
              ),
            ),
            Divider(),
          ];
          snapshot.data!.kids.forEach(
            (kidId) {
              children.add(
                Comment(
                  itemId: kidId,
                  itemMap: itemMap,
                  depth: depth + 1,
                ),
              );
            },
          );

          return Column(
            children: children,
          );
        });
  }

  Widget buildText(ItemModel? item) {
    final text = item!.text
        .replaceAll("'*#x27;", "'")
        .replaceAll('<p>', '')
        .replaceAll('</p>', '');
    return Text(text);
  }
}
