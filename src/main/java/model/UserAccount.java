package model;

public class UserAccount {
    private String email;
    private String password;
    private String role;
    private String name;

    public UserAccount(String email, String password, String role) {
        this.email = email;
        this.password = password;
        this.role = role;
        this.name = email;
    }

    public UserAccount(String name, String email, String password, String role) {
        this.name = name;
        this.email = email;
        this.password = password;
        this.role = role;
    }

    public String getName() { return name; }
    public String getEmail() { return email; }
    public String getPassword() { return password; }
    public String getRole() { return role; }

    public void setName(String name) { this.name = name; }

    public String toFileString() {
        return email + "|" + password + "|" + role;
    }
}
