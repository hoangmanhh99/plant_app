import 'dart:async';

import 'package:rxdart/rxdart.dart';
import '../models/trailer_model.dart';
import '../repositories/repositories.dart';

class MovieDetailBloc {
  final _repository = Repository();
  final _movieId = PublishSubject<int>();
  final _trailers = BehaviorSubject<Map<String, Future<TrailerModel>>>();

  Function(int) get fetchTrailersById => _movieId.sink.add;
  Stream<Map<String, Future<TrailerModel>>> get movieTrailers => _trailers.stream;

  MovieDetailBloc() {
    _movieId.stream.transform(_itemTransformer()).pipe(_trailers);
  }

  dispose() async {
    _movieId.close();
    await _trailers.drain();
    _trailers.close();
  }

  _itemTransformer() {
    return ScanStreamTransformer(
      (Map<String, Future<TrailerModel>> trailer, int id, int index) {
        print(index);
        trailer = _repository.fetchTrailer(id) as Map<String, Future<TrailerModel>>;
        return trailer;
      }, <String, Future<TrailerModel>>{}
    );
  }
}
