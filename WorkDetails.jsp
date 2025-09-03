<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<%
    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String recordId = request.getParameter("recordId");
        if (recordId == null || recordId.isEmpty()) {
            session.setAttribute("errorMessage", "Record ID is required for work details update");
            response.sendRedirect("Others.jsp");
            return;
        }
        
        int daysWorked = Integer.parseInt(request.getParameter("daysWorked"));
        int absences = Integer.parseInt(request.getParameter("absences"));
        int numberLate = Integer.parseInt(request.getParameter("numberLate"));
        double totalLate = Double.parseDouble(request.getParameter("totalLate"));

        // Calculate days to extend (excluding weekends)
        int daysToExtend = absences;
        int businessDaysToAdd = 0;
        
        // Get current end date
        String getDateQuery = "SELECT end_date FROM gip_others WHERE id_no = ?";
        PreparedStatement getDateStmt = conn.prepareStatement(getDateQuery);
        getDateStmt.setString(1, recordId);
        ResultSet dateRs = getDateStmt.executeQuery();
        
        java.sql.Date newEndDate = null;
        if (dateRs.next()) {
            java.sql.Date currentEndDate = dateRs.getDate("end_date");
            Calendar cal = Calendar.getInstance();
            cal.setTime(currentEndDate);
            
            // Add business days (excluding weekends)
            while (businessDaysToAdd < daysToExtend) {
                cal.add(Calendar.DATE, 1);
                int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
                if (dayOfWeek != Calendar.SATURDAY && dayOfWeek != Calendar.SUNDAY) {
                    businessDaysToAdd++;
                }
            }
            
            // Convert java.util.Date to java.sql.Date
            newEndDate = new java.sql.Date(cal.getTime().getTime());
        }
        dateRs.close();
        getDateStmt.close();

        String updateWorkQuery = "UPDATE gip_others SET days_worked = ?, absences = ?, "
                + "number_late = ?, total_late = ?, end_date = ? WHERE id_no = ?";

        PreparedStatement updateWorkStmt = conn.prepareStatement(updateWorkQuery);
        updateWorkStmt.setInt(1, daysWorked);
        updateWorkStmt.setInt(2, absences);
        updateWorkStmt.setInt(3, numberLate);
        updateWorkStmt.setDouble(4, totalLate);
        updateWorkStmt.setDate(5, newEndDate);
        updateWorkStmt.setString(6, recordId);

        int rowsUpdated = updateWorkStmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("successMessage", "Work details updated successfully! Contract extended by " + businessDaysToAdd + " business days due to absences.");
        } else {
            session.setAttribute("errorMessage", "Failed to update work details.");
        }

        updateWorkStmt.close();
        conn.close();
    } catch (Exception e) {
        session.setAttribute("errorMessage", "Error updating work details: " + e.getMessage());
        e.printStackTrace();
    }
    
    response.sendRedirect("Others.jsp");
%>