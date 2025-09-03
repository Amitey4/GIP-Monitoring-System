<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Forgot Password | GIP Portal | DOLE Laguna</title>
    <link rel="stylesheet" href="styles.css">
    <!-- Include Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts for DOLE-like fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Roboto', sans-serif;
            background-color: #f0f0f0;
            display: flex;
            flex-direction: column;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .container {
            text-align: center;
            padding: 35px;
            background-color: white;
            box-shadow: 0px 4px 15px rgba(0, 0, 0, 0.1);
            border-radius: 8px;
            max-width: 400px;
            width: 105%;
        }

        h2 {
            color: #004d99;
        }

        input[type="email"] {
            width: 100%;
            padding: 10px;
            margin: 10px 0;
            border-radius: 5px;
            border: 1px solid #ddd;
        }

        button {
            background-color: #004d99;
            color: white;
            padding: 10px 20px;
            border: none;
            border-radius: 5px;
            cursor: pointer;
            width: 106%;
        }

        button:hover {
            background-color: #003366;
        }

        .error-message {
            color: red;
            font-size: 1.1em;
            margin-bottom: 15px;
            display: none;
        }
    </style>
</head>
<body>

<div class="container">
    <h2>Forgot Password</h2>
    <p>Enter your email address below to reset your password.</p>
    
    <!-- Error message -->
    <div id="error-message" class="error-message">Please enter a valid email address.</div>
    
    <!-- Forgot Password Form -->
    <form action="ForgotPasswordServlet" method="post" onsubmit="return validateEmail()">
        <input type="email" id="email" name="email" placeholder="Enter your email" required>
        <button type="submit">Send Reset Link</button>
    </form>
</div>

<script>
    // JavaScript to validate email format
    function validateEmail() {
        const email = document.getElementById('email').value;
        const errorMessage = document.getElementById('error-message');

        // Simple email validation regex
        const emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,6}$/;
        if (!emailPattern.test(email)) {
            errorMessage.style.display = 'block';
            return false;
        }

        errorMessage.style.display = 'none';
        return true;
    }
</script>

</body>
</html>
