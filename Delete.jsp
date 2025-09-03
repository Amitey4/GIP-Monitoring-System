<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String recordId = request.getParameter("recordId");
        if (recordId == null || recordId.isEmpty()) {
            session.setAttribute("errorMessage", "Record ID is required for deletion");
            response.sendRedirect("Others.jsp");
            return;
        }

        // FIXED: Changed table name from gip_records to gip_others
        String deleteQuery = "DELETE FROM gip_others WHERE id_no = ?";
        PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery);
        deleteStmt.setString(1, recordId);

        int rowsDeleted = deleteStmt.executeUpdate();
        if (rowsDeleted > 0) {
            session.setAttribute("successMessage", "GIP record deleted successfully!");
        } else {
            session.setAttribute("errorMessage", "Failed to delete GIP record. Record not found.");
        }

        deleteStmt.close();
        conn.close();
    } catch (Exception e) {
        session.setAttribute("errorMessage", "Error deleting record: " + e.getMessage());
        e.printStackTrace();
    }
    
    response.sendRedirect("Others.jsp");
%>