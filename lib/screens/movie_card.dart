import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';

import '../bloc/movie_favorite_bloc/movie_favorite_bloc.dart';
import '../bloc/movie_favorite_bloc/movie_favorite_event.dart';
import '../bloc/movie_favorite_bloc/movie_favorite_state.dart';
import '../data/models/movie.dart';

class MovieCard2 extends StatelessWidget {
  final Movie movie;

  const MovieCard2({
    Key? key,
    required this.movie
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5.0,
      margin: const EdgeInsets.all(10.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: () {
          // Handle tap to navigate to details page or other functionality
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Poster Image
            movie.posterPath != null
                ? ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
              child: Image.network(
                'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                // height: 400,
                width: double.infinity,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Center(
                      child: Icon(
                        Icons.broken_image,
                        size: 50,
                        color: Colors.grey,
                      ),
                    ),
                  );
                },
              ),
            )
                : Container(
              height: 600,
              color: Colors.grey[300],
              child: const Center(
                child: Icon(
                  Icons.image_not_supported,
                  size: 50,
                  color: Colors.grey,
                ),
              ),
            ),

            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      movie.title??"",
                      style: const TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis,
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Favorite Button
                      IconButton(
                        icon: const Icon(
                          Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          // Handle favorite toggle logic
                        },
                      ),
                    ],
                  ),
                ),
              ],
            )


          ],
        ),
      ),
    );
  }
}

class MovieCard extends StatelessWidget {
  final Movie movie;

  const MovieCard({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieCardFavoriteBloc()
        ..add(CheckFavoriteStatus(movie.id.toString())),
      child: BlocBuilder<MovieCardFavoriteBloc, MovieCardFavoriteState>(
        builder: (context, state) {
          final bloc = BlocProvider.of<MovieCardFavoriteBloc>(context);

          if (state is MovieCardFavoriteLoading) {
            return const CircularProgressIndicator();
          }

          bool isFavorite = false;
          if (state is MovieCardFavoriteStatus) {
            isFavorite = state.isFavorite;
          }

          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Poster Image
                movie.posterPath != null
                    ? ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(10.0),
                  ),
                  child: Image.network(
                    'https://image.tmdb.org/t/p/w500/${movie.posterPath}',
                    // height: 400,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        height: 200,
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      );
                    },
                  ),
                )
                    : Container(
                  height: 600,
                  color: Colors.grey[300],
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                      color: Colors.grey,
                    ),
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          movie.title??"",
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: IconButton(
                        icon: Icon(
                          isFavorite ? Icons.favorite : Icons.favorite_border,
                          color: isFavorite ? Colors.red : null,
                        ),
                        onPressed: () {
                          bloc.add(ToggleFavoriteStatus(movie));
                        },
                      ),
                    ),
                  ],
                ),


              ],
            ),
          );
        },
      ),
    );
  }
}
