package db.daos.jdbc;

import db.daos.ProductDAO;
import db.entities.Product;
import db.exceptions.DAOException;
import db.exceptions.UniqueConstraintException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.List;
import java.util.logging.Level;
import java.util.logging.Logger;

/**
 * The JDBC implementation of the {@link ProductDAO} interface.
 */
public class JDBCProductDAO extends JDBCDAO<Product, Integer> implements ProductDAO {

    /**
     * The default constructor of the class.
     *
     * @param con the connection to the persistence system.
     */
    public JDBCProductDAO(Connection con) {
        super(con);
    }

    /**
     * Persists the new {@code Product} passed as parameter to the storage
     * system.
     *
     * @param product the new {@code product} to persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public Integer insert(Product product) throws DAOException {
        if (product == null) {
            throw new DAOException("product is not valid", new NullPointerException("product is null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO products (name, notes, logo, photo, product_category, owner, reserved) VALUES (?,?,?,?,?,?,?)", Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getNotes());
            ps.setString(3, product.getLogoPath());
            ps.setString(4, product.getPhotoPath().toString());
            ps.setInt(5, product.getProductCategoryId());
            ps.setInt(6, product.getOwnerId());
            ps.setBoolean(7, product.isReserved());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                product.setId(rs.getInt(1));
            }

            return product.getId();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to insert the new product", ex);
        }
    }

    /**
     * Persists the alredy existing {@code Product} passed as parameter to the
     * storage system.
     *
     * @param product the {@code product} to persist.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public void update(Product product) throws DAOException {
        if (product == null) {
            throw new DAOException("product is not valid", new NullPointerException("product is null"));
        }

        Integer productId = product.getId();
        if (productId == null) {
            throw new DAOException("product is not valid", new NullPointerException("product id is null"));
        }

        try (PreparedStatement ps = CON.prepareStatement("UPDATE products SET name = ?, notes = ?, logo = ?, photo = ?, product_category = ?, owner = ?, reserved = ? WHERE id = ?")) {

            ps.setString(1, product.getName());
            ps.setString(2, product.getNotes());
            ps.setString(3, product.getLogoPath());
            ps.setString(4, product.getPhotoPath().toString());
            ps.setInt(5, product.getProductCategoryId());
            ps.setInt(6, product.getOwnerId());
            ps.setBoolean(7, product.isReserved());
            ps.setInt(8, product.getId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            throw new DAOException("Impossible to update the product", ex);
        }
    }

    /**
     * Delete the alredy existing {@code Product} passed as parameter from the
     * storage system.
     *
     * @param primaryKey the primaryKey of the {@code product} to delete.
     * @throws DAOException if an error occurred during the delting action.
     */
    @Override
    public void delete(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM products WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete the product", ex);
        }
    }

    /**
     * Returns the number of {@link Product product} stored on the persistence
     * system of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public Long getCount() throws DAOException {
        try (Statement stmt = CON.createStatement()) {
            ResultSet counter = stmt.executeQuery("SELECT COUNT(*) FROM products");
            if (counter.next()) {
                return counter.getLong(1);
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to count products", ex);
        }

        return 0L;
    }

    /**
     * Returns the {@link Product product} with the primary key equals to the
     * one passed as parameter.
     *
     * @param primaryKey the {@code id} of the {@code product} to get.
     * @return the {@code product} with the id equals to the one passed as
     * parameter.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public Product getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM products WHERE id = ?")) {
            stm.setInt(1, primaryKey);

            ResultSet rs = stm.executeQuery();
            rs.next();
            return setAllProductFields(rs);

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the product for the passed primary key", ex);
        }
    }

    /**
     * Returns the list of all the valid {@link Product product} stored by the
     * storage system.
     *
     * @return the list of all the valid {@code product}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public List<Product> getAll() throws DAOException {
        try (Statement stm = CON.createStatement()) {

            List<Product> products = new ArrayList<>();
            ResultSet rs = stm.executeQuery("SELECT * FROM products ORDER BY name");

            while (rs.next()) {
                products.add(setAllProductFields(rs));
            }

            return products;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products", ex);
        }
    }

    @Override
    public List<Product> getPublic(Integer order) throws DAOException {
        try (Statement stm = CON.createStatement()) {

            List<Product> products = new ArrayList<>();
            ResultSet rs = null;
            if (order == null) {
                rs = stm.executeQuery("SELECT * FROM products WHERE reserved=false ORDER BY name ASC");
            } else {
                switch (order) {
                    case 1:
                        rs = stm.executeQuery("SELECT * FROM products WHERE reserved=false ORDER BY name ASC");
                        break;
                    case 2:
                        rs = stm.executeQuery("SELECT * FROM products WHERE reserved=false ORDER BY name DESC");
                        break;
                    case 3:
                        rs = stm.executeQuery("SELECT * FROM products, product_categories WHERE reserved=false AND products.product_category=product_categories.id ORDER BY product_categories.name ASC");
                        break;
                    case 4:
                        rs = stm.executeQuery("SELECT * FROM products, product_categories WHERE reserved=false AND products.product_category=product_categories.id ORDER BY product_categories.name DESC");
                        break;
                }
            }
            while (rs.next()) {
                products.add(setAllProductFields(rs));
            }

            return products;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of public products", ex);
        }
    }

    @Override
    public List<Product> getByUser(Integer userId, Integer order) throws DAOException {
        if (userId == null) {
            throw new DAOException("userId is a mandatory field", new NullPointerException("userId is null"));
        }
        try {
            PreparedStatement stm = null;
            if (order == null) {
                stm = CON.prepareStatement("SELECT * FROM products WHERE reserved=true AND owner = ? ORDER BY name ASC");
            } else {
                switch (order) {
                    case 1:
                        stm = CON.prepareStatement("SELECT * FROM products WHERE reserved=true AND owner = ? ORDER BY name ASC");
                        break;
                    case 2:
                        stm = CON.prepareStatement("SELECT * FROM products WHERE reserved=true AND owner = ? ORDER BY name DESC");
                        break;
                    case 3:
                        stm = CON.prepareStatement("SELECT * FROM products, product_categories WHERE reserved=true AND owner = ? AND products.product_category=product_categories.id ORDER BY product_categories.name ASC");
                        break;
                    case 4:
                        stm = CON.prepareStatement("SELECT * FROM products, product_categories WHERE reserved=true AND owner = ? AND products.product_category=product_categories.id ORDER BY product_categories.name DESC");
                        break;
                }
            }
            List<Product> products = new ArrayList<>();
            stm.setInt(1, userId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                products.add(setAllProductFields(rs));
            }
            return products;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products for the passed userId", ex);
        }
    }

    @Override
    public List<Product> getByShoppingListCategory(Integer shoppingListCategoryId, Integer userId, Integer order) throws DAOException {
        if (shoppingListCategoryId == null || userId == null) {
            throw new DAOException("shoppingListCategoryId and userId are mandatory fields", new NullPointerException("shoppingListCategoryId or userId is null"));
        }
        try {
            PreparedStatement stm = null;
            if (order == null) {
                stm = CON.prepareStatement("SELECT * FROM products, users_products, PC_LC"
                        + " WHERE products.product_category = PC_LC.product_category"
                        + " AND PC_LC.list_category = ?"
                        + " AND (products.reserved = false"
                        + " OR (products.id = users_products.product"
                        + " AND users_product.user_id = ?)) ORDER BY products.name ASC");
            } else {
                switch (order) {
                    case 1:
                        stm = CON.prepareStatement("SELECT * FROM products, users_products, PC_LC"
                                + " WHERE products.product_category = PC_LC.product_category"
                                + " AND PC_LC.list_category = ?"
                                + " AND (products.reserved = false"
                                + " OR (products.id = users_products.product"
                                + " AND users_product.user_id = ?)) ORDER BY products.name ASC");
                        break;
                    case 2:
                        stm = CON.prepareStatement("SELECT * FROM products, users_products, PC_LC"
                                + " WHERE products.product_category = PC_LC.product_category"
                                + " AND PC_LC.list_category = ?"
                                + " AND (products.reserved = false"
                                + " OR (products.id = users_products.product"
                                + " AND users_product.user_id = ?)) ORDER BY products.name DESC");
                        break;
                    case 3:
                        stm = CON.prepareStatement("SELECT * FROM products, users_products, PC_LC, product_categories"
                                + " WHERE products.product_category = PC_LC.product_category"
                                + " AND PC_LC.list_category = ?"
                                + " AND products.product_category=product_categories.id"
                                + " AND (products.reserved = false"
                                + " OR (products.id = users_products.product"
                                + " AND users_product.user_id = ?)) ORDER BY product_categories.name ASC");
                        break;
                    case 4:
                        stm = CON.prepareStatement("SELECT * FROM products, users_products, PC_LC, product_categories"
                                + " WHERE products.product_category = PC_LC.product_category"
                                + " AND PC_LC.list_category = ?"
                                + " AND products.product_category=product_categories.id"
                                + " AND (products.reserved = false"
                                + " OR (products.id = users_products.product"
                                + " AND users_product.user_id = ?)) ORDER BY product_categories.name DESC");
                        break;
                }
            }
            List<Product> products = new ArrayList<>();
            stm.setInt(1, shoppingListCategoryId);
            stm.setInt(2, userId);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                products.add(setAllProductFields(rs));
            }
            return products;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products for the passed shoppingListCategoryId and userId", ex);
        }
    }

    @Override
    public List<Product> getByProductCategory(Integer productCategoryId, Integer userId, Integer order) throws DAOException {
        if (productCategoryId == null) {
            throw new DAOException("productCategoryId is a mandatory fields", new NullPointerException("productCategoryId is null"));
        }
        PreparedStatement stm = null;
        try {
            if (userId == null) {
                if (order == null) {
                    stm = CON.prepareStatement("SELECT * FROM products"
                            + " WHERE products.product_category = ?"
                            + " AND products.reserved = false"
                            + " ORDER BY products.name ASC");
                } else {
                    switch (order) {
                        case 1:
                            stm = CON.prepareStatement("SELECT * FROM products"
                                    + " WHERE products.product_category = ?"
                                    + " AND products.reserved = false"
                                    + " ORDER BY products.name ASC");
                            break;
                        case 2:
                            stm = CON.prepareStatement("SELECT * FROM products"
                                    + " WHERE products.product_category = ?"
                                    + " AND products.reserved = false"
                                    + " ORDER BY products.name DESC");
                            break;
                    }
                }
                stm.setInt(1, productCategoryId);
            } else {
                if (order == null) {
                    stm = CON.prepareStatement("SELECT id, name, notes, logo, photo, owner, reserved, product_category FROM products LEFT JOIN users_products "
                            + " ON products.id = users_products.product"
                            + " WHERE products.product_category = ?"
                            + " AND (products.reserved = false"
                            + " OR users_products.user_id = ?)"
                            + " ORDER BY products.name ASC");
                } else {
                    switch (order) {
                        case 1:
                            stm = CON.prepareStatement("SELECT id, name, notes, logo, photo, owner, reserved, product_category FROM products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE products.product_category = ?"
                                    + " AND (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " ORDER BY products.name ASC");
                            break;
                        case 2:
                            stm = CON.prepareStatement("SELECT id, name, notes, logo, photo, owner, reserved, product_category FROM products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE products.product_category = ?"
                                    + " AND (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " ORDER BY products.name DESC");
                            break;
                    }
                }
                stm.setInt(1, productCategoryId);
                stm.setInt(2, userId);
            }
            List<Product> products = new ArrayList<>();
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                products.add(setAllProductFields(rs));
            }
            return products;
        } catch (SQLException ex) {
            System.out.println("SQLException " + ex.getMessage());
            throw new DAOException("Impossible to get the list of products for the passed productCategoryId and userId", ex);
        }
    }

    @Override
    public List<Product> searchByName(String query, Integer userId, Integer order) throws DAOException {
        if (query == null) {
            throw new DAOException("query is a mandatory field", new NullPointerException("query is null"));
        }
        PreparedStatement stm = null;
        try {
            if (userId == null) {
                if (order == null) {
                    stm = CON.prepareStatement("SELECT * FROM products  "
                            + " WHERE products.reserved = false"
                            + " AND LOWER(products.name) LIKE LOWER(?)"
                            + " ORDER BY products.name ASC");
                } else {
                    switch (order) {
                        case 1:
                            stm = CON.prepareStatement("SELECT * FROM products  "
                                    + " WHERE products.reserved = false"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name ASC");
                            break;
                        case 2:
                            stm = CON.prepareStatement("SELECT * FROM products  "
                                    + " WHERE products.reserved = false"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name DESC");
                            break;
                        case 3:
                            stm = CON.prepareStatement("SELECT * FROM products, product_categories  "
                                    + " WHERE products.reserved = false"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name ASC");
                            break;
                        case 4:
                            stm = CON.prepareStatement("SELECT * FROM products, product_categories  "
                                    + " WHERE products.reserved = false"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name DESC");
                            break;
                    }
                }
                stm.setString(1, "%" + query + "%");
            } else {
                if (order == null) {
                    stm = CON.prepareStatement("SELECT * FROM products LEFT JOIN users_products "
                            + " ON products.id = users_products.product"
                            + " WHERE (products.reserved = false"
                            + " OR users_products.user_id = ?)"
                            + " AND LOWER(products.name) LIKE LOWER(?)"
                            + " ORDER BY products.name ASC");
                } else {
                    switch (order) {
                        case 1:
                            stm = CON.prepareStatement("SELECT * FROM products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name ASC");
                            break;
                        case 2:
                            stm = CON.prepareStatement("SELECT * FROM products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name DESC");
                            break;
                        case 3:
                            stm = CON.prepareStatement("SELECT * FROM product_categories, products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name ASC");
                            break;
                        case 4:
                            stm = CON.prepareStatement("SELECT * FROM product_categories, products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name DESC");
                            break;
                    }
                }
                stm.setInt(1, userId);
                stm.setString(2, "%" + query + "%");
            }
            List<Product> products = new ArrayList<>();
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                products.add(setAllProductFields(rs));
            }
            return products;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products for the passed query and userId", ex);
        }
    }

    @Override
    public List<Product> searchByNameAndCategory(String query, Integer shoppingListCategoryId, Integer userId, Integer order) throws DAOException {
        if (shoppingListCategoryId == null) {
            throw new DAOException("shoppingListCategoryId and userId are mandatory fields", new NullPointerException("shoppingListCategoryId or userId is null"));
        }
        PreparedStatement stm = null;
        try {
            if (userId == null) {
                if (order == null) {
                    stm = CON.prepareStatement("SELECT * FROM PC_LC, products"
                            + " WHERE products.product_category = PC_LC.product_category"
                            + " AND PC_LC.list_category = ?"
                            + " AND products.reserved = false"
                            + " AND LOWER(products.name) LIKE LOWER(?)"
                            + " ORDER BY products.name ASC");
                } else {
                    switch (order) {
                        case 1:
                            stm = CON.prepareStatement("SELECT * FROM PC_LC, products"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND products.reserved = false"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name ASC");
                            break;
                        case 2:
                            stm = CON.prepareStatement("SELECT * FROM PC_LC, products"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND products.reserved = false"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name DESC");
                            break;
                        case 3:
                            stm = CON.prepareStatement("SELECT * FROM PC_LC, products, product_categories"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND products.reserved = false"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name ASC");
                            break;
                        case 4:
                            stm = CON.prepareStatement("SELECT * FROM PC_LC, products, product_categories"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND products.reserved = false"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name DESC");
                            break;
                    }
                }
                stm.setInt(1, shoppingListCategoryId);
                stm.setString(2, "%" + query + "%");
            } else {
                if (order == null) {
                    stm = CON.prepareStatement("SELECT * FROM PC_LC, products LEFT JOIN users_products "
                            + " ON products.id = users_products.product"
                            + " WHERE products.product_category = PC_LC.product_category"
                            + " AND PC_LC.list_category = ?"
                            + " AND (products.reserved = false"
                            + " OR users_products.user_id = ?)"
                            + " AND LOWER(products.name) LIKE LOWER(?)"
                            + " ORDER BY products.name ASC");
                } else {
                    switch (order) {
                        case 1:
                            stm = CON.prepareStatement("SELECT * FROM PC_LC, products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name ASC");
                            break;
                        case 2:
                            stm = CON.prepareStatement("SELECT * FROM PC_LC, products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY products.name DESC");
                            break;
                        case 3:
                            stm = CON.prepareStatement("SELECT * FROM product_categories, PC_LC, products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name ASC");
                            break;
                        case 4:
                            stm = CON.prepareStatement("SELECT * FROM product_categories, PC_LC, products LEFT JOIN users_products "
                                    + " ON products.id = users_products.product"
                                    + " WHERE products.product_category = PC_LC.product_category"
                                    + " AND products.product_category = product_categories.id"
                                    + " AND PC_LC.list_category = ?"
                                    + " AND (products.reserved = false"
                                    + " OR users_products.user_id = ?)"
                                    + " AND LOWER(products.name) LIKE LOWER(?)"
                                    + " ORDER BY product_categories.name DESC");
                            break;
                    }
                }
                stm.setInt(1, shoppingListCategoryId);
                stm.setInt(2, userId);
                stm.setString(3, "%" + query + "%");
            }

            List<Product> products = new ArrayList<>();
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                products.add(setAllProductFields(rs));
            }
            return products;
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of products for the passed query, shoppingListCategoryId and userId", ex);
        }
    }

    @Override
    public Product getIfVisible(Integer productId, Integer userId) throws DAOException {
        if (productId == null || userId == null) {
            throw new DAOException("productId and userId are mandatory fields", new NullPointerException("productId or userId is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM products LEFT JOIN users_products "
                + " ON products.id = users_products.product"
                + " WHERE products.id = ?"
                + " AND (products.reserved = false"
                + " OR users_products.user_id = ?)")) {

            stm.setInt(1, productId);
            stm.setInt(2, userId);

            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return setAllProductFields(rs);
            } else {
                return null;
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the product for the passed id and userId", ex);
        }
    }

    @Override
    public void addLinkWithUser(Integer productId, Integer userId) throws DAOException {
        if ((productId == null) || (userId == null)) {
            throw new DAOException("productId and userId are mandatory fields", new NullPointerException("productId or userId are null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO users_products (user_id, product) VALUES (?, ?)")) {

            ps.setInt(1, userId);
            ps.setInt(2, productId);

            ps.executeUpdate();

        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to link the passed product with the passed user", new UniqueConstraintException("This link already exist in the system"));
            }
            throw new DAOException("Impossible to link the passed product with the passed user", ex);
        }
    }

    @Override
    public void shareProductToList(Integer productId, Integer shoppingListId) throws DAOException {
        if ((productId == null) || (shoppingListId == null)) {
            throw new DAOException("productId and shoppingListId are mandatory fields", new NullPointerException("productId or shoppingListId are null"));
        }
        try (PreparedStatement ps1 = CON.prepareStatement("SELECT user_id FROM users_lists WHERE list = ?");
                PreparedStatement ps2 = CON.prepareStatement("INSERT INTO users_products (user_id, product) VALUES (?,?) ON CONFLICT (user_id, product) DO NOTHING")) {

            ps1.setInt(1, shoppingListId);
            
            ResultSet rs = ps1.executeQuery();
            while (rs.next()) {
                System.out.println(rs.isLast());
                System.out.println(rs.getInt("user_id"));
                ps2.setInt(1, rs.getInt("user_id"));
                ps2.setInt(2, productId);
                ps2.executeUpdate();
            }
        } catch (SQLException ex) {
            //if (!ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to get the list of users for the passed shoppingList", ex);
            //}
        }
    }

    @Override
    public void removeLinkWithUser(Integer productId, Integer userId) throws DAOException {
        if ((productId == null) || (userId == null)) {
            throw new DAOException("productId and userId are mandatory fields", new NullPointerException("productId or userId are null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM users_products WHERE (user_id = ? AND product = ?)")) {
            stm.setInt(1, userId);
            stm.setInt(2, productId);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete the link between the passed product and the passed user", ex);
        }
    }

    /**
     * Convinience method for setting all the fileds of a {@code product} after
     * retriving it from the storage system.
     *
     * @param rs the {@link ResultSet} of the query that retrives the
     * {@code product}
     * @return the new {@code product}
     * @throws SQLException if an error occurred during the information
     * retriving
     */
    public static Product setAllProductFields(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setNotes(rs.getString("notes"));
        product.setLogoPath(rs.getString("logo"));
        String[] paths = rs.getString("photo").replace("[", "").replace("]", "").split(", ");
        if (paths[0].equals("")) {
            product.setPhotoPath(new HashSet<>());
        } else {
            product.setPhotoPath(new HashSet<>(Arrays.asList(paths)));
        }
        product.setProductCategoryId(rs.getInt("product_category"));
        product.setOwnerId(rs.getInt("owner"));
        product.setReserved(rs.getBoolean("reserved"));

        return product;
    }

    /**
     * Link the reserved product of the passed shoppingList {@code shoppingList}
     * to the passed {@code user}.
     *
     * @param shoppingListId the id of the list to share with the user.
     * @param userId the id of user.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public void shareProductFromList(Integer shoppingListId, Integer userId) throws DAOException {
        if ((shoppingListId == null) || (userId == null)) {
            throw new DAOException("shoppingListId and userId are mandatory fields", new NullPointerException("productId or userId are null"));
        }
        try (PreparedStatement stm1 = CON.prepareStatement("SELECT product FROM list_products, products WHERE product=id AND list = ? AND reserved=true");
                PreparedStatement stm2 = CON.prepareStatement("INSERT INTO users_products (user_id, product) VALUES (?,?) ON CONFLICT (user_id, product) DO NOTHING")) {
            stm1.setInt(1, shoppingListId);
            ResultSet rs = stm1.executeQuery();
            while (rs.next()) {
                try {
                    stm2.setInt(1, userId);
                    stm2.setInt(2, rs.getInt("product"));
                    stm2.executeUpdate();
                } catch (SQLException ex) {
                    if (!ex.getSQLState().equals("23505")) {
                        throw new DAOException("Impossible to link the product with the user", ex);
                    }
                }
            }
        } catch (SQLException ex) {
            throw new DAOException("Impossible to get list of products ", ex);
        }
    }

}
