package service;

import model.UserAccount;
import util.FileHandler;

import java.util.ArrayList;
import java.util.List;

public class AuthService {

    private static final String FILE_NAME = "users.txt";

    public UserAccount login(String email, String password) {
        if ("sahanliyanage003@gmail.com".equals(email) && "0712570096".equals(password)) {
            return new UserAccount("Sahan Liyanage", email, password, "ADMIN");
        }
        if ("hasaramaligaspe003@gmail.com".equals(email) && "0768092696".equals(password)) {
            return new UserAccount("Hasara Maligaspe", email, password, "ADMIN");
        }
        if ("lashanfernando003@gmail.com".equals(email) && "0711945184".equals(password)) {
            return new UserAccount("Lashan Fernando", email, password, "ADMIN");
        }

        List<String> records = FileHandler.readFromFile(FILE_NAME);
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|");
            if (data.length >= 3 && data[0].equals(email) && data[1].equals(password)) {
                return new UserAccount(data[0], data[1], data[2]);
            }
        }
        return null;
    }

    public boolean isEmailRegistered(String email) {
        if ("sahanliyanage003@gmail.com".equals(email) ||
            "hasaramaligaspe003@gmail.com".equals(email) ||
            "lashanfernando003@gmail.com".equals(email)) {
            return true;
        }
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|");
            if (data.length >= 1 && data[0].equals(email)) {
                return true;
            }
        }
        return false;
    }

    public void registerUser(String email, String password, String role) {
        if (!isEmailRegistered(email)) {
            UserAccount account = new UserAccount(email, password, role);
            FileHandler.writeToFile(FILE_NAME, account.toFileString());
        }
    }

    public List<UserAccount> getAllUsers() {
        List<UserAccount> users = new ArrayList<>();
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|");
            if (data.length >= 3) {
                users.add(new UserAccount(data[0], data[1], data[2]));
            }
        }
        return users;
    }

    public void deleteUser(String email) {
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        List<String> updated = new ArrayList<>();
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|");
            if (data.length >= 1 && !data[0].equals(email)) {
                updated.add(record);
            }
        }
        FileHandler.overwriteFile(FILE_NAME, updated);
    }
}
