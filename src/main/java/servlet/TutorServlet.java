package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Tutor;
import service.TutorService;

import java.io.File;
import java.io.IOException;

@WebServlet("/tutors")
@MultipartConfig(
        fileSizeThreshold = 1024 * 1024,
        maxFileSize       = 5 * 1024 * 1024,
        maxRequestSize    = 10 * 1024 * 1024
)
public class TutorServlet extends HttpServlet {

    private final TutorService tutorService = new TutorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("tutors.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userEmail") == null) {
            response.sendRedirect("login.jsp");
            return;
        }

        String userRole  = (String) session.getAttribute("userRole");
        String userEmail = (String) session.getAttribute("userEmail");
        String action    = request.getParameter("action");

        if ("saveProfile".equals(action)) {
            String name          = request.getParameter("name");
            String phone         = request.getParameter("phone");
            String location      = request.getParameter("location");
            String qualification = request.getParameter("qualification");
            String teachingGrade = request.getParameter("teachingGrade");
            String subjects      = request.getParameter("subjects");

            double hourlyRate = 0;
            try {
                hourlyRate = Double.parseDouble(request.getParameter("hourlyRate"));
            } catch (NumberFormatException ignored) {}

            // Keep existing photo unless a new file is uploaded
            String photoPath = "";
            Tutor existing = tutorService.getTutorByEmail(userEmail);
            if (existing != null && existing.getPhotoPath() != null) {
                photoPath = existing.getPhotoPath();
            }

            Part photoPart = request.getPart("photo");
            if (photoPart != null && photoPart.getSize() > 0) {
                String originalName = extractFileName(photoPart);
                if (originalName != null && !originalName.isEmpty()) {
                    String uploadsDir = request.getServletContext().getRealPath("/uploads");
                    File dir = new File(uploadsDir);
                    if (!dir.exists()) dir.mkdirs();

                    String ext        = getExtension(originalName);
                    String uniqueName = "tut_" + userEmail.replaceAll("[^a-zA-Z0-9]", "_")
                                        + "_" + System.currentTimeMillis() + ext;
                    photoPart.write(uploadsDir + File.separator + uniqueName);
                    photoPath = "uploads/" + uniqueName;
                }
            }

            Tutor tutor = new Tutor(userEmail, name, phone, location,
                    qualification, teachingGrade, subjects, hourlyRate, photoPath);
            tutorService.saveTutor(tutor);

            session.setAttribute("userName", name);
            response.sendRedirect("tutors.jsp?success=profileSaved");

        } else if ("delete".equals(action) && "ADMIN".equals(userRole)) {
            String email = request.getParameter("email");
            tutorService.deleteTutor(email);
            response.sendRedirect("tutors.jsp?success=deleted");

        } else {
            response.sendRedirect("tutors.jsp");
        }
    }

    private String extractFileName(Part part) {
        String cd = part.getHeader("content-disposition");
        if (cd == null) return null;
        for (String token : cd.split(";")) {
            if (token.trim().startsWith("filename")) {
                String raw = token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
                int sep = Math.max(raw.lastIndexOf('/'), raw.lastIndexOf('\\'));
                return sep >= 0 ? raw.substring(sep + 1) : raw;
            }
        }
        return null;
    }

    private String getExtension(String fileName) {
        int dot = fileName.lastIndexOf('.');
        return dot >= 0 ? fileName.substring(dot).toLowerCase() : ".jpg";
    }
}
