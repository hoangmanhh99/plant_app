import 'package:flutter/material.dart';
import 'package:flutter_application/data/blocs/movies_blocs.dart';
import 'package:flutter_application/data/models/trailer_model.dart';
import '../data/blocs/movie_detail_blocs.dart';

class MovieDetail extends StatefulWidget {
  late final posterUrl;
  late final description;
  late final releaseDate;
  late final String title;
  late final String voteAverage;
  late final int movieId;

  MovieDetail(
      {this.posterUrl,
      this.description,
      this.releaseDate,
      required this.title,
      required this.voteAverage,
      required this.movieId});

  @override
  _MovieDetailState createState() => _MovieDetailState(
        posterUrl: posterUrl,
        description: description,
        releaseDate: releaseDate,
        title: title,
        voteAverage: voteAverage,
        movieId: movieId,
      );
}

class _MovieDetailState extends State<MovieDetail> {
  late final posterUrl;
  late final description;
  late final releaseDate;
  late final String title;
  late final String voteAverage;
  late final int movieId;

  _MovieDetailState(
      {this.posterUrl,
      this.description,
      this.releaseDate,
      required this.title,
      required this.voteAverage,
      required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        top: false,
        bottom: false,
        child: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200.0,
                floating: false,
                pinned: true,
                elevation: 0.0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Image.network(
                    "https://image.tmdb.org/t/p/w185${posterUrl}",
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ];
          },
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 5.0),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 1.0, right: 1.0),
                    ),
                    Text(
                      voteAverage,
                      style: TextStyle(fontSize: 18.0),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 10.0, right: 10.0),
                    ),
                    Text(
                      releaseDate,
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
                Text(description),
                Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
                Text(
                  'Trailer',
                  style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.bold),
                ),
                Container(
                  margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                ),
                StreamBuilder(
                    stream: bloc.movieTrailers,
                    builder: (context,
                        AsyncSnapshot<Future<TrailerModel>> snapshot) {
                      if (snapshot.hasData) {
                        return FutureBuilder(
                          future: snapshot.data,
                          builder: (context,
                              AsyncSnapshot<TrailerModel> itemSnapshot) {
                            if (itemSnapshot.hasData) {
                              if (itemSnapshot.data!.results.length > 0)
                                return trailerLayout(itemSnapshot.data!) as Widget;
                              else return noTrailer(itemSnapshot.data!) as Widget;
                            } else {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                          },
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    })
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget? noTrailer(TrailerModel data) {
    return Center(child: Container(child: Text("No trailer available")));
  }

  Widget? trailerLayout(TrailerModel data) {
    if (data.results.length > 1) {
      return Row(
        children: <Widget>[trailerItem(data, 0), trailerItem(data, 1)],
      );
    } else {
      return Row(
        children: <Widget>[trailerItem(data, 0)],
      );
    }
  }

  trailerItem(TrailerModel data, int index) {
    return Expanded(
        child: Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(5.0),
          height: 100.0,
          color: Colors.grey,
          child: Center(
            child: Icon(Icons.play_circle_filled),
          ),
        ),
        Text(
          data.results[index].name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        )
      ],
    ));
  }
}
