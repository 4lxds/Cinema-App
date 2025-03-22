package com.cinema.service;

import java.util.List;
import com.cinema.model.Movie;

public interface MovieService {
    List<Movie> getAllMovies();
    Movie getMovieById(Long id);
    void saveMovie(Movie movie);
}