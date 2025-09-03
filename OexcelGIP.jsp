<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>
<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<%
    class GipRecord {
        String idNo;
        String lastName;
        String firstName;
        String middleName;
        String extensionName;
        String designation;
        String address; // Combined address field (street, barangay, municipality, province)
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
                String designation, String street, String barangay, String municipality, String province,
                String contactNumber, String sex, String birthDate, int daysWorked, int numberLate, double totalLate, String status) {
            this.idNo = idNo;
            this.lastName = lastName;
            this.firstName = firstName;
            this.middleName = middleName;
            this.extensionName = extensionName;
            this.designation = designation;
            // Concatenate street, barangay, municipality, province into a single address
            this.address = (street != null ? street + ", " : "") + 
                           (barangay != null ? barangay + ", " : "") + 
                           (municipality != null ? municipality + ", " : "") + 
                           (province != null ? province : "");
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
    }

    String bayanName = "Others";
    List<GipRecord> gipRecords = new ArrayList<>();
    String errorMessage = null;

    try {
        // Database connection parameters
        String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
        String dbUser = "";
        String dbPass = "";

        // Load the JDBC driver
        Class.forName("org.apache.derby.jdbc.ClientDriver");

        // Establish connection
        Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPass);

        // Query to fetch ALL GIP records from the gip_others table
        String query = "SELECT * FROM gip_others";
        PreparedStatement pstmt = conn.prepareStatement(query);
        ResultSet rs = pstmt.executeQuery();

        SimpleDateFormat displayFormat = new SimpleDateFormat("MMMM d, yyyy");

        // Fetch records from database
        while (rs.next()) {
            String idNo = rs.getString("id_no");
            String lastName = rs.getString("last_name");
            String firstName = rs.getString("first_name");
            String middleName = rs.getString("middle_name");
            String extensionName = rs.getString("extension_name");
            String designation = rs.getString("designation");
            String street = rs.getString("street");
            String barangay = rs.getString("barangay");
            String municipality = rs.getString("municipality");
            String province = rs.getString("province");
            String contactNumber = rs.getString("contact_number");
            String sex = rs.getString("sex");

            Date birthDate = rs.getDate("birth_date");
            String formattedBirthDate = birthDate != null ? displayFormat.format(birthDate) : "";

            String status = rs.getString("status");
            int daysWorked = rs.getInt("days_worked");
            int numberLate = rs.getInt("number_late");
            double totalLate = rs.getDouble("total_late");

            GipRecord record = new GipRecord(
                idNo, lastName, firstName, middleName, extensionName, 
                designation, street, barangay, municipality, province,
                contactNumber, sex, formattedBirthDate, daysWorked, numberLate, totalLate, status
            );

            gipRecords.add(record);
        }

        // Close resources
        rs.close();
        pstmt.close();
        conn.close();

    } catch (Exception e) {
        errorMessage = "Error: " + e.getMessage();
        e.printStackTrace();
    }

    // Set response content type for Excel
    response.setContentType("application/vnd.ms-excel");
    response.setHeader("Content-Disposition", "attachment; filename=GIP_Records_" + bayanName + ".xls");

    PrintWriter outExcel = response.getWriter();

    outExcel.println("<html>");
    outExcel.println("<head>");
    outExcel.println("<style>");
    outExcel.println("td { mso-number-format:\\@; }"); // Ensures text formatting in Excel
    outExcel.println(".header { background-color: #004d99; color: white; font-weight: bold; text-align: center; }");
    outExcel.println("</style>");
    outExcel.println("</head>");
    outExcel.println("<body>");
    
    // Error message if any
    if (errorMessage != null) {
        outExcel.println("<div class=\"error\">" + errorMessage + "</div>");
    }

    outExcel.println("<table border=\"1\" cellpadding=\"3\" cellspacing=\"0\">");

    // Table Header
    outExcel.println("<tr>");
    outExcel.println("<td class=\"header\">GIP ID Number</td>");
    outExcel.println("<td class=\"header\">Last Name</td>");
    outExcel.println("<td class=\"header\">First Name</td>");
    outExcel.println("<td class=\"header\">Middle Name</td>");
    outExcel.println("<td class=\"header\">Extension Name</td>");
    outExcel.println("<td class=\"header\">Designation</td>");
    outExcel.println("<td class=\"header\">Address</td>");
    outExcel.println("<td class=\"header\">Contact Number</td>");
    outExcel.println("<td class=\"header\">Sex</td>");
    outExcel.println("<td class=\"header\">Birthdate</td>");
    outExcel.println("<td class=\"header\">No. of Days Worked</td>");
    outExcel.println("<td class=\"header\">Number of Late</td>");
    outExcel.println("<td class=\"header\">Total of Late (minutes)</td>");
    outExcel.println("<td class=\"header\">Amount of Wages</td>");
    outExcel.println("<td class=\"header\">Net Amount</td>");
    outExcel.println("<td class=\"header\">Signature</td>");
    outExcel.println("<td class=\"header\">Status</td>");
    outExcel.println("</tr>");

    // Check if there are records
    if (gipRecords.isEmpty()) {
        outExcel.println("<tr>");
        outExcel.println("<td colspan=\"17\" style=\"text-align: center; padding: 20px;\">No records found in GIP_OTHERS table.</td>");
        outExcel.println("</tr>");
    } else {
        // Write records to Excel
        for (GipRecord record : gipRecords) {
            outExcel.println("<tr>");
            outExcel.println("<td>" + record.idNo + "</td>");
            outExcel.println("<td>" + record.lastName + "</td>");
            outExcel.println("<td>" + record.firstName + "</td>");
            outExcel.println("<td>" + record.middleName + "</td>");
            outExcel.println("<td>" + record.extensionName + "</td>");
            outExcel.println("<td>" + record.designation + "</td>");
            outExcel.println("<td>" + record.address + "</td>");
            outExcel.println("<td>" + record.contactNumber + "</td>");
            outExcel.println("<td>" + record.sex + "</td>");
            outExcel.println("<td>" + record.birthDate + "</td>");
            outExcel.println("<td>" + record.daysWorked + "</td>");
            outExcel.println("<td>" + record.numberLate + "</td>");
            outExcel.println("<td>" + record.totalLate + "</td>");
            outExcel.println("<td>" + record.amountWages + "</td>");
            outExcel.println("<td>" + record.netAmount + "</td>");
            outExcel.println("<td>" + record.signature + "</td>");
            outExcel.println("<td>" + record.status + "</td>");
            outExcel.println("</tr>");
        }
    }

    outExcel.println("</table>");
    outExcel.println("</body>");
    outExcel.println("</html>");

    outExcel.flush();
    outExcel.close();
%>
