package com.cinema.service;

import java.util.List;

import com.cinema.model.Movie;
import com.cinema.repository.MovieRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class MovieServiceImpl implements MovieService {

    @Autowired
    private MovieRepository movieRepository;

    @Override
    public List<Movie> getAllMovies() {
        return movieRepository.getAllMovies();
    }

    @Override
    public Movie getMovieById(Long id) {
        return movieRepository.getMovieById(id);
    }

    @Override
    public void saveMovie(Movie movie) {
        movieRepository.saveMovie(movie);
    }
}