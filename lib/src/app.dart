import 'package:flutter/material.dart';
import 'package:performant_dat_fetching/src/screens/news_detail.dart';
import './screens/news_list.dart';
import 'blocs/stories_provider.dart';
import 'blocs/comments_provider.dart';

class App extends StatelessWidget {
  Widget build(BuildContext context) {
    return CommentsProvider(
      child: StoriesProvider(
        child: MaterialApp(
          title: 'News!',
          // home: NewsList(),
          onGenerateRoute: routes,
        ),
      ),
    );
  }
}

//Perfect place to initialize widget, such as `calling api`
Route routes(RouteSettings settings) {
  if (settings.name == "/") {
    return MaterialPageRoute(
      builder: (context) {
        final storiesBloc = StoriesProvider.of(context);
        storiesBloc.fetchTopIds();
        return NewsList();
      },
    );
  } else {
    //   /NewsDetail
    return MaterialPageRoute(
      builder: (context) {
        // extract the item id from settings.name
        // and pass into NewsDetail
        // A fantasti location to do some initialization
        // or data fetching for NewsDetail
        final commentsBloc = CommentsProvider.of(context);
        final itemId = int.parse(settings.name!.replaceFirst('/', ''));
        commentsBloc.fetchItemWithComments(itemId);
        return NewsDetail(itemId: itemId);
      },
    );
  }
}
