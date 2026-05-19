package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.AuthService;
import service.StudentService;
import service.TutorService;

import java.io.IOException;

@WebServlet("/users")
public class UserServlet extends HttpServlet {

    private final AuthService authService = new AuthService();
    private final StudentService studentService = new StudentService();
    private final TutorService tutorService = new TutorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("index.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || !"ADMIN".equals(session.getAttribute("userRole"))) {
            response.sendRedirect("login.jsp");
            return;
        }

        String action = request.getParameter("action");
        String email  = request.getParameter("email");

        if ("delete".equals(action) && email != null && !email.isEmpty()) {
            authService.deleteUser(email);
            studentService.deleteStudent(email);
            tutorService.deleteTutor(email);
        }

        response.sendRedirect("index.jsp?success=userDeleted");
    }
}
