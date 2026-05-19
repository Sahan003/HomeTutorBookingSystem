<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login - Home Tutor Booking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body class="auth-body">

<div class="container d-flex justify-content-center align-items-center" style="min-height:100vh;">
    <div class="auth-card">

        <div class="text-center mb-4">
            <div class="auth-logo"><i class="bi bi-mortarboard-fill"></i></div>
            <h3 class="fw-bold mt-2">Home Tutor Booking System</h3>
            <p class="text-muted">Sign in to your account</p>
        </div>

        <% if ("invalid".equals(request.getParameter("error"))) { %>
            <div class="alert alert-danger py-2">
                <i class="bi bi-exclamation-circle me-1"></i> Invalid email or password.
            </div>
        <% } %>

        <% if ("registered".equals(request.getParameter("success"))) { %>
            <div class="alert alert-success py-2">
                <i class="bi bi-check-circle me-1"></i> Registration successful. Please login.
            </div>
        <% } %>

        <% if ("loggedout".equals(request.getParameter("msg"))) { %>
            <div class="alert alert-info py-2">
                <i class="bi bi-info-circle me-1"></i> You have been logged out.
            </div>
        <% } %>

        <form action="login" method="post">
            <div class="mb-3">
                <label class="form-label fw-semibold">Email Address</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                    <input type="email" name="email" class="form-control" placeholder="your@email.com" required>
                </div>
            </div>
            <div class="mb-4">
                <label class="form-label fw-semibold">Password</label>
                <div class="input-group">
                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                    <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                </div>
            </div>
            <button type="submit" class="btn btn-primary w-100 py-2 fw-semibold">
                <i class="bi bi-box-arrow-in-right me-1"></i> Login
            </button>
        </form>

        <hr class="my-3">
        <div class="text-center">
            <span class="text-muted">New user?</span>
            <a href="register.jsp" class="ms-1 fw-semibold text-decoration-none">Create an account</a>
        </div>

    </div>
</div>

</body>
</html>
