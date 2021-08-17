import 'dart:async';
import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class CommentsBloc {
  // Controller
  final _repository = Repository();
  final _commentsFetcher = PublishSubject<int>();
  final _commentsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();

  // Streams - data
  Stream<Map<int, Future<ItemModel?>>> get itemWithComments =>
      _commentsOutput.stream;

  // Sink - action
  Function(int) get fetchItemWithComments => _commentsFetcher.sink.add;

  // Constructur - transform
  CommentsBloc() {
    _commentsFetcher.stream
        .transform(_commentsTransformer())
        .pipe(_commentsOutput);
  }

  //Input - Item
  //Output - Item with Comments
  _commentsTransformer() {
    /*
      StreamTransformer.fromHandlers(handleData: () {});
     */
    //ScanStreamTransformer uses `cache`
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel?>> cache, int id, index) {
      // cache - ScanStreamTransformer provides cached data
      // id - id we pass
      // index - index is provided by ScanStreamTransformer
      cache[id] = _repository.fetchItem(id);
      cache[id]?.then((ItemModel? item) {
        item?.kids.forEach((kidId) => fetchItemWithComments(kidId));
      });
      return cache;
    }, <int, Future<ItemModel?>>{});
  }

  dispose() {
    _commentsFetcher.close();
  }
}
