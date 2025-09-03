<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About GIP - Government Internship Program</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&display=swap" rel="stylesheet">
    <style>
        :root {
            --dole-blue: #004d99;
            --dole-light-blue: #d0e5f5;
            --dole-yellow: #ffcc00;
            --dole-dark-blue: #003366;
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: 'Roboto', 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background: linear-gradient(135deg, #004d99 0%, #00aaff 100%);
            color: #333;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
        }
        
        .page-wrapper {
            flex: 1;
            display: flex;
            flex-direction: column;
        }
        
        header {
            background-color: var(--dole-blue);
            color: white;
            padding: 0;
            width: 100%;
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 0 5%;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.2);
            position: relative;
            z-index: 1000;
        }
        
        .header-content {
            display: flex;
            justify-content: space-between;
            align-items: center;
            width: 100%;
            max-width: 1400px;
            margin: 0 auto;
            padding: 10px 0;
        }
        
        .logo-container {
            display: flex;
            align-items: center;
        }
        
        .header-buttons {
            display: flex;
            gap: 15px;
        }
        
        .header-buttons a {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            padding: 12px 20px;
            background-color: var(--dole-dark-blue);
            color: white;
            text-decoration: none;
            border-radius: 50px;
            font-size: 1em;
            font-weight: 500;
            transition: all 0.3s ease;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }

        .header-buttons a:hover {
            background-color: #00264d;
            transform: translateY(-2px);
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
        }
        
        .main-content {
            flex: 1;
            width: 100%;
            padding: 20px 0;
        }
        
        .content-container {
            background-color: white;
            border-radius: 15px;
            box-shadow: 0 10px 30px rgba(0, 0, 0, 0.15);
            margin: 20px auto;
            padding: 30px;
            width: 95%;
            max-width: 1400px;
        }
        
        .hero-section {
            background: linear-gradient(rgba(0, 77, 153, 0.85), rgba(0, 77, 153, 0.95)), url('https://i.postimg.cc/wMZZRrCF/HEAD.jpg') center/cover no-repeat;
            color: white;
            padding: 100px 0;
            margin-bottom: 40px;
            border-radius: 15px;
            text-align: center;
            position: relative;
            overflow: hidden;
        }
        
        .hero-section::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: url('https://i.postimg.cc/wMZZRrCF/HEAD.jpg') center/cover no-repeat;
            z-index: -1;
        }
        
        .hero-content {
            max-width: 800px;
            margin: 0 auto;
            position: relative;
            z-index: 2;
        }
        
        .section-title {
            color: var(--dole-blue);
            position: relative;
            padding-bottom: 15px;
            margin-bottom: 30px;
            font-weight: 700;
        }
        
        .section-title:after {
            content: '';
            position: absolute;
            bottom: 0;
            left: 0;
            width: 70px;
            height: 4px;
            background-color: var(--dole-yellow);
            border-radius: 2px;
        }
        
        .section-title.text-center:after {
            left: 50%;
            transform: translateX(-50%);
        }
        
        .card {
            border: none;
            border-radius: 15px;
            overflow: hidden;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            margin-bottom: 25px;
            height: 100%;
        }
        
        .card:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }
        
        .card-img-top {
            height: 200px;
            object-fit: cover;
        }
        
        .btn-primary {
            background-color: var(--dole-blue);
            border-color: var(--dole-blue);
            border-radius: 50px;
            padding: 10px 25px;
            font-weight: 500;
            transition: all 0.3s ease;
        }
        
        .btn-primary:hover {
            background-color: #003366;
            border-color: #003366;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(0, 0, 0, 0.2);
        }
        
        .bg-light-blue {
            background-color: var(--dole-light-blue);
            border-radius: 15px;
            padding: 40px 30px;
        }
        
        .icon-box {
            text-align: center;
            padding: 40px 25px;
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            height: 100%;
        }
        
        .icon-box:hover {
            transform: translateY(-5px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }
        
        .icon-box i {
            font-size: 50px;
            color: var(--dole-blue);
            margin-bottom: 25px;
            background: var(--dole-light-blue);
            width: 90px;
            height: 90px;
            line-height: 90px;
            border-radius: 50%;
            text-align: center;
        }
        
        /* GIP in Action Styles */
        .gip-action-item {
            background: white;
            border-radius: 15px;
            padding: 30px 25px;
            text-align: center;
            height: 100%;
            box-shadow: 0 8px 20px rgba(0, 0, 0, 0.1);
            transition: all 0.3s ease;
            position: relative;
            overflow: hidden;
        }
        
        .gip-action-item::before {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 5px;
            background: linear-gradient(90deg, var(--dole-blue), var(--dole-yellow));
        }
        
        .gip-action-item:hover {
            transform: translateY(-8px);
            box-shadow: 0 12px 25px rgba(0, 0, 0, 0.15);
        }
        
        .gip-action-item i {
            font-size: 50px;
            color: var(--dole-blue);
            margin-bottom: 20px;
            background: var(--dole-light-blue);
            width: 80px;
            height: 80px;
            line-height: 80px;
            border-radius: 50%;
            text-align: center;
            transition: all 0.3s ease;
        }
        
        .gip-action-item:hover i {
            background: var(--dole-blue);
            color: white;
            transform: scale(1.1);
        }
        
        .gip-action-item h5 {
            color: var(--dole-dark-blue);
            margin-bottom: 15px;
            font-weight: 600;
        }
        
        .gip-action-item p {
            color: #555;
            line-height: 1.6;
        }
        
        footer {
            text-align: center;
            padding: 25px 0;
            font-size: 1em;
            color: #FFFFFF;
            background-color: var(--dole-dark-blue);
            width: 100%;
            margin-top: auto;
        }

        footer p {
            margin: 0;
        }

        footer a {
            color: #ADD8E6;
            text-decoration: none;
            font-weight: bold;
            transition: color 0.3s ease;
        }

        footer a:hover {
            color: #FFFFFF;
            text-decoration: underline;
        }
        
        /* Animation effects */
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        
        .animate-fadeIn {
            animation: fadeIn 1s ease forwards;
        }
        
        /* Responsive adjustments */
        @media (max-width: 992px) {
            .header-content {
                flex-direction: column;
                padding: 15px 0;
            }
            
            .header-buttons {
                margin-top: 15px;
                flex-wrap: wrap;
                justify-content: center;
            }
            
            .hero-section {
                padding: 70px 0;
            }
        }
        
        @media (max-width: 768px) {
            .content-container {
                padding: 20px;
                width: 98%;
            }
            
            .header-buttons a {
                padding: 10px 15px;
                font-size: 0.9em;
            }
            
            .hero-section {
                padding: 50px 0;
            }
            
            .gip-action-item {
                padding: 20px 15px;
            }
            
            .gip-action-item i {
                font-size: 40px;
                width: 70px;
                height: 70px;
                line-height: 70px;
            }
        }
    </style>
</head>
<body>
<div class="page-wrapper">
    <header>
        <div class="header-content">
            <!-- Logo on the left -->
            <div class="logo-container">
                <img src="https://i.postimg.cc/0QvVb3kG/gip2.png" alt="GIP Portal Logo" width="95">
            </div>
            
            <!-- Header Buttons on the right -->
            <div class="header-buttons">
                <!-- About GIP Button with Icon -->
                <a href="about.jsp"><i class="fas fa-info-circle"></i> About GIP</a>

                <!-- Register Button with Icon -->
                <a href="register.jsp"><i class="fas fa-user-plus"></i> Register</a>
                
                <!-- Login Button with Icon -->
                <a href="login.jsp"><i class="fas fa-sign-in-alt"></i> Login</a>
            </div>
        </div>
    </header>

    <!-- Main Content Container -->
    <main class="main-content">
        <div class="content-container">
            <!-- Hero Section -->
            <section class="hero-section">
                <div class="hero-content">
                    <h1 class="display-4 fw-bold">Government Internship Program</h1>
                    <p class="lead">Empowering the youth through meaningful government service experience</p>
                </div>
            </section>

            <!-- About GIP Section -->
            <section class="py-5">
                <div class="container">
                    <div class="row">
                        <div class="col-lg-8 mx-auto text-center">
                            <h2 class="section-title">About the Government Internship Program</h2>
                            <p class="lead">The Government Internship Program (GIP) is a component of Kabataan 2000 under Executive Order No. 139 s. 1993, implemented by the Department of Labor and Employment (DOLE).</p>
                            <p>The program aims to provide young workers with opportunities to demonstrate their talents and skills in the field of public service with the ultimate objective of attracting the best and the brightest who want to pursue a career in government service.</p>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Objectives Section -->
            <section class="py-5 bg-light-blue">
                <div class="container">
                    <h2 class="section-title text-center">Program Objectives</h2>
                    <div class="row mt-5">
                        <div class="col-md-4 mb-4">
                            <div class="icon-box">
                                <i class="fas fa-graduation-cap"></i>
                                <h4>Provide Experience</h4>
                                <p>To provide opportunities for young workers to acquire experience in government service.</p>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="icon-box">
                                <i class="fas fa-briefcase"></i>
                                <h4>Career Exposure</h4>
                                <p>To expose the youth to career opportunities in the public sector.</p>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="icon-box">
                                <i class="fas fa-hand-holding-usd"></i>
                                <h4>Financial Support</h4>
                                <p>To provide financial assistance to deserving youth to help with their education.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Program Components -->
            <section class="py-5">
                <div class="container">
                    <h2 class="section-title text-center">Program Components</h2>
                    <div class="row mt-5">
                        <div class="col-md-6 mb-4">
                            <div class="card">
                                <img src="https://i.postimg.cc/RhM9Sqr9/gip1.jpg" class="card-img-top" alt="Internship Placement">
                                <div class="card-body">
                                    <h4 class="card-title">Internship Placement</h4>
                                    <p class="card-text">Interns are assigned to different government agencies, local government units, and other public sector entities where they can learn and contribute.</p>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6 mb-4">
                            <div class="card">
                                <img src="https://i.postimg.cc/rmT2jzwW/gip.jpg" class="card-img-top" alt="Training Program">
                                <div class="card-body">
                                    <h4 class="card-title">Training and Development</h4>
                                    <p class="card-text">Comprehensive training programs are provided to enhance interns' skills in public administration, governance, and professional development.</p>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- Eligibility Section -->
            <section class="py-5 bg-light">
                <div class="container">
                    <h2 class="section-title text-center">Eligibility Requirements</h2>
                    <div class="row mt-4">
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Who Can Apply?</h4>
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item">Filipino citizens aged 18 to 30 years old</li>
                                        <li class="list-group-item">High school graduates, technical-vocational graduates, or college graduates</li>
                                        <li class="list-group-item">Currently enrolled students may also apply</li>
                                        <li class="list-group-item">No work experience or first-time job seekers are prioritized</li>
                                        <li class="list-group-item">Must pass the screening requirements of DOLE</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class="card">
                                <div class="card-body">
                                    <h4 class="card-title">Required Documents</h4>
                                    <ul class="list-group list-group-flush">
                                        <li class="list-group-item">Application Form</li>
                                        <li class="list-group-item">Resume with 2x2 picture</li>
                                        <li class="list-group-item">School credentials (Transcript of Records or Diploma)</li>
                                        <li class="list-group-item">Certificate of Good Moral Character</li>
                                        <li class="list-group-item">Birth Certificate (PSA)</li>
                                    </ul>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </section>

            <!-- GIP in Action Section -->
            <section class="py-5">
                <div class="container">
                    <h2 class="section-title text-center">GIP in Action</h2>
                    <p class="text-center mb-5">See how our interns are making a difference in various government agencies across the country</p>
                    
                    <div class="row">
                        <div class="col-md-4 mb-4">
                            <div class="gip-action-item">
                                <i class="fas fa-users"></i>
                                <h5>Orientation Program</h5>
                                <p>New interns participate in comprehensive orientation sessions to familiarize themselves with government processes and their roles.</p>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="gip-action-item">
                                <i class="fas fa-laptop"></i>
                                <h5>Office Assignments</h5>
                                <p>Interns gain hands-on experience by working on real projects and tasks in various government departments.</p>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="gip-action-item">
                                <i class="fas fa-chart-line"></i>
                                <h5>Skills Development</h5>
                                <p>Regular training sessions help interns develop professional skills that will benefit their future careers.</p>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="gip-action-item">
                                <i class="fas fa-handshake"></i>
                                <h5>Public Service</h5>
                                <p>Interns directly serve the community by assisting in frontline government services and public assistance programs.</p>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="gip-action-item">
                                <i class="fas fa-lightbulb"></i>
                                <h5>Project Implementation</h5>
                                <p>Interns contribute to meaningful government projects and initiatives that benefit local communities.</p>
                            </div>
                        </div>
                        <div class="col-md-4 mb-4">
                            <div class="gip-action-item">
                                <i class="fas fa-graduation-cap"></i>
                                <h5>Program Completion</h5>
                                <p>Successful interns receive certificates of completion and valuable references for future employment opportunities.</p>
                            </div>
                        </div>
                    </div>
                </div>
            </section>
        </div>
    </main>

    <!-- Footer -->
    <footer>
        <p>&copy; 2025 Department of Labor and Employment | <a href="https://www.eservices.dole-laguna.com/" target="_blank">DOLE Laguna Official Website</a></p>
    </footer>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script>
    // Add animation to elements when they come into view
    document.addEventListener('DOMContentLoaded', function() {
        const animatedElements = document.querySelectorAll('.icon-box, .card, .section-title, .gip-action-item');
        
        animatedElements.forEach(element => {
            element.classList.add('animate-fadeIn');
        });
    });
</script>
</body>
</html>

