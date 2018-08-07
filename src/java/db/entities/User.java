package db.entities;

/**
 * The entity that describe a {@code user}.
 */
public class User {

    private Integer id;
    private String firstName;
    private String lastName;
    private String email;
    private String password;
    private String avatarPath;
    private boolean admin;

    private Integer shoppingListsCount;

    /**
     * Returns the primary key of this user entity.
     *
     * @return the id of the user entity.
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the new primary key of this user entity.
     *
     * @param id the new id of this user entity.
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Returns the first name of this user entity.
     *
     * @return the first name of this user entity.
     */
    public String getFirstName() {
        return firstName;
    }

    /**
     * Sets the new first name of this user entity.
     *
     * @param firstName the new first name of this user entity.
     */
    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    /**
     * Returns the last name of this user entity.
     *
     * @return the last name of this user entity.
     */
    public String getLastName() {
        return lastName;
    }

    /**
     * Sets the new last name of this user entity.
     *
     * @param lastName the new last name of this user entity.
     */
    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    /**
     * Returns the unique email of this user entity.
     *
     * @return the email of this user entity.
     */
    public String getEmail() {
        return email;
    }

    /**
     * Sets the new email of this user entity.
     *
     * @param email the new email of this user entity.
     */
    public void setEmail(String email) {
        this.email = email;
    }

    /**
     * Returns the password of this user entity.
     *
     * @return the password of this user entity.
     */
    public String getPassword() {
        return password;
    }

    /**
     * Sets the new password of this user entity.
     *
     * @param password the new password of this user entity.
     */
    public void setPassword(String password) {
        this.password = password;
    }

    /**
     * Returns the avatar path of this user.
     *
     * @return the avatar path of this user.
     */
    public String getAvatarPath() {
        return avatarPath;
    }

    /**
     * Sets the avatar path of this user.
     *
     * @param avatarPath the avatar path of this user.
     */
    public void setAvatarPath(String avatarPath) {
        this.avatarPath = avatarPath;
    }

    /**
     * Ruturn the value of the property admin of this user entity.
     *
     * @return the admin of the property admin of this user entity.
     */
    public boolean isAdmin() {
        return admin;
    }

    /**
     * Sets of the new value of the property admin of this user entity.
     *
     * @param admin the new value of the property admin of this user entity.
     */
    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    /**
     * Returns the number of shopping-lists shared with this user entity.
     *
     * @return the number of shopping-lists shared with this user entity.
     */
    public Integer getShoppingListsCount() {
        return shoppingListsCount;
    }

    /**
     * Sets the new amount of shopping-lists shared with this user entity.
     *
     * @param shoppingListsCount the new amount of shopping-lists shared with
     * this user entity.
     */
    public void setShoppingListsCount(Integer shoppingListsCount) {
        this.shoppingListsCount = shoppingListsCount;
    }

}
