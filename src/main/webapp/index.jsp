<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="service.AuthService, model.UserAccount, java.util.List" %>
<%
    String userName = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userRole  = (String) session.getAttribute("userRole");

    if (userName == null || userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if ("STUDENT".equals(userRole)) {
        response.sendRedirect("students.jsp");
        return;
    }
    if ("TUTOR".equals(userRole)) {
        response.sendRedirect("tutors.jsp");
        return;
    }

    AuthService authService = new AuthService();
    List<UserAccount> allUsers = authService.getAllUsers();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Dashboard - Home Tutor Booking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow">
    <a class="navbar-brand fw-bold fs-5" href="index.jsp">
        <i class="bi bi-mortarboard-fill me-2"></i>HomeTutor
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMenu">
        <ul class="navbar-nav ms-auto align-items-lg-center gap-1">
            <li class="nav-item">
                <a class="nav-link active" href="index.jsp">
                    <i class="bi bi-house me-1"></i>Dashboard
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="students.jsp">
                    <i class="bi bi-people me-1"></i>Students
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="tutors.jsp">
                    <i class="bi bi-person-workspace me-1"></i>Tutors
                </a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="bookings.jsp">
                    <i class="bi bi-calendar-check me-1"></i>All Bookings
                </a>
            </li>
            <li class="nav-item ms-2">
                <a class="btn btn-outline-light btn-sm px-3" href="logout">
                    <i class="bi bi-box-arrow-right me-1"></i>Logout
                </a>
            </li>
        </ul>
    </div>
</nav>

<!-- HERO -->
<section class="hero-section">
    <div class="container text-center">
        <h1 class="display-5 fw-bold">Home Tutor Search &amp; Booking System</h1>
        <p class="lead mt-3">
            Welcome, <strong><%= userName %></strong>
            &nbsp;|&nbsp;
            <span class="badge bg-warning text-dark fs-6"><%= userRole %></span>
        </p>
        <div class="mt-4 d-flex justify-content-center gap-3 flex-wrap">
            <a href="students.jsp" class="btn btn-light btn-lg fw-semibold">
                <i class="bi bi-people me-1"></i>Student Management
            </a>
            <a href="tutors.jsp" class="btn btn-outline-light btn-lg fw-semibold">
                <i class="bi bi-person-workspace me-1"></i>Tutor Management
            </a>
            <a href="bookings.jsp" class="btn btn-warning btn-lg fw-semibold">
                <i class="bi bi-calendar-check me-1"></i>All Bookings
            </a>
        </div>
    </div>
</section>

<div class="container my-5">

    <% if ("userDeleted".equals(request.getParameter("success"))) { %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            <i class="bi bi-check-circle me-1"></i> User account deleted successfully.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- Dashboard Cards -->
    <h4 class="fw-bold mb-4 text-secondary"><i class="bi bi-grid me-2"></i>Management Sections</h4>
    <div class="row g-4 mb-5">

        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="dashboard-icon bg-primary-subtle text-primary">
                    <i class="bi bi-person-lines-fill"></i>
                </div>
                <h5 class="fw-bold mt-3">User Management</h5>
                <p class="text-muted">View and manage all registered user accounts.</p>
                <a href="#userTable" class="btn btn-primary btn-sm">
                    <i class="bi bi-eye me-1"></i>View Users
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="dashboard-icon bg-success-subtle text-success">
                    <i class="bi bi-people-fill"></i>
                </div>
                <h5 class="fw-bold mt-3">Student Management</h5>
                <p class="text-muted">View all student profiles, bookings, and activities.</p>
                <a href="students.jsp" class="btn btn-success btn-sm">
                    <i class="bi bi-arrow-right me-1"></i>Open
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="dashboard-icon bg-info-subtle text-info">
                    <i class="bi bi-person-workspace"></i>
                </div>
                <h5 class="fw-bold mt-3">Tutor Management</h5>
                <p class="text-muted">View all tutor profiles, subjects, and availability.</p>
                <a href="tutors.jsp" class="btn btn-info btn-sm text-white">
                    <i class="bi bi-arrow-right me-1"></i>Open
                </a>
            </div>
        </div>

        <div class="col-md-4">
            <div class="dashboard-card">
                <div class="dashboard-icon bg-warning-subtle text-warning">
                    <i class="bi bi-calendar2-check-fill"></i>
                </div>
                <h5 class="fw-bold mt-3">Booking Records</h5>
                <p class="text-muted">View all booking records, statuses and manage them.</p>
                <a href="bookings.jsp" class="btn btn-warning btn-sm">
                    <i class="bi bi-arrow-right me-1"></i>Open
                </a>
            </div>
        </div>

    </div>

    <!-- User Management Table -->
    <div id="userTable" class="table-card">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-bold mb-0">
                <i class="bi bi-person-lines-fill me-2 text-primary"></i>Registered Users
                <span class="badge bg-secondary ms-2"><%= allUsers.size() %></span>
            </h5>
        </div>

        <% if (allUsers.isEmpty()) { %>
            <div class="alert alert-info mb-0">No registered users found.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-primary">
                <tr>
                    <th>#</th>
                    <th>Email</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <%
                    int uIdx = 1;
                    for (UserAccount ua : allUsers) {
                %>
                <tr>
                    <td><%= uIdx++ %></td>
                    <td><i class="bi bi-envelope me-1 text-muted"></i><%= ua.getEmail() %></td>
                    <td>
                        <% if ("STUDENT".equals(ua.getRole())) { %>
                            <span class="badge bg-success"><i class="bi bi-person me-1"></i>STUDENT</span>
                        <% } else if ("TUTOR".equals(ua.getRole())) { %>
                            <span class="badge bg-info"><i class="bi bi-person-workspace me-1"></i>TUTOR</span>
                        <% } else { %>
                            <span class="badge bg-secondary"><%= ua.getRole() %></span>
                        <% } %>
                    </td>
                    <td>
                        <form action="users" method="post" style="display:inline;"
                              onsubmit="return confirm('Delete this user and all their data?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="email" value="<%= ua.getEmail() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                <i class="bi bi-trash me-1"></i>Delete
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
