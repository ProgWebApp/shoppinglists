package db.daos;

import db.exceptions.DAOException;
import db.exceptions.DAOFactoryException;
import java.util.List;

/**
 * The basic DAO interface that all DAOs must implement.
 *
 * @param <ENTITY_CLASS> the class of the entity to handle.
 * @param <PRIMARY_KEY_CLASS> the class of the primary key of the entity the DAO
 * handle.
 */
public interface DAO<ENTITY_CLASS, PRIMARY_KEY_CLASS> {

    /**
     * Persists the new {@code ENTITY_CLASS} passed as parameter to the storage
     * system.
     *
     * @param entity the new {@code entity} to persist.
     * @return the id of the new persisted record.
     * @throws DAOException if an error occurred during the persist action.
     */
    public Integer insert(ENTITY_CLASS entity) throws DAOException;

    /**
     * Persists the alredy existing {@code ENTITY_CLASS} passed as parameter to
     * the storage system.
     *
     * @param entity the {@code entity} to persist.
     * @throws DAOException if an error occurred during the persist action.
     */
    public void update(ENTITY_CLASS entity) throws DAOException;

    /**
     * Delete the alredy existing {@code ENTITY_CLASS} passed as parameter from
     * the storage system.
     *
     * @param primaryKey the primaryKey of the {@code entity} to delete.
     * @throws DAOException if an error occurred during the delting action.
     */
    public void delete(PRIMARY_KEY_CLASS primaryKey) throws DAOException;

    /**
     * Returns the number of records of {@code ENTITY_CLASS} stored on the
     * persistence system of the application.
     *
     * @return the number of records present into the storage system.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public Long getCount() throws DAOException;

    /**
     * Returns the {@code ENTITY_CLASS} instance of the storage system record
     * with the primary key equals to the one passed as parameter.
     *
     * @param primaryKey the primary key used to obtain the entity instance.
     * @return the {@code ENTITY_CLASS} instance of the storage system record
     * with the primary key equals to the one passed as parameter.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public ENTITY_CLASS getByPrimaryKey(PRIMARY_KEY_CLASS primaryKey) throws DAOException;

    /**
     * Returns the list of all the valid entities of type {@code ENTITY_CLASS}
     * stored by the storage system.
     *
     * @return the list of all the valid entities of type {@code ENTITY_CLASS}.
     * @throws DAOException if an error occurred during the information
     * retrieving.
     */
    public List<ENTITY_CLASS> getAll() throws DAOException;

    /**
     * If this DAO can interact with it, then returns the DAO of class passed as
     * parameter.
     *
     * @param <DAO_CLASS> the class name of the DAO that can interact with this
     * DAO.
     * @param daoClass the class of the DAO that can interact with this DAO.
     * @return the instance of the DAO or null if no DAO of the type passed as
     * parameter can interact with this DAO.
     * @throws DAOFactoryException if an error occurred.
     */
    public <DAO_CLASS extends DAO> DAO_CLASS getDAO(Class<DAO_CLASS> daoClass) throws DAOFactoryException;
}
