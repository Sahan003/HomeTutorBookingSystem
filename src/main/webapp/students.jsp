<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="service.StudentService, service.TutorService, service.BookingService" %>
<%@ page import="model.Student, model.Tutor, model.Booking, java.util.List" %>
<%
    String userName  = (String) session.getAttribute("userName");
    String userEmail = (String) session.getAttribute("userEmail");
    String userRole  = (String) session.getAttribute("userRole");

    if (userName == null || userRole == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    if ("TUTOR".equals(userRole)) {
        response.sendRedirect("tutors.jsp");
        return;
    }

    // ── Dropdown data ──────────────────────────────────────────────
    String[] GRADES         = {"6","7","8","9","10","11","A/L"};
    String[] LOCATIONS      = {"Colombo","Anuradhapura","Galle","Jaffna","Matara",
                                "Kandy","Kurunegala","Negombo","Gampaha"};
    String[] QUALIFICATIONS = {"BSC Degree","MSC Degree","School Teacher","Undergraduate Student"};

    // ── Services ───────────────────────────────────────────────────
    StudentService studentService = new StudentService();
    TutorService   tutorService   = new TutorService();
    BookingService bookingService = new BookingService();

    // ── Student own profile ────────────────────────────────────────
    Student myProfile = null;
    if ("STUDENT".equals(userRole)) {
        myProfile = studentService.getStudentByEmail(userEmail);
    }
    String curGrade    = (myProfile != null) ? myProfile.getGrade()    : "";
    String curLocation = (myProfile != null) ? myProfile.getLocation() : "";
    String curPhoto    = (myProfile != null && myProfile.getPhotoPath() != null)
                         ? myProfile.getPhotoPath() : "";

    // ── Tutor search (STUDENT) ─────────────────────────────────────
    String searchSubject       = request.getParameter("searchSubject");
    String searchGrade         = request.getParameter("searchGrade");
    String searchQualification = request.getParameter("searchQualification");
    String searchLocation      = request.getParameter("searchLocation");
    String searchDate          = request.getParameter("searchDate");
    String searchTime          = request.getParameter("searchTime");
    if (searchSubject       == null) searchSubject       = "";
    if (searchGrade         == null) searchGrade         = "";
    if (searchQualification == null) searchQualification = "";
    if (searchLocation      == null) searchLocation      = "";
    if (searchDate          == null) searchDate          = "";
    if (searchTime          == null) searchTime          = "";

    boolean searched = !searchSubject.trim().isEmpty() || !searchGrade.isEmpty()
                       || !searchQualification.isEmpty() || !searchLocation.isEmpty();
    List<Tutor> matchedTutors = null;
    if (searched) {
        matchedTutors = tutorService.searchTutors(searchSubject, searchGrade,
                                                   searchQualification, searchLocation);
    }

    // ── Edit booking ───────────────────────────────────────────────
    String  editBookingId = request.getParameter("editBookingId");
    Booking editBooking   = null;
    if (editBookingId != null && !editBookingId.isEmpty()) {
        editBooking = bookingService.getBookingById(editBookingId);
        if (editBooking != null
                && !"ADMIN".equals(userRole)
                && !editBooking.getStudentEmail().equals(userEmail)) {
            editBooking = null;
        }
    }

    // ── Booking lists ──────────────────────────────────────────────
    List<Booking> bookings = "STUDENT".equals(userRole)
        ? bookingService.getBookingsByStudentEmail(userEmail)
        : bookingService.getAllBookings();

    // ── All students (ADMIN) ───────────────────────────────────────
    List<Student> allStudents = "ADMIN".equals(userRole)
        ? studentService.getAllStudents() : null;
%>
<!DOCTYPE html>
<html>
<head>
    <title>Student Management - Home Tutor Booking System</title>
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
            <% } %>
            <li class="nav-item">
                <a class="nav-link active" href="students.jsp">
                    <i class="bi bi-people me-1"></i>Student Management
                </a>
            </li>
            <% if ("ADMIN".equals(userRole)) { %>
            <li class="nav-item"><a class="nav-link" href="tutors.jsp"><i class="bi bi-person-workspace me-1"></i>Tutors</a></li>
            <li class="nav-item"><a class="nav-link" href="bookings.jsp"><i class="bi bi-calendar-check me-1"></i>All Bookings</a></li>
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
        <h3 class="page-title mb-0"><i class="bi bi-people-fill me-2"></i>Student Management</h3>
        <span class="text-muted small">
            <strong><%= userName %></strong>
            &nbsp;<span class="badge bg-primary"><%= userRole %></span>
        </span>
    </div>

    <!-- ── Alerts ── -->
    <% String succ = request.getParameter("success"); %>
    <% if ("profileSaved".equals(succ)) { %>
        <div class="alert alert-success alert-dismissible fade show py-2">
            <i class="bi bi-check-circle me-1"></i>Profile saved successfully!
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("booked".equals(succ)) { %>
        <div class="alert alert-success alert-dismissible fade show py-2">
            <i class="bi bi-check-circle me-1"></i>Tutor booked! Status: <strong>Pending</strong>.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("updated".equals(succ)) { %>
        <div class="alert alert-success alert-dismissible fade show py-2">
            <i class="bi bi-check-circle me-1"></i>Booking updated.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("cancelled".equals(succ)) { %>
        <div class="alert alert-info alert-dismissible fade show py-2">
            <i class="bi bi-info-circle me-1"></i>Booking cancelled.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } else if ("deleted".equals(succ)) { %>
        <div class="alert alert-warning alert-dismissible fade show py-2">
            <i class="bi bi-trash me-1"></i>Student profile deleted.
            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
        </div>
    <% } %>

    <!-- ════════════════════════════════════════════════════
         STUDENT ROLE
    ════════════════════════════════════════════════════ -->
    <% if ("STUDENT".equals(userRole)) { %>

    <!-- ── 1. MY PROFILE ── -->
    <div class="table-card mb-4">
        <h5 class="fw-bold mb-4">
            <i class="bi bi-person-circle me-2 text-primary"></i>My Student Profile
            <% if (myProfile == null) { %>
                <span class="badge bg-warning text-dark ms-2">Incomplete – please fill your profile</span>
            <% } else { %>
                <span class="badge bg-success ms-2">Complete</span>
            <% } %>
        </h5>

        <form action="students" method="post" enctype="multipart/form-data" class="row g-3">
            <input type="hidden" name="action" value="saveProfile">

            <!-- Profile photo preview + upload -->
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

            <!-- Text fields -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Full Name</label>
                <input type="text" name="name" class="form-control"
                       value="<%= myProfile != null ? myProfile.getName() : "" %>" required>
            </div>
            <div class="col-md-4">
                <label class="form-label fw-semibold">Mobile Number</label>
                <input type="text" name="phone" class="form-control"
                       value="<%= myProfile != null ? myProfile.getPhone() : "" %>" required>
            </div>
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

            <!-- Grade dropdown -->
            <div class="col-md-4">
                <label class="form-label fw-semibold">Grade / Class</label>
                <select name="grade" class="form-select" required>
                    <option value="">-- Select Grade --</option>
                    <% for (String g : GRADES) { %>
                    <option value="<%= g %>" <%= g.equals(curGrade) ? "selected" : "" %>>
                        <%= "A/L".equals(g) ? "A/L (Advanced Level)" : "Grade " + g %>
                    </option>
                    <% } %>
                </select>
            </div>

            <div class="col-12">
                <button type="submit" class="btn btn-primary px-4">
                    <i class="bi bi-save me-1"></i>
                    <%= myProfile == null ? "Save Profile" : "Update Profile" %>
                </button>
            </div>
        </form>
    </div>

    <!-- ── 2. SEARCH TUTORS ── -->
    <% if (myProfile != null) { %>
    <div class="table-card mb-4">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-search me-2 text-success"></i>Search Available Tutors
        </h5>

        <form action="students.jsp" method="get" class="row g-3">
            <!-- Subject – text -->
            <div class="col-md-4 col-lg-2">
                <label class="form-label fw-semibold">Subject</label>
                <input type="text" name="searchSubject" class="form-control"
                       placeholder="e.g. Mathematics"
                       value="<%= searchSubject %>">
            </div>

            <!-- Grade – dropdown -->
            <div class="col-md-4 col-lg-2">
                <label class="form-label fw-semibold">Grade</label>
                <select name="searchGrade" class="form-select">
                    <option value="">-- Any Grade --</option>
                    <% for (String g : GRADES) { %>
                    <option value="<%= g %>" <%= g.equals(searchGrade) ? "selected" : "" %>>
                        <%= "A/L".equals(g) ? "A/L" : "Grade " + g %>
                    </option>
                    <% } %>
                </select>
            </div>

            <!-- Qualification – dropdown -->
            <div class="col-md-4 col-lg-2">
                <label class="form-label fw-semibold">Qualification</label>
                <select name="searchQualification" class="form-select">
                    <option value="">-- Any --</option>
                    <% for (String q : QUALIFICATIONS) { %>
                    <option value="<%= q %>" <%= q.equals(searchQualification) ? "selected" : "" %>><%= q %></option>
                    <% } %>
                </select>
            </div>

            <!-- Location – dropdown -->
            <div class="col-md-4 col-lg-2">
                <label class="form-label fw-semibold">Location</label>
                <select name="searchLocation" class="form-select">
                    <option value="">-- Any Location --</option>
                    <% for (String loc : LOCATIONS) { %>
                    <option value="<%= loc %>" <%= loc.equals(searchLocation) ? "selected" : "" %>><%= loc %></option>
                    <% } %>
                </select>
            </div>

            <!-- Date -->
            <div class="col-md-4 col-lg-2">
                <label class="form-label fw-semibold">Booking Date</label>
                <input type="date" name="searchDate" class="form-control"
                       value="<%= searchDate %>" required>
            </div>

            <!-- Time -->
            <div class="col-md-4 col-lg-2">
                <label class="form-label fw-semibold">Booking Time</label>
                <input type="time" name="searchTime" class="form-control"
                       value="<%= searchTime %>" required>
            </div>

            <div class="col-12">
                <button type="submit" class="btn btn-success">
                    <i class="bi bi-search me-1"></i>Search Tutors
                </button>
                <a href="students.jsp" class="btn btn-outline-secondary ms-2">
                    <i class="bi bi-x me-1"></i>Clear
                </a>
            </div>
        </form>

        <!-- Search Results -->
        <% if (searched) { %>
        <hr class="my-3">
        <h6 class="fw-bold text-secondary mb-3">
            <i class="bi bi-list-ul me-1"></i>Search Results
            <span class="badge bg-secondary ms-1">
                <%= matchedTutors != null ? matchedTutors.size() : 0 %> found
            </span>
        </h6>

        <% if (matchedTutors == null || matchedTutors.isEmpty()) { %>
            <div class="alert alert-info">
                <i class="bi bi-info-circle me-1"></i>
                No tutors found. Try adjusting subject, grade, or remove location/qualification filters.
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle">
                <thead class="table-success">
                <tr>
                    <th>Photo</th>
                    <th>Tutor</th>
                    <th>Subjects</th>
                    <th>Teaching Grade</th>
                    <th>Qualification</th>
                    <th>Location</th>
                    <th>Rate (Rs./hr)</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (Tutor t : matchedTutors) { %>
                <tr>
                    <td>
                        <% if (t.getPhotoPath() != null && !t.getPhotoPath().isEmpty()) { %>
                            <img src="<%= t.getPhotoPath() %>" class="table-avatar" alt="<%= t.getName() %>">
                        <% } else { %>
                            <span class="table-avatar-icon"><i class="bi bi-person-circle"></i></span>
                        <% } %>
                    </td>
                    <td>
                        <strong><%= t.getName() %></strong><br>
                        <small class="text-muted"><%= t.getEmail() %></small>
                    </td>
                    <td><%= t.getSubjects() %></td>
                    <td>
                        <% String tg = t.getTeachingGrade(); %>
                        <%= "A/L".equals(tg) ? "A/L (Advanced Level)" : "Grade " + tg %>
                    </td>
                    <td><%= t.getQualification() %></td>
                    <td><i class="bi bi-geo-alt me-1 text-muted"></i><%= t.getLocation() %></td>
                    <td><strong class="text-success">Rs. <%= String.format("%.2f", t.getHourlyRate()) %></strong></td>
                    <td>
                        <form action="bookings" method="post">
                            <input type="hidden" name="action"        value="book">
                            <input type="hidden" name="tutorEmail"    value="<%= t.getEmail() %>">
                            <input type="hidden" name="tutorName"     value="<%= t.getName() %>">
                            <input type="hidden" name="subject"       value="<%= searchSubject %>">
                            <input type="hidden" name="grade"         value="<%= searchGrade %>">
                            <input type="hidden" name="qualification" value="<%= searchQualification %>">
                            <input type="hidden" name="location"      value="<%= searchLocation %>">
                            <input type="hidden" name="bookingDate"   value="<%= searchDate %>">
                            <input type="hidden" name="bookingTime"   value="<%= searchTime %>">
                            <button type="submit" class="btn btn-sm btn-primary">
                                <i class="bi bi-calendar-plus me-1"></i>Book
                            </button>
                        </form>
                    </td>
                </tr>
                <% } %>
                </tbody>
            </table>
        </div>
        <% } %>
        <% } /* end searched */ %>
    </div>
    <% } /* end myProfile != null */ %>

    <!-- ── 3. MY BOOKINGS ── -->
    <div class="table-card mb-4">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-calendar2-week me-2 text-warning"></i>My Booked Tutors
            <span class="badge bg-secondary"><%= bookings != null ? bookings.size() : 0 %></span>
        </h5>

        <!-- Edit booking form -->
        <% if (editBooking != null) { %>
        <div class="alert alert-warning mb-3">
            <strong><i class="bi bi-pencil me-1"></i>Editing:</strong> <%= editBooking.getBookingId() %>
        </div>
        <form action="bookings" method="post" class="row g-3 mb-4">
            <input type="hidden" name="action"    value="update">
            <input type="hidden" name="bookingId" value="<%= editBooking.getBookingId() %>">

            <div class="col-md-3">
                <label class="form-label fw-semibold">Subject</label>
                <input type="text" name="subject" class="form-control"
                       value="<%= editBooking.getSubject() %>" required>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Grade</label>
                <select name="grade" class="form-select">
                    <option value="">-- Any Grade --</option>
                    <% for (String g : GRADES) { %>
                    <option value="<%= g %>" <%= g.equals(editBooking.getGrade()) ? "selected" : "" %>>
                        <%= "A/L".equals(g) ? "A/L" : "Grade " + g %>
                    </option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Qualification</label>
                <select name="qualification" class="form-select">
                    <option value="">-- Any --</option>
                    <% for (String q : QUALIFICATIONS) { %>
                    <option value="<%= q %>" <%= q.equals(editBooking.getQualification()) ? "selected" : "" %>><%= q %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Location</label>
                <select name="location" class="form-select">
                    <option value="">-- Any --</option>
                    <% for (String loc : LOCATIONS) { %>
                    <option value="<%= loc %>" <%= loc.equals(editBooking.getLocation()) ? "selected" : "" %>><%= loc %></option>
                    <% } %>
                </select>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Booking Date</label>
                <input type="date" name="bookingDate" class="form-control"
                       value="<%= editBooking.getBookingDate() %>" required>
            </div>
            <div class="col-md-3">
                <label class="form-label fw-semibold">Booking Time</label>
                <input type="time" name="bookingTime" class="form-control"
                       value="<%= editBooking.getBookingTime() %>" required>
            </div>
            <div class="col-12">
                <button type="submit" class="btn btn-warning">
                    <i class="bi bi-save me-1"></i>Update Booking
                </button>
                <a href="students.jsp" class="btn btn-outline-secondary ms-2">Cancel</a>
            </div>
        </form>
        <hr>
        <% } %>

        <% if (bookings == null || bookings.isEmpty()) { %>
            <div class="alert alert-info mb-0">
                <i class="bi bi-info-circle me-1"></i>
                No bookings yet. Search for a tutor above and click <strong>Book</strong>.
            </div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-warning">
                <tr>
                    <th>Booking ID</th>
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
                <% for (Booking b : bookings) {
                       String bc = "bg-warning text-dark";
                       if ("Reserved".equals(b.getStatus()))  bc = "bg-success";
                       if ("Rejected".equals(b.getStatus()))  bc = "bg-danger";
                %>
                <tr>
                    <td><small class="text-muted"><%= b.getBookingId() %></small></td>
                    <td>
                        <strong><%= b.getTutorName() %></strong><br>
                        <small class="text-muted"><%= b.getTutorEmail() %></small>
                    </td>
                    <td><%= b.getSubject() %></td>
                    <td><%= b.getGrade().isEmpty() ? "—" : b.getGrade() %></td>
                    <td><%= b.getBookingDate() %></td>
                    <td><%= b.getBookingTime() %></td>
                    <td><span class="badge <%= bc %>"><%= b.getStatus() %></span></td>
                    <td>
                        <% if ("Pending".equals(b.getStatus())) { %>
                        <a href="students.jsp?editBookingId=<%= b.getBookingId() %>"
                           class="btn btn-sm btn-warning me-1">
                            <i class="bi bi-pencil"></i> Edit
                        </a>
                        <% } %>
                        <form action="bookings" method="post" style="display:inline;"
                              onsubmit="return confirm('Cancel this booking?');">
                            <input type="hidden" name="action"    value="delete">
                            <input type="hidden" name="bookingId" value="<%= b.getBookingId() %>">
                            <button type="submit" class="btn btn-sm btn-outline-danger">
                                <i class="bi bi-x-circle"></i> Cancel
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

    <!-- ════════════════════════════════════════════════════
         ADMIN ROLE
    ════════════════════════════════════════════════════ -->
    <% } else if ("ADMIN".equals(userRole)) { %>

    <!-- All student profiles -->
    <div class="table-card mb-4">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-people me-2 text-primary"></i>All Student Profiles
            <span class="badge bg-secondary"><%= allStudents != null ? allStudents.size() : 0 %></span>
        </h5>
        <% if (allStudents == null || allStudents.isEmpty()) { %>
            <div class="alert alert-info mb-0">No student profiles found.</div>
        <% } else { %>
        <div class="table-responsive">
            <table class="table table-hover align-middle mb-0">
                <thead class="table-primary">
                <tr>
                    <th>Photo</th>
                    <th>Name</th>
                    <th>Email</th>
                    <th>Phone</th>
                    <th>Location</th>
                    <th>Grade</th>
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (Student s : allStudents) { %>
                <tr>
                    <td>
                        <% if (s.getPhotoPath() != null && !s.getPhotoPath().isEmpty()) { %>
                            <img src="<%= s.getPhotoPath() %>" class="table-avatar" alt="<%= s.getName() %>">
                        <% } else { %>
                            <span class="table-avatar-icon"><i class="bi bi-person-circle"></i></span>
                        <% } %>
                    </td>
                    <td><strong><%= s.getName() %></strong></td>
                    <td><small><%= s.getEmail() %></small></td>
                    <td><%= s.getPhone() %></td>
                    <td><%= s.getLocation() %></td>
                    <td>
                        <%= "A/L".equals(s.getGrade()) ? "A/L" : "Grade " + s.getGrade() %>
                    </td>
                    <td>
                        <form action="students" method="post" style="display:inline;"
                              onsubmit="return confirm('Delete this student profile?');">
                            <input type="hidden" name="action" value="delete">
                            <input type="hidden" name="email"  value="<%= s.getEmail() %>">
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

    <!-- All bookings (admin view on this page) -->
    <div class="table-card">
        <h5 class="fw-bold mb-3">
            <i class="bi bi-calendar-check me-2 text-warning"></i>All Booking Records
            <span class="badge bg-secondary"><%= bookings != null ? bookings.size() : 0 %></span>
        </h5>
        <% if (bookings == null || bookings.isEmpty()) { %>
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
                    <th>Action</th>
                </tr>
                </thead>
                <tbody>
                <% for (Booking b : bookings) {
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
