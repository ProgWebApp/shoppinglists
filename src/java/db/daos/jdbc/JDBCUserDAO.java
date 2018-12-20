package db.daos.jdbc;

import db.daos.UserDAO;
import db.entities.User;
import db.exceptions.DAOException;
import db.exceptions.UniqueConstraintException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

/**
 * The JDBC implementation of the {@link UserDAO} interface.
 */
public class JDBCUserDAO extends JDBCDAO<User, Integer> implements UserDAO {

    /**
     * The default constructor of the class.
     *
     * @param con the connection to the persistence system.
     */
    public JDBCUserDAO(Connection con) {
        super(con);
    }

    /**
     * Persists the new {@code User} passed as parameter to the storage system.
     *
     * @param user the new {@code user} to persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public Integer insert(User user) throws DAOException {
        if (user == null) {
            throw new DAOException("user is not valid", new NullPointerException("user is null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO users (firstname, lastname, email, password, avatar, code, admin) VALUES (?,?,?,ENCODE(DIGEST(?,'sha256'),'hex'),?,?,?)", Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getPassword());
            ps.setString(5, user.getAvatarPath());
            ps.setString(6, user.getCheck());
            ps.setBoolean(7, user.isAdmin());
            
            ps.executeUpdate();
            
            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                user.setId(rs.getInt(1));
            }
            return user.getId();
        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to insert the new user", new UniqueConstraintException("A user with this email already exists in the system"));
            }
            throw new DAOException("Impossible to insert the new user", ex);
        }
    }

    /**
     * Persists the alredy existing {@code User} passed as parameter to the
     * storage system. IT DOES NOT UPDATE THE PASSWORD FIELD!
     *
     * @param user the {@code user} to persist.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public void update(User user) throws DAOException {
        if (user == null) {
            throw new DAOException("user is not valid", new NullPointerException("User is null"));
        }
        
        Integer userId = user.getId();
        if (userId == null) {
            throw new DAOException("user is not valid", new NullPointerException("User id is null"));
        }
        
        try (PreparedStatement ps = CON.prepareStatement("UPDATE users SET firstname = ?, lastname = ?, email = ?, avatar = ?, admin = ?, code = ? WHERE id = ?")) {
            
            ps.setString(1, user.getFirstName());
            ps.setString(2, user.getLastName());
            ps.setString(3, user.getEmail());
            ps.setString(4, user.getAvatarPath());
            ps.setBoolean(5, user.isAdmin());
            ps.setString(6, user.getCheck());
            ps.setInt(7, user.getId());
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to update the user", new UniqueConstraintException("A user with this email already exists in the system"));
            }
            throw new DAOException("Impossible to update the user", ex);
        }
    }

    @Override
    public void updatePassword(User user) throws DAOException {
        if (user == null) {
            throw new DAOException("user is not valid", new NullPointerException("User is null"));
        }
        
        Integer userId = user.getId();
        if (userId == null) {
            throw new DAOException("user is not valid", new NullPointerException("User id is null"));
        }
        
        try (PreparedStatement ps = CON.prepareStatement("UPDATE users SET password = ENCODE(DIGEST(?,'sha256'),'hex') WHERE id = ?")) {
            
            ps.setString(1, user.getPassword());
            ps.setInt(2, user.getId());
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the user", ex);
        }
    }

    /**
     * Delete the alredy existing {@code User} passed as parameter from the
     * storage system.
     *
     * @param primaryKey the primaryKey of the {@code user} to delete.
     * @throws DAOException if an error occurred during the delting action.
     */
    @Override
    public void delete(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM users WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete the user", ex);
        }
    }

    /**
     * Returns the number of {@link User users} stored on the persistence system
     * of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public Long getCount() throws DAOException {
        try (Statement stmt = CON.createStatement()) {
            ResultSet counter = stmt.executeQuery("SELECT COUNT(*) FROM users");
            if (counter.next()) {
                return counter.getLong(1);
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to count users", ex);
        }
        return 0L;
    }

    /**
     * Returns the {@link User user} with the primary key equals to the one
     * passed as parameter.
     *
     * @param primaryKey the {@code id} of the {@code user} to get.
     * @return the {@code user} with the id equals to the one passed as
     * parameter.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public User getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE id = ?");
                PreparedStatement countStatement = CON.prepareStatement("SELECT COUNT(*) FROM users_lists WHERE user_id = ?")) {
            stm.setInt(1, primaryKey);
            
            ResultSet rs = stm.executeQuery();
            rs.next();
            return setAllUserFields(rs, countStatement);
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user for the passed primary key", ex);
        }
    }

    /**
     * Returns the list of all the valid {@link User users} stored by the
     * storage system.
     *
     * @return the list of all the valid {@code users}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public List<User> getAll() throws DAOException {
        try (Statement stm = CON.createStatement();
                PreparedStatement countStatement = CON.prepareStatement("SELECT COUNT(*) FROM users_lists WHERE user_id = ?")) {
            
            List<User> users = new ArrayList<>();
            ResultSet rs = stm.executeQuery("SELECT * FROM users ORDER BY lastname");
            
            while (rs.next()) {
                users.add(setAllUserFields(rs, countStatement));
            }
            
            return users;
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users", ex);
        }
    }
    
    @Override
    public User getByEmailAndPassword(String email, String password) throws DAOException {
        if (email == null) {
            throw new DAOException("Email is a mandatory fields", new NullPointerException("email is null"));
        }
        if (password == null) {
            throw new DAOException("Password is a mandatory fields", new NullPointerException("password is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE email = ? AND password = ENCODE(DIGEST(?,'sha256'),'hex')");
                PreparedStatement countStatement = CON.prepareStatement("SELECT COUNT(*) FROM users_lists WHERE user_id = ?")) {
            stm.setString(1, email);
            stm.setString(2, password);
            
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return setAllUserFields(rs, countStatement);
            } else {
                return null;
            }
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user", ex);
        }
    }
    
    @Override
    public User getByEmail(String email) throws DAOException {
        if (email == null) {
            throw new DAOException("Email is a mandatory fields", new NullPointerException("email is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE email = ? ")) {
            stm.setString(1, email);
            ResultSet rs = stm.executeQuery();
            if(rs.next()){
                return setAllUserFields(rs, null);
            }else{
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user", ex);
        }
    }

    @Override
    public User getByCheckCode(String checkCode) throws DAOException {
        if (checkCode == null) {
            throw new DAOException("checkCode is a mandatory fields", new NullPointerException("checkCode is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE code = ?")) {
            stm.setString(1, checkCode);
            
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return setAllUserFields(rs, null);
            } else {
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user", ex);
        }
    }
    
    @Override
    public List<User> searchByName(String query) throws DAOException {
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE (LOWER(firstname) LIKE LOWER(?) OR LOWER(lastname) LIKE LOWER(?))")) {
            
            List<User> users = new ArrayList<>();
            stm.setString(1, "%" + query + "%");
            stm.setString(2, "%" + query + "%");
            ResultSet rs = stm.executeQuery();
            
            while (rs.next()) {
                users.add(setAllUserFields(rs, null));
            }
            
            return users;
            
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of users for the passed query", ex);
        }
    }

    /**
     * Convinience method for setting all the fileds of a {@code user} after
     * retriving it from the storage system.
     *
     * @param rs the {@link ResultSet} of the query that retrives the
     * {@code user}
     * @param countStatement the {@link PreparedStatement} for retriving the
     * number of shopping list associated to a user
     * @return the new {@code user}
     * @throws SQLException if an error occurred during the information
     * retriving
     */
    public static User setAllUserFields(ResultSet rs, PreparedStatement countStatement) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setFirstName(rs.getString("firstname"));
        user.setLastName(rs.getString("lastname"));
        user.setEmail(rs.getString("email"));
        user.setPassword(rs.getString("password"));
        user.setAvatarPath(rs.getString("avatar"));
        user.setAdmin(rs.getBoolean("admin"));
        user.setCheck(rs.getString("code"));
        
        if (countStatement != null) {
            countStatement.setInt(1, user.getId());
            ResultSet counter = countStatement.executeQuery();
            counter.next();
            user.setShoppingListsCount(counter.getInt(1));
        }
        
        return user;
    }
    
    @Override
    public User getByToken(String token) throws DAOException {
        if (token == null) {
            throw new DAOException("token is a mandatory fields", new NullPointerException("token is null"));
        }
        
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM users WHERE token_code = ? AND expiration>NOW()")) {
            stm.setString(1, token);
            
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return setAllUserFields(rs, null);
            } else {
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the user", ex);
        }
    }
    
    @Override
    public void setToken(Integer userId, String token, Date expirationDate) throws DAOException {
        if (userId == null) {
            throw new DAOException("userId is not valid", new NullPointerException("userId is null"));
        }
        
        try (PreparedStatement ps = CON.prepareStatement("UPDATE users SET token_code = ?, expiration = ? WHERE id = ?")) {
            
            if(token != null){
                ps.setString(1, token);
            }else{
                ps.setNull(1, Types.VARCHAR);
            }
            if (expirationDate != null) {
                ps.setDate(2, expirationDate);
            } else {
                ps.setNull(2, Types.DATE);
            }
            ps.setInt(3, userId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to update the user", new UniqueConstraintException("A user with this email already exists in the system"));
            }
            throw new DAOException("Impossible to update the user", ex);
        }
    }
}
