package db.daos;

import db.entities.ShoppingList;
import db.exceptions.DAOException;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence 
 * system that interact with {@link ShoppingList shoppingList}.
 */
public interface ShoppingListDAO extends DAO<ShoppingList, Integer> {

    /**
     * Returns the list of {@link ShoppingList shoppingList} with the
     * {@code user} is the one passed as parameter.
     *
     * @param userId the {@code id} of the {@code user} for which retrieve the
     * shoppingList list.
     * @return the list of {@code shoppingList} with the user id equals to the
     * one passed as parameter or an empty list if user id is not linked to any.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<ShoppingList> getByUserId(Integer userId) throws DAOException;

    /**
     * Links the passed {@code shoppingList} with the passed {@code user}.
     *
     * @param shoppingListId the id of the shoppingList to link.
     * @param userId the id of user to link.
     * @param permissions the {@code user} permission for the
     * {@code shoppingList}.
     * @param notifications the notification for the {@code user} for the
     * {@code shoppingList}
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addLinkWithUser(Integer shoppingListId, Integer userId, int permissions, boolean notifications) throws DAOException;

    /**
     * Removes the link between the passed {@code shoppingList} and the passed
     * {@code user}.
     *
     * @param shoppingListId the id of the shoppingList to remove from the
     * link.
     * @param userId the id of user to remove from the link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeLinkWithUser(Integer shoppingListId, Integer userId) throws DAOException;

    /**
     * Updates the link between the passed {@code shoppingList} and the passed
     * {@code user}.
     *
     * @param shoppingListId the id of the shoppingList to update in the link.
     * @param userId the id of user to update in the link.
     * @param permissions the {@code user} new permission for the
     * {@code shoppingList}.
     * @param notifications the {@code user} new notification for the
     * {@code shoppingList}
     * @throws DAOException if an error occurred during the persist action.
     */
    public void updateLinkWithUser(Integer shoppingListId, Integer userId, int permissions, boolean notifications) throws DAOException;

    /**
     * Adds the passed {@code pruduct} to the passed {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList in which to add the product.
     * @param productId the id of the product to add in the shoppingList.
     * @param quantity the quantity of the product to add in the shoppingList.
     * @param necessary true if the product needs to be bought, false otherwise.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addProduct(Integer shoppingListId, Integer productId, int quantity, boolean necessary) throws DAOException;

    /**
     * Removes the passed {@code pruduct} from the passed {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList from which to remove the product.
     * @param productId the id of the product to remove from the shoppingList.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeProduct(Integer shoppingListId, Integer productId) throws DAOException;

    /**
     * Updates the propertys of the passed {@code pruduct} in the passed {@code shoppingList}.
     *
     * @param shoppingListId the id of the shoppingList in which to update the properties of the product.
     * @param productId the id of the product whose properties needs to be updated.
     * @param quantity the new quantity of the product in the shoppingList.
     * @param necessary true if the product needs to be bought, false otherwise.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void updateProduct(Integer shoppingListId, Integer productId, int quantity, boolean necessary) throws DAOException;
}
