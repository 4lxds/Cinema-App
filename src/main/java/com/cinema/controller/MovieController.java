package com.cinema.controller;

import com.cinema.model.Movie;
import com.cinema.model.Reservation;
import com.cinema.model.Seat;
import com.cinema.service.MovieService;
import com.cinema.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
public class MovieController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private ReservationService reservationService;

    //display movies
    @GetMapping("/movies")
    public String listMovies(Model model) {
        model.addAttribute("movies", movieService.getAllMovies());
        return "movies";
    }

    //add a movie
    @GetMapping("/movies/new")
    public String newMovieForm() {
        return "createMovie";
    }

    //display movie details and reservation form
    @GetMapping("/movie/{id}")
    public String movieDetails(@PathVariable Long id, Model model) {
        Movie movie = movieService.getMovieById(id);
        model.addAttribute("movie", movie);
        return "movieDetails";
    }

    //add a movie
    @PostMapping("/movies/add")
    public String addMovie(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("ticketPrice") double price) {
        Movie movie = new Movie(title, description, price);
        movieService.saveMovie(movie);
        return "redirect:/movies";
    }

    //reservation form
    @GetMapping("/reservation")
    public String showReservationForm(@RequestParam("movieId") Long movieId, Model model) {
        Movie movie = movieService.getMovieById(movieId);
        model.addAttribute("movie", movie);
        return "reservationForm";
    }

    //process reservation form
    @PostMapping("/reserve")
    public String reserveTickets(
            @RequestParam("movieId") Long movieId,
            @RequestParam("numberOfTickets") int numberOfTickets,
            @RequestParam("selectedSeats") String selectedSeats,
            Model model
    ) {
        Movie movie = movieService.getMovieById(movieId);
        double totalPrice = movie.getTicketPrice() * numberOfTickets;

        //actual reservation
        Reservation reservation = new Reservation();
        reservation.setMovie(movie);
        reservation.setNumberOfTickets(numberOfTickets);
        reservation.setSeats(selectedSeats);
        reservation.setTotalPrice(totalPrice);
        //save reservation
        reservationService.saveReservation(reservation);

        model.addAttribute("reservation", reservation);
        return "reservationSummary";
    }

    //confirmation and thank-you message
    @PostMapping("/confirmReservation")
    public String confirmReservation(@RequestParam("reservationId") Long reservationId, Model model) {
        Reservation reservation = reservationService.getReservationById(reservationId);
        model.addAttribute("reservation", reservation);
        return "thankYou";
    }
}