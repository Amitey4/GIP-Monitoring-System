<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.sql.Connection" %>
<%@ page import="java.sql.PreparedStatement" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="jakarta.ee.gipsystem.util.DBUtil" %>

<!DOCTYPE html>
<html lang="en">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0, user-scalable=yes">
        <title>GIP Monitoring System</title>
        <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
        <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
        <style>
            /* Enhanced CSS with smooth effects */
            :root {
                --primary: #004d99;
                --primary-dark: #003366;
                --primary-light: #0066cc;
                --accent: #ffcc00;
                --danger: #cc0000;
                --success: #2e7d32;
                --text: #333;
                --text-light: #666;
                --bg-light: #f4f4f9;
                --card-shadow: 0 10px 20px rgba(0,0,0,0.12);
                --card-shadow-hover: 0 15px 30px rgba(0,0,0,0.2);
            }
            
            * {
                margin: 0;
                padding: 0;
                box-sizing: border-box;
            }

            body {
                font-family: 'Roboto', sans-serif;
                background: var(--bg-light);
                color: var(--text);
                min-height: 100vh;
                display: flex;
                flex-direction: column;
                overflow-x: hidden;
            }

            header {
                background-color: var(--primary);
                color: white;
                padding: 15px 30px;
                display: flex;
                justify-content: space-between;
                align-items: center;
                box-shadow: 0 2px 10px rgba(0,0,0,0.15);
                position: sticky;
                top: 0;
                z-index: 1000;
                transition: all 0.3s ease;
            }

            .logo-container {
                display: flex;
                align-items: center;
                gap: 15px;
            }

            .logo {
                width: 50px;
                height: 50px;
                object-fit: contain;
                transition: transform 0.3s ease;
            }

            .logo:hover {
                transform: rotate(5deg) scale(1.05);
            }

            .header-text {
                font-size: 1.5em;
                font-weight: 700;
                letter-spacing: 0.5px;
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
                box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            }

            .logout-btn:hover {
                background-color: #b30000;
                transform: translateY(-2px);
                box-shadow: 0 6px 8px rgba(0,0,0,0.15);
            }

            .main-wrapper {
                display: flex;
                flex: 1;
                height: calc(100vh - 80px);
                opacity: 0;
                animation: fadeIn 0.8s ease forwards;
            }

            .sidebar {
                width: 280px;
                background-color: var(--primary-dark);
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
                background-color: rgba(0,77,153,0.3);
            }

            .sidebar-item:hover i {
                transform: scale(1.2);
            }

            .sidebar-item.active {
                background-color: rgba(0,77,153,0.5);
                border-left: 4px solid var(--accent);
                font-weight: 500;
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
                background-color: var(--bg-light);
                animation: slideIn 0.5s ease forwards;
            }

            .dashboard-section {
                background-color: white;
                padding: 25px;
                border-radius: 12px;
                box-shadow: var(--card-shadow);
                margin-bottom: 30px;
                transition: all 0.3s ease;
            }

            .dashboard-section:hover {
                box-shadow: var(--card-shadow-hover);
            }

            .dashboard-section h2 {
                font-size: 1.5em;
                color: var(--primary);
                margin-bottom: 20px;
                padding-bottom: 10px;
                border-bottom: 1px solid #eee;
                display: flex;
                align-items: center;
                gap: 10px;
            }

            .municipalities-container {
                display: grid;
                grid-template-columns: repeat(auto-fill, minmax(200px, 1fr));
                gap: 20px;
                margin-top: 20px;
            }

            .municipality-card {
                background: linear-gradient(135deg, #ffffff 0%, #f8f9fa 100%);
                border-radius: 12px;
                box-shadow: var(--card-shadow);
                overflow: hidden;
                transition: all 0.3s ease;
                cursor: pointer;
                text-align: center;
                padding: 20px;
                position: relative;
                transform: translateY(0);
                border: 1px solid rgba(0,0,0,0.05);
            }

            .municipality-card:after {
                content: '';
                position: absolute;
                top: 0;
                left: 0;
                width: 100%;
                height: 4px;
                background: linear-gradient(90deg, var(--primary), var(--accent));
                opacity: 0;
                transition: all 0.3s ease;
            }

            .municipality-card:hover {
                transform: translateY(-8px);
                box-shadow: var(--card-shadow-hover);
            }

            .municipality-card:hover:after {
                opacity: 1;
            }

            .municipality-name {
                font-size: 1.2em;
                font-weight: 500;
                margin-bottom: 10px;
                color: var(--primary);
                transition: all 0.3s ease;
            }

            .municipality-card:hover .municipality-name {
                color: var(--primary-light);
            }

            .gip-count {
                font-size: 2.2em;
                font-weight: 700;
                color: var(--success);
                margin-bottom: 5px;
                transition: all 0.3s ease;
                text-shadow: 0 2px 4px rgba(0,0,0,0.1);
            }

            .municipality-card:hover .gip-count {
                transform: scale(1.1);
            }

            .gip-label {
                font-size: 0.9em;
                color: var(--text-light);
                font-weight: 500;
            }

            .search-filter {
                display: flex;
                gap: 15px;
                margin-bottom: 20px;
            }

            .search-box {
                flex: 1;
                position: relative;
            }

            .search-box i {
                position: absolute;
                left: 12px;
                top: 50%;
                transform: translateY(-50%);
                color: var(--text-light);
            }

            .search-box input {
                padding-left: 40px;
            }

            .filter-box {
                width: 200px;
            }

            .form-control {
                padding: 12px;
                border: 1px solid #ddd;
                border-radius: 8px;
                font-family: 'Roboto', sans-serif;
                width: 100%;
                transition: all 0.3s ease;
                background: white;
            }

            .form-control:focus {
                outline: none;
                border-color: var(--primary-light);
                box-shadow: 0 0 0 3px rgba(0, 102, 204, 0.1);
            }

            /* Footer Styling */
            footer {
                text-align: center;
                background-color: var(--primary);
                color: white;
                padding: 15px 0;
                font-size: 0.85em;
                transition: all 0.3s ease;
            }

            /* Animations */
            @keyframes fadeIn {
                from { opacity: 0; }
                to { opacity: 1; }
            }

            @keyframes slideIn {
                from { 
                    opacity: 0;
                    transform: translateY(20px);
                }
                to { 
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            @keyframes pulse {
                0% { transform: scale(1); }
                50% { transform: scale(1.05); }
                100% { transform: scale(1); }
            }

            /* Loading animation for cards */
            .municipality-card {
                animation: cardAppear 0.5s ease-out forwards;
                opacity: 0;
                transform: translateY(20px);
            }

            @keyframes cardAppear {
                to {
                    opacity: 1;
                    transform: translateY(0);
                }
            }

            /* Responsive adjustments */
            @media (max-width: 1200px) {
                .main-content {
                    padding: 15px;
                }

                .dashboard-section {
                    padding: 15px;
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

                .sidebar-item {
                    padding: 12px 20px;
                }

                .content-area {
                    flex-direction: column;
                }

                .municipalities-container {
                    grid-template-columns: repeat(auto-fill, minmax(150px, 1fr));
                }

                .search-filter {
                    flex-direction: column;
                }

                .filter-box {
                    width: 100%;
                }
                
                header {
                    padding: 15px 20px;
                }
            }
        </style>
    </head>
    <body>
        <%
            // Database connection and query to fetch GIP counts by municipality
            Map<String, Integer> gipCounts = new HashMap<>();
            String[] municipalities = {
                "Alaminos","Bay", "Biñan", "Cabuyao", "Calamba", "Calauan", "Cavinti",
                "Famy", "Kalayaan", "Liliw", "Los Baños", "Luisiana", "Lumban",
                "Mabitac", "Magdalena", "Majayjay", "Nagcarlan", "Paete", "Pagsanjan",
                "Pakil", "Pangil", "Pila", "Rizal", "Santa Cruz", "Santa Maria",
                "San Pablo", "San Pedro", "Santa Rosa", "Siniloan", "Victoria"
            };
            
            // Initialize counts to 0
            for (String municipality : municipalities) {
                gipCounts.put(municipality, 0);
            }
            
            // Initialize Others count to 0
            int othersCount = 0;

            // Fetch GIP counts from gip_records table for municipalities
            try (Connection conn = DBUtil.getConnection()) {
                // Query for municipalities
                String query = "SELECT municipality, COUNT(*) FROM gip_records GROUP BY municipality";
                try (PreparedStatement ps = conn.prepareStatement(query);
                     ResultSet rs = ps.executeQuery()) {
                    while (rs.next()) {
                        String municipality = rs.getString(1);
                        int count = rs.getInt(2);
                        
                        // Check if the municipality is in our predefined list
                        for (String muni : municipalities) {
                            if (muni.equalsIgnoreCase(municipality)) {
                                gipCounts.put(muni, count);
                                break;
                            }
                        }
                    }
                }
                
                // Query for Others count from gip_others table
                String othersQuery = "SELECT COUNT(*) FROM gip_others";
                try (PreparedStatement ps = conn.prepareStatement(othersQuery);
                     ResultSet rs = ps.executeQuery()) {
                    if (rs.next()) {
                        othersCount = rs.getInt(1);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        %>

        <header>
            <div class="logo-container">
           		<img src="https://i.postimg.cc/0QvVb3kG/gip2.png" alt="GIP Portal Logo" class="logo">
                <div class="header-text">GIP Monitoring System</div>
            </div>
        </header>

        <div class="main-wrapper">
            <!-- Sidebar Navigation -->
            <div class="sidebar">
                <div class="sidebar-header">
                    <h2>Admin Menu</h2>
                </div>

                <div class="sidebar-item" onclick="window.location.href = 'adminDashboard.jsp'">
                    <i class="fas fa-tachometer-alt"></i> Dashboard
                </div>

                <div class="sidebar-item active">
                    <i class="fas fa-city"></i> Municipalities
                </div>
            </div>

            <!-- Main Content Area -->
            <div class="content-area">
                <div class="main-content">
                    <div class="dashboard-section" id="municipalities-view">
                        <h2><i class="fas fa-city"></i> Municipalities</h2>

                        <div class="search-filter">
                            <div class="search-box">
                                <i class="fas fa-search"></i>
                                <input type="text" class="form-control" placeholder="Search municipalities..." id="searchInput">
                            </div>
                        </div>

                        <div class="municipalities-container">
                            <%
                                int delay = 0;
                                for (String municipality : municipalities) {
                                    int count = gipCounts.getOrDefault(municipality, 0);
                                    delay += 50; // Increment delay for each card
                            %>
                            <div class="municipality-card" onclick="window.location.href='<%= municipality.replace(" ", "") %>.jsp'" style="animation-delay: <%= delay %>ms">
                                <div class="municipality-name"><%= municipality%></div>
                                <div class="gip-count"><%= count%></div>
                                <div class="gip-label">GIPs</div>
                            </div>
                            <% } %>

                            <!-- Others card -->
                            <div class="municipality-card" onclick="window.location.href='Others.jsp'" style="animation-delay: <%= delay + 50 %>ms">
                                <div class="municipality-name">Others</div>
                                <div class="gip-count"><%= othersCount %></div>
                                <div class="gip-label">GIPs</div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <footer>
            <p>DOLE GIP Portal &copy; 2025 | Department of Labor and Employment</p>
        </footer>
        <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
        <script>
            $(document).ready(function () {
                // Search functionality for municipalities
                $('#searchInput').on('keyup', function () {
                    const searchText = $(this).val().toLowerCase();
                    $('.municipality-card').each(function () {
                        const townName = $(this).find('.municipality-name').text().toLowerCase();
                        if (townName.includes(searchText)) {
                            $(this).fadeIn(300);
                        } else {
                            $(this).fadeOut(300);
                        }
                    });
                });
                
                // Add click animation to cards
                $('.municipality-card').on('click', function() {
                    $(this).css('transform', 'scale(0.95)');
                    setTimeout(() => {
                        $(this).css('transform', '');
                    }, 200);
                });
                
                // Add hover effect to cards
                $('.municipality-card').hover(
                    function() {
                        $(this).css('transform', 'translateY(-8px)');
                    },
                    function() {
                        $(this).css('transform', 'translateY(0)');
                    }
                );
            });
        </script>
    </body>
</html>