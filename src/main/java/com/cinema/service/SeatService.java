package com.cinema.service;

import java.util.List;
import com.cinema.model.Seat;

public interface SeatService {
    List<Seat> getSeatsForMovie(Long movieId);
    Seat getSeatById(Long seatId);
    void saveSeat(Seat seat);
}
