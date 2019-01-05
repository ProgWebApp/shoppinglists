package db.daos;

import db.entities.Product;
import db.entities.User;
import db.entities.ShoppingListCategory;
import db.entities.ProductCategory;
import db.entities.ShoppingList;
import db.exceptions.DAOException;
import java.util.List;

/**
 * All concrete DAOs must implement this interface to handle the persistence
 * system that interact with {@link Product}.
 */
public interface ProductDAO extends DAO<Product, Integer> {

    /**
     * Returns the list of the {@link Product} that are public.
     *
     * @param order order to display results.
     * @return the list of {@link Product} that are public, or an empty
     * list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> getPublic(Integer order) throws DAOException;

    /**
     * Returns the list of the {@link Product} that are owned by the passed {@link User}.
     *
     * @param userId the id of the {@link User} for which retrieve the
     * product list.
     * @param order order to display results.
     * @return the list of {@link Product} that are owned by the passed user or an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> getByUser(Integer userId, Integer order) throws DAOException;

    /**
     * Returns the list of {@link Product} that are compatible with the
     * passed {@link ShoppingListCategory} and that are shared with the
     * passed {@link User} in the specified order.
     *
     * @param shoppingListCategoryId the id of the {@link ShoppingListCategory}
     * for which to retrive the compatible products.
     * @param userId the id of the {@link User} for which retrieve the
     * product list.
     * @param order order to display results.
     * @return the list of {@link Product} that are compatible with the passed 
     * shoppingListCategoryand that are shared with the passed user
     * or an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> getByShoppingListCategory(Integer shoppingListCategoryId, Integer userId, Integer order) throws DAOException;
    
    /**
     * Returns the list of {@link Product} that are compatible with the
     * passed {@link ProductCategory} and that are shared with the passed
     * {@link User} in the specified order.
     *
     * @param productCategoryId the id of the {@link ShoppingListCategory}
     * for which to retrive the compatible products.
     * @param userId the id of the {@link User} for which retrieve the
     * product list.
     * @param order order to display results.
     * @return the list of {@link Product} that are compatible with the passed
     * shoppingListCategory and that are shared with the passed user or an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> getByProductCategory(Integer productCategoryId, Integer userId, Integer order) throws DAOException;

    /**
     * Returns the list of {@link Product} that are shared with the user
     * passed as parameter and that contais query in the name field.
     *
     * @param query the letters that the name of the product must contains.
     * @param userId the id of the {@link User} for which retrieve the
     * product list.
     * @param order order to display results
     * @return the list of {@link Product} that are shared with the user
     * passed as parameter and that contais query in the name field or
     * an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> searchByName(String query, Integer userId, Integer order) throws DAOException;

    /**
     * Returns the list of {@link Product} that are compatible with the passed
     * {@link ShoppingListCategory}, shared with the passed {@link User}
     * and that contais query in the name field.
     *
     * @param query the letters that the name of the product must contains.
     * @param shoppingListCategoryId the id of the {@link ShoppingListCategory}
     * for which to retrive the compatible products.
     * @param userId the id of the {@link User} for which retrieve the
     * product list.
     * @param order order to display results.
     * @return the list of {@link Product} that are compatible with the
     * shoppingListCategory passed as paramenter, that are shared with the user
     * passed as parameter and that contais query in the name field or
     * an empty list.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<Product> searchByNameAndCategory(String query, Integer shoppingListCategoryId, Integer userId, Integer order) throws DAOException;
    
    /**
     * Returns a product if is visible by a user. A product is visible by user
     * if the product is public or if someone shared the product with the user.
     *
     * @param productId the id of the {@link Product}.
     * @param userId the id of the {@link User}.
     * @return the product with the passed id if this exists and is visible by
     * the user null otherwise
     * @throws DAOException if an error occurred during the persist action
     */
    public Product getIfVisible(Integer productId, Integer userId) throws DAOException;

    /**
     * Links the passed product with the passed {@link User}.
     *
     * @param productId the id of the {@link Product} to link.
     * @param userId the id of {@link User} to link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void addLinkWithUser(Integer productId, Integer userId) throws DAOException;

    /**
     * Links the passed {@link Product} with al the users that are members of
     * the passed shoppingList.
     *
     * @param productId the id of the {@link Product} to link.
     * @param shoppingListId the id of the {@link ShoppingList}.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void shareProductToList(Integer productId, Integer shoppingListId) throws DAOException;

    /**
     * Removes the link between the passed {@link Product} and the passed
     * {@link User}.
     *
     * @param productId the id of the {@link Product} to remove from the link.
     * @param userId the id of {@link User} to remove from the link.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void removeLinkWithUser(Integer productId, Integer userId) throws DAOException;

    /**
     * Link the reserved product of the passed shoppingList {@link ShoppingList}
     * to the passed {@link User}.
     *
     * @param shoppingListId the id of the {@link ShoppingList} to share with the user.
     * @param userId the id of {@link User}.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void shareProductFromList(Integer shoppingListId, Integer userId) throws DAOException;

}
