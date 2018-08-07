package db.daos;

import db.entities.ProductCategory;

/**
 * All concrete DAOs must implement this interface to handle the persistence
 * system that interact with {@link ProductCategory productCategory}.
 */
public interface ProductCategoryDAO extends DAO<ProductCategory, Integer>{
    
}
