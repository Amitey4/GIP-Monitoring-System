<%@ page import="jakarta.ee.gipsystem.model.User" %>
<%@ page session="true" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Sample data for dashboard cards - replace with your actual data
    int totalGips = 0;
    int newThisMonth = 0;
    int completionRate = 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | GIP Portal | DOLE</title>
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        /* Reset and base styles */
        body, h1, h2, p, img, form, input, select, textarea {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        html, body {
            height: 100%;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: #f4f4f9;
            color: #333;
            display: flex;
            flex-direction: column;
            overflow: hidden;
        }

        /* Loading overlay styles */
        .loading-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(255, 255, 255, 0.9);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 9999;
            flex-direction: column;
            display: none;
        }

        /* Bouncing dots spinner */
        .spinner {
            width: 70px;
            height: 20px;
            text-align: center;
        }

        .spinner > div {
            width: 18px;
            height: 18px;
            background-color: #004d99;
            border-radius: 100%;
            display: inline-block;
            animation: sk-bouncedelay 1.4s infinite ease-in-out both;
        }

        .spinner .bounce1 {
            animation-delay: -0.32s;
        }

        .spinner .bounce2 {
            animation-delay: -0.16s;
        }

        @keyframes sk-bouncedelay {
            0%, 80%, 100% { 
                transform: scale(0);
            } 40% { 
                transform: scale(1.0);
            }
        }

        .loading-text {
            margin-top: 20px;
            font-size: 1.2em;
            color: #004d99;
            font-weight: 500;
        }

        /* [Keep all your existing CSS styles here] */
        /* ... (your existing header, sidebar, content styles remain unchanged) ... */

    </style>
</head>
<body>
    <!-- Loading Overlay (hidden by default) -->
    <div class="loading-overlay">
        <div class="spinner">
            <div class="bounce1"></div>
            <div class="bounce2"></div>
            <div class="bounce3"></div>
        </div>
        <div class="loading-text">Logging out...</div>
    </div>

    <header>
        <div class="logo-container">
            <img src="images/gip2.png" alt="DOLE Logo" class="logo">
            <div class="header-text">Government Internship Program</div>
        </div>
        <button class="logout-btn" id="logoutBtn">
            <i class="fas fa-sign-out-alt"></i> Logout
        </button>
    </header>

    <div class="main-wrapper">
        <!-- [Keep your existing sidebar and content structure] -->
        <!-- ... (your existing sidebar and content HTML remains unchanged) ... -->
    </div>

    <footer>
        <p>DOLE GIP Portal &copy; 2025 | Department of Labor and Employment</p>
    </footer>

    <script>
        document.addEventListener('DOMContentLoaded', function () {
            // Highlight active sidebar item
            const currentPage = window.location.pathname.split('/').pop();
            const sidebarItems = document.querySelectorAll('.sidebar-item');

            sidebarItems.forEach(item => {
                if (item.getAttribute('onclick').includes(currentPage)) {
                    item.classList.add('active');
                } else {
                    item.classList.remove('active');
                }
            });

            // Enhanced logout functionality
            document.getElementById('logoutBtn').addEventListener('click', function(e) {
                e.preventDefault();
                
                if (confirm('Are you sure you want to logout?')) {
                    const loadingOverlay = document.querySelector('.loading-overlay');
                    
                    // Show loading overlay with bouncing dots
                    loadingOverlay.style.display = 'flex';
                    
                    // Set timeout for the loading effect (2 seconds)
                    setTimeout(function() {
                        // Show success message
                        alert('Successfully logged out');
                        
                        // Redirect directly to logout.jsp
                        window.location.href = 'logout.jsp';
                    }, 2000);
                }
            });
        });
    </script>
</body>
</html>