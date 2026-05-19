package model;

public class Tutor extends User {
    private String qualification;
    private String teachingGrade;
    private String subjects;
    private double hourlyRate;

    public Tutor(String email, String name, String phone, String location,
                 String qualification, String teachingGrade, String subjects,
                 double hourlyRate, String photoPath) {
        super(email, name, phone, location, photoPath);
        this.qualification = qualification;
        this.teachingGrade = teachingGrade;
        this.subjects = subjects;
        this.hourlyRate = hourlyRate;
    }

    public String getQualification() { return qualification; }
    public String getTeachingGrade() { return teachingGrade; }
    public String getSubjects() { return subjects; }
    public double getHourlyRate() { return hourlyRate; }

    public void setQualification(String qualification) { this.qualification = qualification; }
    public void setTeachingGrade(String teachingGrade) { this.teachingGrade = teachingGrade; }
    public void setSubjects(String subjects) { this.subjects = subjects; }
    public void setHourlyRate(double hourlyRate) { this.hourlyRate = hourlyRate; }

    @Override
    public String displayRole() {
        return "Tutor";
    }

    public String toFileString() {
        return email + "|" + name + "|" + phone + "|" + location + "|" +
               qualification + "|" + teachingGrade + "|" + subjects + "|" +
               hourlyRate + "|" + photoPath;
    }
}
