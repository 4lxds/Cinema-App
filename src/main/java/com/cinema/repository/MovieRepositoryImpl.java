package com.cinema.repository;

import java.util.List;
import com.cinema.model.Movie;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MovieRepositoryImpl implements MovieRepository {

    @Autowired
    private SessionFactory sessionFactory;

    @Override
    public List<Movie> getAllMovies() {
        return sessionFactory.getCurrentSession().createQuery("from Movie", Movie.class).list();
    }

    @Override
    public Movie getMovieById(long id) {
        return sessionFactory.getCurrentSession().get(Movie.class, id);
    }

    @Override
    public void saveMovie(Movie movie) {
        sessionFactory.getCurrentSession().saveOrUpdate(movie);
    }
}
