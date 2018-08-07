package db.daos.jdbc;

import db.daos.MessageDAO;
import db.entities.Message;
import db.entities.Product;
import db.exceptions.DAOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

/**
 * The JDBC implementation of the {@link MessageDAO} interface.
 */
public class JDBCMessageDAO extends JDBCDAO<Message, Integer> implements MessageDAO {

    /**
     * The default constructor of the class.
     *
     * @param con the connection to the persistence system.
     */
    public JDBCMessageDAO(Connection con) {
        super(con);
    }

    /**
     * Persists the new {@code Message} passed as parameter to the storage
     * system.
     *
     * @param message the new {@code message} to persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public Integer insert(Message message) throws DAOException {
        if (message == null) {
            throw new DAOException("message is not valid", new NullPointerException("message is null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO messages (sender, date, body, list) VALUES (?,?,?,?)", Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, message.getSenderId());
            ps.setString(2, message.getDate());
            ps.setString(3, message.getBody());
            ps.setInt(4, message.getShoppingListId());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                message.setId(rs.getInt(1));
            }

            return message.getId();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert the new message", ex);
        }
    }

    /**
     * Persists the alredy existing {@code Message} passed as parameter to the
     * storage system.
     *
     * @param message the {@code message} to persist.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public void update(Message message) throws DAOException {
        if (message == null) {
            throw new DAOException("message is not valid", new NullPointerException("message is null"));
        }

        Integer messageId = message.getId();
        if (messageId == null) {
            throw new DAOException("message is not valid", new NullPointerException("message id is null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("UPDATE messages SET sender = ?, date = ?, body = ?, list = ?", Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, message.getSenderId());
            ps.setString(2, message.getDate());
            ps.setString(3, message.getBody());
            ps.setInt(4, message.getShoppingListId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the message", ex);
        }
    }

    /**
     * Delete the alredy existing {@code Message} passed as parameter from the
     * storage system.
     *
     * @param message the primaryKey of the {@code message} to delete.
     * @throws DAOException if an error occurred during the delting action.
     */
    @Override
    public void delete(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM messages WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete the message", ex);
        }
    }

    /**
     * Returns the number of {@link Message message} stored on the persistence
     * system of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public Long getCount() throws DAOException {
        try (Statement stmt = CON.createStatement()) {
            ResultSet counter = stmt.executeQuery("SELECT COUNT(*) FROM messages");
            if (counter.next()) {
                return counter.getLong(1);
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to count messages", ex);
        }

        return 0L;
    }

    /**
     * Returns the {@link Message message} with the primary key equals to the
     * one passed as parameter.
     *
     * @param primaryKey the {@code id} of the {@code message} to get.
     * @return the {@code message} with the id equals to the one passed as
     * parameter.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public Message getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM messages WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            ResultSet rs = stm.executeQuery();

            rs.next();
            return setAllMessageFields(rs);

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the message for the passed primary key", ex);
        }
    }

    /**
     * Returns the list of all the valid {@link Message message} stored by the
     * storage system.
     *
     * @return the list of all the valid {@code message}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public List<Message> getAll() throws DAOException {
        try (Statement stm = CON.createStatement()) {

            List<Message> messages = new ArrayList<>();
            ResultSet rs = stm.executeQuery("SELECT * FROM messages ORDER BY name");

            while (rs.next()) {
                messages.add(setAllMessageFields(rs));
            }

            return messages;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of messages", ex);
        }
    }

    @Override
    public List<Message> getByShoppingList(Integer shoppingListId) throws DAOException {
        if (shoppingListId == null) {
            throw new DAOException("shoppingListId is a mandatory field", new NullPointerException("shoppingListId is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM messages WHERE list = ?")) {

            List<Message> messages = new ArrayList<>();

            stm.setInt(1, shoppingListId);
            ResultSet rs = stm.executeQuery();

            while (rs.next()) {
                messages.add(setAllMessageFields(rs));
            }

            return messages;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of messages for the passed shoppingListId", ex);
        }
    }

    /**
     * Convinience method for setting all the fileds of a {@code message} after
     * retriving it from the storage system.
     *
     * @param rs the {@link ResultSet} of the query that retrives the
     * {@code message}
     * @return the new {@code message}
     * @throws SQLException if an error occurred during the information
     * retriving
     */
    private Message setAllMessageFields(ResultSet rs) throws SQLException {
        Message message = new Message();
        message.setId(rs.getInt("id"));
        message.setSenderId(rs.getInt("sneder"));
        message.setDate(rs.getString("date"));
        message.setBody(rs.getString("body"));
        message.setShoppingListId(rs.getInt("list"));

        return message;
    }
}
