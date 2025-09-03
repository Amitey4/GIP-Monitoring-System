<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*, java.util.*, java.net.URLEncoder" %>
<%
    // List of valid municipalities
    String[] validMunicipalities = {
        "Alaminos", "Biñan", "Bay", "Cabuyao", "Calamba", "Calauan", "Cavinti",
        "Famy", "Kalayaan", "Liliw", "Los Baños", "Luisiana", "Lumban",
        "Mabitac", "Magdalena", "Majayjay", "Nagcarlan", "Paete", "Pagsanjan",
        "Pakil", "Pangil", "Pila", "Rizal", "Santa Cruz", "Santa Maria",
        "San Pablo", "San Pedro", "Santa Rosa", "Siniloan", "Victoria"
    };
    
    // Map of municipality display names to file names (with proper encoding)
    Map<String, String> municipalityFileMap = new HashMap<>();
    municipalityFileMap.put("Santa Cruz", "SantaCruz");
    municipalityFileMap.put("Santa Maria", "SantaMaria");
    municipalityFileMap.put("San Pablo", "SanPablo");
    municipalityFileMap.put("San Pedro", "SanPedro");
    municipalityFileMap.put("Santa Rosa", "SantaRosa");
    municipalityFileMap.put("Los Baños", "LosBaños");
    municipalityFileMap.put("Biñan", "Biñan");
    // Add other municipalities that might have special characters
    
    List<String> validMunicipalityList = Arrays.asList(validMunicipalities);

    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    String dbUser = "";
    String dbPass = "";

    String currentMunicipality = "Alaminos";
    String currentMunicipalityFile = "Alaminos";

    try {
        Class.forName("org.apache.derby.jdbc.ClientDriver");
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        String editIdNo = request.getParameter("editIdNo");
        if (editIdNo == null || editIdNo.isEmpty()) {
            session.setAttribute("errorMessage", "GIP ID is required for editing");
            response.sendRedirect("Alaminos.jsp");
            return;
        }
        
        // Get current municipality from database
        try {
            PreparedStatement selectStmt = conn.prepareStatement(
                "SELECT municipality FROM gip_records WHERE id_no = ?");
            selectStmt.setString(1, editIdNo);
            ResultSet rs = selectStmt.executeQuery();
            if (rs.next()) {
                currentMunicipality = rs.getString("municipality");
                if (validMunicipalityList.contains(currentMunicipality)) {
                    currentMunicipalityFile = municipalityFileMap.getOrDefault(
                        currentMunicipality, 
                        currentMunicipality.replace(" ", "")
                    );
                }
            }
            rs.close();
            selectStmt.close();
        } catch (SQLException e) {
            // Log error but continue with default
            e.printStackTrace();
        }

        // Get form parameters
        String editLastName = request.getParameter("editLastName");
        String editFirstName = request.getParameter("editFirstName");
        String editMiddleName = request.getParameter("editMiddleName");
        String editExtensionName = request.getParameter("editExtensionName");
        String editStreet = request.getParameter("editStreet");
        String editBarangay = request.getParameter("editBarangay");
        String editMunicipality = request.getParameter("editMunicipality");
        String editProvince = request.getParameter("editProvince");
        String editContactNumber = request.getParameter("editContactNumber");
        String editSex = request.getParameter("editSex");
        String editBirthDate = request.getParameter("editBirthDate");
        String editStatus = request.getParameter("editStatus");

        // Validate municipality
        if (editMunicipality != null && !validMunicipalityList.contains(editMunicipality)) {
            session.setAttribute("errorMessage", "Invalid municipality specified");
            response.sendRedirect(URLEncoder.encode(currentMunicipalityFile, "UTF-8") + ".jsp");
            return;
        }

        // Update record
        String updateQuery = "UPDATE gip_records SET last_name = ?, first_name = ?, middle_name = ?, "
                + "extension_name = ?, street = ?, barangay = ?, municipality = ?, province = ?, "
                + "contact_number = ?, sex = ?, birth_date = ?, status = ? WHERE id_no = ?";

        PreparedStatement updateStmt = conn.prepareStatement(updateQuery);
        updateStmt.setString(1, editLastName);
        updateStmt.setString(2, editFirstName);
        updateStmt.setString(3, editMiddleName);
        updateStmt.setString(4, editExtensionName);
        updateStmt.setString(5, editStreet);
        updateStmt.setString(6, editBarangay);
        updateStmt.setString(7, editMunicipality);
        updateStmt.setString(8, editProvince);
        updateStmt.setString(9, editContactNumber);
        updateStmt.setString(10, editSex);
        updateStmt.setDate(11, java.sql.Date.valueOf(editBirthDate));
        updateStmt.setString(12, editStatus);
        updateStmt.setString(13, editIdNo);

        int rowsUpdated = updateStmt.executeUpdate();
        if (rowsUpdated > 0) {
            session.setAttribute("successMessage", "GIP record updated successfully!");
            
            // Determine redirect with proper encoding
            String redirectMunicipality = editMunicipality;
            String redirectFile;
            
            if (redirectMunicipality != null && validMunicipalityList.contains(redirectMunicipality)) {
                redirectFile = municipalityFileMap.getOrDefault(
                    redirectMunicipality, 
                    redirectMunicipality.replace(" ", "")
                );
            } else {
                redirectFile = currentMunicipalityFile;
            }
            
            // URL encode the filename to handle special characters
            response.sendRedirect(URLEncoder.encode(redirectFile, "UTF-8") + ".jsp");
            return;
        } else {
            session.setAttribute("errorMessage", "Failed to update GIP record.");
            response.sendRedirect(URLEncoder.encode(currentMunicipalityFile, "UTF-8") + ".jsp");
            return;
        }

    } catch (IllegalArgumentException e) {
        session.setAttribute("errorMessage", "Invalid date format. Please use YYYY-MM-DD.");
        response.sendRedirect(URLEncoder.encode(currentMunicipalityFile, "UTF-8") + ".jsp");
    } catch (SQLException e) {
        session.setAttribute("errorMessage", "Database error: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect(URLEncoder.encode(currentMunicipalityFile, "UTF-8") + ".jsp");
    } catch (Exception e) {
        session.setAttribute("errorMessage", "Error updating record: " + e.getMessage());
        e.printStackTrace();
        response.sendRedirect(URLEncoder.encode(currentMunicipalityFile, "UTF-8") + ".jsp");
    }
%>

