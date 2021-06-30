import 'dart:async';
import '../datasources/movie_api_provider.dart';
import '../models/item_models.dart';

class Repository {
  final moviesApiProvider = MovieApiProvider();

  Future<ItemModel?> fetchAllMovies() => moviesApiProvider.fetchMovieList();

  Future<ItemModel?> fetchTrailer(int movieId) => moviesApiProvider.fetchTrailer(movieId);
}