package db.entities;

/**
 * The entity that describe a {@code product}.
 */
public class Product {

    private Integer id;
    private String name;
    private String notes;
    private String logoPath;
    private String photoPath;
    private Integer productCategoryId;
    private Integer ownerId;    //set to null if the product is created by an administrator

    /**
     * Returns the primary key of this product.
     *
     * @return the id of the product.
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the new primary key of this product.
     *
     * @param id the new id of this product.
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Returns the name of this product.
     *
     * @return the name of this producty.
     */
    public String getName() {
        return name;
    }

    /**
     * Sets the new name of this product.
     *
     * @param name the new name of this product.
     */
    public void setName(String name) {
        this.name = name;
    }

    /**
     * Returns the notes of this product.
     *
     * @return the notes of this product.
     */
    public String getNotes() {
        return notes;
    }

    /**
     * Sets the new notes of this product.
     *
     * @param notes the new description of this product.
     */
    public void setNotes(String notes) {
        this.notes = notes;
    }

    /**
     * Returns the logo path of this product.
     *
     * @return the logo path of this product.
     */
    public String getLogoPath() {
        return logoPath;
    }

    /**
     * Sets the logo path of this product.
     *
     * @param logoPath the logo path of this product.
     */
    public void setLogoPath(String logoPath) {
        this.logoPath = logoPath;
    }

    /**
     * Returns the photo path of this product.
     *
     * @return the photo path of this product.
     */
    public String getPhotoPath() {
        return photoPath;
    }

    /**
     * Sets the photo path of this product.
     *
     * @param photoPath the photo path of this product.
     */
    public void setPhotoPath(String photoPath) {
        this.photoPath = photoPath;
    }

    /**
     * Returns the id of the product_category of this product.
     *
     * @return the id of the product_category of this product.
     */
    public Integer getProductCategoryId() {
        return productCategoryId;
    }

    /**
     * Sets the id of the product_category of this product.
     * 
     * @param productCategoryId the id of the product_category of this product.
     */
    public void setProductCategoryId(Integer productCategoryId) {
        this.productCategoryId = productCategoryId;
    }

    /**
     * Returns the id of the owner of this product.
     *
     * @return the id of the owner of this product.
     */
    public Integer getOwnerId() {
        return ownerId;
    }

    /**
     * Sets the id of the owner of this product.
     * 
     * @param ownerId the id of the owner of this product.
     */
    public void setOwnerId(Integer ownerId) {
        this.ownerId = ownerId;
    }

}
