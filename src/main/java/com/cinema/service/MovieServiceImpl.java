package com.cinema.service;

import java.util.List;

import com.cinema.model.Movie;
import com.cinema.model.Seat;
import com.cinema.repository.MovieRepository;
import com.cinema.repository.SeatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class MovieServiceImpl implements MovieService {

    @Autowired
    private SeatRepository seatRepository;

    @Autowired
    private MovieRepository movieRepository;

    @Override
    public List<Movie> getAllMovies() {
        return movieRepository.findAll();
    }

    @Override
    public Movie getMovieById(Long id) {
        return movieRepository.findById(id).orElse(null);
    }

    @Override
    public void saveMovie(Movie movie) {
        movieRepository.save(movie);
        seedSeatsForMovie(movie);
    }

    private void seedSeatsForMovie(Movie movie) {
        for (char row = 'A'; row <= 'H'; row++) {
            for (int col = 1; col <= 12; col++) {
                String seatLabel = row + String.valueOf(col);
                Seat seat = new Seat(seatLabel, movie);
                seatRepository.save(seat);
            }
        }
    }
}