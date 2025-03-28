package com.cinema.controller;

import com.cinema.model.Movie;
import com.cinema.model.MovieDTO;
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
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Arrays;
import java.util.Base64;
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
        List<Movie> movies = movieService.getAllMovies();
        List<MovieDTO> movieDTOs = movies.stream().map(movie -> {
            MovieDTO dto = new MovieDTO();
            dto.setId(movie.getId());
            dto.setTitle(movie.getTitle());
            dto.setDescription(movie.getDescription());
            dto.setTicketPrice(movie.getTicketPrice());
            if (movie.getImageData() != null && movie.getImageData().length > 0) {
                dto.setBase64Image(convertToBase64(movie.getImageData()));
            }
            return dto;
        }).collect(Collectors.toList());

        model.addAttribute("movies", movieDTOs);
        return "movies";
    }

    //2. display movie details and a link to a reservation form
    @GetMapping("/movie/{id}")
    public String movieDetails(@PathVariable Long id, Model model) {
        Movie movie = movieService.getMovieById(id);
        model.addAttribute("movie", movie);

        String base64Image = convertToBase64(movie.getImageData());
        model.addAttribute("base64Image", base64Image);

        return "movieDetails";
    }

    //3. reservation form
    @GetMapping("/reservation")
    public String showReservationForm(@RequestParam("movieId") Long movieId, Model model) {
        Movie movie = movieService.getMovieById(movieId);
        List<Seat> seats = seatRepository.findByMovieId(movieId);
        if (movie.getImageData() != null && movie.getImageData().length > 0) {
            model.addAttribute("base64Image", convertToBase64(movie.getImageData()));
        }
        model.addAttribute("movie", movie);
        model.addAttribute("seats", seats);
        return "reservationForm";
    }

    //4. seat selection
    @PostMapping("/reviewReservation")
    public String reviewReservation(
            @RequestParam("movieId") Long movieId,
            @RequestParam("numberOfTickets") int numberOfTickets,
            @RequestParam("selectedSeatIds") String selectedSeatIds,
            Model model
    ) {
        List<Long> seatIdList = Arrays.stream(selectedSeatIds.split(","))
                .filter(s -> !s.trim().isEmpty())
                .map(Long::parseLong)
                .collect(Collectors.toList());

        // seat count == number of seats selected
        if (seatIdList.size() != numberOfTickets) {
            model.addAttribute("error", "Please select exactly " + numberOfTickets + " seats.");
            Movie movie = movieService.getMovieById(movieId);
            List<Seat> seats = seatRepository.findByMovieId(movieId);
            model.addAttribute("movie", movie);
            model.addAttribute("seats", seats);
            return "reservationForm";
        }

        Movie movie = movieService.getMovieById(movieId);
        double totalPrice = numberOfTickets * movie.getTicketPrice();
        if (movie.getImageData() != null && movie.getImageData().length > 0) {
            model.addAttribute("base64Image", convertToBase64(movie.getImageData()));
        }

        // temporary reservation
        Reservation tempReservation = new Reservation();
        tempReservation.setMovie(movie);
        tempReservation.setNumberOfTickets(numberOfTickets);
        tempReservation.setTotalPrice(totalPrice);

        String seatLabels = seatIdList.stream()
                .map(id -> seatRepository.getReferenceById(id).getSeatLabel())
                .collect(Collectors.joining(","));
        tempReservation.setSeats(seatLabels);

        model.addAttribute("tempReservation", tempReservation);
        model.addAttribute("seatIdList", seatIdList);

        return "reservationSummary"; // Show summary page
    }

    //5. confirmation and thank-you message
    @PostMapping("/confirmReservation")
    public String confirmReservation(
            @RequestParam("movieId") Long movieId,
            @RequestParam("numberOfTickets") int numberOfTickets,
            @RequestParam("seatIds") List<Long> seatIds,
            Model model
    ) {
        // recreate reservation
        Movie movie = movieService.getMovieById(movieId);
        double totalPrice = movie.getTicketPrice() * numberOfTickets;

        Reservation reservation = new Reservation();
        reservation.setMovie(movie);
        reservation.setNumberOfTickets(numberOfTickets);
        reservation.setTotalPrice(totalPrice);
        String seatLabels = seatIds.stream()
                .map(id -> seatRepository.getReferenceById(id).getSeatLabel())
                .collect(Collectors.joining(","));
        reservation.setSeats(seatLabels);

        //save
        reservationService.saveReservation(reservation);
        for (Long seatId : seatIds) {
            Seat seat = seatRepository.findById(seatId).orElse(null);
            if (seat.getReservation() != null) {
                model.addAttribute("error", "Seat " + seat.getSeatLabel() + " was just reserved!");
                return "reservationSummary";
            }
            seat.setReservation(reservation);
            seatRepository.save(seat);
        }

        model.addAttribute("reservation", reservation);
        if (movie.getImageData() != null && movie.getImageData().length > 0) {
            model.addAttribute("base64Image", convertToBase64(movie.getImageData()));
        }
        return "thankYou";
    }

    //ADDITIONAL add a movie
    @GetMapping("/movies/new")
    public String newMovieForm() {
        return "createMovie";
    }

    //ADDITIONAL add a movie
    @PostMapping("/movies/add")
    public String addMovie(
            @RequestParam("title") String title,
            @RequestParam("description") String description,
            @RequestParam("ticketPrice") double ticketPrice,
            @RequestParam("imageFile") MultipartFile imageFile) {
        Movie movie = new Movie(title, description, ticketPrice);
        try {
            if (!imageFile.isEmpty()) {
                byte[] imageData = imageFile.getBytes();
                movie.setImageData(imageData);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        movieService.saveMovie(movie);
        return "redirect:/movies";
    }

    public String convertToBase64(byte[] imageData) {
        if (imageData == null || imageData.length == 0) {
            return null;
        }
        return Base64.getEncoder().encodeToString(imageData);
    }
}