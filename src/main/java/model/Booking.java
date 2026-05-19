package model;

public class Booking {
    private String bookingId;
    private String studentEmail;
    private String studentName;
    private String tutorEmail;
    private String tutorName;
    private String subject;
    private String grade;
    private String qualification;
    private String location;
    private String bookingDate;
    private String bookingTime;
    private String status;

    public Booking(String bookingId, String studentEmail, String studentName,
                   String tutorEmail, String tutorName,
                   String subject, String grade, String qualification, String location,
                   String bookingDate, String bookingTime, String status) {
        this.bookingId = bookingId;
        this.studentEmail = studentEmail;
        this.studentName = studentName;
        this.tutorEmail = tutorEmail;
        this.tutorName = tutorName;
        this.subject = subject;
        this.grade = grade;
        this.qualification = qualification;
        this.location = location;
        this.bookingDate = bookingDate;
        this.bookingTime = bookingTime;
        this.status = status;
    }

    public String getBookingId() { return bookingId; }
    public String getStudentEmail() { return studentEmail; }
    public String getStudentName() { return studentName; }
    public String getTutorEmail() { return tutorEmail; }
    public String getTutorId() { return tutorEmail; }
    public String getTutorName() { return tutorName; }
    public String getSubject() { return subject; }
    public String getGrade() { return grade; }
    public String getQualification() { return qualification; }
    public String getLocation() { return location; }
    public String getBookingDate() { return bookingDate; }
    public String getBookingTime() { return bookingTime; }
    public String getStatus() { return status; }

    public void setStatus(String status) { this.status = status; }

    public String toFileString() {
        return bookingId + "|" + studentEmail + "|" + studentName + "|" +
               tutorEmail + "|" + tutorName + "|" + subject + "|" + grade + "|" +
               qualification + "|" + location + "|" + bookingDate + "|" +
               bookingTime + "|" + status;
    }
}
