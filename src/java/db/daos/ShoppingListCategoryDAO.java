package db.daos;

import db.entities.ProductCategory;
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
     * Returns the list of pruductCategory linked with the {@code shoppingListCategory}.
     * @param shoppingListCategoryId the id of the shoppingListCategory
     * @return 
     * @throws DAOException if an error occurred during the persist action.
     */
    public List<ProductCategory> getProductCategories(Integer shoppingListCategoryId) throws DAOException;
    
    /**
     * Checks if the shoppingListCategory is linked with the productCategory.
     * @param shoppingListCategoryId the id of the shoppingListCategory
     * @param productCategoryId the id of the productCategory
     * @return true if are linked, false otherwise
     * @throws DAOException if an error occurred during the persist action.
     */
    public boolean hasProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;
    
    /**
     * Returns the list of all the valid shops where the user has to buy something
     * system.
     *
     * @param userId the id of the user which we are checking
     * @return the list of all the shops where {@code user} has to buy something
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<String> getShopsByUser(Integer userId) throws DAOException;
}
