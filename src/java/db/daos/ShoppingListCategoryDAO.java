package db.daos;

import db.entities.ShoppingListCategory;
import db.entities.User;
import db.exceptions.DAOException;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence
 * system that interact with {@link ShoppingListCategory shoppingListCategory}.
 */
public interface ShoppingListCategoryDAO extends DAO<ShoppingListCategory, Integer> {

    /**
     * Adds the passed {@code pruductCategory} to the passed
     * {@code shoppingListCategory}.
     *
     * @param shoppingListCategoryId the id of the shoppingListCategory in which
     * to add the productCategory.
     * @param productCategoryId the id of the productCategory to add in the
     * shoppingListCategory.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;

    /**
     * Removes the passed {@code pruductCategory} from the passed
     * {@code shoppingListCategory}.
     *
     * @param shoppingListCategoryId the id of the shoppingListCategory from which
     * to remove the productCategory.
     * @param productCategoryId the id of the productCategory to remove from the
     * shoppingListCategory.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;
    
    /**
     * Returns the list of all the valid shops where the user has to buy something
     * system.
     *
     * @param user the user which we are checking
     * @return the list of all the shops where {@code user} has to buy something
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<String> getShopsByUser(User user) throws DAOException;
}
