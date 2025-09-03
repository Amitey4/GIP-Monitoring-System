<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login | GIP Portal | DOLE Laguna</title>
    <link rel="stylesheet" href="styles.css">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        /* Enhanced Reset with Better Box Sizing */
        *, *::before, *::after {
            box-sizing: border-box;
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(135deg, #004d99 0%, #00aaff 100%);
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: space-between;
            padding: 0;
            position: relative;
        }

        /* Header Improvements */
        header {
            background-color: rgba(0, 77, 153, 0.95);
            color: white;
            text-align: center;
            padding: 15px 20px;
            width: 100%;
            display: flex;
            justify-content: center;
            align-items: center;
            box-shadow: 0 2px 15px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 10;
        }

        .logo-container {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .logo {
            width: 80px;
            height: auto;
            margin-right: 15px;
            filter: drop-shadow(0 2px 4px rgba(0, 0, 0, 0.3));
        }

        .header-text {
            font-size: 1.6rem;
            font-weight: 700;
            color: white;
            text-shadow: 1px 1px 3px rgba(0, 0, 0, 0.2);
        }

        /* Main Content Area */
        .main-content {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            width: 100%;
            flex: 1;
            padding: 20px;
        }

        /* Login Container Enhancements */
        .login-container {
            background-color: white;
            padding: 35px 30px;
            border-radius: 20px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            width: 100%;
            max-width: 450px;
            display: flex;
            flex-direction: column;
            align-items: center;
            position: relative;
            overflow: hidden;
        }

        .login-container::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(to right, #004d99, #00aaff);
        }

        h2 {
            text-align: center;
            font-size: 2.2rem;
            margin-bottom: 25px;
            color: #004d99;
            font-weight: 700;
            width: 100%;
        }

        /* Form Improvements */
        form {
            width: 100%;
        }

        .input-container {
            position: relative;
            width: 100%;
            margin-bottom: 22px;
        }

        input {
            width: 100%;
            padding: 14px 45px 14px 45px;
            border-radius: 8px;
            border: 1px solid #ddd;
            font-size: 1rem;
            transition: all 0.3s ease;
            background-color: #f9f9f9;
        }

        input:focus {
            outline: none;
            border-color: #004d99;
            box-shadow: 0 0 0 3px rgba(0, 77, 153, 0.2);
            background-color: #fff;
        }

        .input-icon {
            position: absolute;
            left: 15px;
            top: 50%;
            transform: translateY(-50%);
            font-size: 1.2em;
            color: #004d99;
        }

        /* Button Enhancements */
        button {
            background-color: #004d99;
            color: white;
            padding: 14px 20px;
            border: none;
            border-radius: 10px;
            cursor: pointer;
            width: 100%;
            font-size: 1.1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            margin-top: 10px;
            box-shadow: 0 4px 6px rgba(0, 77, 153, 0.2);
        }

        button:hover {
            background-color: #003366;
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0, 77, 153, 0.3);
        }

        button:active {
            transform: translateY(0);
        }

        /* Remember Me Improvements */
        .remember-me {
            display: flex;
            align-items: center;
            margin-top: 15px;
            font-size: 0.95rem;
            width: 100%;
        }

        .remember-me input {
            width: auto;
            margin-right: 10px;
            accent-color: #004d99;
        }

        .remember-me label {
            color: #555;
            cursor: pointer;
        }

        /* Registration Footer */
        .registration-footer {
            margin-top: 20px;
            text-align: center;
            width: 100%;
        }

        .registration-footer p {
            color: #555;
            font-size: 0.95rem;
        }

        .registration-footer a {
            color: #004d99;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s ease;
        }

        .registration-footer a:hover {
            color: #003366;
            text-decoration: underline;
        }

        /* Footer Improvements */
        footer {
            text-align: center;
            padding: 18px 0;
            font-size: 0.95rem;
            color: #FFFFFF;
            background-color: rgba(0, 51, 102, 0.95);
            width: 100%;
            margin-top: auto;
        }

        footer p {
            margin: 0;
        }

        footer a {
            color: #ADD8E6;
            text-decoration: none;
            font-weight: 500;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #FFFFFF;
            text-decoration: underline;
        }

        /* Responsive Adjustments */
        @media (max-width: 768px) {
            .header-text {
                font-size: 1.3rem;
            }
            
            .login-container {
                padding: 25px 20px;
                max-width: 90%;
            }
            
            h2 {
                font-size: 1.8rem;
            }
        }

        @media (max-width: 480px) {
            header {
                padding: 12px 15px;
            }
            
            .logo {
                width: 65px;
                margin-right: 10px;
            }
            
            .header-text {
                font-size: 1.1rem;
            }
            
            input {
                padding: 12px 40px 12px 40px;
            }
        }
    </style>
</head>
<body>

<header>
    <div class="logo-container">
        <img src="https://i.postimg.cc/0QvVb3kG/gip2.png" alt="GIP Portal Logo" class="logo">
        <div class="header-text">
            Government Internship Program Monitoring System
        </div>
    </div>
</header>

<main class="main-content">
    <div class="login-container">
        <h2>Login</h2>

        <!-- Login Form -->
        <form action="login" method="post">
            <!-- Email Input with Icon -->
            <div class="input-container">
                <i class="fas fa-envelope input-icon"></i>
                <input type="email" name="email" placeholder="Enter your email" required>
            </div>

            <!-- Password Input with Icon -->
            <div class="input-container">
                <i class="fas fa-lock input-icon"></i>
                <input type="password" name="password" placeholder="Enter your password" required>
            </div>

            <!-- Remember Me Checkbox -->
            <div class="remember-me">
                <input type="checkbox" name="rememberMe" id="rememberMe">
                <label for="rememberMe">Remember Me</label>
            </div>

            <button type="submit">Login</button>
        </form>

        <div class="registration-footer">
            <p>Don't have an account? <a href="register.jsp">Register here</a></p>
        </div>
    </div>
</main>

<footer>
    <p>&copy; 2025 Department of Labor and Employment | <a href="https://www.dole.gov.ph" target="_blank">DOLE Laguna Official Website</a></p>
</footer>

</body>
</html>