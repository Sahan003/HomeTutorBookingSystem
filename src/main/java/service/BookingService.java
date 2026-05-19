package service;

import model.Booking;
import util.FileHandler;

import java.util.ArrayList;
import java.util.List;

public class BookingService {

    private static final String FILE_NAME = "bookings.txt";

    public void addBooking(Booking booking) {
        FileHandler.writeToFile(FILE_NAME, booking.toFileString());
    }

    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|", -1);
            if (data.length >= 12) {
                bookings.add(new Booking(
                    data[0], data[1], data[2], data[3], data[4],
                    data[5], data[6], data[7], data[8],
                    data[9], data[10], data[11]
                ));
            }
        }
        return bookings;
    }

    public Booking getBookingById(String bookingId) {
        for (Booking booking : getAllBookings()) {
            if (booking.getBookingId().equals(bookingId)) {
                return booking;
            }
        }
        return null;
    }

    public List<Booking> getBookingsByStudentEmail(String email) {
        List<Booking> result = new ArrayList<>();
        for (Booking booking : getAllBookings()) {
            if (booking.getStudentEmail().equals(email)) {
                result.add(booking);
            }
        }
        return result;
    }

    public List<Booking> getBookingsByTutorEmail(String email) {
        List<Booking> result = new ArrayList<>();
        for (Booking booking : getAllBookings()) {
            if (booking.getTutorEmail().equals(email)) {
                result.add(booking);
            }
        }
        return result;
    }

    public void updateBooking(Booking updated) {
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        List<String> result = new ArrayList<>();
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|", -1);
            if (data.length >= 1 && data[0].equals(updated.getBookingId())) {
                result.add(updated.toFileString());
            } else {
                result.add(record);
            }
        }
        FileHandler.overwriteFile(FILE_NAME, result);
    }

    public void updateBookingStatus(String bookingId, String status) {
        Booking booking = getBookingById(bookingId);
        if (booking != null) {
            booking.setStatus(status);
            updateBooking(booking);
        }
    }

    public void deleteBooking(String bookingId) {
        List<String> records = FileHandler.readFromFile(FILE_NAME);
        List<String> result = new ArrayList<>();
        for (String record : records) {
            if (record.trim().isEmpty()) continue;
            String[] data = record.split("\\|", -1);
            if (data.length >= 1 && !data[0].equals(bookingId)) {
                result.add(record);
            }
        }
        FileHandler.overwriteFile(FILE_NAME, result);
    }
}
