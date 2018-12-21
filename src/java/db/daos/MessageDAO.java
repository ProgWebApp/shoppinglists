package db.daos;

import db.entities.Message;
import db.exceptions.DAOException;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence
 * system that interact with {@link Message message}.
 */
public interface MessageDAO extends DAO<Message, Integer> {

    /**
     * Returns the list of {@link Message} that refers to the
     * {@link ShoppingList} passed as paramenter.
     *
     * @param shoppingListId the id of the {@link ShoppingList} which the message refers to.
     * @return the list of {@link Message} that refers to the
     * passed shoppingList o an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Message> getByShoppingList(Integer shoppingListId) throws DAOException;
}
