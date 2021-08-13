import 'package:rxdart/rxdart.dart';
import '../models/item_model.dart';
import '../resources/repository.dart';

class StoriesBloc {
  final _repository = Repository();
  final _topIds = PublishSubject<List<int>>();
  final _itemsFetcher = PublishSubject<int>();
  final _itemsOutput = BehaviorSubject<Map<int, Future<ItemModel?>>>();

  // Getters to Streams
  Stream<List<int>> get topIds => _topIds.stream;
  Stream<Map<int, Future<ItemModel?>>> get items => _itemsOutput.stream;

  /// DON'T DO THIS BAD, IM GOING TO REMOVE THIS
  // This will trigger `_itemsTransformer()` for every instantiatation.
  // We need to make sure, `_itemsTransformer` is initialized once.
  // Our goal here is to invoke `_itemsTransformer()` one time.
  // get items => _items.stream.transform(_itemsTransformer());

  // Getters to Sinks
  Function(int) get fetchItem => _itemsFetcher.sink.add;

  /// Right way to apply transform. Put it inside Constructor. Otherwise, `_itemsTransformer()` will be initialized every time its attached object is initialized.
  StoriesBloc() {
    _itemsFetcher.stream.transform(_itemsTransformer()).pipe(_itemsOutput);
  }

  fetchTopIds() async {
    final ids = await _repository.fetchTopIds();
    if (ids != null) {
      _topIds.sink.add(ids);
    }
  }

  _itemsTransformer() {
    return ScanStreamTransformer(
        (Map<int, Future<ItemModel?>> cache, int id, index) {
      cache[id] = _repository.fetchItem(id);
      return cache;
    }, <int, Future<ItemModel?>>{});
  }

  dispose() {
    _topIds.close();
    _itemsOutput.close();
    _itemsFetcher.close();
  }
}
