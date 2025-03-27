package com.cinema.service;

import com.cinema.model.Seat;
import com.cinema.repository.SeatRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
public class SeatServiceImpl implements SeatService {

    @Autowired
    private SeatRepository seatRepository;

    @Override
    public List<Seat> getSeatsForMovie(Long movieId) {
        return seatRepository.findByMovieId(movieId);
    }

    @Override
    public Seat getSeatById(Long seatId) {
        return seatRepository.findById(seatId).orElse(null);
    }

    @Override
    public void saveSeat(Seat seat) {
        seatRepository.save(seat);
    }
}