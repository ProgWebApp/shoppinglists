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
     * Adds the passed {@link PruductCategory} to the passed
     * {@link ShoppingListCategory}.
     *
     * @param shoppingListCategoryId the id of the {@link ShoppingListCategory} in which
     * to add the productCategory.
     * @param productCategoryId the id of the {@link ProductCategory} to add in the
     * shoppingListCategory.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;

    /**
     * Removes the passed {@link PruductCategory} from the passed
     * {@link ShoppingListCategory}.
     *
     * @param shoppingListCategoryId the id of the {@link ShoppingListCategory} from
     * which to remove the productCategory.
     * @param productCategoryId the id of the {@link ProductCategory} to remove from the
     * shoppingListCategory.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;

    /**
     * Returns the list of {@link PruductCategory} linked with the
     * {@link ShoppingListCategory}.
     *
     * @param shoppingListCategoryId the id of the {@link ShoppingListCategory}.
     * @return the list of {@link ProductCategory} for the passed shoppingListCategoryId.
     * @throws DAOException if an error occurred during the persist action.
     */
    public List<ProductCategory> getProductCategories(Integer shoppingListCategoryId) throws DAOException;

    /**
     * Checks if the passed {@link ShoppingListCategory} is linked with the passed {@link ProductCategory}.
     *
     * @param shoppingListCategoryId the id of the {@link ShoppingListCategory} to check.
     * @param productCategoryId the id of the {@link ProductCategory}.
     * @return true if are linked, false otherwise.
     * @throws DAOException if an error occurred during the persist action.
     */
    public boolean hasProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException;

    /**
     * Returns the list of all the valid shops where the user has to buy
     * something.
     *
     * @param userId the id of the {@link User} which we are checking.
     * @return the list of all the shops where the user has to buy something.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<String> getShopsByUser(Integer userId) throws DAOException;

    /**
     * Returns the list of the shop where the non-logged user has to buy
     * something.
     *
     * @param cookie the cookie of the {@link User} which we are checking.
     * @return the list of all the shops where the user has to buy something.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public String getShopByCookie(String cookie) throws DAOException;
}
