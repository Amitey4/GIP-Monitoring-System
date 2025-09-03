<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%
    // Set UTF-8 encoding at the very beginning
    request.setCharacterEncoding("UTF-8");
    response.setCharacterEncoding("UTF-8");
    response.setContentType("text/html; charset=UTF-8");

    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    String[] municipalities = {
        "Alaminos", "Biñan", "Bay", "Cabuyao", "Calamba", "Calauan", "Cavinti",
        "Famy", "Kalayaan", "Liliw", "Los Baños", "Luisiana", "Lumban",
        "Mabitac", "Magdalena", "Majayjay", "Nagcarlan", "Paete", "Pagsanjan",
        "Pakil", "Pangil", "Pila", "Rizal", "Santa Cruz", "Santa Maria",
        "San Pablo", "San Pedro", "Santa Rosa", "Siniloan", "Victoria", "Others"
    };

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Get parameters safely - use getParameter with default values
        String recordId = (request.getParameter("recordId") != null) ? request.getParameter("recordId").trim() : "";
        String origin = (request.getParameter("origin") != null) ? request.getParameter("origin").trim() : "";

        System.out.println("DEBUG: recordId='" + recordId + "', origin='" + origin + "'");

        if (recordId.isEmpty()) {
            session.setAttribute("errorMessage", "Record ID is required for deletion");
            // Use forward instead of redirect to avoid URL encoding issues
            String targetPage = (!origin.isEmpty()) ? origin + ".jsp" : "Alaminos.jsp";
            request.getRequestDispatcher(targetPage).forward(request, response);
            return;
        }

        String municipality = null;
        
        // Try to get municipality from database
        String getMunicipalityQuery = "SELECT municipality FROM gip_records WHERE id_no = ?";
        try (PreparedStatement getMunicipalityStmt = conn.prepareStatement(getMunicipalityQuery)) {
            getMunicipalityStmt.setString(1, recordId);
            ResultSet rs = getMunicipalityStmt.executeQuery();
            if (rs.next()) {
                municipality = rs.getString("municipality");
                System.out.println("DEBUG: Found municipality in DB: " + municipality);
            }
        }

        // Fallback logic
        if (municipality == null || municipality.trim().isEmpty()) {
            municipality = (!origin.isEmpty()) ? origin : "Alaminos";
            System.out.println("DEBUG: Using fallback municipality: " + municipality);
        }

        // Validate and normalize municipality name
        String targetMunicipality = "Alaminos";
        for (String muni : municipalities) {
            if (muni.equalsIgnoreCase(municipality)) {
                targetMunicipality = muni;
                break;
            }
        }

        System.out.println("DEBUG: Final target municipality: " + targetMunicipality);

        // Delete the record
        String deleteQuery = "DELETE FROM gip_records WHERE id_no = ?";
        try (PreparedStatement deleteStmt = conn.prepareStatement(deleteQuery)) {
            deleteStmt.setString(1, recordId);
            int rowsDeleted = deleteStmt.executeUpdate();
            
            if (rowsDeleted > 0) {
                session.setAttribute("successMessage", "GIP record deleted successfully!");
            } else {
                session.setAttribute("errorMessage", "Failed to delete GIP record. Record not found.");
            }
        }

        conn.close();

        // Get the target page name
        String targetPage = getTargetPageName(targetMunicipality);
        System.out.println("DEBUG: Forwarding to: " + targetPage);
        
        // Use forward instead of redirect to avoid URL encoding issues
        request.getRequestDispatcher(targetPage).forward(request, response);
        return;

    } catch (Exception e) {
        e.printStackTrace();
        session.setAttribute("errorMessage", "Error deleting record: " + e.getMessage());
        request.getRequestDispatcher("Alaminos.jsp").forward(request, response);
    }
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
            case "LosBaños": return "LosBaños.jsp";
            default: 
                return normalized.replace(" ", "") + ".jsp";
        }
    }
%>

