package servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import service.AuthService;

import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private final AuthService authService = new AuthService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.sendRedirect("register.jsp");
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String role = request.getParameter("role");

        if (email == null || password == null || role == null ||
            email.trim().isEmpty() || password.trim().isEmpty()) {
            response.sendRedirect("register.jsp?error=missing");
            return;
        }

        if ("ADMIN".equals(role)) {
            response.sendRedirect("register.jsp?error=adminNotAllowed");
            return;
        }

        if (authService.isEmailRegistered(email.trim())) {
            response.sendRedirect("register.jsp?error=exists");
            return;
        }

        authService.registerUser(email.trim(), password, role);
        response.sendRedirect("login.jsp?success=registered");
    }
}
