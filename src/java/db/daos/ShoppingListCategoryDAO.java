package db.daos;

import db.entities.ShoppingListCategory;
import db.exceptions.DAOException;

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
    public void addProductCaregory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;

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
    public void removeProductCaregory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;
}
