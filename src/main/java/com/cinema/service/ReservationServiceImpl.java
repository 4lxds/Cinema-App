package com.cinema.service;

import com.cinema.model.Reservation;
import com.cinema.repository.ReservationRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationRepository reservationRepository;

    @Override
    public void saveReservation(Reservation reservation) {
        reservationRepository.saveReservation(reservation);
    }

    @Override
    public Reservation getReservationById(Long id) {
        return reservationRepository.getReservationById(id);
    }
}