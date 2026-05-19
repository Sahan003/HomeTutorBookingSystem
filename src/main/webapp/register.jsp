<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Register - Home Tutor Booking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="auth-body">

<div class="container d-flex justify-content-center align-items-center" style="min-height:100vh;">
    <div class="auth-card">

        <div class="text-center mb-4">
            <div class="auth-logo"><i class="bi bi-person-plus-fill"></i></div>
            <h3 class="fw-bold mt-2">Create Account</h3>
            <p class="text-muted">Register as a Student or Tutor</p>
        </div>

        <% if ("exists".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger py-2">
                <i class="bi bi-exclamation-circle me-1"></i> Email already registered. Please login.
            </div>
        <% } %>
        <% if ("missing".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger py-2">
                <i class="bi bi-exclamation-circle me-1"></i> Please fill in all fields.
            </div>
        <% } %>
        <% if ("adminNotAllowed".equals(request.getParameter("error"))) { %>
            <div class="alert alert-warning py-2">
                <i class="bi bi-shield-exclamation me-1"></i> Admin accounts cannot be created through registration.
            </div>
        <% } %>

        <form action="register" method="post">
            <div class="mb-3">
                <label class="form-label fw-semibold">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
                </div>
            </div>
            <div class="mb-3">
                <label class="form-label fw-semibold">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" class="form-control"
                           placeholder="Create a password" minlength="6" required>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold">Register As</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                    <select name="role" class="form-select" required>
                        <option value="">-- Select Role --</option>
                        <option value="STUDENT">Student</option>
                        <option value="TUTOR">Tutor</option>
                    </select>
                </div>
                <div class="form-text">You will complete your profile details after login.</div>
            </div>
            <button type="submit" class="btn btn-success w-100 py-2 fw-semibold">
                <i class="bi bi-check-circle me-1"></i> Register
            </button>
        </form>

        <hr class="my-3">
        <div class="text-center">
            <span class="text-muted">Already have an account?</span>
            <a href="login.jsp" class="ms-1 fw-semibold text-decoration-none">Login here</a>
        </div>

    </div>
</div>

</body>
</html>
