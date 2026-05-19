package model;

public class User {
    protected String email;
    protected String name;
    protected String phone;
    protected String location;
    protected String photoPath;

    public User(String email, String name, String phone, String location, String photoPath) {
        this.email = email;
        this.name = name;
        this.phone = phone;
        this.location = location;
        this.photoPath = photoPath;
    }

    public String getEmail() { return email; }
    public String getName() { return name; }
    public String getPhone() { return phone; }
    public String getLocation() { return location; }
    public String getPhotoPath() { return photoPath; }

    public void setName(String name) { this.name = name; }
    public void setPhone(String phone) { this.phone = phone; }
    public void setLocation(String location) { this.location = location; }
    public void setPhotoPath(String photoPath) { this.photoPath = photoPath; }

    public String displayRole() {
        return "System User";
    }
}
