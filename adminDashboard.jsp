<%@ page import="jakarta.ee.gipsystem.model.User" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="jakarta.ee.gipsystem.util.DBUtil" %>
<%@ page session="true" %>
<%
    // User Authentication
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }

    // Initialize variables
    int totalGipsRecords = 0;
    int totalGipsOthers = 0;
    int newThisMonthRecords = 0;
    int newThisMonthOthers = 0;
    int completionRateRecords = 0;
    int completionRateOthers = 0;
    int totalCompleted = 0;

    // Fetch total GIPs from GIP_RECORDS table
    try (Connection conn = DBUtil.getConnection()) {
        // Query to get total GIPs from GIP_RECORDS table
        String queryRecords = "SELECT COUNT(*) FROM GIP_RECORDS";
        try (PreparedStatement ps = conn.prepareStatement(queryRecords);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalGipsRecords = rs.getInt(1);
            }
        }

        // Query to get total GIPs from GIP_OTHERS table
        String queryOthers = "SELECT COUNT(*) FROM GIP_OTHERS";
        try (PreparedStatement ps = conn.prepareStatement(queryOthers);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                totalGipsOthers = rs.getInt(1);
            }
        }

        // Fetch new GIPs registered this month from GIP_RECORDS table
        String queryNewThisMonthRecords = "SELECT COUNT(*) FROM GIP_RECORDS WHERE MONTH(start_date) = MONTH(CURRENT_DATE) AND YEAR(start_date) = YEAR(CURRENT_DATE)";
        try (PreparedStatement ps = conn.prepareStatement(queryNewThisMonthRecords);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                newThisMonthRecords = rs.getInt(1);
            }
        }

        // Fetch new GIPs registered this month from GIP_OTHERS table
        String queryNewThisMonthOthers = "SELECT COUNT(*) FROM GIP_OTHERS WHERE MONTH(start_date) = MONTH(CURRENT_DATE) AND YEAR(start_date) = YEAR(CURRENT_DATE)";
        try (PreparedStatement ps = conn.prepareStatement(queryNewThisMonthOthers);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                newThisMonthOthers = rs.getInt(1);
            }
        }

        // Fetch completed GIPs from GIP_RECORDS table
        String queryCompletedRecords = "SELECT COUNT(*) FROM GIP_RECORDS WHERE status = 'Completed'";
        try (PreparedStatement ps = conn.prepareStatement(queryCompletedRecords);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                completionRateRecords = rs.getInt(1);
            }
        }

        // Fetch completed GIPs from GIP_OTHERS table
        String queryCompletedOthers = "SELECT COUNT(*) FROM GIP_OTHERS WHERE status = 'Completed'";
        try (PreparedStatement ps = conn.prepareStatement(queryCompletedOthers);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                completionRateOthers = rs.getInt(1);
            }
        }

        // Combine total completed GIPs from both tables
        totalCompleted = completionRateRecords + completionRateOthers;

    } catch (Exception e) {
        e.printStackTrace();
        // Log the error for debugging
        System.out.println("Database error: " + e.getMessage());
    }

    // Calculate totals
    int totalGips = totalGipsRecords + totalGipsOthers;
    int totalNewThisMonth = newThisMonthRecords + newThisMonthOthers;
    int completionRate = totalGips > 0 ? (int) ((double) totalCompleted / totalGips * 100) : 0;
    
    // Get context path for proper image URLs
    String contextPath = request.getContextPath();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | GIP Portal | DOLE</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis/css2?family=Roboto:wght@300;400;500;700&family=Poppins:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --primary: #004d99;
            --primary-dark: #003366;
            --primary-light: #0066cc;
            --accent: #ffcc00;
            --secondary: #64748b;
            --success: #2e7d32;
            --danger: #cc0000;
            --warning: #f59e0b;
            --info: #06b6d4;
            --light: #f8fafc;
            --dark: #1e293b;
            --gray: #94a3b8;
            --sidebar-bg: #003366;
            --sidebar-hover: #004d99;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
            --card-shadow-hover: 0 20px 25px -5px rgba(0, 0, 0, 0.1), 0 10px 10px -5px rgba(0, 0, 0, 0.04);
        }

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: #f4f4f9;
            color: #333;
            display: flex;
            flex-direction: column;
            min-height: 100vh;
            overflow: hidden;
        }

        /* Header styles */
        header {
            background: var(--primary);
            color: white;
            padding: 15px 30px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
            position: sticky;
            top: 0;
            z-index: 100;
            flex-shrink: 0;
        }

        .logo-container {
            display: flex;
            align-items: center;
            gap: 15px;
        }

        .logo {
            width: 60px;
            height: 60px;
            object-fit: contain;
            transition: all 0.3s ease;
        }

        .logo:hover {
            transform: rotate(5deg);
        }

        .header-text {
            font-family: 'Poppins', sans-serif;
            font-size: 1.6em;
            font-weight: 700;
        }

        .logout-btn {
            background-color: var(--danger);
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

        /* Main content wrapper */
        .main-wrapper {
            display: flex;
            flex: 1;
            overflow: hidden;
        }

        /* Sidebar styles - Matching monitoring.jsp */
        .sidebar {
            width: 280px;
            background-color: var(--sidebar-bg);
            color: white;
            padding: 30px 0;
            overflow-y: auto;
            transition: all 0.3s ease;
        }

        .sidebar-header {
            padding: 0 30px 20px;
            border-bottom: 1px solid rgba(255,255,255,0.1);
            margin-bottom: 20px;
        }

        .sidebar-header h2 {
            font-size: 1.3em;
            font-weight: 500;
        }

        .sidebar-item {
            padding: 15px 30px;
            margin-bottom: 5px;
            font-size: 1.1em;
            cursor: pointer;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            gap: 15px;
            border-left: 4px solid transparent;
            position: relative;
            overflow: hidden;
        }

        .sidebar-item:before {
            content: '';
            position: absolute;
            top: 0;
            left: -100%;
            width: 100%;
            height: 100%;
            background: linear-gradient(90deg, transparent, rgba(255,255,255,0.1), transparent);
            transition: all 0.5s ease;
        }

        .sidebar-item:hover:before {
            left: 100%;
        }

        .sidebar-item i {
            font-size: 1.2em;
            width: 25px;
            text-align: center;
            transition: transform 0.3s ease;
        }

        .sidebar-item:hover {
            background-color: var(--sidebar-hover);
        }

        .sidebar-item:hover i {
            transform: scale(1.2);
        }

        .sidebar-item.active {
            background-color: rgba(0,77,153,0.5);
            border-left: 4px solid var(--accent);
            font-weight: 500;
        }

        /* Content area */
        .content-container {
            flex: 1;
            display: flex;
            overflow: hidden;
        }

        .content-area {
            flex: 1;
            display: flex;
            overflow: auto;
            background: #f4f4f9;
        }

        .main-content {
            flex: 1;
            padding: 30px;
            min-height: min-content;
        }

        .dashboard-section {
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: var(--card-shadow);
            margin-bottom: 30px;
            transition: all 0.3s ease;
        }

        .dashboard-section:hover {
            box-shadow: var(--card-shadow-hover);
        }

        .dashboard-section h2 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.8em;
            font-weight: 600;
            color: var(--primary);
            margin-bottom: 25px;
            padding-bottom: 15px;
            border-bottom: 2px solid #f1f5f9;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .stats-container {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 25px;
            margin: 30px 0 20px;
        }

        .stat-card {
            background: white;
            border-radius: 10px;
            padding: 25px;
            box-shadow: var(--card-shadow);
            transition: all 0.4s ease;
            height: 200px;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
            position: relative;
            overflow: hidden;
            border-left: 5px solid var(--primary);
        }

        .stat-card:hover {
            transform: translateY(-8px);
            box-shadow: var(--card-shadow-hover);
        }

        .stat-card h3 {
            margin-top: 0;
            color: var(--secondary);
            font-size: 1em;
            font-weight: 500;
            flex: 0 0 auto;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .stat-value {
            font-family: 'Poppins', sans-serif;
            font-size: 3em;
            font-weight: 700;
            color: var(--primary);
            margin: 10px 0;
            flex: 1;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
        }

        .stat-card:hover .stat-value {
            transform: scale(1.05);
        }

        .stat-card p {
            font-size: 0.9em;
            color: var(--gray);
            margin: 0;
            flex: 0 0 auto;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        /* Profile sidebar */
        .profile-sidebar {
            width: 350px;
            background: white;
            padding: 30px;
            border-left: 1px solid #e2e8f0;
            overflow-y: auto;
            flex-shrink: 0;
            box-shadow: -4px 0 6px rgba(0, 0, 0, 0.05);
        }

        .profile-header {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 25px;
            padding-bottom: 25px;
            border-bottom: 1px solid #f1f5f9;
        }

        .profile-img-container {
            position: relative;
            width: 150px;
            height: 150px;
            margin-bottom: 20px;
        }

        .profile-img {
            border-radius: 50%;
            width: 100%;
            height: 100%;
            object-fit: cover;
            border: 4px solid var(--primary);
            box-shadow: 0 4px 6px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
        }

        .profile-img-container:hover .profile-img {
            transform: scale(1.05);
            box-shadow: 0 8px 15px rgba(0, 0, 0, 0.2);
        }

        .profile-fallback {
            border-radius: 50%;
            width: 100%;
            height: 100%;
            background: var(--primary);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 3.5em;
            font-weight: bold;
            border: 4px solid var(--primary);
        }

        .profile-info {
            text-align: center;
            width: 100%;
        }

        .profile-info h2 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.6em;
            color: var(--dark);
            margin-bottom: 10px;
        }

        .profile-info p {
            margin: 8px 0;
            font-size: 1em;
            color: var(--secondary);
        }

        .admin-badge {
            display: inline-block;
            padding: 8px 18px;
            background: var(--primary);
            color: white;
            border-radius: 30px;
            font-size: 0.9em;
            margin-top: 15px;
            font-weight: 500;
        }

        .edit-profile-btn {
            margin-top: 25px;
            padding: 14px 28px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 30px;
            cursor: pointer;
            font-size: 1em;
            transition: all 0.3s ease;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            text-decoration: none;
            min-width: 200px;
            font-weight: 500;
        }

        .edit-profile-btn:hover {
            background: var(--primary-dark);
            transform: translateY(-3px);
        }

        /* Footer */
        footer {
            text-align: center;
            background: var(--primary);
            color: white;
            padding: 20px 0;
            font-size: 0.9em;
            flex-shrink: 0;
        }

        /* Scrollbar styling */
        ::-webkit-scrollbar {
            width: 8px;
            height: 8px;
        }

        ::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb {
            background: var(--primary);
            border-radius: 10px;
        }

        ::-webkit-scrollbar-thumb:hover {
            background: var(--primary-dark);
        }

        /* Animations */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }

        .card-enter {
            animation: fadeIn 0.6s ease-out forwards;
            opacity: 0;
        }

        /* Responsive design */
        @media (max-width: 1200px) {
            .profile-sidebar {
                width: 320px;
            }
            
            .stats-container {
                grid-template-columns: repeat(2, 1fr);
            }
        }

        @media (max-width: 992px) {
            .profile-sidebar {
                display: none;
            }
            
            .stats-container {
                grid-template-columns: 1fr;
            }
        }

        @media (max-width: 768px) {
            .main-wrapper {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                max-height: 200px;
            }

            .sidebar-item {
                padding: 12px 20px;
            }

            .content-area {
                flex-direction: column;
            }

            .main-content {
                padding: 20px;
            }
            
            .stat-card {
                height: 180px;
                padding: 20px;
            }
            
            .stat-value {
                font-size: 2.5em;
            }
        }

        @media (max-width: 576px) {
            header {
                flex-direction: column;
                gap: 15px;
                padding: 15px;
                text-align: center;
            }

            .logout-btn {
                width: 100%;
                justify-content: center;
            }
            
            .stat-card {
                height: 160px;
                padding: 20px;
            }
            
            .stat-value {
                font-size: 2.2em;
            }
            
            .dashboard-section h2 {
                font-size: 1.5em;
            }
        }

        /* Loading overlay styles */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.7);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 1000;
        }

        .spinner {
            border: 5px solid #f3f3f3;
            border-top: 5px solid var(--primary);
            border-radius: 50%;
            width: 60px;
            height: 60px;
            animation: spin 1s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            to { transform: rotate(360deg); }
        }

        /* Confirmation modal */
        .confirm-logout-modal {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.8);
            display: none;
            justify-content: center;
            align-items: center;
            z-index: 2000;
        }

        .modal-content {
            background-color: white;
            padding: 30px;
            border-radius: 10px;
            width: 350px;
            text-align: center;
            animation: modalAppear 0.3s ease-out;
        }

        @keyframes modalAppear {
            from { opacity: 0; transform: scale(0.9); }
            to { opacity: 1; transform: scale(1); }
        }

        .modal-content h2 {
            font-family: 'Poppins', sans-serif;
            font-size: 1.4em;
            margin-bottom: 15px;
            color: var(--dark);
        }

        .modal-buttons {
            margin-top: 25px;
            display: flex;
            justify-content: center;
            gap: 15px;
        }

        .modal-btn {
            padding: 12px 25px;
            cursor: pointer;
            border-radius: 30px;
            border: none;
            font-size: 1em;
            min-width: 120px;
            font-weight: 500;
            transition: all 0.3s ease;
        }

        .modal-btn-confirm {
            background-color: var(--danger);
            color: white;
        }

        .modal-btn-confirm:hover {
            background-color: #b30000;
            transform: translateY(-2px);
        }

        .modal-btn-cancel {
            background-color: var(--primary);
            color: white;
        }

        .modal-btn-cancel:hover {
            background-color: var(--primary-dark);
            transform: translateY(-2px);
        }
    </style>
</head>
<body>
    <header>
        <div class="logo-container">
            <img src="https://i.postimg.cc/0QvVb3kG/gip2.png" alt="GIP Portal Logo" class="logo" onerror="this.style.display='none';">
            <div class="header-text">Government Internship Program</div>
        </div>
        <button class="logout-btn" id="logoutBtn">
            <i class="fas fa-sign-out-alt"></i> Logout
        </button>
    </header>

    <div class="main-wrapper">
        <!-- Sidebar Navigation -->
        <div class="sidebar">
            <div class="sidebar-content">
                <div class="sidebar-header">
                    <h2>Admin Menu</h2>
                </div>

                <div class="sidebar-item active" onclick="window.location.href = 'adminDashboard.jsp'">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </div>

                <div class="sidebar-item" onclick="window.location.href = 'Monitoring.jsp'">
                    <i class="fas fa-city"></i> Municipalities
                </div>
            </div>
        </div>

        <!-- Main Content Area -->
        <div class="content-container">
            <div class="content-area">
                <div class="main-content">
                    <div class="dashboard-section">
                        <h2><i class="fas fa-chart-line"></i> Dashboard Overview</h2>

                        <div class="stats-container">
                            <!-- Total GIPs from GIP_RECORDS -->
                            <div class="stat-card card-enter" style="animation-delay: 0.1s">
                                <h3><i class="fas fa-building"></i> Total GIPs (MUNICIPALITIES)</h3>
                                <div class="stat-value"><%= totalGipsRecords %></div>
                                <p><i class="fas fa-database"></i> Total records in Municipalities table</p>
                            </div>

                            <!-- Total GIPs from GIP_OTHERS -->
                            <div class="stat-card card-enter" style="animation-delay: 0.2s">
                                <h3><i class="fas fa-landmark"></i> Total GIPs (PARTNER GOVERNMENT AGENCY)</h3>
                                <div class="stat-value"><%= totalGipsOthers %></div>
                                <p><i class="fas fa-database"></i> Total records in GIP Partner Agency table</p>
                            </div>

                            <!-- New GIPs This Month (combined) -->
                            <div class="stat-card card-enter" style="animation-delay: 0.3s">
                                <h3><i class="fas fa-calendar-plus"></i> New This Month</h3>
                                <div class="stat-value"><%= totalNewThisMonth %></div>
                                <p><i class="fas fa-chart-line"></i> New registrations from both tables</p>
                            </div>

                            <!-- Completion Rate (combined) -->
                            <div class="stat-card card-enter" style="animation-delay: 0.4s">
                                <h3><i class="fas fa-tasks"></i> Completion Rate</h3>
                                <div class="stat-value"><%= completionRate %>%</div>
                                <p><i class="fas fa-percentage"></i> Combined completion rate</p>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Additional dashboard content can be added here -->
                </div>

                <!-- Profile Sidebar -->
                <div class="profile-sidebar">
                    <div class="profile-header">
                        <div class="profile-img-container">
                            <img src="<%= contextPath %>/images/dpp.jpg" alt="Admin Profile" class="profile-img" onerror="this.style.display='none'; this.nextElementSibling.style.display='flex'">
                            <div class="profile-fallback" style="display: none;">
                                <%= user.getFullName().substring(0, 1).toUpperCase() %>
                            </div>
                        </div>
                        <div class="profile-info">
                            <h2><%= user.getFullName() %></h2>
                            <p><i class="fas fa-envelope"></i> <%= user.getEmail() %></p>
                            <p><i class="fas fa-user-tag"></i> Provincial Administrator</p>
                            <span class="admin-badge">
                                <i class="fas fa-shield-alt"></i> ADMINISTRATOR
                            </span>
                        </div>
                    </div>
                    
                    <!-- Quick Actions -->
                    <div style="margin-top: 30px;">
                        <h3 style="font-family: 'Poppins', sans-serif; margin-bottom: 15px; color: var(--dark);">Quick Actions</h3>
                        <div style="display: grid; gap: 10px;">
                            <button class="sidebar-item" style="margin: 0; background: rgba(0, 77, 153, 0.1); color: var(--primary);" onclick="window.location.href = 'Monitoring.jsp'">
                                <i class="fas fa-plus-circle"></i> Add New GIP
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <footer>
        <p>DOLE GIP Portal &copy; 2025 | Department of Labor and Employment</p>
    </footer>

    <!-- Logout Confirmation Modal -->
    <div class="confirm-logout-modal" id="confirmLogoutModal">
        <div class="modal-content">
            <h2><i class="fas fa-sign-out-alt"></i> Confirm Logout</h2>
            <p>Are you sure you want to log out of your account?</p>
            <div class="modal-buttons">
                <button id="confirmLogoutBtn" class="modal-btn modal-btn-confirm">Yes, Log out</button>
                <button id="cancelLogoutBtn" class="modal-btn modal-btn-cancel">Cancel</button>
            </div>
        </div>
    </div>

    <!-- Loading Overlay -->
    <div class="loading-overlay" id="loadingOverlay">
        <div class="spinner"></div>
    </div>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Logout functionality
            document.getElementById('logoutBtn').addEventListener('click', function(e) {
                e.preventDefault();
                document.getElementById('confirmLogoutModal').style.display = 'flex';
            });

            // Confirm Logout
            document.getElementById('confirmLogoutBtn').addEventListener('click', function() {
                // Show loading overlay
                document.getElementById('loadingOverlay').style.display = 'flex';

                // Redirect to index page after animation
                setTimeout(function() {
                    window.location.href = 'index.jsp';
                }, 1000);
            });

            // Cancel Logout
            document.getElementById('cancelLogoutBtn').addEventListener('click', function() {
                document.getElementById('confirmLogoutModal').style.display = 'none';
            });
            
            // Add staggered animation to cards
            const cards = document.querySelectorAll('.card-enter');
            cards.forEach((card, index) => {
                card.style.animationDelay = `${0.1 + (index * 0.1)}s`;
            });
            
            // Check if profile image failed to load and show fallback
            const profileImg = document.querySelector('.profile-img');
            if (profileImg && profileImg.complete && profileImg.naturalHeight === 0) {
                profileImg.style.display = 'none';
                document.querySelector('.profile-fallback').style.display = 'flex';
            }
        });
    </script>
</body>
</html>