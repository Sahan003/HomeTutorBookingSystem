package service;

import model.Tutor;
import util.FileHandler;

import java.util.ArrayList;
import java.util.List;

public class TutorService {

    private static final String FILE_NAME = "tutors.txt";

    public void saveTutor(Tutor tutor) {
        if (getTutorByEmail(tutor.getEmail()) != null) {
            updateTutor(tutor);
        } else {
            FileHandler.writeToFile(FILE_NAME, tutor.toFileString());
        }
    }

    public List<Tutor> getAllTutors() {
        List<Tutor> tutors = new ArrayList<>();
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|", -1);
            if (data.length >= 9) {
                try {
                    tutors.add(new Tutor(
                        data[0], data[1], data[2], data[3],
                        data[4], data[5], data[6],
                        Double.parseDouble(data[7]), data[8]
                    ));
                } catch (NumberFormatException e) {
                    // skip malformed record
                }
            }
        }
        return tutors;
    }

    public Tutor getTutorByEmail(String email) {
        for (Tutor tutor : getAllTutors()) {
            if (tutor.getEmail().equals(email)) {
                return tutor;
            }
        }
        return null;
    }

    /**
     * Searches tutors by subject (contains), grade (exact), qualification (exact), location (exact).
     * Passing null or empty string for any criterion skips that filter.
     */
    public List<Tutor> searchTutors(String subject, String grade,
                                     String qualification, String location) {
        List<Tutor> matched = new ArrayList<>();
        for (Tutor tutor : getAllTutors()) {
            boolean subjectMatch = subject == null || subject.isEmpty() ||
                tutor.getSubjects().toLowerCase().contains(subject.toLowerCase());

            boolean gradeMatch = grade == null || grade.isEmpty() ||
                tutor.getTeachingGrade().equalsIgnoreCase(grade);

            boolean qualMatch = qualification == null || qualification.isEmpty() ||
                tutor.getQualification().equalsIgnoreCase(qualification);

            boolean locMatch = location == null || location.isEmpty() ||
                tutor.getLocation().equalsIgnoreCase(location);

            if (subjectMatch && gradeMatch && qualMatch && locMatch) {
                matched.add(tutor);
            }
        }
        return matched;
    }

    public void updateTutor(Tutor updated) {
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        List<String> result  = new ArrayList<>();
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

    public void deleteTutor(String email) {
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        List<String> result  = new ArrayList<>();
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
