<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="service.BookingService, model.Booking, java.util.List" %>
<%
    String userName  = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userRole  = (String) session.getAttribute("userRole");

    if (userName == null || userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    if (!"ADMIN".equals(userRole)) {
        if ("STUDENT".equals(userRole)) {
            response.sendRedirect("students.jsp");
        } else {
            response.sendRedirect("tutors.jsp");
        }
        return;
    }

    BookingService bookingService = new BookingService();
    List<Booking> allBookings = bookingService.getAllBookings();

    long pendingCount  = 0;
    long reservedCount = 0;
    long rejectedCount = 0;
    for (Booking b : allBookings) {
        if ("Pending".equals(b.getStatus()))  pendingCount++;
        else if ("Reserved".equals(b.getStatus())) reservedCount++;
        else if ("Rejected".equals(b.getStatus())) rejectedCount++;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>All Bookings - Home Tutor Booking System</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <link href="assets/css/style.css" rel="stylesheet">
</head>
<body>

<!-- NAVBAR -->
<nav class="navbar navbar-expand-lg navbar-dark bg-primary px-4 shadow">
    <a class="navbar-brand fw-bold" href="index.jsp">
        <i class="bi bi-mortarboard-fill me-2"></i>HomeTutor
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navMenu">
        <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navMenu">
        <ul class="navbar-nav ms-auto align-items-lg-center gap-1">
            <li class="nav-item"><a class="nav-link" href="index.jsp"><i class="bi bi-house me-1"></i>Dashboard</a></li>
            <li class="nav-item"><a class="nav-link" href="students.jsp"><i class="bi bi-people me-1"></i>Students</a></li>
            <li class="nav-item"><a class="nav-link" href="tutors.jsp"><i class="bi bi-person-workspace me-1"></i>Tutors</a></li>
            <li class="nav-item">
                <a class="nav-link active" href="bookings.jsp">
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

<div class="container my-4">

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="page-title mb-0">
            <i class="bi bi-calendar2-check me-2"></i>All Booking Records
        </h3>
        <span class="text-muted small">
            Admin: <strong><%= userName %></strong>
        </span>
    </div>

    <!-- Alerts -->
    <% String success = request.getParameter("success"); %>
    <% if ("deleted".equals(success)) { %>
        <div class="alert alert-warning alert-dismissible fade show py-2">
            <i class="bi bi-trash me-1"></i> Booking deleted.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("statusUpdated".equals(success)) { %>
        <div class="alert alert-success alert-dismissible fade show py-2">
            <i class="bi bi-check-circle me-1"></i> Booking status updated.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- Summary Cards -->
    <div class="row g-3 mb-4">
        <div class="col-md-3">
            <div class="stat-card border-start border-primary border-4">
                <div class="stat-number text-primary"><%= allBookings.size() %></div>
                <div class="stat-label">Total Bookings</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card border-start border-warning border-4">
                <div class="stat-number text-warning"><%= pendingCount %></div>
                <div class="stat-label">Pending</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card border-start border-success border-4">
                <div class="stat-number text-success"><%= reservedCount %></div>
                <div class="stat-label">Reserved</div>
            </div>
        </div>
        <div class="col-md-3">
            <div class="stat-card border-start border-danger border-4">
                <div class="stat-number text-danger"><%= rejectedCount %></div>
                <div class="stat-label">Rejected</div>
            </div>
        </div>
    </div>

    <!-- All Bookings Table -->
    <div class="table-card">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-table me-2 text-primary"></i>Complete Booking Records
        </h5>

        <% if (allBookings.isEmpty()) { %>
            <div class="alert alert-info mb-0">
                <i class="bi bi-info-circle me-1"></i> No bookings have been made yet.
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-primary">
                <tr>
                    <th>Booking ID</th>
                    <th>Student</th>
                    <th>Tutor</th>
                    <th>Subject</th>
                    <th>Grade</th>
                    <th>Qualification</th>
                    <th>Location</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Booking b : allBookings) {
                       String badgeClass = "bg-warning text-dark";
                       if ("Reserved".equals(b.getStatus())) badgeClass = "bg-success";
                       else if ("Rejected".equals(b.getStatus())) badgeClass = "bg-danger";
                %>
                <tr>
                    <td><small class="text-muted fw-semibold"><%= b.getBookingId() %></small></td>
                    <td>
                        <strong><%= b.getStudentName() %></strong><br>
                        <small class="text-muted"><%= b.getStudentEmail() %></small>
                    </td>
                    <td>
                        <strong><%= b.getTutorName() %></strong><br>
                        <small class="text-muted"><%= b.getTutorEmail() %></small>
                    </td>
                    <td><%= b.getSubject() %></td>
                    <td><%= b.getGrade() %></td>
                    <td><%= b.getQualification() %></td>
                    <td><%= b.getLocation() %></td>
                    <td><%= b.getBookingDate() %></td>
                    <td><%= b.getBookingTime() %></td>
                    <td><span class="badge <%= badgeClass %>"><%= b.getStatus() %></span></td>
                    <td>
                        <% if (!"Reserved".equals(b.getStatus())) { %>
                        <form action="bookings" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                            <input type="hidden" name="status" value="Reserved">
                            <button type="submit" class="btn btn-sm btn-outline-success mb-1"
                                    title="Mark as Reserved">
                                <i class="bi bi-check-lg"></i>
                            </button>
                        </form>
                        <% } %>
                        <% if (!"Rejected".equals(b.getStatus())) { %>
                        <form action="bookings" method="post" style="display:inline;">
                            <input type="hidden" name="action" value="updateStatus">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                            <input type="hidden" name="status" value="Rejected">
                            <button type="submit" class="btn btn-sm btn-outline-warning mb-1"
                                    title="Mark as Rejected">
                                <i class="bi bi-x-lg"></i>
                            </button>
                        </form>
                        <% } %>
                        <form action="bookings" method="post" style="display:inline;"
                              onsubmit="return confirm('Permanently delete this booking?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger mb-1"
                                    title="Delete">
                                <i class="bi bi-trash"></i>
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
