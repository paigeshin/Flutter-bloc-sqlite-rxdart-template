import 'package:flutter/material.dart';
import '../blocs/stories_provider.dart';
import '../blocs/stories_bloc.dart';
import '../widgets/news_list_tile.dart';
import '../widgets/refresh.dart';

class NewsList extends StatelessWidget {
  Widget build(BuildContext context) {
    final bloc = StoriesProvider.of(context);
    // THIS IS BAD!!!! DONT DO THIS!
    // TEMPORARY!
    bloc.fetchTopIds();
    return Scaffold(
      appBar: AppBar(
        title: Text('Top News'),
      ),
      body: buildList(bloc),
    );
  }

  Widget buildList(StoriesBloc bloc) {
    return StreamBuilder(
      stream: bloc.topIds,
      builder: (context, AsyncSnapshot<List<int>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        return Refresh(
          child: ListView.builder(
            itemCount: snapshot.data!.length,
            itemBuilder: (context, int index) {
              var itemId = -1;
              if (snapshot.hasData) {
                itemId = snapshot.data![index];
                bloc.fetchItem(itemId);
              }
              return NewsListTile(
                itemId: itemId,
              );
            },
          ),
        );
      },
    );
  }
}
