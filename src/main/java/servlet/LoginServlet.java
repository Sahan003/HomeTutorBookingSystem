package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import model.Student;
import model.Tutor;
import model.UserAccount;
import service.AuthService;
import service.StudentService;
import service.TutorService;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private final AuthService authService = new AuthService();
    private final StudentService studentService = new StudentService();
    private final TutorService tutorService = new TutorService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("login.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");

        UserAccount account = authService.login(email, password);

        if (account == null) {
            response.sendRedirect("login.jsp?error=invalid");
            return;
        }

        HttpSession session = request.getSession();
        session.setAttribute("userEmail", account.getEmail());
        session.setAttribute("userRole", account.getRole());

        String displayName = account.getName();

        if ("STUDENT".equals(account.getRole())) {
            Student profile = studentService.getStudentByEmail(account.getEmail());
            if (profile != null) {
                displayName = profile.getName();
            }
            session.setAttribute("userName", displayName);
            response.sendRedirect("students.jsp");

        } else if ("TUTOR".equals(account.getRole())) {
            Tutor profile = tutorService.getTutorByEmail(account.getEmail());
            if (profile != null) {
                displayName = profile.getName();
            }
            session.setAttribute("userName", displayName);
            response.sendRedirect("tutors.jsp");

        } else {
            session.setAttribute("userName", displayName);
            response.sendRedirect("index.jsp");
        }
    }
}
