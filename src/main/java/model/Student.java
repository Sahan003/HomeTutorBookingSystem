package model;

public class Student extends User {
    private String grade;

    public Student(String email, String name, String phone, String location,
                   String grade, String photoPath) {
        super(email, name, phone, location, photoPath);
        this.grade = grade;
    }

    public String getGrade() { return grade; }
    public void setGrade(String grade) { this.grade = grade; }

    @Override
    public String displayRole() {
        return "Student";
    }

    public String toFileString() {
        return email + "|" + name + "|" + phone + "|" + location + "|" + grade + "|" + photoPath;
    }
}
