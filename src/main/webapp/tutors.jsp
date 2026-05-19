<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="service.TutorService, service.BookingService" %>
<%@ page import="model.Tutor, model.Booking, java.util.List" %>
<%
    String userName  = (String) session.getAttribute("userName");
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

    // ── Dropdown data ──────────────────────────────────────────────
    String[] GRADES         = {"6","7","8","9","10","11","A/L"};
    String[] LOCATIONS      = {"Colombo","Anuradhapura","Galle","Jaffna","Matara",
                                "Kandy","Kurunegala","Negombo","Gampaha"};
    String[] QUALIFICATIONS = {"BSC Degree","MSC Degree","School Teacher","Undergraduate Student"};

    // ── Services ───────────────────────────────────────────────────
    TutorService   tutorService   = new TutorService();
    BookingService bookingService = new BookingService();

    // ── Tutor own profile ──────────────────────────────────────────
    Tutor myProfile = null;
    if ("TUTOR".equals(userRole)) {
        myProfile = tutorService.getTutorByEmail(userEmail);
    }
    String curQual     = (myProfile != null) ? myProfile.getQualification()  : "";
    String curGrade    = (myProfile != null) ? myProfile.getTeachingGrade()  : "";
    String curLocation = (myProfile != null) ? myProfile.getLocation()       : "";
    String curPhoto    = (myProfile != null && myProfile.getPhotoPath() != null)
                         ? myProfile.getPhotoPath() : "";

    // ── Booking requests (TUTOR) ───────────────────────────────────
    List<Booking> myRequests = null;
    if ("TUTOR".equals(userRole)) {
        myRequests = bookingService.getBookingsByTutorEmail(userEmail);
    }

    // ── All tutors + all bookings (ADMIN) ──────────────────────────
    List<Tutor>   allTutors   = "ADMIN".equals(userRole) ? tutorService.getAllTutors()    : null;
    List<Booking> allBookings = "ADMIN".equals(userRole) ? bookingService.getAllBookings() : null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Tutor Management - Home Tutor Booking System</title>
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
            <% if ("ADMIN".equals(userRole)) { %>
            <li class="nav-item"><a class="nav-link" href="index.jsp"><i class="bi bi-house me-1"></i>Dashboard</a></li>
            <li class="nav-item"><a class="nav-link" href="students.jsp"><i class="bi bi-people me-1"></i>Students</a></li>
            <% } %>
            <li class="nav-item">
                <a class="nav-link active" href="tutors.jsp">
                    <i class="bi bi-person-workspace me-1"></i>Tutor Management
                </a>
            </li>
            <% if ("ADMIN".equals(userRole)) { %>
            <li class="nav-item">
                <a class="nav-link" href="bookings.jsp">
                    <i class="bi bi-calendar-check me-1"></i>All Bookings
                </a>
            </li>
            <% } %>
            <li class="nav-item ms-2">
                <a class="btn btn-outline-light btn-sm px-3" href="logout">
                    <i class="bi bi-box-arrow-right me-1"></i>Logout
                </a>
            </li>
        </ul>
    </div>
</nav>

<div class="container my-4">

    <div class="d-flex justify-content-between align-items-center mb-2">
        <h3 class="page-title mb-0"><i class="bi bi-person-workspace me-2"></i>Tutor Management</h3>
        <span class="text-muted small">
            <strong><%= userName %></strong>
            &nbsp;<span class="badge bg-info"><%= userRole %></span>
        </span>
    </div>

    <!-- ── Alerts ── -->
    <% String succ = request.getParameter("success"); %>
    <% if ("profileSaved".equals(succ)) { %>
        <div class="alert alert-success alert-dismissible fade show py-2">
            <i class="bi bi-check-circle me-1"></i>Profile saved successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("statusUpdated".equals(succ)) { %>
        <div class="alert alert-success alert-dismissible fade show py-2">
            <i class="bi bi-check-circle me-1"></i>Booking status updated.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("deleted".equals(succ)) { %>
        <div class="alert alert-warning alert-dismissible fade show py-2">
            <i class="bi bi-trash me-1"></i>Tutor profile deleted.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- ════════════════════════════════════════════════════
         TUTOR ROLE
    ════════════════════════════════════════════════════ -->
    <% if ("TUTOR".equals(userRole)) { %>

    <!-- ── 1. MY TUTOR PROFILE ── -->
    <div class="table-card mb-4">
        <h5 class="fw-bold mb-4">
            <i class="bi bi-person-badge me-2 text-primary"></i>My Tutor Profile
            <% if (myProfile == null) { %>
                <span class="badge bg-warning text-dark ms-2">Incomplete – complete your profile so students can find you</span>
            <% } else { %>
                <span class="badge bg-success ms-2">Complete</span>
            <% } %>
        </h5>

        <form action="tutors" method="post" enctype="multipart/form-data" class="row g-3">
            <input type="hidden" name="action" value="saveProfile">

            <!-- Profile photo -->
            <div class="col-12">
                <div class="d-flex align-items-center gap-4 flex-wrap">
                    <div id="photoWrap">
                        <% if (!curPhoto.isEmpty()) { %>
                            <img src="<%= curPhoto %>" class="profile-photo" id="photoPreview" alt="Profile Photo">
                        <% } else { %>
                            <div class="profile-photo-placeholder" id="photoPlaceholder">
                                <i class="bi bi-person"></i>
                            </div>
                            <img id="photoPreview" class="profile-photo" style="display:none;" alt="Preview">
                        <% } %>
                    </div>
                    <div class="flex-grow-1">
                        <label class="form-label fw-semibold">Profile Photo</label>
                        <input type="file" name="photo" class="form-control" accept=".jpg,.jpeg,.png"
                               onchange="previewPhoto(this,'photoPreview','photoPlaceholder')">
                        <div class="form-text">
                            <i class="bi bi-info-circle me-1"></i>
                            Accepted: JPG, JPEG, PNG &nbsp;|&nbsp; Max: 5 MB &nbsp;|&nbsp;
                            Leave empty to keep current photo.
                        </div>
                    </div>
                </div>
            </div>

            <!-- Name -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Full Name</label>
                <input type="text" name="name" class="form-control"
                       value="<%= myProfile != null ? myProfile.getName() : "" %>" required>
            </div>
            <!-- Phone -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Mobile Number</label>
                <input type="text" name="phone" class="form-control"
                       value="<%= myProfile != null ? myProfile.getPhone() : "" %>" required>
            </div>
            <!-- Email readonly -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Email (Account)</label>
                <input type="email" class="form-control bg-light" value="<%= userEmail %>" readonly>
            </div>

            <!-- Location dropdown -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Location / City</label>
                <select name="location" class="form-select" required>
                    <option value="">-- Select Location --</option>
                    <% for (String loc : LOCATIONS) { %>
                    <option value="<%= loc %>" <%= loc.equals(curLocation) ? "selected" : "" %>><%= loc %></option>
                    <% } %>
                </select>
            </div>

            <!-- Qualification dropdown -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Qualification</label>
                <select name="qualification" class="form-select" required>
                    <option value="">-- Select Qualification --</option>
                    <% for (String q : QUALIFICATIONS) { %>
                    <option value="<%= q %>" <%= q.equals(curQual) ? "selected" : "" %>><%= q %></option>
                    <% } %>
                </select>
            </div>

            <!-- Teaching Grade dropdown -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Teaching Grade</label>
                <select name="teachingGrade" class="form-select" required>
                    <option value="">-- Select Grade --</option>
                    <% for (String g : GRADES) { %>
                    <option value="<%= g %>" <%= g.equals(curGrade) ? "selected" : "" %>>
                        <%= "A/L".equals(g) ? "A/L (Advanced Level)" : "Grade " + g %>
                    </option>
                    <% } %>
                </select>
            </div>

            <!-- Subjects (text) -->
            <div class="col-md-6">
                <label class="form-label fw-semibold">Subjects Taught</label>
                <input type="text" name="subjects" class="form-control"
                       placeholder="e.g. Mathematics, Physics, Chemistry"
                       value="<%= myProfile != null ? myProfile.getSubjects() : "" %>" required>
                <div class="form-text">Separate multiple subjects with commas.</div>
            </div>

            <!-- Hourly rate -->
            <div class="col-md-3">
                <label class="form-label fw-semibold">Hourly Rate (Rs.)</label>
                <div class="input-group">
                    <span class="input-group-text">Rs.</span>
                    <input type="number" name="hourlyRate" class="form-control" step="0.01" min="0"
                           placeholder="e.g. 1500"
                           value="<%= myProfile != null ? myProfile.getHourlyRate() : "" %>" required>
                </div>
            </div>

            <div class="col-12">
                <button type="submit" class="btn btn-primary px-4">
                    <i class="bi bi-save me-1"></i>
                    <%= myProfile == null ? "Save Profile" : "Update Profile" %>
                </button>
            </div>
        </form>
    </div>

    <!-- ── 2. BOOKING REQUESTS ── -->
    <div class="table-card">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-inbox me-2 text-info"></i>Booking Requests
            <span class="badge bg-secondary">
                <%= myRequests != null ? myRequests.size() : 0 %>
            </span>
        </h5>

        <% if (myRequests == null || myRequests.isEmpty()) { %>
            <div class="alert alert-info mb-0">
                <i class="bi bi-info-circle me-1"></i>
                No booking requests yet. Complete your profile so students can find and book you.
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-info">
                <tr>
                    <th>Booking ID</th>
                    <th>Student</th>
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
                <% for (Booking b : myRequests) {
                       String bc = "bg-warning text-dark";
                       if ("Reserved".equals(b.getStatus())) bc = "bg-success";
                       if ("Rejected".equals(b.getStatus())) bc = "bg-danger";
                %>
                <tr>
                    <td><small class="text-muted"><%= b.getBookingId() %></small></td>
                    <td>
                        <strong><%= b.getStudentName() %></strong><br>
                        <small class="text-muted"><%= b.getStudentEmail() %></small>
                    </td>
                    <td><%= b.getSubject() %></td>
                    <td><%= b.getGrade().isEmpty() ? "—" : b.getGrade() %></td>
                    <td><%= b.getQualification().isEmpty() ? "—" : b.getQualification() %></td>
                    <td><%= b.getLocation().isEmpty() ? "—" : b.getLocation() %></td>
                    <td><%= b.getBookingDate() %></td>
                    <td><%= b.getBookingTime() %></td>
                    <td><span class="badge <%= bc %>"><%= b.getStatus() %></span></td>
                    <td>
                        <% if ("Pending".equals(b.getStatus())) { %>
                        <form action="bookings" method="post" style="display:inline;">
                            <input type="hidden" name="action"    value="updateStatus">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                            <input type="hidden" name="status"    value="Reserved">
                            <button type="submit" class="btn btn-sm btn-success me-1"
                                    onclick="return confirm('Accept this booking request?')">
                                <i class="bi bi-check-lg me-1"></i>Accept
                            </button>
                        </form>
                        <form action="bookings" method="post" style="display:inline;">
                            <input type="hidden" name="action"    value="updateStatus">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                            <input type="hidden" name="status"    value="Rejected">
                            <button type="submit" class="btn btn-sm btn-danger"
                                    onclick="return confirm('Reject this booking request?')">
                                <i class="bi bi-x-lg me-1"></i>Reject
                            </button>
                        </form>
                        <% } else { %>
                        <span class="text-muted small fst-italic">
                            <%= "Reserved".equals(b.getStatus()) ? "Accepted" : "Rejected" %>
                        </span>
                        <% } %>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
    </div>

    <!-- ════════════════════════════════════════════════════
         ADMIN ROLE
    ════════════════════════════════════════════════════ -->
    <% } else if ("ADMIN".equals(userRole)) { %>

    <!-- All tutor profiles -->
    <div class="table-card mb-4">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-person-workspace me-2 text-info"></i>All Tutor Profiles
            <span class="badge bg-secondary"><%= allTutors != null ? allTutors.size() : 0 %></span>
        </h5>
        <% if (allTutors == null || allTutors.isEmpty()) { %>
            <div class="alert alert-info mb-0">No tutor profiles found.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-info">
                <tr>
                    <th>Photo</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Location</th>
                    <th>Qualification</th>
                    <th>Teaching Grade</th>
                    <th>Subjects</th>
                    <th>Rate (Rs./hr)</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (Tutor t : allTutors) { %>
                <tr>
                    <td>
                        <% if (t.getPhotoPath() != null && !t.getPhotoPath().isEmpty()) { %>
                            <img src="<%= t.getPhotoPath() %>" class="table-avatar" alt="<%= t.getName() %>">
                        <% } else { %>
                            <span class="table-avatar-icon"><i class="bi bi-person-circle"></i></span>
                        <% } %>
                    </td>
                    <td><strong><%= t.getName() %></strong></td>
                    <td><small><%= t.getEmail() %></small></td>
                    <td><%= t.getPhone() %></td>
                    <td><%= t.getLocation() %></td>
                    <td><%= t.getQualification() %></td>
                    <td>
                        <%= "A/L".equals(t.getTeachingGrade()) ? "A/L" : "Grade " + t.getTeachingGrade() %>
                    </td>
                    <td><%= t.getSubjects() %></td>
                    <td><strong>Rs. <%= String.format("%.2f", t.getHourlyRate()) %></strong></td>
                    <td>
                        <form action="tutors" method="post" style="display:inline;"
                              onsubmit="return confirm('Delete this tutor profile?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="email"  value="<%= t.getEmail() %>">
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

    <!-- All bookings (admin view here) -->
    <div class="table-card">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-calendar-check me-2 text-warning"></i>All Booking Records
            <span class="badge bg-secondary"><%= allBookings != null ? allBookings.size() : 0 %></span>
        </h5>
        <% if (allBookings == null || allBookings.isEmpty()) { %>
            <div class="alert alert-info mb-0">No bookings found.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-warning">
                <tr>
                    <th>Booking ID</th>
                    <th>Student</th>
                    <th>Tutor</th>
                    <th>Subject</th>
                    <th>Grade</th>
                    <th>Date</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
                </thead>
                <tbody>
                <% for (Booking b : allBookings) {
                       String bc = "bg-warning text-dark";
                       if ("Reserved".equals(b.getStatus())) bc = "bg-success";
                       if ("Rejected".equals(b.getStatus())) bc = "bg-danger";
                %>
                <tr>
                    <td><small><%= b.getBookingId() %></small></td>
                    <td><%= b.getStudentName() %><br><small class="text-muted"><%= b.getStudentEmail() %></small></td>
                    <td><%= b.getTutorName() %><br><small class="text-muted"><%= b.getTutorEmail() %></small></td>
                    <td><%= b.getSubject() %></td>
                    <td><%= b.getGrade().isEmpty() ? "—" : b.getGrade() %></td>
                    <td><%= b.getBookingDate() %></td>
                    <td><%= b.getBookingTime() %></td>
                    <td><span class="badge <%= bc %>"><%= b.getStatus() %></span></td>
                    <td>
                        <form action="bookings" method="post" style="display:inline;"
                              onsubmit="return confirm('Delete this booking?');">
                            <input type="hidden" name="action"    value="delete">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger">
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

    <% } %>

</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script>
function previewPhoto(input, previewId, placeholderId) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function(e) {
            var preview = document.getElementById(previewId);
            preview.src = e.target.result;
            preview.style.display = 'block';
            var ph = document.getElementById(placeholderId);
            if (ph) ph.style.display = 'none';
        };
        reader.readAsDataURL(input.files[0]);
    }
}
</script>
</body>
</html>
