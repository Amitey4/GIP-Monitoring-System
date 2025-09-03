<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.util.Arrays" %>

<%
    // Check if this is an export request
    boolean isExportRequest = "true".equals(request.getParameter("export"));
    
    if (isExportRequest) {
        // Export functionality
        class GipRecord {
            String idNo;
            String lastName;
            String firstName;
            String middleName;
            String extensionName;
            String street;
            String barangay;
            String municipality;
            String province;
            String contactNumber;
            String sex;
            String birthDate;
            int daysWorked;
            int numberLate;
            double totalLate;
            double amountWages;
            double netAmount;
            String signature;
            String status;
            double dailyWage = 560.00;

            public GipRecord(String idNo, String lastName, String firstName, String middleName, String extensionName,
                    String street, String barangay, String municipality, String province, String contactNumber,
                    String sex, String birthDate, int daysWorked, int numberLate, double totalLate, String status) {
                this.idNo = idNo;
                this.lastName = lastName;
                this.firstName = firstName;
                this.middleName = middleName;
                this.extensionName = extensionName;
                this.street = street;
                this.barangay = barangay;
                this.municipality = municipality;
                this.province = province;
                this.contactNumber = contactNumber;
                this.sex = sex;
                this.birthDate = birthDate;
                this.daysWorked = daysWorked;
                this.numberLate = numberLate;
                this.totalLate = totalLate;
                this.amountWages = daysWorked * dailyWage;
                this.netAmount = this.amountWages - (totalLate * 2); // Deduct for late
                this.signature = "";
                this.status = status;
            }

            public String getFullName() {
                return lastName + ", " + firstName + (middleName.isEmpty() ? "" : " " + middleName)
                        + (extensionName.isEmpty() ? "" : " " + extensionName);
            }
        }

        String bayanName = request.getParameter("municipality");
        if (bayanName == null || bayanName.isEmpty()) {
            bayanName = "Alaminos"; // Default municipality
        }
        
        // Validate municipality to prevent security issues
        String[] validMunicipalities = {
            "Alaminos", "Biñan", "Bay", "Cabuyao", "Calamba", "Calauan", "Cavinti",
            "Famy", "Kalayaan", "Liliw", "Los Baños", "Luisiana", "Lumban",
            "Mabitac", "Magdalena", "Majayjay", "Nagcarlan", "Paete", "Pagsanjan",
            "Pakil", "Pangil", "Pila", "Rizal", "Santa Cruz", "Santa Maria",
            "San Pablo", "San Pedro", "Santa Rosa", "Siniloan", "Victoria"
        };
        
        boolean isValidMunicipality = false;
        for (String valid : validMunicipalities) {
            if (valid.equalsIgnoreCase(bayanName)) {
                isValidMunicipality = true;
                bayanName = valid; // Use the correct case
                break;
            }
        }
        
        if (!isValidMunicipality) {
            bayanName = "Alaminos"; // Fallback to default
        }
        
        List<GipRecord> gipRecords = new ArrayList<>();

        try {
            // Database connection parameters
            String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
            String dbUser = "";
            String dbPass = "";

            // Load the JDBC driver
            Class.forName("org.apache.derby.jdbc.ClientDriver");

            // Establish connection
            Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

            // Query to fetch GIP records for the selected municipality
            String query = "SELECT * FROM gip_records WHERE municipality = ?";
            PreparedStatement pstmt = conn.prepareStatement(query);
            pstmt.setString(1, bayanName);

            ResultSet rs = pstmt.executeQuery();

            SimpleDateFormat displayFormat = new SimpleDateFormat("MMMM d, yyyy");

            while (rs.next()) {
                String idNo = rs.getString("id_no");
                String lastName = rs.getString("last_name");
                String firstName = rs.getString("first_name");
                String middleName = rs.getString("middle_name");
                String extensionName = rs.getString("extension_name");
                String street = rs.getString("street");
                String barangay = rs.getString("barangay");
                String municipality = rs.getString("municipality");
                String province = rs.getString("province");
                String contactNumber = rs.getString("contact_number");
                String sex = rs.getString("sex");

                // Format birthdate
                Date birthDate = rs.getDate("birth_date");
                String formattedBirthDate = birthDate != null ? displayFormat.format(birthDate) : "";

                String status = rs.getString("status");
                int daysWorked = rs.getInt("days_worked");
                int numberLate = rs.getInt("number_late");
                double totalLate = rs.getDouble("total_late");

                GipRecord record = new GipRecord(
                        idNo, lastName, firstName, middleName, extensionName,
                        street, barangay, municipality, province, contactNumber,
                        sex, formattedBirthDate, daysWorked, numberLate, totalLate, status
                );

                gipRecords.add(record);
            }

            // Close resources
            rs.close();
            pstmt.close();
            conn.close();

        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        response.setContentType("application/vnd.ms-excel");
        response.setHeader("Content-Disposition", "attachment; filename=GIP_Records_" + bayanName + ".xls");

        PrintWriter outExcel = response.getWriter();

        // Create HTML table with minimal styling for Excel
        outExcel.println("<html xmlns:x=\"urn:schemas-microsoft-com:office:excel\">");
        outExcel.println("<head>");
        outExcel.println("<meta name=\"Excel Workbook Frameset\">");
        outExcel.println("<!--[if gte mso 9]>");
        outExcel.println("<xml>");
        outExcel.println("<x:ExcelWorkbook>");
        outExcel.println("<x:ExcelWorksheets>");
        outExcel.println("<x:ExcelWorksheet>");
        outExcel.println("<x:Name>GIP Records</x:Name>");
        outExcel.println("<x:WorksheetOptions>");
        outExcel.println("<x:FitToPage/>");
        outExcel.println("<x:FitWidth/>");
        outExcel.println("<x:Print>");
        outExcel.println("<x:FitHeight>0</x:FitHeight>");
        outExcel.println("<x:ValidPrinterInfo/>");
        outExcel.println("<x:Scale>100</x:Scale>");
        outExcel.println("<x:HorizontalResolution>600</x:HorizontalResolution>");
        outExcel.println("<x:VerticalResolution>600</x:VerticalResolution>");
        outExcel.println("</x:Print>");
        outExcel.println("<x:Selected/>");
        outExcel.println("<x:FreezePanes/>");
        outExcel.println("<x:FrozenNoSplit/>");
        outExcel.println("<x:SplitHorizontal>1</x:SplitHorizontal>");
        outExcel.println("<x:TopRowBottomPane>1</x:TopRowBottomPane>");
        outExcel.println("<x:ActivePane>2</x:ActivePane>");
        outExcel.println("<x:Panes>");
        outExcel.println("<x:Pane>");
        outExcel.println("<x:Number>3</x:Number>");
        outExcel.println("</x:Pane>");
        outExcel.println("</x:Panes>");
        outExcel.println("<x:ProtectContents>False</x:ProtectContents>");
        outExcel.println("<x:ProtectObjects>False</x:ProtectObjects>");
        outExcel.println("<x:ProtectScenarios>False</x:ProtectScenarios>");
        outExcel.println("</x:WorksheetOptions>");
        outExcel.println("</x:ExcelWorksheet>");
        outExcel.println("</x:ExcelWorksheets>");
        outExcel.println("<x:WindowHeight>9000</x:WindowHeight>");
        outExcel.println("<x:WindowWidth>16000</x:WindowWidth>");
        outExcel.println("<x:WindowTopX>0</x:WindowTopX>");
        outExcel.println("<x:WindowTopY>0</x:WindowTopY>");
        outExcel.println("<x:ProtectStructure>False</x:ProtectStructure>");
        outExcel.println("<x:ProtectWindows>False</x:ProtectWindows>");
        outExcel.println("</x:ExcelWorkbook>");
        outExcel.println("</xml>");
        outExcel.println("<![endif]-->");
        outExcel.println("<style>");
        outExcel.println("td { mso-number-format:\\@; }"); // Preserve text formatting
        outExcel.println(".header { background-color: #004d99; color: white; font-weight: bold; }");
        outExcel.println("</style>");
        outExcel.println("</head>");
        outExcel.println("<body>");
        outExcel.println("<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">");

        // Write table header with blue background
        outExcel.println("<tr>");
        outExcel.println("<td class=\"header\">GIP ID Number</td>");
        outExcel.println("<td class=\"header\">Last Name</td>");
        outExcel.println("<td class=\"header\">First Name</td>");
        outExcel.println("<td class=\"header\">Middle Name</td>");
        outExcel.println("<td class=\"header\">Extension Name</td>");
        outExcel.println("<td class=\"header\">Street</td>");
        outExcel.println("<td class=\"header\">Barangay</td>");
        outExcel.println("<td class=\"header\">Municipality</td>");
        outExcel.println("<td class=\"header\">Province</td>");
        outExcel.println("<td class=\"header\">Contact Number</td>");
        outExcel.println("<td class=\"header\">Sex</td>");
        outExcel.println("<td class=\"header\">Birthdate</td>");
        outExcel.println("<td class=\"header\">No. of Days Worked</td>");
        outExcel.println("<td class=\"header\">Number of Late</td>");
        outExcel.println("<td class=\"header\">Total of Late (minutes)</td>");
        outExcel.println("<td class=\"header\">Amount of Wages</td>");
        outExcel.println("<td class=\"header\">Net Amount</td>");
        outExcel.println("<td class=\"header\">Signature</td>");
        outExcel.println("</tr>");

        // Write data rows (only include active and renewed records, exclude completed)
        for (GipRecord record : gipRecords) {
            if (!record.status.equals("Completed")) {
                outExcel.println("<tr>");
                outExcel.println("<td>" + record.idNo + "</td>");
                outExcel.println("<td>" + record.lastName + "</td>");
                outExcel.println("<td>" + record.firstName + "</td>");
                outExcel.println("<td>" + record.middleName + "</td>");
                outExcel.println("<td>" + record.extensionName + "</td>");
                outExcel.println("<td>" + record.street + "</td>");
                outExcel.println("<td>" + record.barangay + "</td>");
                outExcel.println("<td>" + record.municipality + "</td>");
                outExcel.println("<td>" + record.province + "</td>");
                outExcel.println("<td>" + record.contactNumber + "</td>");
                outExcel.println("<td>" + record.sex + "</td>");
                outExcel.println("<td>" + record.birthDate + "</td>");
                outExcel.println("<td>" + record.daysWorked + "</td>");
                outExcel.println("<td>" + record.numberLate + "</td>");
                outExcel.println("<td>" + record.totalLate + "</td>");
                outExcel.println("<td>" + record.amountWages + "</td>");
                outExcel.println("<td>" + record.netAmount + "</td>");
                outExcel.println("<td>" + record.signature + "</td>");
                outExcel.println("</tr>");
            }
        }

        outExcel.println("</table>");
        outExcel.println("</body>");
        outExcel.println("</html>");

        outExcel.flush();
        outExcel.close();
        return; // Stop further processing after export
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>GIP Records Export</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            margin: 20px;
            background-color: #f5f5f5;
        }
        .container {
            max-width: 800px;
            margin: 0 auto;
            background: white;
            padding: 20px;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
        }
        h1 {
            color: #004d99;
            text-align: center;
        }
        .form-group {
            margin-bottom: 15px;
        }
        label {
            display: block;
            margin-bottom: 5px;
            font-weight: bold;
        }
        select, button {
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            width: 100%;
            font-size: 16px;
        }
        button {
            background-color: #004d99;
            color: white;
            cursor: pointer;
            border: none;
        }
        button:hover {
            background-color: #003366;
        }
        .instructions {
            background-color: #e7f3ff;
            padding: 15px;
            border-radius: 4px;
            margin-bottom: 20px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>GIP Records Export</h1>
        
        <div class="instructions">
            <p><strong>Instructions:</strong> Select a municipality from the dropdown below and click "Export to Excel" to download the GIP records for that municipality.</p>
        </div>
        
        <form method="get" action="">
            <input type="hidden" name="export" value="true">
            
            <div class="form-group">
                <label for="municipality">Select Municipality:</label>
                <select name="municipality" id="municipality" required>
                    <option value="Alaminos">Alaminos</option>
                    <option value="Biñan">Biñan</option>
                    <option value="Bay">Bay</option>
                    <option value="Cabuyao">Cabuyao</option>
                    <option value="Calamba">Calamba</option>
                    <option value="Calauan">Calauan</option>
                    <option value="Cavinti">Cavinti</option>
                    <option value="Famy">Famy</option>
                    <option value="Kalayaan">Kalayaan</option>
                    <option value="Liliw">Liliw</option>
                    <option value="Los Baños">Los Baños</option>
                    <option value="Luisiana">Luisiana</option>
                    <option value="Lumban">Lumban</option>
                    <option value="Mabitac">Mabitac</option>
                    <option value="Magdalena">Magdalena</option>
                    <option value="Majayjay">Majayjay</option>
                    <option value="Nagcarlan">Nagcarlan</option>
                    <option value="Paete">Paete</option>
                    <option value="Pagsanjan">Pagsanjan</option>
                    <option value="Pakil">Pakil</option>
                    <option value="Pangil">Pangil</option>
                    <option value="Pila">Pila</option>
                    <option value="Rizal">Rizal</option>
                    <option value="Santa Cruz">Santa Cruz</option>
                    <option value="Santa Maria">Santa Maria</option>
                    <option value="San Pablo">San Pablo</option>
                    <option value="San Pedro">San Pedro</option>
                    <option value="Santa Rosa">Santa Rosa</option>
                    <option value="Siniloan">Siniloan</option>
                    <option value="Victoria">Victoria</option>
                </select>
            </div>
            
            <div class="form-group">
                <button type="submit">Export to Excel</button>
            </div>
        </form>
    </div>
</body>
</html>