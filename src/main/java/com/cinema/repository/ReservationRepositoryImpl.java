package com.cinema.repository;

import com.cinema.model.Reservation;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReservationRepositoryImpl implements ReservationRepository {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public void saveReservation(Reservation reservation) {
        sessionFactory.getCurrentSession().saveOrUpdate(reservation);
    }

    @Override
    public Reservation getReservationById(long id) {
        return sessionFactory.getCurrentSession().get(Reservation.class, id);
    }
}