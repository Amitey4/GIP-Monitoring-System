<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String idNo = request.getParameter("idNo");
        if (idNo == null || idNo.isEmpty()) {
            session.setAttribute("errorMessage", "GIP ID is required");
            response.sendRedirect("Others.jsp");
            return;
        }
        
        String lastName = request.getParameter("lastName");
        String firstName = request.getParameter("firstName");
        String middleName = request.getParameter("middleName");
        String extensionName = request.getParameter("extensionName");
        String designation = request.getParameter("designation");
        String address = request.getParameter("address");
        String contactNumber = request.getParameter("contactNumber");
        String sex = request.getParameter("sex");
        String birthDate = request.getParameter("birthDate");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");

        // Validate required fields
        if (lastName == null || lastName.isEmpty() || 
            firstName == null || firstName.isEmpty() ||
            contactNumber == null || contactNumber.isEmpty() ||
            sex == null || sex.isEmpty() ||
            birthDate == null || birthDate.isEmpty() ||
            startDate == null || startDate.isEmpty() ||
            endDate == null || endDate.isEmpty()) {
            
            session.setAttribute("errorMessage", "All required fields must be filled out");
            response.sendRedirect("Others.jsp");
            return;
        }

        // Initialize address components
        String street = "";
        String barangay = "";
        String municipality = "";
        String province = "";
        
        // Process address only if it's provided and not empty
        if (address != null && !address.trim().isEmpty()) {
            String[] addressParts = address.split(",");
            
            // Assign values based on available parts
            if (addressParts.length > 0) street = addressParts[0].trim();
            if (addressParts.length > 1) barangay = addressParts[1].trim();
            if (addressParts.length > 2) municipality = addressParts[2].trim();
            if (addressParts.length > 3) province = addressParts[3].trim();
        }

        // If address was not provided or is empty, set default values
        if (street.isEmpty() && barangay.isEmpty() && municipality.isEmpty() && province.isEmpty()) {
            street = "No Address provided";
            barangay = "No Address provided";
            municipality = "No Address provided";
            province = "No Address provided";
        }

        // Log the address parts for debugging
        System.out.println("Original Address: " + address);
        System.out.println("Street: " + street);
        System.out.println("Barangay: " + barangay);
        System.out.println("Municipality: " + municipality);
        System.out.println("Province: " + province);

        // Check for duplicate ID number
        String checkIdQuery = "SELECT id_no FROM gip_others WHERE id_no = ?";
        PreparedStatement checkIdStmt = conn.prepareStatement(checkIdQuery);
        checkIdStmt.setString(1, idNo);
        ResultSet checkIdRs = checkIdStmt.executeQuery();

        if (checkIdRs.next()) {
            session.setAttribute("errorMessage", "Error adding record: GIP ID already exists!");
            checkIdRs.close();
            checkIdStmt.close();
            conn.close();
            response.sendRedirect("Others.jsp");
            return;
        }
        checkIdRs.close();
        checkIdStmt.close();

        // Check for duplicate record based on full name and birthdate
        String checkDuplicateQuery = "SELECT id_no FROM gip_others WHERE last_name = ? AND first_name = ? " +
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
            response.sendRedirect("Others.jsp");
            return;
        }
        checkDuplicateRs.close();
        checkDuplicateStmt.close();

        // If no duplicates found, proceed with insertion
        String insertQuery = "INSERT INTO gip_others (id_no, last_name, first_name, middle_name, "
                + "extension_name, designation, street, barangay, municipality, province, contact_number, sex, birth_date, "
                + "start_date, end_date, status, days_worked, number_late, total_late, absences) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

        PreparedStatement insertStmt = conn.prepareStatement(insertQuery);
        insertStmt.setString(1, idNo);
        insertStmt.setString(2, lastName);
        insertStmt.setString(3, firstName);
        insertStmt.setString(4, middleName != null ? middleName : "");
        insertStmt.setString(5, extensionName != null ? extensionName : "");
        insertStmt.setString(6, designation != null ? designation : "");
        insertStmt.setString(7, street);
        insertStmt.setString(8, barangay);
        insertStmt.setString(9, municipality);
        insertStmt.setString(10, province);
        insertStmt.setString(11, contactNumber);
        insertStmt.setString(12, sex);
        insertStmt.setDate(13, java.sql.Date.valueOf(birthDate));
        insertStmt.setDate(14, java.sql.Date.valueOf(startDate));
        insertStmt.setDate(15, java.sql.Date.valueOf(endDate));
        insertStmt.setString(16, "Active");
        insertStmt.setInt(17, 0);
        insertStmt.setInt(18, 0);
        insertStmt.setDouble(19, 0);
        insertStmt.setInt(20, 0);

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
        session.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
        response.sendRedirect("Others.jsp");
        return;
    } catch (SQLException e) {
        session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        response.sendRedirect("Others.jsp");
        return;
    } catch (Exception e) {
        session.setAttribute("errorMessage", "Error adding record: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect("Others.jsp");
        return;
    }
    
    response.sendRedirect("Others.jsp");
%>
