<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.concurrent.TimeUnit" %>
<%@ page import="java.util.Collections" %>
<%@ page import="java.util.Comparator" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.sql.*" %>
<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
        <title>GIP Monitoring - Pangil | GIP Portal | DOLE</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            body, h1, h2, p, img, form, input, select, textarea {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Roboto', sans-serif;
                background: #f4f4f9;
                color: #333;
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                overflow-x: hidden;
            }

            header {
                background-color: #004d99;
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 5px rgba(0,0,0,0.1);
                position: sticky;
                top: 0;
                z-index: 100;
            }

            .logo-container {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .logo {
                width: 70px;
                height: 70px;
                object-fit: contain;
            }

            .header-text {
                font-size: 1.5em;
                font-weight: 700;
            }

            .logout-btn {
                background-color: #cc0000;
                color: white;
                border: none;
                padding: 10px 20px;
                border-radius: 30px;
                cursor: pointer;
                font-size: 1em;
                display: flex;
                align-items: center;
                gap: 8px;
                transition: all 0.3s ease;
            }

            .logout-btn:hover {
                background-color: #b30000;
                transform: translateY(-2px);
            }

            .main-wrapper {
                display: flex;
                flex: 1;
                height: calc(100vh - 80px);
            }

             .sidebar {
                width: 80px;
                background-color: #003366;
                color: white;
                padding: 30px 0;
                overflow-y: auto;
                transition: width 0.3s ease;
            }

            .sidebar:hover {
                width: 280px;
            }

            .sidebar-header {
                padding: 0 20px 20px;
                border-bottom: 1px solid rgba(255,255,255,0.1);
                margin-bottom: 20px;
                white-space: nowrap;
                overflow: hidden;
            }

            .sidebar-header h2 {
                font-size: 1.3em;
                display: none;
            }

            .sidebar:hover .sidebar-header h2 {
                display: block;
            }

            .sidebar-item {
                padding: 15px 20px;
                margin-bottom: 5px;
                font-size: 1.1em;
                cursor: pointer;
                transition: all 0.3s ease;
                display: flex;
                align-items: center;
                gap: 15px;
                border-left: 4px solid transparent;
                white-space: nowrap;
                overflow: hidden;
            }

            .sidebar-item i {
                font-size: 1.5em;
                width: 40px;
                text-align: center;
            }

            .sidebar-item span {
                display: none;
            }

            .sidebar:hover .sidebar-item span {
                display: inline;
            }

            .sidebar-item:hover {
                background-color: #003366;
            }

            .sidebar-item.active {
                background-color: #003366;
                border-left: 4px solid #ffcc00;
            }

            .content-area {
                display: flex;
                flex: 1;
                overflow: hidden;
            }

            .main-content {
                flex: 1;
                padding: 30px;
                overflow-y: auto;
                background-color: #f4f4f9;
            }

            .dashboard-section {
                background-color: white;
                padding: 25px;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                margin-bottom: 30px;
            }

            .dashboard-section h2 {
                font-size: 1.5em;
                color: #004d99;
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
            }

            .data-table {
                width: 100%;
                background-color: white;
                border-radius: 10px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.08);
                overflow-x: auto;
                margin-top: 20px;
                display: block;
            }

            table {
                width: 100%;
                border-collapse: collapse;
                min-width: 1100px;
            }

            th, td {
                padding: 15px;
                text-align: left;
                border-bottom: 1px solid #eee;
            }

            th {
                background-color: #004d99;
                color: white;
                font-weight: 500;
            }

            tr:hover {
                background-color: #f5f9ff;
            }

            .action-btn-container {
                display: flex;
                flex-wrap: nowrap;
                gap: 5px;
            }

            .action-btn {
                padding: 8px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.9em;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                white-space: nowrap;
            }

            .edit-btn {
                background-color: #ffcc00;
                color: #333;
            }

            .save-btn {
                background-color: #2e7d32;
                color: white;
            }

            .cancel-btn {
                background-color: #757575;
                color: white;
            }

            .alert-btn {
                background-color: #d32f2f;
                color: white;
            }

            .absent-btn {
                background-color: #ff9800;
                color: white;
            }

            .view-btn {
                background-color: #2196F3;
                color: white;
            }

            .late-btn {
                background-color: #ff5722;
                color: white;
            }

            .cutoff-btn {
                background-color: #9c27b0;
                color: white;
            }

            .delete-btn {
                background-color: #d32f2f;
                color: white;
            }

            .status-badge {
                padding: 5px 10px;
                border-radius: 20px;
                font-size: 0.8em;
                font-weight: 500;
            }

            .status-new {
                background-color: #e6f7e6;
                color: #2e7d32;
            }

            .status-renew {
                background-color: #fff8e1;
                color: #ff8f00;
            }

            .status-completed {
                background-color: #f0f0f0;
                color: #666;
            }

            .form-control {
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
                font-family: 'Roboto', sans-serif;
                width: 100%;
            }

            .search-filter {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
            }

            .search-box {
                flex: 1;
            }

            .filter-box {
                width: 200px;
            }

            .pagination {
                display: flex;
                justify-content: center;
                margin-top: 20px;
                gap: 5px;
            }

            .page-btn {
                padding: 8px 12px;
                border: 1px solid #ddd;
                background-color: white;
                cursor: pointer;
                border-radius: 4px;
            }

            .page-btn.active {
                background-color: #004d99;
                color: white;
                border-color: #004d99;
            }

            .page-btn:hover:not(.active) {
                background-color: #f0f0f0;
            }

            .export-buttons {
                display: flex;
                gap: 10px;
                margin-bottom: 20px;
            }

            .export-btn {
                padding: 10px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.9em;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                background-color: #004d99;
                color: white;
                text-decoration: none;
            }

            .export-btn:hover {
                background-color: #003366;
            }

            .add-gip-btn {
                padding: 10px 15px;
                border: none;
                border-radius: 5px;
                cursor: pointer;
                font-size: 0.9em;
                transition: all 0.3s ease;
                display: inline-flex;
                align-items: center;
                gap: 5px;
                background-color: #2e7d32;
                color: white;
            }

            .add-gip-btn:hover {
                background-color: #1b5e20;
            }

            /* Modal styles */
            .modal {
                display: none;
                position: fixed;
                z-index: 1000;
                left: 0;
                top: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
                overflow: auto;
            }

            .modal-content {
                background-color: #fff;
                margin: 5% auto;
                padding: 20px;
                border-radius: 8px;
                width: 80%;
                max-width: 800px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.2);
                max-height: 90vh;
                overflow-y: auto;
            }

            .modal-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                border-bottom: 1px solid #eee;
                padding-bottom: 15px;
                margin-bottom: 15px;
            }

            .modal-header h3 {
                color: #004d99;
                font-size: 1.5em;
                font-weight: 700;
            }

            .close-btn {
                background: none;
                border: none;
                font-size: 1.5em;
                cursor: pointer;
                color: #666;
            }

            .modal-body {
                margin-bottom: 20px;
            }

            .form-group {
                margin-bottom: 15px;
            }

            .form-group label {
                display: block;
                margin-bottom: 5px;
                font-weight: 500;
            }

            .form-group input,
            .form-group select,
            .form-group textarea {
                width: 100%;
                padding: 8px;
                border: 1px solid #ddd;
                border-radius: 4px;
            }

            .modal-footer {
                display: flex;
                justify-content: flex-end;
                gap: 10px;
                border-top: 1px solid #eee;
                padding-top: 15px;
            }

            /* Alert styles */
            .alert-message {
                padding: 15px;
                margin-bottom: 20px;
                border-radius: 4px;
                display: flex;
                align-items: center;
                gap: 10px;
                animation: fadeIn 0.5s ease-in-out;
            }

            @keyframes fadeIn {
                from {
                    opacity: 0;
                    transform: translateY(-20px);
                }
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            .alert-success {
                background-color: #dff0d8;
                color: #3c763d;
                border: 1px solid #d6e9c6;
            }

            .alert-info {
                background-color: #d9edf7;
                color: #31708f;
                border: 1px solid #bce8f1;
            }

            .alert-warning {
                background-color: #fcf8e3;
                color: #8a6d3b;
                border: 1px solid #faebcc;
            }

            .alert-danger {
                background-color: #f2dede;
                color: #a94442;
                border: 1px solid #ebccd1;
            }

            .alert-icon {
                font-size: 1.5em;
            }

            /* SweetAlert-like custom alert */
            .custom-alert {
                display: none;
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background-color: rgba(0,0,0,0.5);
                z-index: 1100;
                justify-content: center;
                align-items: center;
            }

            .custom-alert-content {
                background-color: white;
                border-radius: 10px;
                width: 90%;
                max-width: 400px;
                box-shadow: 0 5px 15px rgba(0,0,0,0.3);
                overflow: hidden;
                animation: alertFadeIn 0.3s ease-out;
            }

            @keyframes alertFadeIn {
                from {
                    opacity: 0;
                    transform: scale(0.8);
                }
                to {
                    opacity: 1;
                    transform: scale(1);
                }
            }

            .custom-alert-header {
                padding: 15px 20px;
                background-color: #004d99;
                color: white;
                font-size: 1.2em;
                font-weight: 500;
            }

            .custom-alert-body {
                padding: 20px;
                text-align: center;
            }

            .custom-alert-footer {
                padding: 15px;
                display: flex;
                justify-content: center;
                gap: 10px;
                border-top: 1px solid #eee;
            }

            .custom-alert-btn {
                padding: 8px 20px;
                border: none;
                border-radius: 4px;
                cursor: pointer;
                font-weight: 500;
            }

            .custom-alert-btn-confirm {
                background-color: #004d99;
                color: white;
            }

            .custom-alert-btn-cancel {
                background-color: #f0f0f0;
                color: #333;
            }

            /* Responsive adjustments */
            @media (max-width: 1200px) {
                .sidebar {
                    width: 70px;
                }
                .sidebar:hover {
                    width: 240px;
                }
            }

            @media (max-width: 992px) {
                .sidebar {
                    width: 60px;
                    padding: 20px 0;
                }
                .sidebar:hover {
                    width: 220px;
                }

                .sidebar-item {
                    padding: 12px 15px;
                }

                .main-content {
                    padding: 20px;
                }
            }

            @media (max-width: 768px) {
                .main-wrapper {
                    flex-direction: column;
                    height: auto;
                }

                .sidebar {
                    width: 100%;
                    padding: 15px 0;
                }
                .sidebar:hover {
                    width: 100%;
                }

                .sidebar-header {
                    padding: 0 20px 15px;
                }

                .sidebar-item {
                    padding: 10px 20px;
                }

                .content-area {
                    flex-direction: column;
                }

                .search-filter {
                    flex-direction: column;
                    gap: 10px;
                }

                .filter-box {
                    width: 100%;
                }

                .modal-content {
                    width: 95%;
                    margin: 10% auto;
                }
            }

            @media (max-width: 576px) {
                header {
                    padding: 10px 15px;
                    flex-direction: column;
                    gap: 10px;
                    text-align: center;
                }

                .logo-container {
                    flex-direction: column;
                    gap: 5px;
                }

                .modal-content {
                    width: 98%;
                    padding: 15px;
                }

                .modal-footer {
                    flex-direction: column;
                    gap: 5px;
                }

                .custom-alert-content {
                    width: 95%;
                }

                .action-btn-container {
                    flex-direction: column;
                }

                .action-btn {
                    width: 100%;
                    justify-content: center;
                }
            }
        </style>
    </head>
    <body>
        <%
            class GipRecord {

                String idNo;
                String lastName;
                String firstName;
                String middleName;
                String extensionName;
                String street;
                String barangay;
                String municipality;
                String province;
                String contactNumber;
                String sex;
                String birthDate;
                int daysWorked;
                int numberLate;
                double totalLate;
                double amountWages;
                double netAmount;
                String signature;
                String startDate;
                String endDate;
                String status;
                String rawEndDate;
                int absences;
                int extendedDays;
                double dailyWage = 560.00;

                public GipRecord(String idNo, String lastName, String firstName, String middleName, String extensionName,
                        String street, String barangay, String municipality, String province, String contactNumber,
                        String sex, String birthDate, String startDate, String endDate, String status,
                        int daysWorked, int numberLate, double totalLate, int absences) {
                    this.idNo = idNo;
                    this.lastName = lastName;
                    this.firstName = firstName;
                    this.middleName = middleName;
                    this.extensionName = extensionName;
                    this.street = street;
                    this.barangay = barangay;
                    this.municipality = municipality;
                    this.province = province;
                    this.contactNumber = contactNumber;
                    this.sex = sex;
                    this.birthDate = birthDate;
                    this.startDate = startDate;
                    this.endDate = endDate;
                    this.rawEndDate = endDate;
                    this.status = status;
                    this.absences = absences;
                    this.extendedDays = 0;
                    this.daysWorked = daysWorked;
                    this.numberLate = numberLate;
                    this.totalLate = totalLate;
                    this.amountWages = daysWorked * dailyWage;
                    this.netAmount = this.amountWages - (totalLate * 2) - (absences * dailyWage);
                    this.signature = "";
                }

                public String getFullName() {
                    return lastName + ", " + firstName + (middleName.isEmpty() ? "" : " " + middleName)
                            + (extensionName.isEmpty() ? "" : " " + extensionName);
                }

                public void setWorkDetails(int daysWorked, int absences, int numberLate, double totalLate) {
                    this.daysWorked = daysWorked;
                    this.absences = absences;
                    this.numberLate = numberLate;
                    this.totalLate = totalLate;
                    calculateNetAmount();
                }

                private void calculateNetAmount() {
                    this.amountWages = this.daysWorked * dailyWage;
                    double lateDeduction = totalLate * 2;
                    double absenceDeduction = absences * dailyWage;
                    this.netAmount = amountWages - lateDeduction - absenceDeduction;
                    if (this.netAmount < 0) {
                        this.netAmount = 0;
                    }
                }

                public void extendContract(int days) {
                    try {
                        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
                        Date endDateObj = sdf.parse(rawEndDate);

                        long newTime = endDateObj.getTime() + (days * 24L * 60 * 60 * 1000);
                        Date newEndDate = new Date(newTime);

                        rawEndDate = sdf.format(newEndDate);
                        SimpleDateFormat displayFormat = new SimpleDateFormat("MMMM d, yyyy");
                        endDate = displayFormat.format(newEndDate);
                        extendedDays += days;

                        if (!status.equals("Completed")) {
                            status = "Renewed";
                        }
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }

            String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
            String dbUser = "";
            String dbPass = "";

            List<GipRecord> gipRecords = new ArrayList<>();
            String bayanName = "Pangil";

            try {
                Class.forName("org.apache.derby.jdbc.ClientDriver");
                Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

                String query = "SELECT * FROM gip_records WHERE municipality = ?";
                PreparedStatement pstmt = conn.prepareStatement(query);
                pstmt.setString(1, bayanName);

                ResultSet rs = pstmt.executeQuery();

                SimpleDateFormat displayFormat = new SimpleDateFormat("MMMM d, yyyy");
                SimpleDateFormat dbDateFormat = new SimpleDateFormat("yyyy-MM-dd");

                while (rs.next()) {
                    String idNo = rs.getString("id_no");
                    String lastName = rs.getString("last_name");
                    String firstName = rs.getString("first_name");
                    String middleName = rs.getString("middle_name");
                    String extensionName = rs.getString("extension_name");
                    String street = rs.getString("street");
                    String barangay = rs.getString("barangay");
                    String municipality = rs.getString("municipality");
                    String province = rs.getString("province");
                    String contactNumber = rs.getString("contact_number");
                    String sex = rs.getString("sex");

                    Date birthDate = rs.getDate("birth_date");
                    String formattedBirthDate = birthDate != null ? displayFormat.format(birthDate) : "";

                    Date startDate = rs.getDate("start_date");
                    String formattedStartDate = startDate != null ? dbDateFormat.format(startDate) : "";

                    Date endDate = rs.getDate("end_date");
                    String formattedEndDate = endDate != null ? dbDateFormat.format(endDate) : "";

                    String status = rs.getString("status");
                    int daysWorked = rs.getInt("days_worked");
                    int numberLate = rs.getInt("number_late");
                    double totalLate = rs.getDouble("total_late");
                    int absences = rs.getInt("absences");

                    GipRecord record = new GipRecord(
                            idNo, lastName, firstName, middleName, extensionName,
                            street, barangay, municipality, province, contactNumber,
                            sex, formattedBirthDate, formattedStartDate, formattedEndDate,
                            status, daysWorked, numberLate, totalLate, absences
                    );

                    gipRecords.add(record);
                }

                rs.close();
                pstmt.close();
                conn.close();

            } catch (ClassNotFoundException | SQLException e) {
                e.printStackTrace();
                session.setAttribute("errorMessage", "Database error: " + e.getMessage());
            }

            String successMessage = (String) session.getAttribute("successMessage");
            String errorMessage = (String) session.getAttribute("errorMessage");
        %>

        <header>
            <div class="logo-container">
                <img src="https://i.postimg.cc/0QvVb3kG/gip2.png" alt="GIP Portal Logo" class="logo">
                <span class="header-text">GIP Portal - <%= bayanName%></span>
            </div>
        </header>

        <div class="main-wrapper">
            <div class="sidebar">
                <div class="sidebar-header">
                    <h2>Admin Menu</h2>
                </div>
                <div class="sidebar-item">
                    <i class="fas fa-home"></i>
                    <a href="adminDashboard.jsp" style="text-decoration: none; color: white;"><span>Dashboard</span></a>
                </div>
                <div class="sidebar-item active">
                    <i class="fas fa-city"></i>
                    <a href="Monitoring.jsp" style="text-decoration: none; color: white;"><span>Municipalities</span></a>
                </div>
            </div>

            <div class="content-area">
                <div class="main-content">
                    <div class="dashboard-section">
                        <h2>GIP Monitoring - <%= bayanName%></h2>

                        <% if (successMessage != null) {%>
                        <div class="alert-message alert-success">
                            <i class="fas fa-check-circle alert-icon"></i>
                            <%= successMessage%>
                        </div>
                        <%
                                session.removeAttribute("successMessage");
                            }

                            if (errorMessage != null) {
                        %>
                        <div class="alert-message alert-danger">
                            <i class="fas fa-exclamation-circle alert-icon"></i>
                            <%= errorMessage%>
                        </div>
                        <%
                                session.removeAttribute("errorMessage");
                            }
                        %>

                        <div class="export-buttons">
                            <a href="ExportExcel.jsp" class="export-btn">
                                <i class="fas fa-file-excel"></i> Export to Excel
                            </a>
                            <button class="add-gip-btn" onclick="openAddModal()">
                                <i class="fas fa-plus"></i> Add GIP
                            </button>
                        </div>

                        <div class="search-filter">
                            <div class="search-box">
                                <input type="text" class="form-control" placeholder="Search by name or ID..." id="searchInput">
                            </div>
                            <div class="filter-box">
                                <select class="form-control" id="statusFilter">
                                    <option value="">All Status</option>
                                    <option value="Active">Active</option>
                                    <option value="Renewed">Renewed</option>
                                    <option value="Completed">Completed</option>
                                </select>
                            </div>
                        </div>

                        <div class="data-table">
                            <table>
                                <thead>
                                    <tr>
                                        <th>GIP ID</th>
                                        <th>Full Name</th>
                                        <th>Address</th>
                                        <th>Contact</th>
                                        <th>Sex</th>
                                        <th>Birthdate</th>
                                        <th>Start Date</th>
                                        <th>End Date</th>
                                        <th>Days Worked</th>
                                        <th>Late Count</th>
                                        <th>Absences</th>
                                        <th>Net Amount</th>
                                        <th>Status</th>
                                        <th>Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <%
                                        for (GipRecord record : gipRecords) {
                                            String statusClass = "";
                                            if (record.status.equals("Active")) {
                                                statusClass = "status-new";
                                            } else if (record.status.equals("Renewed")) {
                                                statusClass = "status-renew";
                                            } else if (record.status.equals("Completed")) {
                                                statusClass = "status-completed";
                                            }

                                            SimpleDateFormat sdfDisplay = new SimpleDateFormat("MMMM d, yyyy");
                                            SimpleDateFormat sdfDB = new SimpleDateFormat("yyyy-MM-dd");

                                            String displayStartDate = "";
                                            String displayEndDate = "";

                                            try {
                                                Date startDate = sdfDB.parse(record.startDate);
                                                displayStartDate = sdfDisplay.format(startDate);

                                                Date endDate = sdfDB.parse(record.rawEndDate);
                                                displayEndDate = sdfDisplay.format(endDate);
                                            } catch (Exception e) {
                                                e.printStackTrace();
                                            }
                                    %>
                                    <tr>
                                        <td><%= record.idNo%></td>
                                        <td><%= record.getFullName()%></td>
                                        <td><%= record.street + ", " + record.barangay + ", " + record.municipality%></td>
                                        <td><%= record.contactNumber%></td>
                                        <td><%= record.sex%></td>
                                        <td><%= record.birthDate%></td>
                                        <td><%= displayStartDate%></td>
                                        <td><%= displayEndDate%></td>
                                        <td><%= record.daysWorked%></td>
                                        <td><%= record.numberLate%></td>
                                        <td><%= record.absences%></td>
                                        <td>₱<%= String.format("%.2f", record.netAmount)%></td>
                                        <td><span class="status-badge <%= statusClass%>"><%= record.status%></span></td>
                                        <td>
                                            <div class="action-btn-container">
                                                <% if (record.status.equals("Completed")) {%>
                                                <button class="action-btn delete-btn" onclick="confirmDelete('<%= record.idNo%>')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                                <% } else {%>
                                                <button class="action-btn edit-btn" onclick="openEditModal('<%= record.idNo%>')">
                                                    <i class="fas fa-edit"></i>
                                                </button>
                                                <button class="action-btn cutoff-btn" onclick="openWorkDetailsModal('<%= record.idNo%>')">
                                                    <i class="fas fa-calculator"></i>
                                                </button>
                                                <button class="action-btn delete-btn" onclick="confirmDelete('<%= record.idNo%>')">
                                                    <i class="fas fa-trash"></i>
                                                </button>
                                                <% } %>
                                            </div>
                                        </td>
                                    </tr>
                                    <%
                                        }
                                    %>
                                </tbody>
                            </table>
                        </div>

                        <div class="pagination">
                            <button class="page-btn active">1</button>
                            <button class="page-btn">2</button>
                            <button class="page-btn">3</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>

        <!-- Add GIP Modal -->
        <div id="addModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Add New GIP</h3>
                    <button class="close-btn" onclick="closeAddModal()">&times;</button>
                </div>
                <form action="AddGIP.jsp" method="post" onsubmit="return validateAddForm()">
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="idNo">GIP ID Number</label>
                            <input type="text" id="idNo" name="idNo" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="lastName">Last Name</label>
                            <input type="text" id="lastName" name="lastName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="firstName">First Name</label>
                            <input type="text" id="firstName" name="firstName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="middleName">Middle Name</label>
                            <input type="text" id="middleName" name="middleName" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="extensionName">Extension Name</label>
                            <input type="text" id="extensionName" name="extensionName" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="street">Street</label>
                            <input type="text" id="street" name="street" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="barangay">Barangay</label>
                            <input type="text" id="barangay" name="barangay" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="municipality">Municipality</label>
                            <input type="text" id="municipality" name="municipality" class="form-control" value="<%= bayanName%>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="province">Province</label>
                            <input type="text" id="province" name="province" class="form-control" value="Laguna" readonly>
                        </div>
                        <div class="form-group">
                            <label for="contactNumber">Contact Number</label>
                            <input type="text" id="contactNumber" name="contactNumber" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="sex">Sex</label>
                            <select id="sex" name="sex" class="form-control" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="birthDate">Birthdate</label>
                            <input type="date" id="birthDate" name="birthDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="startDate">Start Date</label>
                            <input type="date" id="startDate" name="startDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="endDate">End Date</label>
                            <input type="date" id="endDate" name="endDate" class="form-control" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="action-btn cancel-btn" onclick="closeAddModal()">Cancel</button>
                        <button type="submit" class="action-btn save-btn">Save</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Edit GIP Modal -->
        <div id="editModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Edit GIP Record</h3>
                    <button class="close-btn" onclick="closeEditModal()">&times;</button>
                </div>
                <form action="EditGIP.jsp" method="post">
                    <input type="hidden" id="editIdNo" name="editIdNo">
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="editLastName">Last Name</label>
                            <input type="text" id="editLastName" name="editLastName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="editFirstName">First Name</label>
                            <input type="text" id="editFirstName" name="editFirstName" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="editMiddleName">Middle Name</label>
                            <input type="text" id="editMiddleName" name="editMiddleName" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="editExtensionName">Extension Name</label>
                            <input type="text" id="editExtensionName" name="editExtensionName" class="form-control">
                        </div>
                        <div class="form-group">
                            <label for="editStreet">Street</label>
                            <input type="text" id="editStreet" name="editStreet" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="editBarangay">Barangay</label>
                            <input type="text" id="editBarangay" name="editBarangay" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="editMunicipality">Municipality</label>
                            <input type="text" id="editMunicipality" name="editMunicipality" class="form-control" value="<%= bayanName%>" readonly>
                        </div>
                        <div class="form-group">
                            <label for="editProvince">Province</label>
                            <input type="text" id="editProvince" name="editProvince" class="form-control" value="Laguna" readonly>
                        </div>
                        <div class="form-group">
                            <label for="editContactNumber">Contact Number</label>
                            <input type="text" id="editContactNumber" name="editContactNumber" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="editSex">Sex</label>
                            <select id="editSex" name="editSex" class="form-control" required>
                                <option value="Male">Male</option>
                                <option value="Female">Female</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label for="editBirthDate">Birthdate</label>
                            <input type="date" id="editBirthDate" name="editBirthDate" class="form-control" required>
                        </div>
                        <div class="form-group">
                            <label for="editStatus">Status</label>
                            <select id="editStatus" name="editStatus" class="form-control">
                                <option value="Active">Active</option>
                                <option value="Renewed">Renewed</option>
                                <option value="Completed">Completed</option>
                            </select>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="action-btn cancel-btn" onclick="closeEditModal()">Cancel</button>
                        <button type="submit" class="action-btn save-btn">Save Changes</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Work Details Modal -->
        <div id="workDetailsModal" class="modal">
            <div class="modal-content">
                <div class="modal-header">
                    <h3>Update Work Details</h3>
                    <button class="close-btn" onclick="closeWorkDetailsModal()">&times;</button>
                </div>
                <form action="UpdateWorkDetails.jsp" method="post">
                    <input type="hidden" id="workDetailsRecordId" name="recordId">
                    <div class="modal-body">
                        <div class="form-group">
                            <label for="startWorkDate">Start Date</label>
                            <input type="date" id="startWorkDate" class="form-control" onchange="calculateWorkingDays()">
                        </div>
                        <div class="form-group">
                            <label for="endWorkDate">End Date</label>
                            <input type="date" id="endWorkDate" class="form-control" onchange="calculateWorkingDays()">
                        </div>
                        <div class="form-group">
                            <label for="daysWorked">Days Worked</label>
                            <input type="number" id="daysWorked" name="daysWorked" class="form-control" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="absences">Number of Absences</label>
                            <input type="number" id="absences" name="absences" class="form-control" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="numberLate">Number of Late Instances</label>
                            <input type="number" id="numberLate" name="numberLate" class="form-control" min="0" required>
                        </div>
                        <div class="form-group">
                            <label for="totalLate">Total Late Minutes</label>
                            <input type="number" id="totalLate" name="totalLate" class="form-control" min="0" step="1" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="action-btn cancel-btn" onclick="closeWorkDetailsModal()">Cancel</button>
                        <button type="submit" class="action-btn save-btn">Update</button>
                    </div>
                </form>
            </div>
        </div>

        <!-- Custom Alert Modal -->
        <div id="customAlert" class="custom-alert">
            <div class="custom-alert-content">
                <div class="custom-alert-header" id="alertHeader">
                    Alert
                </div>
                <div class="custom-alert-body" id="alertBody">
                    Message goes here
                </div>
                <div class="custom-alert-footer">
                    <button class="custom-alert-btn custom-alert-btn-confirm" id="alertConfirmBtn">OK</button>
                    <button class="custom-alert-btn custom-alert-btn-cancel" id="alertCancelBtn" style="display: none;">Cancel</button>
                </div>
            </div>
        </div>

        <script>
            // Search functionality
            document.getElementById('searchInput').addEventListener('input', function() {
                const searchTerm = this.value.toLowerCase();
                const rows = document.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    const text = row.textContent.toLowerCase();
                    if (text.includes(searchTerm)) {
                        row.style.display = '';
                    } else {
                        row.style.display = 'none';
                    }
                });
            });
            
            // Status filter functionality
            document.getElementById('statusFilter').addEventListener('change', function() {
                const status = this.value;
                const rows = document.querySelectorAll('tbody tr');
                rows.forEach(row => {
                    if (status === '') {
                        row.style.display = '';
                    } else {
                        const rowStatus = row.querySelector('.status-badge').textContent;
                        if (rowStatus === status) {
                            row.style.display = '';
                        } else {
                            row.style.display = 'none';
                        }
                    }
                });
            });
            
            // Modal functions
            function openAddModal() {
                document.getElementById('addModal').style.display = 'block';
                // Set default dates
                const today = new Date().toISOString().split('T')[0];
                document.getElementById('startDate').value = today;
                const endDate = new Date();
                endDate.setDate(endDate.getDate() + 30);
                document.getElementById('endDate').value = endDate.toISOString().split('T')[0];
            }

            function closeAddModal() {
                document.getElementById('addModal').style.display = 'none';
            }

            function validateAddForm() {
                const idNo = document.getElementById('idNo').value;
                const lastName = document.getElementById('lastName').value;
                const firstName = document.getElementById('firstName').value;
                const startDate = new Date(document.getElementById('startDate').value);
                const endDate = new Date(document.getElementById('endDate').value);
                if (!idNo || !lastName || !firstName) {
                    alert('Please fill in all required fields');
                    return false;
                }

                if (startDate >= endDate) {
                    alert('End date must be after start date');
                    return false;
                }
                return true;
            }

            function openEditModal(recordId) {
                const records = [
                    <% for (GipRecord record : gipRecords) {%>
                    {
                        idNo: '<%= record.idNo%>',
                        lastName: '<%= record.lastName%>',
                        firstName: '<%= record.firstName%>',
                        middleName: '<%= record.middleName%>',
                        extensionName: '<%= record.extensionName%>',
                        street: '<%= record.street%>',
                        barangay: '<%= record.barangay%>',
                        municipality: '<%= record.municipality%>',
                        province: '<%= record.province%>',
                        contactNumber: '<%= record.contactNumber%>',
                        sex: '<%= record.sex%>',
                        birthDate: '<%= record.birthDate%>',
                        status: '<%= record.status%>'
                    },
                    <% } %>
                ];
                const record = records.find(r => r.idNo === recordId);
                if (record) {
                    document.getElementById('editIdNo').value = record.idNo;
                    document.getElementById('editLastName').value = record.lastName;
                    document.getElementById('editFirstName').value = record.firstName;
                    document.getElementById('editMiddleName').value = record.middleName;
                    document.getElementById('editExtensionName').value = record.extensionName;
                    document.getElementById('editStreet').value = record.street;
                    document.getElementById('editBarangay').value = record.barangay;
                    document.getElementById('editMunicipality').value = record.municipality;
                    document.getElementById('editProvince').value = record.province;
                    document.getElementById('editContactNumber').value = record.contactNumber;
                    document.getElementById('editSex').value = record.sex;
                    document.getElementById('editStatus').value = record.status;
                    // Format birthdate for date input
                    const birthDateParts = record.birthDate.split(' ');
                    if (birthDateParts.length === 3) {
                        const months = {
                            'January': '01', 'February': '02', 'March': '03', 'April': '04',
                            'May': '05', 'June': '06', 'July': '07', 'August': '08',
                            'September': '09', 'October': '10', 'November': '11', 'December': '12'
                        };
                        const formattedDate = `${birthDateParts[2]}-${months[birthDateParts[0]]}-${birthDateParts[1].replace(',', '').padStart(2, '0')}`;
                        document.getElementById('editBirthDate').value = formattedDate;
                    }

                    document.getElementById('editModal').style.display = 'block';
                }
            }

            function closeEditModal() {
                document.getElementById('editModal').style.display = 'none';
            }

            function openWorkDetailsModal(recordId) {
                document.getElementById('workDetailsRecordId').value = recordId;
                document.getElementById('workDetailsModal').style.display = 'block';
                // Find the record and populate the form
                const records = [
                    <% for (GipRecord record : gipRecords) {%>
                    {
                        idNo: '<%= record.idNo%>',
                        daysWorked: <%= record.daysWorked%>,
                        absences: <%= record.absences%>,
                        numberLate: <%= record.numberLate%>,
                        totalLate: <%= record.totalLate%>,
                        startDate: '<%= record.startDate%>',
                        endDate: '<%= record.rawEndDate%>'
                    },
                    <% } %>
                ];
                const record = records.find(r => r.idNo === recordId);
                if (record) {
                    document.getElementById('daysWorked').value = record.daysWorked;
                    document.getElementById('absences').value = record.absences;
                    document.getElementById('numberLate').value = record.numberLate;
                    document.getElementById('totalLate').value = record.totalLate;
                    // Set the start and end dates from the record
                    document.getElementById('startWorkDate').value = record.startDate;
                    document.getElementById('endWorkDate').value = record.endDate;
                }
            }

            function closeWorkDetailsModal() {
                document.getElementById('workDetailsModal').style.display = 'none';
            }

            function calculateWorkingDays() {
                const startDate = new Date(document.getElementById('startWorkDate').value);
                const endDate = new Date(document.getElementById('endWorkDate').value);
                if (isNaN(startDate.getTime()) || isNaN(endDate.getTime())) {
                    return;
                }

                // Swap dates if start date is after end date
                if (startDate > endDate) {
                    [startDate, endDate] = [endDate, startDate];
                    document.getElementById('startWorkDate').valueAsDate = startDate;
                    document.getElementById('endWorkDate').valueAsDate = endDate;
                }

                let count = 0;
                const current = new Date(startDate);
                while (current <= endDate) {
                    const day = current.getDay();
                    if (day !== 0 && day !== 6) { // Skip Sunday (0) and Saturday (6)
                        count++;
                    }
                    current.setDate(current.getDate() + 1);
                }

                document.getElementById('daysWorked').value = count;
            }

            // Delete confirmation function
            function confirmDelete(recordId) {
                const alertModal = document.getElementById('customAlert');
                const alertBody = document.getElementById('alertBody');
                const alertHeader = document.getElementById('alertHeader');
                const confirmBtn = document.getElementById('alertConfirmBtn');
                alertHeader.textContent = 'Confirm Delete';
                alertBody.textContent = 'Are you sure you want to delete this GIP record? This action cannot be undone.';
                // Show the alert modal
                alertModal.style.display = 'flex';
                // Set up confirm button
                confirmBtn.onclick = function() {
                    // Submit the delete form
                    const form = document.createElement('form');
                    form.method = 'post';
                    form.action = 'DeleteGIP.jsp';
                    const actionInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'action';
                    actionInput.value = 'delete';
                    form.appendChild(actionInput);
                    const recordIdInput = document.createElement('input');
                    actionInput.type = 'hidden';
                    actionInput.name = 'recordId';
                    actionInput.value = recordId;
                    form.appendChild(recordIdInput);
                    document.body.appendChild(form);
                    form.submit();
                    // Hide the alert modal
                    alertModal.style.display = 'none';
                };
                // Set up cancel button
                document.getElementById('alertCancelBtn').style.display = 'inline-block';
                document.getElementById('alertCancelBtn').onclick = function() {
                    alertModal.style.display = 'none';
                };
            }

            // Close modals when clicking outside
            window.onclick = function(event) {
                if (event.target.className === 'modal') {
                    event.target.style.display = 'none';
                }
                if (event.target.className === 'custom-alert') {
                    event.target.style.display = 'none';
                }
            }

            // Set today's date as default for date inputs
            document.addEventListener('DOMContentLoaded', function() {
                const today = new Date().toISOString().split('T')[0];
                const dateInputs = document.querySelectorAll('input[type="date"]');
                dateInputs.forEach(input => {
                    if (!input.value && input.id !== 'endDate' && input.id !== 'startDate') {
                        input.value = today;
                    }
                });
            });
        </script>
    </body>
</html>