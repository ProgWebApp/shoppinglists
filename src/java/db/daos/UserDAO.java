package db.daos;

import db.entities.User;
import db.exceptions.DAOException;
import java.sql.Date;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence
 * system that interact with {@link User user}.
 */
public interface UserDAO extends DAO<User, Integer> {

    /**
     * Update the password of the passed user.
     *
     * @param user the user to update
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public void updatePassword(User user) throws DAOException;
    
    /**
     * Returns the {@link User user} with the given {@code email} and
     * {@code password}.
     *
     * @param email the email of the user to get.
     * @param password the password of the user to get.
     * @return the {@link User user} with the given {@code username} and
     * {@code password}..
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public User getByEmailAndPassword(String email, String password) throws DAOException;

    /**
     * Returns the {@link User user} with the given {@code email} if exists
     *
     * @param email the email of the user to get.
     * @return the {@link User user} with the given {@code username}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public User getByEmail(String email) throws DAOException;
    
    /**
     * Returns the {@link User user} with the given {@code check} code.
     *
     * @param checkCode the check code
     * @return the {@link User user} with the given {@code check} code.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public User getByCheckCode(String checkCode) throws DAOException;

    /**
     * Returns the {@link User user} with the given token.
     *
     * @param token the token of the user
     * @return the {@link User user} with the given token.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public User getByToken(String token) throws DAOException;

    /**
     * Add a token with the passed expiration date to the user identified by the
     * passed user Id.
     *
     * @param userId the id of the user
     * @param token the new token
     * @param expirationDate the expiration date of the token
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public void setToken(Integer userId, String token, Date expirationDate) throws DAOException;

    /**
     * Returns the list of {@link User user} that that contais {@code query} in
     * the name field.
     *
     * @param query the letters that the name of the user must contains.
     * @return the list of {@link User user} that that contais {@code query} in
     * the name field, or an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<User> searchByName(String query) throws DAOException;
}
