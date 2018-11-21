package db.entities;

/**
 * The entity that describe a {@code shopping-list}.
 */
public class ShoppingList {

    private Integer id;
    private String name;
    private String description;
    private String imagePath;
    private Integer listCategoryId;
    private String listCategoryIcon;
    private Integer ownerId;
    private String cookie;
    private Integer notifications;

    /**
     * Returns the primary key of this shopping-list.
     *
     * @return the id of the shopping-list.
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the new primary key of this shopping-list.
     *
     * @param id the new id of this shopping-list.
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Returns the name of this shopping-list.
     *
     * @return the name of this shopping-list.
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the new name of this shopping-list.
     *
     * @param name the new name of this shopping-list.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Returns the description of this shopping-list.
     *
     * @return the description of this shopping-list.
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the new description of this shopping-list.
     *
     * @param description the new description of this shopping-list.
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Returns the logo path of this shopping-list.
     *
     * @return the logo path of this shopping-list.
     */
    public String getImagePath() {
        return imagePath;
    }

    /**
     * Sets the logo path of this shopping-list.
     *
     * @param imagePath the logo path of this shopping-list.
     */
    public void setImagePath(String imagePath) {
        this.imagePath = imagePath;
    }

    /**
     * Returns the id of the list-category of this shopping-list.
     *
     * @return the id of the list-category of this shopping-list.
     */
    public Integer getListCategoryId() {
        return listCategoryId;
    }

    /**
     * Sets the id of the list-category of this shopping-list.
     * 
     * @param listCategoryId the id of the list-category of this shopping-list.
     */
    public void setListCategoryId(Integer listCategoryId) {
        this.listCategoryId = listCategoryId;
    }

    /**
     * Returns the id of the owner of this shopping-list.
     *
     * @return the id of the owner of this shopping-list.
     */
    public Integer getOwnerId() {
        return ownerId;
    }

    /**
     * Sets the id of the owner of this shopping-list.
     * 
     * @param ownerId the id of the owner of this shopping-list.
     */
    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

    /**
     * @return the cookie
     */
    public String getCookie() {
        return cookie;
    }

    /**
     * @param cookie the cookie to set
     */
    public void setCookie(String cookie) {
        this.cookie = cookie;
    }

    /**
     * @return the listCategoryIcon
     */
    public String getListCategoryIcon() {
        return listCategoryIcon;
    }

    /**
     * @param listCategoryIcon the listCategoryIcon to set
     */
    public void setListCategoryIcon(String listCategoryIcon) {
        this.listCategoryIcon = listCategoryIcon;
    }

    /**
     * @return the notifications
     */
    public Integer getNotifications() {
        return notifications;
    }

    /**
     * @param notifications the notifications to set
     */
    public void setNotifications(Integer notifications) {
        this.notifications = notifications;
    }
}
