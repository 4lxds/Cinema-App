package com.cinema.repository;

import com.cinema.model.Movie;
import java.util.List;

public interface MovieRepository {
    List<Movie> getAllMovies();
    Movie getMovieById(long id);
    void saveMovie(Movie movie);
}
