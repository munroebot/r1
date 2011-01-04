public enum RouterStatusCodes {

    MESSAGE_ENQUEUED_OK  (203,"Message was enqueued successfully."),
    MESSAGE_ENQUEUED_BAD (403,"Message was not enqueued successfully.");
    
    private final int id;
    private final String description; 
    
    RouterStatusCodes(int id, String description) {
        this.id = id;
        this.description = description;
    }
    
    public int id() {
        return id;
    }
    
    public String description() {
        return this.description;
    }
    
    public String toString() {
        return this.description;
    }
}
