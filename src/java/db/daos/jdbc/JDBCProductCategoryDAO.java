package db.daos.jdbc;

import db.daos.ProductCategoryDAO;
import db.entities.ProductCategory;
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

public class JDBCProductCategoryDAO extends JDBCDAO<ProductCategory, Integer> implements ProductCategoryDAO {

    /**
     * The default constructor of the class.
     *
     * @param con the connection to the persistence system.
     */
    public JDBCProductCategoryDAO(Connection con) {
        super(con);
    }

    /**
     * Persists the new {@code ProductCategory} passed as parameter to the
     * storage system.
     *
     * @param productCategory the new {@code productCategory} to persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public Integer insert(ProductCategory productCategory) throws DAOException {
        if (productCategory == null) {
            throw new DAOException("productCategory is not valid", new NullPointerException("productCategory is null"));
        }
        try (PreparedStatement ps = CON.prepareStatement("INSERT INTO product_categories (name, description, logo, icons) VALUES (?,?,?,?)", Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, productCategory.getName());
            ps.setString(2, productCategory.getDescription());
            ps.setString(3, productCategory.getLogoPath());
            ps.setString(4, productCategory.getIconPath().toString());

            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                productCategory.setId(rs.getInt(1));
            }

            return productCategory.getId();
        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to insert the new productCategory", new UniqueConstraintException("A productCategory with this name already exists in the system"));
            }
            throw new DAOException("Impossible to insert the new product", ex);
        }
    }

    /**
     * Persists the alredy existing {@code ProductCategory} passed as parameter
     * to the storage system.
     *
     * @param productCategory the {@code productCategory} to persist.
     * @throws DAOException if an error occurred during the persist action.
     */
    @Override
    public void update(ProductCategory productCategory) throws DAOException {
        if (productCategory == null) {
            throw new DAOException("productCategory is not valid", new NullPointerException("productCategory is null"));
        }

        Integer productCategoryId = productCategory.getId();
        if (productCategoryId == null) {
            throw new DAOException("productCategory is not valid", new NullPointerException("productCategory id is null"));
        }

        try (PreparedStatement ps = CON.prepareStatement("UPDATE product_categories SET name = ?, description = ?, logo = ?, icons = ? WHERE id = ?")) {

            ps.setString(1, productCategory.getName());
            ps.setString(2, productCategory.getDescription());
            ps.setString(3, productCategory.getLogoPath());
            ps.setString(4, productCategory.getIconPath().toString());
            ps.setInt(5, productCategory.getId());

            ps.executeUpdate();

        } catch (SQLException ex) {
            if (ex.getSQLState().equals("23505")) {
                throw new DAOException("Impossible to update the productCategory", new UniqueConstraintException("A productCategory with this name already exists in the system"));
            }
            throw new DAOException("Impossible to update the productCategory", ex);
        }
    }

    /**
     * Delete the alredy existing {@code ProductCategory} passed as parameter
     * from the storage system.
     *
     * @param primaryKey the primaryKey of the {@code productCategory} to
     * delete.
     * @throws DAOException if an error occurred during the delting action.
     */
    @Override
    public void delete(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("DELETE FROM product_categories WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            stm.executeUpdate();
        } catch (SQLException ex) {
            throw new DAOException("Impossible to delete the productCategory", ex);
        }
    }

    /**
     * Returns the number of {@link ProductCategory productCategory} stored on
     * the persistence system of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public Long getCount() throws DAOException {
        try (Statement stmt = CON.createStatement()) {
            ResultSet counter = stmt.executeQuery("SELECT COUNT(*) FROM product_categories");
            if (counter.next()) {
                return counter.getLong(1);
            }

        } catch (SQLException ex) {
            throw new DAOException("Impossible to count productCategory", ex);
        }

        return 0L;
    }

    /**
     * Returns the {@link ProductCategory productCategory} with the primary key
     * equals to the one passed as parameter.
     *
     * @param primaryKey the {@code id} of the {@code productCategory} to get.
     * @return the {@code productCategory} with the id equals to the one passed
     * as parameter.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public ProductCategory getByPrimaryKey(Integer primaryKey) throws DAOException {
        if (primaryKey == null) {
            throw new DAOException("primaryKey is not valid", new NullPointerException("primaryKey is null"));
        }
        try (PreparedStatement stm = CON.prepareStatement("SELECT * FROM product_categories WHERE id = ?")) {
            stm.setInt(1, primaryKey);
            ResultSet rs = stm.executeQuery();

            rs.next();
            return setAllProductCategoryFields(rs);

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the productCategory for the passed primary key", ex);
        }
    }

    /**
     * Returns the list of all the valid {@link ProductCategory productCategory}
     * stored by the storage system.
     *
     * @return the list of all the valid {@code productCategory}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    @Override
    public List<ProductCategory> getAll() throws DAOException {
        try (Statement stm = CON.createStatement()) {

            List<ProductCategory> productCategories = new ArrayList<>();
            ResultSet rs = stm.executeQuery("SELECT * FROM product_categories ORDER BY name");

            while (rs.next()) {
                productCategories.add(setAllProductCategoryFields(rs));
            }

            return productCategories;

        } catch (SQLException ex) {
            throw new DAOException("Impossible to get the list of productCategory", ex);
        }
    }

    /**
     * Convinience method for setting all the fileds of a {@code productCategory} after
     * retriving it from the storage system.
     *
     * @param rs the {@link ResultSet} of the query that retrives the
     * {@code product}
     * @return the new {@code productCategory}
     * @throws SQLException if an error occurred during the information
     * retriving
     */
    private ProductCategory setAllProductCategoryFields(ResultSet rs) throws SQLException {
        ProductCategory productCategory = new ProductCategory();
        productCategory.setId(rs.getInt("id"));
        productCategory.setName(rs.getString("name"));
        productCategory.setDescription(rs.getString("description"));
        productCategory.setLogoPath(rs.getString("logo"));
        String[] paths = rs.getString("icons").replace("[", "").replace("]", "").split(", ");
        if(paths[0].equals("")){
            productCategory.setIconPath(new HashSet<>());
        }else{
            productCategory.setIconPath(new HashSet<>(Arrays.asList(paths)));
        }

        return productCategory;
    }
}
