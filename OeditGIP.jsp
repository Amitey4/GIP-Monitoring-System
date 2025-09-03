<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String editIdNo = request.getParameter("editIdNo");
        if (editIdNo == null || editIdNo.isEmpty()) {
            session.setAttribute("errorMessage", "GIP ID is required for editing");
            response.sendRedirect("Others.jsp");
            return;
        }
        
        String editLastName = request.getParameter("editLastName");
        String editFirstName = request.getParameter("editFirstName");
        String editMiddleName = request.getParameter("editMiddleName");
        String editExtensionName = request.getParameter("editExtensionName");
        String editDesignation = request.getParameter("editDesignation");
        String editContactNumber = request.getParameter("editContactNumber");
        String editSex = request.getParameter("editSex");
        String editBirthDate = request.getParameter("editBirthDate");
        String editStatus = request.getParameter("editStatus");

        // Parse the address into its components (street, barangay, municipality, province)
        String editAddress = request.getParameter("editAddress");
        String street = "";
        String barangay = "";
        String municipality = "";
        String province = "";
        
        if (editAddress != null && !editAddress.isEmpty()) {
            String[] addressParts = editAddress.split(",");
            if (addressParts.length >= 4) {
                street = addressParts[0].trim();
                barangay = addressParts[1].trim();
                municipality = addressParts[2].trim();
                province = addressParts[3].trim();
            }
        }

        String updateQuery = "UPDATE gip_others SET last_name = ?, first_name = ?, middle_name = ?, "
                + "extension_name = ?, designation = ?, street = ?, barangay = ?, "
                + "municipality = ?, province = ?, contact_number = ?, sex = ?, birth_date = ?, status = ? WHERE id_no = ?";

        PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
        updateStmt.setString(1, editLastName);
        updateStmt.setString(2, editFirstName);
        updateStmt.setString(3, editMiddleName);
        updateStmt.setString(4, editExtensionName);
        updateStmt.setString(5, editDesignation);
        updateStmt.setString(6, street);
        updateStmt.setString(7, barangay);
        updateStmt.setString(8, municipality);
        updateStmt.setString(9, province);
        updateStmt.setString(10, editContactNumber);
        updateStmt.setString(11, editSex);
        updateStmt.setDate(12, java.sql.Date.valueOf(editBirthDate));
        updateStmt.setString(13, editStatus);
        updateStmt.setString(14, editIdNo);

        int rowsUpdated = updateStmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("successMessage", "GIP record updated successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to update GIP record. Record not found.");
        }

        updateStmt.close();
        conn.close();
    } catch (Exception e) {
        session.setAttribute("errorMessage", "Error updating record: " + e.getMessage());
        e.printStackTrace();
    }
    
    response.sendRedirect("Others.jsp");
%>