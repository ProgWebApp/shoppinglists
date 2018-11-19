package db.entities;

/**
 * The entity that describe a {@code shoppingList-category}.
 */
public class ShoppingListCategory {
    private Integer id;
    private String name;
    private String description;
    private String logoPath;
    private String shop;

    /**
     * The primary key of this shoppingList-category.
     * @return the id
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the primary key of this shoppingList-category.
     * @param id the id to set
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Returns the name of this shoppingList-category.
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the name of this shoppingList-category.
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Returns the description of this shoppingList-category.
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the description of this shoppingList-category.
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Returns the logo path of this shoppingList-category.
     * @return the logoPath
     */
    public String getLogoPath() {
        return logoPath;
    }

    /**
     * Sets the logo path of this shoppingList-category.
     * @param logoPath the logoPath to set
     */
    public void setLogoPath(String logoPath) {
        this.logoPath = logoPath;
    }
    
    /**
     * The shop of this shoppingList-category.
     * @return the shop
     */
    public String getShop() {
        return shop;
    }

    /**
     * Sets the shop of this shoppingList-category.
     * @param shop the shop to set
     */
    public void setShop(String shop) {
        this.shop = shop;
    }
}