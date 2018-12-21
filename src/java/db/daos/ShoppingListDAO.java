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
     * Returns the list of {@link ShoppingList} owned or shared with the passed user that can
     * contain the passed product category.
     *
     * @param productCategoryId the id of the {@link ProductCategory}
     * @param userId the id of the {@link User}
     * @return a list of {@link ShoppingList} having the specified 
     * productCategory for the specified userId
     * @throws DAOException if an error occurred during the persist action.
     */
    public List<ShoppingList> getListsByProductCategory(Integer productCategoryId, Integer userId) throws DAOException;

    /**
     * Returns the list of {@link ShoppingList} shared with the
     * passed user.
     *
     * @param userId the id of the {@link User} for which retrieve the
     * shoppingLists.
     * @return the list of {@link ShoppingList} shared the passed user or 
     * an empty list if user id is not linked to any.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<ShoppingList> getByUserId(Integer userId) throws DAOException;

    /**
     * Returns the {@link ShoppingList} of the passed user
     * identified by his cookie.
     *
     * @param cookie the cookie of the {@link User} for which retrieve the
     * {@link ShoppingList}.
     * @return the {@link ShoppingList} of the {@link User} identified
     * by the passed cookie or null.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public ShoppingList getByCookie(String cookie) throws DAOException;

    /**
     * Returns a shoppingList if is visible by a user. A shoppingList is visible
     * by user if someone shared the shoppingList with the user.
     *
     * @param shoppingListId the id of the {@link ShoppingList}
     * @param userId the id of the {@link User}
     * @return the {@link ShoppingList} with the passed id if this exists 
     * and is visible by the user, null otherwise
     * @throws DAOException if an error occurred during the persist action.
     */
    public ShoppingList getIfVisible(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Adds the passed {@link User} to the members of the passed
     * {@link ShoppingList}.
     *
     * @param shoppingListId the id of the {@link ShoppingList} to link.
     * @param userId the id of {@link User} to link.
     * @param permissions the user's permission for the shoppingList.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addMember(Integer shoppingListId, Integer userId, Integer permissions) throws DAOException;

    /**
     * Removes the the passed {@link User} from the members of the passed
     * {@link ShoppingList}.
     *
     * @param shoppingListId the id of the {@link ShoppingList} to update.
     * @param userId the id of {@link User} to remove from the shoppingList.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeMember(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Update the passed {@link User} in the passed {@link ShoppingList}
     * with the passed permissions.
     *
     * @param shoppingListId the id of the {@link ShoppingList} to update.
     * @param userId the id of {@link User} to update.
     * @param permissions the new permissions to set to the user.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void updateMember(Integer shoppingListId, Integer userId, Integer permissions) throws DAOException;

    /**
     * Returns the list of all the {@link User} that are members of the passed
     * {@link shoppingList}
     *
     * @param shoppingListId the id of the {@link ShoppingList}.
     * @return the list of all the {@link User} that are members of the passed
     * shoppingList, or an empty list.
     * @throws DAOException if an error occurred during the persist action.
     */
    public List<User> getMembers(Integer shoppingListId) throws DAOException;

    /**
     * Updates all the links between the passed {@link ShoppingList} and the
     * {@link User} that shares the shoppingList, exept for the passed one, adding a notification.
     *
     * @param shoppingListId the id of the {@link ShoppingList} to update.
     * @param userId the id of the {@link User} for which not to add the notification
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addNotifications(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Updates the link between the passed {@link ShoppingList} and the passed
     * {@link User} removing all notifications.
     *
     * @param shoppingListId the id of the {@link ShoppingList} to update in the link.
     * @param userId the id of {@link User} to update in the link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeNotifications(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Get the number of notifications for the passed {@link User}
     *
     * @param userId the id of {@link User} to search the notifications.
     * @return the number of notifications for the passed userId
     * @throws DAOException if an error occurred during the persist action.
     */
    public Integer getNotificationsByUser(Integer userId) throws DAOException;

    /**
     * Adds the passed {@link Pruduct} to the passed {@link ShoppingList}.
     *
     * @param shoppingListId the id of the {@link ShoppingList} in which to add the
     * product.
     * @param productId the id of the {@link Product} to add in the shoppingList.
     * @param quantity the quantity of the product to add in the shoppingList.
     * @param necessary true if the product needs to be bought, false otherwise.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addProduct(Integer shoppingListId, Integer productId, int quantity, boolean necessary) throws DAOException;

    /**
     * Removes the passed {@link Pruduct} from the passed {@link ShoppingList}.
     *
     * @param shoppingListId the id of the {@link ShoppingList} from which to remove the
     * product.
     * @param productId the id of the {@link Product} to remove from the shoppingList.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeProduct(Integer shoppingListId, Integer productId) throws DAOException;

    /**
     * Updates the properties of the passed {@link Pruduct} in the passed
     * {@link ShoppingList}.
     *
     * @param shoppingListId the id of the {@link ShoppingList} in which to update the
     * properties of the product.
     * @param productId the id of the {@link Product} whose properties needs to be
     * updated.
     * @param quantity the new quantity of the product in the shoppingList.
     * @param necessary true if the product needs to be bought, false otherwise.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void updateProduct(Integer shoppingListId, Integer productId, int quantity, boolean necessary) throws DAOException;

    /**
     * Returns the list of the {@link Product} in the passed {@link ShoppingList}
     *
     * @param shoppingListId the id of the {@link ShoppingList}.
     * @return the list of the {@link Products} in the passed {@link ShoppingList}.
     * @throws DAOException if an error occurred during the persist action.
     */
    public List<Product> getProducts(Integer shoppingListId) throws DAOException;
    
    /**
     * Returns the permission of the passed {@link User} for the passed {@link ShoppingList}
     *
     * @param shoppingListId the id of the {@link ShoppingList} to check.
     * @param userActiveId the id of the {@link User} to check.
     * @return the permission for the passed user for the passed shoppingList.
     * @throws DAOException if an error occurred during the persist action.
     */
    public Integer getPermission(Integer shoppingListId, Integer userActiveId) throws DAOException;
}
