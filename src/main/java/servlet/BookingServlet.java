package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Booking;
import service.BookingService;

import java.io.IOException;
import java.util.UUID;

@WebServlet("/bookings")
public class BookingServlet extends HttpServlet {

    private final BookingService bookingService = new BookingService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userRole") == null) {
            response.sendRedirect("login.jsp");
            return;
        }
        String role = (String) session.getAttribute("userRole");
        if ("ADMIN".equals(role)) {
            response.sendRedirect("bookings.jsp");
        } else if ("STUDENT".equals(role)) {
            response.sendRedirect("students.jsp");
        } else {
            response.sendRedirect("tutors.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userEmail = (String) session.getAttribute("userEmail");
        String userName = (String) session.getAttribute("userName");
        String userRole = (String) session.getAttribute("userRole");
        String action = request.getParameter("action");

        if ("book".equals(action)) {
            String bookingId = "BKG-" + UUID.randomUUID().toString().substring(0, 8).toUpperCase();
            Booking booking = new Booking(
                bookingId,
                userEmail,
                userName,
                request.getParameter("tutorEmail"),
                request.getParameter("tutorName"),
                request.getParameter("subject"),
                request.getParameter("grade"),
                request.getParameter("qualification"),
                request.getParameter("location"),
                request.getParameter("bookingDate"),
                request.getParameter("bookingTime"),
                "Pending"
            );
            bookingService.addBooking(booking);
            response.sendRedirect("students.jsp?success=booked");

        } else if ("update".equals(action)) {
            String bookingId = request.getParameter("bookingId");
            Booking old = bookingService.getBookingById(bookingId);
            if (old != null && ("ADMIN".equals(userRole) || old.getStudentEmail().equals(userEmail))) {
                Booking updated = new Booking(
                    old.getBookingId(),
                    old.getStudentEmail(),
                    old.getStudentName(),
                    old.getTutorEmail(),
                    old.getTutorName(),
                    request.getParameter("subject"),
                    request.getParameter("grade"),
                    request.getParameter("qualification"),
                    request.getParameter("location"),
                    request.getParameter("bookingDate"),
                    request.getParameter("bookingTime"),
                    old.getStatus()
                );
                bookingService.updateBooking(updated);
            }
            response.sendRedirect("students.jsp?success=updated");

        } else if ("delete".equals(action)) {
            String bookingId = request.getParameter("bookingId");
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking != null && ("ADMIN".equals(userRole) || booking.getStudentEmail().equals(userEmail))) {
                bookingService.deleteBooking(bookingId);
            }
            if ("ADMIN".equals(userRole)) {
                response.sendRedirect("bookings.jsp?success=deleted");
            } else {
                response.sendRedirect("students.jsp?success=cancelled");
            }

        } else if ("updateStatus".equals(action)) {
            String bookingId = request.getParameter("bookingId");
            String newStatus = request.getParameter("status");
            Booking booking = bookingService.getBookingById(bookingId);
            if (booking != null) {
                boolean isTutorOwner = "TUTOR".equals(userRole) && booking.getTutorEmail().equals(userEmail);
                boolean isAdmin = "ADMIN".equals(userRole);
                if (isTutorOwner || isAdmin) {
                    bookingService.updateBookingStatus(bookingId, newStatus);
                }
            }
            if ("ADMIN".equals(userRole)) {
                response.sendRedirect("bookings.jsp?success=statusUpdated");
            } else {
                response.sendRedirect("tutors.jsp?success=statusUpdated");
            }

        } else {
            response.sendRedirect("index.jsp");
        }
    }
}
