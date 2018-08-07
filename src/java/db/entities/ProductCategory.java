package db.entities;

/**
 * The entity that describe a {@code product-category}.
 */
public class ProductCategory {
    private Integer id;
    private String name;
    private String description;
    private String logoPath;

    /**
     * The primary key of this product-category.
     * @return the id
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the primary key of this product-category.
     * @param id the id to set
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Returns the name of this product-category.
     * @return the name
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the name of this product-category.
     * @param name the name to set
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Returns the description of this product-category.
     * @return the description
     */
    public String getDescription() {
        return description;
    }

    /**
     * Sets the description of this product-category.
     * @param description the description to set
     */
    public void setDescription(String description) {
        this.description = description;
    }

    /**
     * Returns the logo path of this product-category.
     * @return the logoPath
     */
    public String getLogoPath() {
        return logoPath;
    }

    /**
     * Sets the logo path of this product-category.
     * @param logoPath the logoPath to set
     */
    public void setLogoPath(String logoPath) {
        this.logoPath = logoPath;
    }
    
}
