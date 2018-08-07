package db.entities;

/**
 * The entity that describe a {@code message}.
 */
public class Message {

    private Integer id;
    private String date;
    private String body;
    private Integer senderId;
    private Integer shoppingListId;

    /**
     * Return the id of the message.
     *
     * @return the id
     */
    public Integer getId() {
        return id;
    }

    /**
     * Sets the id of the message.
     *
     * @param id the id to set
     */
    public void setId(Integer id) {
        this.id = id;
    }

    /**
     * Return the date the message was sent.
     *
     * @return the date
     */
    public String getDate() {
        return date;
    }

    /**
     * Sets the date the message was sent.
     *
     * @param date the date to set
     */
    public void setDate(String date) {
        this.date = date;
    }

    /**
     * Return the body of the message.
     *
     * @return the body
     */
    public String getBody() {
        return body;
    }

    /**
     * Sets the body of the message.
     *
     * @param body the body to set
     */
    public void setBody(String body) {
        this.body = body;
    }

    /**
     * Return the id of the user who sent the message.
     *
     * @return the senderId
     */
    public Integer getSenderId() {
        return senderId;
    }

    /**
     * Sets the id of the user who sent the message.
     *
     * @param senderId the senderId to set
     */
    public void setSenderId(Integer senderId) {
        this.senderId = senderId;
    }

    /**
     * Return the id of the shoppingList to which the message refers.
     *
     * @return the shoppingListId
     */
    public Integer getShoppingListId() {
        return shoppingListId;
    }

    /**
     * Sets the id of the shoppingList to which the message refers.
     *
     * @param shoppingListId the shoppingListId to set
     */
    public void setShoppingListId(Integer shoppingListId) {
        this.shoppingListId = shoppingListId;
    }
}
