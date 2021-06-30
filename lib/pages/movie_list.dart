import 'package:flutter/material.dart';
import 'package:flutter_application/data/blocs/movie_detail_bloc_provider.dart';
import 'package:flutter_application/pages/movie_detail.dart';
import '../data/models/item_models.dart';
import '../data/blocs/movies_blocs.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  @override
  void initState() {
    super.initState();
    bloc.fetchAllMovies();
  }

  @override
  void dispose() {
    super.dispose();
    bloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Popular Movies'),
      ),
      body: StreamBuilder(
        stream: bloc.allMovies,
        builder: (context, AsyncSnapshot<ItemModel> snapshot) {
          if (snapshot.hasData) {
            print("Has data");
            return buildList(snapshot);
          } else if (snapshot.hasError) {
            print("failed views");
            return Text(snapshot.error.toString());
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Widget buildList(AsyncSnapshot<ItemModel> snapshot) {
    return GridView.builder(
      itemCount: snapshot.data?.results.length,
      gridDelegate:
          new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      itemBuilder: (BuildContext context, int index) {
        return GridTile(
            child: InkResponse(
          enableFeedback: true,
          child: Image.network(
            'https://image.tmdb.org/t/p/w185${snapshot.data?.results[index].poster_path}',
            fit: BoxFit.cover,
          ),
          onTap: () => openDetailPage(snapshot.data!, index),
        ));
      },
    );
  }

  openDetailPage(ItemModel data, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MovieDetailBlocProvider(
          child: MovieDetail(
              posterUrl: data.results[index].backdrop_path,
              description: data.results[index].overview,
              releaseDate: data.results[index].release_date,
              title: data.results[index].title,
              voteAverage: data.results[index].vote_average.toString(),
              movieId: data.results[index].id));
    }));
  }
}
