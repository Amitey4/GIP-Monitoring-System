<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.net.URLEncoder" %>
<%
    // Set UTF-8 encoding to handle special characters
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    
    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    // List of valid municipalities
    String[] municipalities = {"Alaminos", "Biñan", "Bay", "Cabuyao", "Calamba", "Calauan", "Cavinti",
                "Famy", "Kalayaan", "Liliw", "Los Baños", "Luisiana", "Lumban",
                "Mabitac", "Magdalena", "Majayjay", "Nagcarlan", "Paete", "Pagsanjan",
                "Pakil", "Pangil", "Pila", "Rizal", "Santa Cruz", "Santa Maria",
                "San Pablo", "San Pedro", "Santa Rosa", "Siniloan", "Victoria"};
    
    // Get the referring page to determine which municipality we're working with
    String referer = request.getHeader("Referer");
    String redirectPage = "Alaminos.jsp"; // default
    
    if (referer != null) {
        for (String municipality : municipalities) {
            // Check both the original name and the mapped filename
            String targetPage = getTargetPageName(municipality);
            if (referer.contains(municipality + ".jsp") || referer.contains(targetPage)) {
                redirectPage = targetPage;
                break;
            }
        }
    }

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String recordId = request.getParameter("recordId");
        if (recordId == null || recordId.isEmpty()) {
            session.setAttribute("errorMessage", "Record ID is required for work details update");
            // Use forward instead of redirect to avoid URL encoding issues
            request.getRequestDispatcher(redirectPage).forward(request, response);
            return;
        }
        
        // Get the municipality from the record itself to ensure correct redirection
        String getMunicipalityQuery = "SELECT municipality FROM gip_records WHERE id_no = ?";
        PreparedStatement getMunicipalityStmt = conn.prepareStatement(getMunicipalityQuery);
        getMunicipalityStmt.setString(1, recordId);
        ResultSet municipalityRs = getMunicipalityStmt.executeQuery();
        
        if (municipalityRs.next()) {
            String recordMunicipality = municipalityRs.getString("municipality");
            if (recordMunicipality != null && !recordMunicipality.isEmpty()) {
                redirectPage = getTargetPageName(recordMunicipality);
            }
        }
        municipalityRs.close();
        getMunicipalityStmt.close();
        
        int daysWorked = Integer.parseInt(request.getParameter("daysWorked"));
        int absences = Integer.parseInt(request.getParameter("absences"));
        int numberLate = Integer.parseInt(request.getParameter("numberLate"));
        double totalLate = Double.parseDouble(request.getParameter("totalLate"));

        // Get current end date and calculate new end date excluding weekends
        String getDateQuery = "SELECT end_date FROM gip_records WHERE id_no = ?";
        PreparedStatement getDateStmt = conn.prepareStatement(getDateQuery);
        getDateStmt.setString(1, recordId);
        ResultSet dateRs = getDateStmt.executeQuery();
        
        java.sql.Date newEndDate = null;
        int businessDaysAdded = 0;
        
        if (dateRs.next()) {
            java.sql.Date currentEndDate = dateRs.getDate("end_date");
            Calendar cal = Calendar.getInstance();
            cal.setTime(currentEndDate);
            
            // Add business days (excluding weekends) for each absence
            int daysToAdd = absences;
            while (businessDaysAdded < daysToAdd) {
                cal.add(Calendar.DATE, 1); // Move to next day
                
                // Check if it's a weekday (Monday-Friday)
                int dayOfWeek = cal.get(Calendar.DAY_OF_WEEK);
                if (dayOfWeek != Calendar.SATURDAY && dayOfWeek != Calendar.SUNDAY) {
                    businessDaysAdded++;
                }
            }
            
            // Convert to java.sql.Date
            newEndDate = new java.sql.Date(cal.getTimeInMillis());
        }
        dateRs.close();
        getDateStmt.close();

        // Update the record with new values
        String updateWorkQuery = "UPDATE gip_records SET days_worked = ?, absences = ?, "
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
            session.setAttribute("successMessage", "Work details updated successfully! Contract extended by " + 
                              businessDaysAdded + " business days. New end date: " + newEndDate);
        } else {
            session.setAttribute("errorMessage", "Failed to update work details.");
        }

        updateWorkStmt.close();
        conn.close();
    } catch (Exception e) {
        session.setAttribute("errorMessage", "Error updating work details: " + e.getMessage());
        e.printStackTrace();
    }
    
    // Use forward instead of redirect to avoid URL encoding issues with special characters
    request.getRequestDispatcher(redirectPage).forward(request, response);
%>

<%!
    // Map to actual JSP filenames
    private String getTargetPageName(String municipality) {
        if (municipality == null || municipality.trim().isEmpty()) {
            return "Alaminos.jsp";
        }
        
        String normalized = municipality.trim();
        
        // Map to actual JSP filenames
        switch(normalized) {
            case "Biñan": return "Biñan.jsp";
            case "Los Baños": return "LosBaños.jsp";
            case "Santa Cruz": return "SantaCruz.jsp";
            case "Santa Maria": return "SantaMaria.jsp";
            case "San Pablo": return "SanPablo.jsp";
            case "San Pedro": return "SanPedro.jsp";
            case "Santa Rosa": return "SantaRosa.jsp";
            default: 
                return normalized.replace(" ", "") + ".jsp";
        }
    }
%>


