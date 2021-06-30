import 'dart:async';
import 'package:http/http.dart' show Client, Response;
import 'dart:convert';
import '../models/item_models.dart';

class MovieApiProvider {
  Client client = Client();
  final _apiKey = "5ba2ca0de5629954329d2edec9933a11";
  final _baseUrl = "https://api.themoviedb.org/3/movie";

  Future<ItemModel?> fetchMovieList() async {
    Response response;
    if (_apiKey != 'api_key') {
      response =
          await client.get(Uri.parse("$_baseUrl/popular?api_key=$_apiKey"));
      print(response.body);
    } else {
      throw Exception('Please add your API key');
    }

    if (response.statusCode == 200) {
      print("get ok");
      return ItemModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }

  Future<ItemModel?> fetchTrailer(int movieId) async {
    final response = await client
        .get(Uri.parse("$_baseUrl/$movieId/video?api_key=$_apiKey"));

    if (response.statusCode == 200) {
      print("get trailer ok");
      return ItemModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load post');
    }
  }
}
