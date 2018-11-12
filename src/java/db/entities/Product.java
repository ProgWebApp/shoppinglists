package db.entities;

import java.util.HashSet;

/**
 * The entity that describe a {@code product}.
 */
public class Product {

    private Integer id;
    private String name;
    private String notes;
    private String logoPath;
    private HashSet<String> photoPath;
    private Integer productCategoryId;
    private Integer ownerId;
    private boolean reserved;
    private Integer necessary;

    /**
     * Returns the primary key of this product.
     * @return the id of the product.
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the new primary key of this product.
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
    public HashSet<String> getPhotoPath() {
        return photoPath;
    }

    /**
     * Sets the photo path of this product.
     *
     * @param photoPath the photo paths of this product.
     */
    public void setPhotoPath(HashSet<String> photoPath) {
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

    /**
     * Returns the value of the property reserved of this product.
     *
     * @return the value of the property reserved of this product
     */
    public boolean isReserved() {
        return reserved;
    }

    /**
     * Sets the new value for the property reserved of this product.
     *
     * @param reserved the new value of the property reserved of this product.
     */
    public void setReserved(boolean reserved) {
        this.reserved = reserved;
    }
    
    /**
     * Returns the necessary of this product.
     * @return the necessary of the product.
     */
    public Integer getNecessary() {
        return necessary;
    }

    /**
     * Sets the new necessary of this product.
     * @param necessary the new necessary of this product.
     */
    public void setNecessary(Integer necessary) {
        this.necessary = necessary;
    }
    
    public String toJson(){
        String json = "{\"id\": "+id+", \"text\": \""+name+"\"}";
        return json;
    }
    
    @Override
    public boolean equals(Object o) {
        if (o == this) return true;
        if (!(o instanceof Product)) {
            return false;
        }
        Product product = (Product) o;
        return product.id.equals(this.id);
    }

    @Override
    public int hashCode() {
        return id;
    }
}
