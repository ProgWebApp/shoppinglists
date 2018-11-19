package db.daos.jdbc;

import db.daos.ShoppingListCategoryDAO;
import db.entities.ProductCategory;
import db.entities.ShoppingListCategory;
import db.exceptions.DAOException;
import db.exceptions.UniqueConstraintException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

public class JDBCShoppingListCategoryDAO extends JDBCDAO<ShoppingListCategory, Integer> implements ShoppingListCategoryDAO {

    /**
     * The default constructor of the class.
     *
     * @param con the connection to the persistence system.
     */
    public JDBCShoppingListCategoryDAO(Connection con) {
        super(con);
    }

    /**
     * Persists the new {@code ShoppingListCategory} passed as parameter to the
     * storage system.
     *
     * @param shoppingListCategory the new {@code shoppingListCategory} to
     * persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public Integer insert(ShoppingListCategory shoppingListCategory) throws DAOException {
        if (shoppingListCategory == null) {
            throw new DAOException("shoppingListCategory is not valid", new NullPointerException("shoppingListCategory is null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO list_categories (name, description, logo, shop) VALUES (?,?,?,?)", Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, shoppingListCategory.getName());
            ps.setString(2, shoppingListCategory.getDescription());
            ps.setString(3, shoppingListCategory.getLogoPath());
            ps.setString(4, shoppingListCategory.getShop());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                shoppingListCategory.setId(rs.getInt(1));
            }

            return shoppingListCategory.getId();
        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to insert the new shoppingListCategory", new UniqueConstraintException("A shoppingListCategory with this name already exists in the system"));
            }
            throw new DAOException("Impossible to insert the new product", ex);
        }
    }

    /**
     * Persists the alredy existing {@code ShoppingListCategory} passed as
     * parameter to the storage system.
     *
     * @param shoppingListCategory the {@code shoppingListCategory} to persist.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public void update(ShoppingListCategory shoppingListCategory) throws DAOException {
        if (shoppingListCategory == null) {
            throw new DAOException("shoppingListCategory is not valid", new NullPointerException("shoppingListCategory is null"));
        }

        Integer shoppingListCategoryId = shoppingListCategory.getId();
        if (shoppingListCategoryId == null) {
            throw new DAOException("shoppingListCategory is not valid", new NullPointerException("shoppingListCategory id is null"));
        }

        try (PreparedStatement ps = CON.prepareStatement("UPDATE list_categories SET name = ?, description = ?, logo = ?, shop = ? WHERE id = ?")) {

            ps.setString(1, shoppingListCategory.getName());
            ps.setString(2, shoppingListCategory.getDescription());
            ps.setString(3, shoppingListCategory.getLogoPath());
            ps.setString(4, shoppingListCategory.getShop());
            ps.setInt(5, shoppingListCategory.getId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to update the shoppingListCategory", new UniqueConstraintException("A shoppingListCategory with this name already exists in the system"));
            }
            throw new DAOException("Impossible to update the shoppingListCategory", ex);
        }
    }

    /**
     * Delete the alredy existing {@code ShoppingListCategory} passed as
     * parameter from the storage system.
     *
     * @param primaryKey the primaryKey of the {@code shoppingListCategory} to
     * delete.
     * @throws DAOException if an error occurred during the delting action.
     */
    @Override
    public void delete(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM list_categories WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete the shoppingListCategory", ex);
        }
    }

    /**
     * Returns the number of {@link ShoppingListCategory shoppingListCategory}
     * stored on the persistence system of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public Long getCount() throws DAOException {
        try (Statement stmt = CON.createStatement()) {
            ResultSet counter = stmt.executeQuery("SELECT COUNT(*) FROM list_categories");
            if (counter.next()) {
                return counter.getLong(1);
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to count shoppingListCategory", ex);
        }

        return 0L;
    }

    /**
     * Returns the {@link ShoppingListCategory shoppingListCategory} with the
     * primary key equals to the one passed as parameter.
     *
     * @param primaryKey the {@code id} of the {@code shoppingListCategory} to
     * get.
     * @return the {@code shoppingListCategory} with the id equals to the one
     * passed as parameter.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public ShoppingListCategory getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM list_categories WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            ResultSet rs = stm.executeQuery();
            rs.next();
            return setAllShoppingListCategoryFields(rs);
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the shoppingListCategory for the passed primary key", ex);
        }
    }

    /**
     * Returns the list of all the valid
     * {@link ShoppingListCategory shoppingListCategory} stored by the storage
     * system.
     *
     * @return the list of all the valid {@code shoppingListCategory}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public List<ShoppingListCategory> getAll() throws DAOException {
        try (Statement stm = CON.createStatement()) {
            List<ShoppingListCategory> productCategories = new ArrayList<>();
            ResultSet rs = stm.executeQuery("SELECT * FROM list_categories ORDER BY name");
            while (rs.next()) {
                productCategories.add(setAllShoppingListCategoryFields(rs));
            }
            return productCategories;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of shoppingListCategory", ex);
        }
    }

    @Override
    public void addProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException {
        if ((shoppingListCategoryId == null) || (productCategoryId == null)) {
            throw new DAOException("shoppingListCategoryId and productCategoryId are mandatory fields", new NullPointerException("shoppingListCategoryId or productCategoryId are null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO PC_LC (list_category, product_category) VALUES (?,?)", Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, shoppingListCategoryId);
            ps.setInt(2, productCategoryId);
            ps.executeUpdate();
        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to link the passed shoppingListCategory with the passed productCategory", new UniqueConstraintException("This link already exist in the system"));
            }
            throw new DAOException("Impossible to insert the new product", ex);
        }
    }

    @Override
    public void removeProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException {
        if ((shoppingListCategoryId == null) || (productCategoryId == null)) {
            throw new DAOException("shoppingListCategoryId and productCategoryId are mandatory fields", new NullPointerException("shoppingListCategoryId or productCategoryId are null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM PC_LC WHERE (list_category = ? AND product_category = ?)")) {
            stm.setInt(1, shoppingListCategoryId);
            stm.setInt(2, productCategoryId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete the link between the passed shoppingListCategory and the productCategory product", ex);
        }
    }

    @Override
    public List<ProductCategory> getProductCategories(Integer shoppingListCategoryId) throws DAOException{
        if (shoppingListCategoryId == null) {
            throw new DAOException("shoppingListCategoryId is a mandatory fields", new NullPointerException("shoppingListCategoryId is null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("SELECT * FROM PC_LC, product_categories WHERE list_category=? AND product_category=id")) {
            List<ProductCategory> productCategories = new ArrayList<>();
            ps.setInt(1, shoppingListCategoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                productCategories.add(JDBCProductCategoryDAO.setAllProductCategoryFields(rs));
            }
            return productCategories;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of productCategory", ex);
        }
    }

    @Override
    public boolean hasProductCategory(Integer shoppingListCategoryId, Integer productCategoryId) throws DAOException {
        if ((shoppingListCategoryId == null) || (productCategoryId == null)) {
            throw new DAOException("shoppingListCategoryId and productCategoryId are mandatory fields", new NullPointerException("shoppingListCategoryId or productCategoryId are null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("SELECT * FROM PC_LC WHERE list_category=? AND product_category=?")) {
            ps.setInt(1, shoppingListCategoryId);
            ps.setInt(2, productCategoryId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of productCategory", ex);
        }
    }
    
    /**
     * Convinience method for setting all the fileds of a
     * {@code shoppingListCategory} after retriving it from the storage system.
     *
     * @param rs the {@link ResultSet} of the query that retrives the
     * {@code product}
     * @return the new {@code shoppingListCategory}
     * @throws SQLException if an error occurred during the information
     * retriving
     */
    private ShoppingListCategory setAllShoppingListCategoryFields(ResultSet rs) throws SQLException {
        ShoppingListCategory shoppingListCategory = new ShoppingListCategory();
        shoppingListCategory.setId(rs.getInt("id"));
        shoppingListCategory.setName(rs.getString("name"));
        shoppingListCategory.setDescription(rs.getString("description"));
        shoppingListCategory.setLogoPath(rs.getString("logo"));
        shoppingListCategory.setShop(rs.getString("shop"));
        return shoppingListCategory;
    }
    
    /**
     * Returns the list of all the valid shops where the user has to buy something
     * system.
     *
     * @param user the user which we are checking
     * @return the list of all the shops where {@code user} has to buy something
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public List<String> getShopsByUser(Integer userId) throws DAOException {
        if (userId == null) {
            throw new DAOException("userId is a mandatory field", new NullPointerException("userId is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT list_categories.shop FROM list_categories, lists, list_products, users_lists"
                    + " WHERE (list_categories.id=lists.list_category AND lists.id=list_products.list AND list_products.necessary=true AND users_lists.list=lists.id AND users_lists.user_id=?)")) {
            List<String> shops = new ArrayList<>();
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
              shops.add(rs.getString("shop"));
            }
            if(shops.isEmpty()){
                System.out.println("Non sono stati trovati shops da cercare");
            }
            return shops;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of shoppingListCategory", ex);
        }
    }

    @Override
    public String getShopByCookie(String userId) throws DAOException {
        if (userId == null) {
            throw new DAOException("userId is a mandatory field", new NullPointerException("userId is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT list_categories.shop FROM list_categories, lists, list_products"
                    + " WHERE (list_categories.id=lists.list_category AND lists.id=list_products.list AND list_products.necessary=true AND lists.cookie=?)")) {

            stm.setString(1, userId);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return rs.getString("shop");
            }else{
                return null;
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of shoppingListCategory", ex);
        }
    }
}
