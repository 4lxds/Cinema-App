package com.cinema.controller;

import com.cinema.model.*;
import com.cinema.repository.ReservationRepository;
import com.cinema.repository.SeatRepository;
import com.cinema.repository.UserRepository;
import com.cinema.service.MovieService;
import com.cinema.service.ReservationService;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.*;
import java.util.stream.Collectors;

@Controller
public class MovieController {

    @Autowired
    private MovieService movieService;

    @Autowired
    private ReservationService reservationService;

    @Autowired
    private SeatRepository seatRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ReservationRepository reservationRepository;

    //1. display movies
    @GetMapping("/movies")
    public String listMovies(Model model, HttpServletRequest request) {
        List<Movie> movies = movieService.getAllMovies();
        List<MovieDTO> movieDTOs = movies.stream().map(movie -> {
            MovieDTO dto = new MovieDTO();
            dto.setId(movie.getId());
            dto.setTitle(movie.getTitle());
            dto.setDescription(movie.getDescription());
            dto.setTicketPrice(movie.getTicketPrice());
            //image
            if (movie.getImageData() != null && movie.getImageData().length > 0) {
                dto.setBase64Image(convertToBase64(movie.getImageData()));
            }
            return dto;
        }).collect(Collectors.toList());

        model.addAttribute("movies", movieDTOs);

        String externalUrl = request.getRequestURL().toString();
        model.addAttribute("externalUrl", externalUrl);

        return "movies";
    }

    //2. display movie details and a link to a reservation form
    @GetMapping("/movie/{id}")
    public String movieDetails(@PathVariable Long id, Model model, HttpServletRequest request) {
        Movie movie = movieService.getMovieById(id);
        model.addAttribute("movie", movie);

        String base64Image = convertToBase64(movie.getImageData());
        model.addAttribute("base64Image", base64Image);

        String externalUrl = request.getRequestURL().toString();
        model.addAttribute("externalUrl", externalUrl);

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
            String errorMsg;
            if (numberOfTickets == 1) {
                errorMsg = "Please select exactly 1 seat.";
            } else {
                errorMsg = "Please select exactly " + numberOfTickets + " seats.";
            }
            model.addAttribute("error", errorMsg);

            Movie movie = movieService.getMovieById(movieId);
            List<Seat> seats = seatRepository.findByMovieId(movieId);
            model.addAttribute("movie", movie);
            model.addAttribute("seats", seats);
            //image
            if (movie.getImageData() != null && movie.getImageData().length > 0) {
                model.addAttribute("base64Image", convertToBase64(movie.getImageData()));
            }
            return "reservationForm";
        }

        Movie movie = movieService.getMovieById(movieId);
        double totalPrice = numberOfTickets * movie.getTicketPrice();
        //image
        if (movie.getImageData() != null && movie.getImageData().length > 0) {
            model.addAttribute("base64Image", convertToBase64(movie.getImageData()));
        }

        // temporary reservation
        Reservation tempReservation = new Reservation();
        tempReservation.setMovie(movie);
        tempReservation.setNumberOfTickets(numberOfTickets);
        BigDecimal price = BigDecimal.valueOf(movie.getTicketPrice());
        BigDecimal total = price.multiply(BigDecimal.valueOf(numberOfTickets))
                .setScale(2, RoundingMode.HALF_UP);
        tempReservation.setTotalPrice(total);

        String seatLabels = seatIdList.stream()
                .map(id -> seatRepository.getReferenceById(id).getSeatLabel())
                .collect(Collectors.joining(","));
        tempReservation.setSeats(seatLabels);

        model.addAttribute("tempReservation", tempReservation);
        model.addAttribute("seatIdList", seatIdList);

        return "reservationSummary"; // Show summary page
    }

    //5. confirmation
    @PostMapping("/confirmReservation")
    public String confirmReservation(
            @RequestParam("movieId") Long movieId,
            @RequestParam("numberOfTickets") int numberOfTickets,
            @RequestParam("seatIds") List<Long> seatIds,
            HttpSession session,
            Model model
    ) {
        // recreate reservation
        Movie movie = movieService.getMovieById(movieId);
        double totalPrice = movie.getTicketPrice() * numberOfTickets;

        Reservation reservation = new Reservation();
        reservation.setMovie(movie);
        reservation.setNumberOfTickets(numberOfTickets);
        BigDecimal price = BigDecimal.valueOf(movie.getTicketPrice());
        BigDecimal total = price.multiply(BigDecimal.valueOf(numberOfTickets))
                .setScale(2, RoundingMode.HALF_UP);
        reservation.setTotalPrice(total);
        String seatLabels = seatIds.stream()
                .map(id -> seatRepository.getReferenceById(id).getSeatLabel())
                .collect(Collectors.joining(","));
        reservation.setSeats(seatLabels);

        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName(); // username from authentication
        User currentUser = userRepository.findByUsername(username);
        reservation.setUser(currentUser);

        reservationService.saveReservation(reservation);
        //attach seats
        for (Long seatId : seatIds) {
            Seat seat = seatRepository.findById(seatId).orElse(null);
            if (seat.getReservation() != null) {
                model.addAttribute("error", "Seat " + seat.getSeatLabel() + " was just reserved!");
                return "reservationSummary";
            }
            seat.setReservation(reservation);
            seatRepository.save(seat);
        }
        //attach image
        model.addAttribute("reservation", reservation);
        if (movie.getImageData() != null && movie.getImageData().length > 0) {
            model.addAttribute("base64Image", convertToBase64(movie.getImageData()));
        }
        session.setAttribute("reservationId", reservation.getId());
        return "redirect:/thankYou?resId=" + reservation.getId();
    }

    //6. thank-you message
    @GetMapping("/thankYou")
    public String thankYou(@RequestParam("resId") Long reservationId, HttpSession session, Model model) {
        Long sessionReservationId = (Long) session.getAttribute("reservationId");
        if (sessionReservationId == null || !sessionReservationId.equals(reservationId)) {
            return "redirect:/movies";
        }
        Reservation reservation = reservationService.getReservationById(reservationId);
        if (reservation == null) {
            return "redirect:/movies";
        }
        model.addAttribute("reservation", reservation);
        Movie movie = reservation.getMovie();
        if (movie.getImageData() != null && movie.getImageData().length > 0) {
            model.addAttribute("base64Image", convertToBase64(movie.getImageData()));
        }
        return "thankYou";
    }

    //add a movie
    @GetMapping("/movies/new")
    public String newMovieForm() {
        return "createMovie";
    }

    //add a movie
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

    //user reservations
    @GetMapping("/myReservations")
    public String myReservations(Model model) {
        Authentication auth = SecurityContextHolder.getContext().getAuthentication();
        String username = auth.getName();
        List<Reservation> reservations = reservationRepository.findByUser_Username(username);

        // Build a list of maps containing each reservation and a MovieDTO for its movie
        List<Map<String, Object>> reservationData = reservations.stream().map(reservation -> {
            Map<String, Object> map = new HashMap<>();
            map.put("reservation", reservation);
            Movie movie = reservation.getMovie();
            MovieDTO movieDTO = new MovieDTO();
            movieDTO.setId(movie.getId());
            movieDTO.setTitle(movie.getTitle());
            movieDTO.setDescription(movie.getDescription());
            movieDTO.setTicketPrice(movie.getTicketPrice());
            if (movie.getImageData() != null && movie.getImageData().length > 0) {
                movieDTO.setBase64Image(convertToBase64(movie.getImageData()));
            }
            map.put("movieDTO", movieDTO);
            return map;
        }).collect(Collectors.toList());

        model.addAttribute("reservationData", reservationData);
        return "myReservations";
    }

    //additional support for image conversion
    public String convertToBase64(byte[] imageData) {
        if (imageData == null || imageData.length == 0) {
            return null;
        }
        return Base64.getEncoder().encodeToString(imageData);
    }
}