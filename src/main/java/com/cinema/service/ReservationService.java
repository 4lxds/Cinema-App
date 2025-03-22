package com.cinema.service;

import com.cinema.model.Reservation;

public interface ReservationService {
    void saveReservation(Reservation reservation);
    Reservation getReservationById(Long id);
}