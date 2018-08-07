package db.daos;

import db.entities.User;
import db.exceptions.DAOException;

/**
 * All concrete DAOs must implement this interface to handle the persistence 
 * system that interact with {@link User user}.
 */
public interface UserDAO extends DAO<User, Integer> {
    
    /**
     * Returns the {@link User user} with the given {@code email} and
     * {@code password}.
     * @param email the email of the user to get.
     * @param password the password of the user to get.
     * @return the {@link User user} with the given {@code username} and
     * {@code password}..
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public User getByEmailAndPassword(String email, String password) throws DAOException;
}
