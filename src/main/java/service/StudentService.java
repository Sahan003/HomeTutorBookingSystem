package service;

import model.Student;
import util.FileHandler;

import java.util.ArrayList;
import java.util.List;

public class StudentService {

    private static final String FILE_NAME = "students.txt";

    public void saveStudent(Student student) {
        if (getStudentByEmail(student.getEmail()) != null) {
            updateStudent(student);
        } else {
            FileHandler.writeToFile(FILE_NAME, student.toFileString());
        }
    }

    public List<Student> getAllStudents() {
        List<Student> students = new ArrayList<>();
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|", -1);
            if (data.length >= 6) {
                students.add(new Student(data[0], data[1], data[2], data[3], data[4], data[5]));
            }
        }
        return students;
    }

    public Student getStudentByEmail(String email) {
        for (Student student : getAllStudents()) {
            if (student.getEmail().equals(email)) {
                return student;
            }
        }
        return null;
    }

    public void updateStudent(Student updated) {
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        List<String> result = new ArrayList<>();
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|", -1);
            if (data.length >= 1 && data[0].equals(updated.getEmail())) {
                result.add(updated.toFileString());
            } else {
                result.add(record);
            }
        }
        FileHandler.overwriteFile(FILE_NAME, result);
    }

    public void deleteStudent(String email) {
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        List<String> result = new ArrayList<>();
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|", -1);
            if (data.length >= 1 && !data[0].equals(email)) {
                result.add(record);
            }
        }
        FileHandler.overwriteFile(FILE_NAME, result);
    }
}
