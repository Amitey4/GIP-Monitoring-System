<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.net.URLEncoder, java.util.*" %>
<%
    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String idNo = request.getParameter("idNo");
        String municipalityParam = request.getParameter("municipality");
        
        if (idNo == null || idNo.isEmpty()) {
            session.setAttribute("errorMessage", "GIP ID is required");
            // Use URL encoding for the redirect
            String redirectFile = getMunicipalityFileName(municipalityParam);
            response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
            return;
        }
        
        String lastName = request.getParameter("lastName");
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String extensionName = request.getParameter("extensionName");
        String street = request.getParameter("street");
        String barangay = request.getParameter("barangay");
        String municipality = request.getParameter("municipality");
        String province = request.getParameter("province");
        String contactNumber = request.getParameter("contactNumber");
        String sex = request.getParameter("sex");
        String birthDate = request.getParameter("birthDate");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Validate required fields
        if (lastName == null || lastName.isEmpty() || 
            firstName == null || firstName.isEmpty() ||
            barangay == null || barangay.isEmpty() ||
            municipality == null || municipality.isEmpty() ||
            province == null || province.isEmpty() ||
            contactNumber == null || contactNumber.isEmpty() ||
            sex == null || sex.isEmpty() ||
            birthDate == null || birthDate.isEmpty() ||
            startDate == null || startDate.isEmpty() ||
            endDate == null || endDate.isEmpty()) {
            
            session.setAttribute("errorMessage", "All required fields must be filled out");
            String redirectFile = getMunicipalityFileName(municipality);
            response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
            return;
        }

        // Check for duplicate ID number
        String checkIdQuery = "SELECT id_no FROM gip_records WHERE id_no = ?";
        PreparedStatement checkIdStmt = conn.prepareStatement(checkIdQuery);
        checkIdStmt.setString(1, idNo);
        ResultSet checkIdRs = checkIdStmt.executeQuery();

        if (checkIdRs.next()) {
            session.setAttribute("errorMessage", "Error adding record: GIP ID already exists!");
            checkIdRs.close();
            checkIdStmt.close();
            conn.close();
            
            String redirectFile = getMunicipalityFileName(municipality);
            response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
            return;
        }
        checkIdRs.close();
        checkIdStmt.close();

        // Check for duplicate record based on full name and birthdate
        String checkDuplicateQuery = "SELECT id_no FROM gip_records WHERE last_name = ? AND first_name = ? " +
                                    "AND COALESCE(middle_name, '') = COALESCE(?, '') " +
                                    "AND COALESCE(extension_name, '') = COALESCE(?, '') " +
                                    "AND birth_date = ?";
        PreparedStatement checkDuplicateStmt = conn.prepareStatement(checkDuplicateQuery);
        checkDuplicateStmt.setString(1, lastName);
        checkDuplicateStmt.setString(2, firstName);
        checkDuplicateStmt.setString(3, middleName);
        checkDuplicateStmt.setString(4, extensionName);
        checkDuplicateStmt.setDate(5, java.sql.Date.valueOf(birthDate));
        
        ResultSet checkDuplicateRs = checkDuplicateStmt.executeQuery();
        
        if (checkDuplicateRs.next()) {
            session.setAttribute("errorMessage", "Warning: A record with the same full name and birthdate already exists!");
            checkDuplicateRs.close();
            checkDuplicateStmt.close();
            conn.close();
            
            String redirectFile = getMunicipalityFileName(municipality);
            response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
            return;
        }
        checkDuplicateRs.close();
        checkDuplicateStmt.close();

        // If no duplicates found, proceed with insertion
        String insertQuery = "INSERT INTO gip_records (id_no, last_name, first_name, middle_name, "
                + "extension_name, street, barangay, municipality, province, contact_number, sex, "
                + "birth_date, start_date, end_date, status, days_worked, number_late, total_late, absences) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
        insertStmt.setString(1, idNo);
        insertStmt.setString(2, lastName);
        insertStmt.setString(3, firstName);
        insertStmt.setString(4, middleName != null ? middleName : "");
        insertStmt.setString(5, extensionName != null ? extensionName : "");
        insertStmt.setString(6, street != null ? street : "");
        insertStmt.setString(7, barangay);
        insertStmt.setString(8, municipality);
        insertStmt.setString(9, province);
        insertStmt.setString(10, contactNumber);
        insertStmt.setString(11, sex);
        insertStmt.setDate(12, java.sql.Date.valueOf(birthDate));
        insertStmt.setDate(13, java.sql.Date.valueOf(startDate));
        insertStmt.setDate(14, java.sql.Date.valueOf(endDate));
        insertStmt.setString(15, "Active");
        insertStmt.setInt(16, 0);
        insertStmt.setInt(17, 0);
        insertStmt.setDouble(18, 0);
        insertStmt.setInt(19, 0);

        int rowsInserted = insertStmt.executeUpdate();
        if (rowsInserted > 0) {
            session.setAttribute("successMessage", "GIP record added successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to add GIP record.");
        }

        insertStmt.close();
        conn.close();
    } catch (IllegalArgumentException e) {
        // Handle date format errors
        String municipality = request.getParameter("municipality");
        session.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
        String redirectFile = getMunicipalityFileName(municipality);
        response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
        return;
    } catch (SQLException e) {
        String municipality = request.getParameter("municipality");
        session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        String redirectFile = getMunicipalityFileName(municipality);
        response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
        return;
    } catch (Exception e) {
        String municipality = request.getParameter("municipality");
        session.setAttribute("errorMessage", "Error adding record: " + e.getMessage());
        String redirectFile = getMunicipalityFileName(municipality);
        response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
        return;
    }
    
    // Redirect back to the municipality's page
    String municipality = request.getParameter("municipality");
    if (municipality == null || municipality.isEmpty()) {
        municipality = "Monitoring"; // default
    }
    
    // Get the correct file name for the municipality
    String municipalityFile = getMunicipalityFileName(municipality);
    response.sendRedirect(URLEncoder.encode(municipalityFile, "UTF-8") + ".jsp");
%>

<%!
    // Method to map municipality names to file names
    private String getMunicipalityFileName(String municipality) {
        if (municipality == null) {
            return "Monitoring";
        }
        
        // Map municipality display names to file names
        switch(municipality) {
            case "Biñan": return "Biñan"; // Keep original filename with special character
            case "Los Baños": return "LosBaños"; // Keep original filename with special character
            case "Santa Cruz": return "SantaCruz";
            case "Santa Maria": return "SantaMaria";
            case "San Pablo": return "SanPablo";
            case "San Pedro": return "SanPedro";
            case "Santa Rosa": return "SantaRosa";
            default: 
                // For other municipalities without special characters
                return municipality.replace(" ", "");
        }
    }
%>
