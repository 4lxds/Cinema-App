package com.cinema.repository;

import com.cinema.model.Reservation;

public interface ReservationRepository {
    void saveReservation(Reservation reservation);
    Reservation getReservationById(long id);
}
