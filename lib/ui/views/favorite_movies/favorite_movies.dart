import 'package:flutter/material.dart';
import 'package:ultimate_movie_database/di/app_modules.dart';
import 'package:ultimate_movie_database/model/movie.dart';
import 'package:ultimate_movie_database/ui/model/resource_state.dart';
import 'package:ultimate_movie_database/ui/navigation/navigation_routes.dart';
import 'package:ultimate_movie_database/ui/views/favorite_movies/viewmodel/favorite_movies_view_model.dart';
import 'package:ultimate_movie_database/ui/widgets/error/error_view.dart';
import 'package:ultimate_movie_database/ui/widgets/movie_list_item/movie_list_item.dart';

class FavoriteMovies extends StatefulWidget {
  const FavoriteMovies({super.key});

  @override
  State<FavoriteMovies> createState() => _FavoriteMoviesState();
}

class _FavoriteMoviesState extends State<FavoriteMovies> {
  final FavoriteMoviesViewModel _viewModel = inject<FavoriteMoviesViewModel>();
  List<Movie> _movies = [];

  @override
  void initState() {
    super.initState();
    _viewModel.getMoviesFromWatchListState.stream.listen((state) {
      switch (state.status) {
        case Status.LOADING:
          break;
        case Status.SUCCESS:
          setState(() {
            _movies = state.data!;
          });
          break;
        case Status.ERROR:
          ErrorView.show(context, state.exception!.toString(), () {
            _viewModel.fetchMoviesFromWatchList();
          });
          break;
      }
    });
    _viewModel.fetchMoviesFromWatchList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 10.0,
                right: 10.0),
            child: const Text(
              "MOVIES I WANT TO WATCH",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.amberAccent,
                shadows: [
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.amberAccent,
                  ),
                  Shadow(
                    offset: Offset(0, 0),
                    blurRadius: 10.0,
                    color: Colors.amberAccent,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: ListView.builder(
              itemCount: _movies.length,
              itemBuilder: (context, index) {
                final movie = _movies[index];
                return MovieListItem(
                  movie: movie,
                  navigationRoute:
                      NavigationRoutes.FAVORITE_MOVIES_MOVIE_DETAIL_ROUTE,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}
