import '../repositories/repositories.dart';
import 'package:rxdart/rxdart.dart';
import '../models/item_models.dart';

class MovieBloc {
  final _repository = Repository();
  final _moviesFetcher = PublishSubject<ItemModel>();

  Stream<ItemModel> get allMovies => _moviesFetcher.stream;

  fetchAllMovies() async {
    ItemModel? itemModel = await _repository.fetchAllMovies();
    _moviesFetcher.sink.add(itemModel!);
  }

  dispose() {
    _moviesFetcher.close();
  }
}

final bloc = MovieBloc();