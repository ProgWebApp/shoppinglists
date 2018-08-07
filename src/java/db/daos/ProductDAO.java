package db.daos;

import db.entities.Product;
import db.exceptions.DAOException;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence
 * system that interact with {@link Product product}.
 */
public interface ProductDAO extends DAO<Product, Integer> {

    /**
     * Returns the list of {@link Product product} that are compatible with the
     * shoppingListCategory passed as paramenter and that are shared with the
     * user passed as parameter.
     *
     * @param shoppingListCategoryId the id of the {@code ShoppingListCategory}
     * for which to retrive the compatible products.
     * @param userId the {@code id} of the {@code user} for which retrieve the
     * product list.
     * @return the list of {@link Product product} that are compatible with the
     * shoppingListCategory passed as paramenter and that are shared with the
     * user passed as parameter, or an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> getByShoppingListCategory(Integer shoppingListCategoryId, Integer userId) throws DAOException;

    /**
     * Returns the list of {@link Product product} that are compatible with the
     * shoppingListCategory passed as paramenter, that are shared with the user
     * passed as parameter and that contais {@code query} in the name field.
     *
     * @param query the letters that the name of the product must contains.
     * @param shoppingListCategoryId the id of the {@code ShoppingListCategory}
     * for which to retrive the compatible products.
     * @param userId the {@code id} of the {@code user} for which retrieve the
     * product list.
     * @return the list of {@link Product product} that are compatible with the
     * shoppingListCategory passed as paramenter, that are shared with the user
     * passed as parameter and that contais {@code query} in the name field, or
     * an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> searchByName(String query, Integer shoppingListCategoryId, Integer userId) throws DAOException;

    /**
     * Links the passed {@code product} with the passed {@code user}.
     *
     * @param productId the id of the product to link.
     * @param userId the id of user to link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addLinkWithUser(Integer productId, Integer userId) throws DAOException;

    /**
     * Removes the link between the passed {@code product} and the passed
     * {@code user}.
     *
     * @param productId the id of the product to remove from the link.
     * @param userId the id of user to remove from the link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeLinkWithUser(Integer productId, Integer userId) throws DAOException;

}
