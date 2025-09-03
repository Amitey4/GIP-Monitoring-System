<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register | GIP Portal</title>
    <link rel="stylesheet" href="styles.css">
    <!-- Include Font Awesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet">
    <!-- Google Fonts for DOLE-like fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;500;700&display=swap" rel="stylesheet">
    <style>
        /* Basic Reset */
        body, h1, h2, p, img {
            margin: 0;
            padding: 0;
        }

        body {
            font-family: 'Roboto', sans-serif;
            background: linear-gradient(to right, #004d99, #00aaff); 
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }

        header {
            background-color: #004d99; 
            color: white;
            padding: 9px 0;
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            padding: 10px 20px;
            box-sizing: border-box;
        }

        .logo {
            width: 80px;
            height: auto;
        }

        .header-buttons {
            display: flex;
            gap: 15px;
        }

        .header-buttons a {
            display: inline-block;
            padding: 10px 20px;
            background-color: #004d99;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            font-size: 1.1em;
            transition: background-color 0.3s;
            border: 0px solid rgba(255,255,255,0.2);
        }

        .header-buttons a:hover {
            background-color: #003366;
        }

        main {
            display: flex;
            justify-content: center;
            align-items: center;
            flex-grow: 1;
            padding: 20px;
        }

        .register-container {
            width: 100%;
            max-width: 500px;
            background: white;
            padding: 30px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        .register-container h2 {
            color: #004d99;
            text-align: center;
            margin-bottom: 25px;
            font-size: 1.8em;
        }

        .form-group {
            margin-bottom: 20px;
        }

        .form-group label {
            display: block;
            font-weight: 500;
            margin-bottom: 8px;
            color: #333;
        }

        .form-group input, 
        .form-group select {
            width: 100%;
            padding: 12px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-family: 'Roboto', sans-serif;
            box-sizing: border-box;
        }

        .submit-btn {
            width: 100%;
            padding: 12px;
            background-color: #004d99;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s;
            margin-top: 10px;
        }

        .submit-btn:hover {
            background-color: #003366;
        }

        footer {
            text-align: center;
            padding: 20px;
            font-size: 1.1em;
            color: #FFFFFF;
            background-color: rgba(0,0,0,0.1);
        }

        footer a {
            color: #ADD8E6;
            text-decoration: none;
        }

        .role-fields {
            display: none;
            margin-top: 15px;
            padding: 15px;
            background-color: #f5f5f5;
            border-radius: 5px;
            border-left: 4px solid #004d99;
        }

        .form-group.checkbox {
            display: flex;
            align-items: center;
            margin-top: 20px;
        }

        .form-group.checkbox input {
            width: auto;
            margin-right: 10px;
        }

        .form-group.checkbox label {
            margin-bottom: 0;
            font-weight: normal;
        }
    </style>
</head>
<body>

<header>
    <!-- Logo on the left -->
    <img src="https://i.postimg.cc/0QvVb3kG/gip2.png" alt="GIP Portal Logo" class="logo">
    
    <!-- Header Buttons on the right -->
    <div class="header-buttons">
        <a href="about.jsp"><i class="fas fa-info-circle"></i> About GIP</a>
        <a href="register.jsp"><i class="fas fa-user-plus"></i> Register</a>
        <a href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
    </div>
</header>

<main>
    <!-- Registration Form Section -->
    <div class="register-container">
        <h2><i class="fas fa-user-plus"></i> GIP Registration</h2>
        <form action="register" method="post">
            <!-- Full Name Field -->
            <div class="form-group">
                <label>Full Name *</label>
                <input type="text" name="fullName" required>
            </div>

            <div class="form-group">
                <label>Email *</label>
                <input type="email" name="email" required>
            </div>

            <div class="form-group">
                <label>Password *</label>
                <input type="password" name="password" required>
            </div>

            <div class="form-group">
                <label>Confirm Password *</label>
                <input type="password" name="confirmPassword" required>
            </div>

            <div class="form-group">
                <label>Role *</label>
                <select name="role" id="role" required onchange="toggleFields()">
                    <option value="" disabled selected>Select Role</option>
                    <option value="GIP">GIP</option>
                    <option value="Admin">Admin</option>
                </select>
            </div>

            <!-- GIP Fields -->
            <div id="gipFields" class="role-fields">
                <div class="form-group">
                    <label>ID No *</label>
                    <input type="text" name="idNo">
                </div>
                <div class="form-group">
                    <label>Province *</label>
                    <select name="province" id="province" onchange="updateMunicipalities()">
                        <option value="" disabled selected>Select Province</option>
                        <option value="Batangas">Batangas</option>
                        <option value="Cavite">Cavite</option>
                        <option value="Laguna">Laguna</option>
                        <option value="Quezon">Quezon</option>
                        <option value="Rizal">Rizal</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Municipality *</label>
                    <select name="municipality" id="municipality">
                        <option value="" disabled selected>Select Municipality</option>
                    </select>
                </div>
            </div>

            <!-- Admin Fields -->
            <div id="adminFields" class="role-fields">
                <div class="form-group">
                    <label>Employee ID *</label>
                    <input type="text" name="employeeId">
                </div>
                <div class="form-group">
                    <label>Office *</label>
                    <select name="office">
                        <option value="" disabled selected>Select Office</option>
                        <option value="DOLE Laguna">DOLE Laguna</option>
                        <option value="Municipality Office">Municipality Office</option>
                    </select>
                </div>
            </div>

            <div class="form-group checkbox">
                <input type="checkbox" name="privacyPolicy" id="privacyPolicy" required>
                <label for="privacyPolicy">I agree to the privacy policy</label>
            </div>

            <button class="submit-btn" type="submit"><i class="fas fa-user-plus"></i> Register</button>
        </form>
    </div>
</main>

<footer>
    <p>&copy; 2025 Department of Labor and Employment | <a href="https://www.dole.gov.ph" target="_blank">DOLE Laguna Official Website</a></p>
</footer>

<script>
    function toggleFields() {
        const role = document.getElementById("role").value;
        document.getElementById("gipFields").style.display = (role === "GIP") ? "block" : "none";
        document.getElementById("adminFields").style.display = (role === "Admin") ? "block" : "none";
    }

    function updateMunicipalities() {
        const province = document.getElementById("province").value;
        const municipality = document.getElementById("municipality");
        municipality.innerHTML = '<option value="" disabled selected>Select Municipality</option>';

        const municipalities = {
            "Batangas": ["Agoncillo", "Alitagtag", "Balayan", "Balete(BS)", "Batangas City", "Bauan", "Calaca", "Calatagan", "Cuenca", "Ibaan", "Laurel", "Lemery (BS)", "Lian", "Lipa", "Lobo", "Mabini (BS)", "Malvar", "Mataas na kahoy", "Nasugbu", "Padre Garcia", "Rosario (BS)", "San Jose(BS)", "San Juan (BS)", "San Luis (BS)", "San Nicolas (BS)", "San Pascual (BS)", "Santa Teresita (BS)", "Santo Tomas (BS)", "Taal", "Talisay", "Tanauan", "Taysan", "Tingloy", "Tuy"],
            "Cavite": ["Alfonso", "Amadeo", "Bacoor", "Carmona", "Cavite", "Dasmarinas", "Gen. Emilio Aguinaldo", "Gen. Mariano Alvarez", "General Trias", "Imus", "Indang", "Kawit", "Magallanes", "Maragondon", "Mendez", "Naic", "Noveleta", "Rosario", "Silang", "Tagaytay", "Tanza", "Ternate", "Trece Martires"],
            "Laguna": ["Alaminos", "Bay", "Binan", "Cabuyao", "Calamba", "Calauan", "Cavinti", "Famy", "Kalayaan", "Liliw", "Los Banos", "Luisiana", "Lumban", "Mabitac", "Magdalena", "Majayjay", "Nagcarlan", "Paete", "Pagsanjan", "Pakil", "Pangil", "Pila", "Rizal", "San Pablo", "San Pedro", "Santa Cruz", "Santa Maria", "Santa Rosa", "Siniloan", "Victora"],
            "Quezon": ["Agdangan", "Alabat", "Atimonan", "Buenavista", "Burdeos", "Calauag", "Candelaria", "Catanuan", "Dolores", "General Nakar", "Guinayangan", "Gumaca", "Infanta", "Jomalig", "Lopez", "Lucban", "Macalelon", "Mauban", "Mulanay", "Padre Burgos", "Pagbilao", "Panukulan", "Patnanungan", "Perez", "Pitogo", "Plaridel", "Polillo", "Quezon", "Real", "Sampaloc", "San Andres", "San Antonio", "San Francisco", "Sariaya", "Tangkawayan", "Tayabas", "Tiaong", "Unisan"],
            "Rizal": ["Angono", "Antipolo", "Baras", "Binangonan", "Cainta", "Cardona", "Jalajala", "Morong", "Pililla", "Rodriguez", "San Mateo", "Tanay", "Taytay", "Teresa"]
        };

        if (municipalities[province]) {
            municipalities[province].forEach(function(city) {
                const option = document.createElement("option");
                option.value = city;
                option.text = city;
                municipality.appendChild(option);
            });
        }
    }
</script>

</body>
</html>
