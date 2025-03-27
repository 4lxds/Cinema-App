package com.cinema.controller;

import com.cinema.model.Movie;
import com.cinema.model.Reservation;
import com.cinema.model.Seat;
import com.cinema.repository.SeatRepository;
import com.cinema.service.MovieService;
import com.cinema.service.ReservationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

@Controller
public class MovieController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private SeatRepository seatRepository;

    //1. display movies
    @GetMapping("/movies")
    public String listMovies(Model model) {
        model.addAttribute("movies", movieService.getAllMovies());
        return "movies";
    }

    //ADDITIONAL add a movie
    @GetMapping("/movies/new")
    public String newMovieForm() {
        return "createMovie";
    }

    //2. display movie details and a link to a reservation form
    @GetMapping("/movie/{id}")
    public String movieDetails(@PathVariable Long id, Model model) {
        Movie movie = movieService.getMovieById(id);
        model.addAttribute("movie", movie);
        return "movieDetails";
    }

    //ADDITIONAL add a movie
    @PostMapping("/movies/add")
    public String addMovie(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("ticketPrice") double ticketPrice) {
        Movie movie = new Movie(title, description, ticketPrice);
        movieService.saveMovie(movie);
        return "redirect:/movies";
    }

    //3. reservation form
    @GetMapping("/reservation")
    public String showReservationForm(@RequestParam("movieId") Long movieId, Model model) {
        Movie movie = movieService.getMovieById(movieId);
        List<Seat> seats = seatRepository.findByMovieId(movieId);
        model.addAttribute("movie", movie);
        model.addAttribute("seats", seats);
        return "reservationForm";
    }

    //4. seat selection
    @PostMapping("/reserve")
    public String reserveTickets(
            @RequestParam("movieId") Long movieId,
            @RequestParam("numberOfTickets") int numberOfTickets,
            @RequestParam("selectedSeatIds") String selectedSeatIds,
            Model model
    ) {
        List<Long> seatIdList = Arrays.stream(selectedSeatIds.split(","))
                .filter(s -> !s.trim().isEmpty())
                .map(Long::parseLong)
                .collect(Collectors.toList());

        // if seat number == number of selected seats
        if (seatIdList.size() != numberOfTickets) {
            model.addAttribute("error", "Please select exactly " + numberOfTickets + " seats.");
            Movie movie = movieService.getMovieById(movieId);
            List<Seat> seats = seatRepository.findByMovieId(movieId);
            model.addAttribute("movie", movie);
            model.addAttribute("seats", seats);
            return "reservationForm";
        }

        Movie movie = movieService.getMovieById(movieId);
        // create and save reservation
        Reservation reservation = new Reservation();
        reservation.setMovie(movie);
        reservation.setNumberOfTickets(numberOfTickets);
        double totalPrice = numberOfTickets * movie.getTicketPrice();
        reservation.setTotalPrice(totalPrice);
        reservationService.saveReservation(reservation);

        // add to reservation
        for (Long seatId : seatIdList) {
            Seat seat = seatRepository.findById(seatId).orElse(null);
            if (seat.getReservation() != null) {
                // if seat reserved
                model.addAttribute("error", "Seat " + seat.getSeatLabel() + " is already reserved.");
                Movie movieReload = movieService.getMovieById(movieId);
                List<Seat> seats = seatRepository.findByMovieId(movieId);
                model.addAttribute("movie", movieReload);
                model.addAttribute("seats", seats);
                return "reservationForm";
            }
            seat.setReservation(reservation);
            seatRepository.save(seat);
        }
        String reservedSeats = seatIdList.stream()
                .map(id -> seatRepository.getReferenceById(id).getSeatLabel())
                .collect(Collectors.joining(","));
        reservation.setSeats(reservedSeats);
        //save reservation
        reservationService.saveReservation(reservation);

        model.addAttribute("reservation", reservation);
        return "reservationSummary";
    }

    //5. confirmation and thank-you message
    @PostMapping("/confirmReservation")
    public String confirmReservation(@RequestParam("reservationId") Long reservationId, Model model) {
        Reservation reservation = reservationService.getReservationById(reservationId);
        model.addAttribute("reservation", reservation);
        return "thankYou";
    }
}