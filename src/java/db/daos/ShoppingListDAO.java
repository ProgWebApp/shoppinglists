package db.daos;

import db.entities.Product;
import db.entities.ShoppingList;
import db.entities.User;
import db.exceptions.DAOException;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence
 * system that interact with {@link ShoppingList shoppingList}.
 */
public interface ShoppingListDAO extends DAO<ShoppingList, Integer> {

    /**
     * Returns the list of {@link ShoppingList shoppingList} shared with the
     * passed user.
     *
     * @param userId the {@code id} of the {@code user} for which retrieve the
     * shoppingList list.
     * @return the list of {@code shoppingList} shared the user passed as
     * parameter or an empty list if user id is not linked to any.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<ShoppingList> getByUserId(Integer userId) throws DAOException;
    
    /**
     * Returns the {@link ShoppingList shoppingList} of the
     * passed user, identified by his cookie.
     *
     * @param userId the {@code id} of the {@code user} for which retrieve the
     * shoppingList list.
     * @return the {@code shoppingList} of the user passed as
     * parameter or null.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public ShoppingList getByCookie(String userId) throws DAOException;

    /**
     * Returns a shoppingList if is visible by a user. A shoppingList is visible
     * by user if someone shared the shoppingList with the user.
     *
     * @param shoppingListId the id of the shoppingList
     * @param userId the id of the user
     * @return the shoppingList with the passed id if this exists and is visible
     * by the user, null otherwise
     * @throws DAOException
     */
    public ShoppingList getIfVisible(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Adds the passed {@code user} to the members of the passed
     * {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList to link.
     * @param userId the id of user to link.
     * @param permissions the {@code user} permission for the
     * {@code shoppingList}.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addMember(Integer shoppingListId, Integer userId, Integer permissions) throws DAOException;

    /**
     * Removes the the passed {@code user} from the members of the passed
     * {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList to remove from the link.
     * @param userId the id of user to remove from the link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeMember(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Update the the passed {@code user} in the passed {@code shoppingList}
     * with the passed {@code permissions]
     *
     * @param shoppingListId the id of the shoppingList
     * @param userId the id of user to update
     * @param permissions the new permissions to set to the user
     * @throws DAOException if an error occurred during the persist action.
     */
    public void updateMember(Integer shoppingListId, Integer userId, Integer permissions) throws DAOException;

    /**
     * Returns the list of all the {@code user} that are members of the passed
     * {@code shoppingList}
     *
     * @param shoppingListId the id of the shoppingList
     * @return the list of all the {@code user} that are members of the passed
     * {@code shoppingList}, or an empty list.
     * @throws DAOException
     */
    public List<User> getMembers(Integer shoppingListId) throws DAOException;

    /**
     * Updates all the links between the passed {@code shoppingList} and all the
     * users adding a notification.
     *
     * @param shoppingListId the id of the shoppingList to update in the link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addNotifications(Integer shoppingListId) throws DAOException;

    /**
     * Updates the link between the passed {@code shoppingList} and the passed
     * {@code user} removing all notifications.
     *
     * @param shoppingListId the id of the shoppingList to update in the link.
     * @param userId the id of user to update in the link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeNotifications(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Adds the passed {@code pruduct} to the passed {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList in which to add the
     * product.
     * @param productId the id of the product to add in the shoppingList.
     * @param quantity the quantity of the product to add in the shoppingList.
     * @param necessary true if the product needs to be bought, false otherwise.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addProduct(Integer shoppingListId, Integer productId, int quantity, boolean necessary) throws DAOException;
    
    /**
     * Removes the passed {@code pruduct} from the passed {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList from which to remove the
     * product.
     * @param productId the id of the product to remove from the shoppingList.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeProduct(Integer shoppingListId, Integer productId) throws DAOException;

    /**
     * Updates the propertys of the passed {@code pruduct} in the passed
     * {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList in which to update the
     * properties of the product.
     * @param productId the id of the product whose properties needs to be
     * updated.
     * @param quantity the new quantity of the product in the shoppingList.
     * @param necessary true if the product needs to be bought, false otherwise.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void updateProduct(Integer shoppingListId, Integer productId, int quantity, boolean necessary) throws DAOException;

    /**
     * Returns the list of the products in the passed {@code shoppingList}
     *
     * @param shoppingListId the id of the shoppingList
     * @return the list of the products in the passed {@code shoppingList}
     * @throws DAOException if an error occurred during the persist action.
     */
    public List<Product> getProducts(Integer shoppingListId) throws DAOException;

    public Integer getPermission(Integer shoppingListId, Integer userActiveId) throws DAOException;
}
