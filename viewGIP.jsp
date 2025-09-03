<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    // Get GIP ID from URL parameter
    String idNo = request.getParameter("id");
    if (idNo == null || idNo.isEmpty()) {
        out.print("<div class='error-message'>Error: No GIP ID specified</div>");
        return;
    }

    // Database connection
    String dbURL = "jdbc:derby:C:\\Users\\acer\\GIPSystemDB;create=true";
    try (Connection conn = DriverManager.getConnection(dbURL, "", "");
         PreparedStatement stmt = conn.prepareStatement(
            "SELECT * FROM gip_records WHERE id_no = ?")) {
        
        stmt.setString(1, idNo);
        ResultSet rs = stmt.executeQuery();
        
        if (rs.next()) {
            // Format dates and calculate values
            SimpleDateFormat dateFormat = new SimpleDateFormat("MMMM d, yyyy");
            double dailyWage = 560.00;
            int daysWorked = rs.getInt("days_worked");
            int absences = rs.getInt("absences");
            double totalLate = rs.getDouble("total_late");
            double amountWages = daysWorked * dailyWage;
            double netAmount = amountWages - (totalLate * 2) - (absences * dailyWage);
%>
<div class="gip-details">
    <!-- Personal Information -->
    <div class="section">
        <h3><i class="fas fa-user"></i> Personal Information</h3>
        <div class="row">
            <span class="label">GIP ID:</span>
            <span class="value"><%= rs.getString("id_no") %></span>
        </div>
        <div class="row">
            <span class="label">Full Name:</span>
            <span class="value">
                <%= rs.getString("last_name") %>, <%= rs.getString("first_name") %>
                <%= rs.getString("middle_name") != null ? " " + rs.getString("middle_name") : "" %>
                <%= rs.getString("extension_name") != null ? " " + rs.getString("extension_name") : "" %>
            </span>
        </div>
        <div class="row">
            <span class="label">Address:</span>
            <span class="value">
                <%= rs.getString("street") %>, <%= rs.getString("barangay") %>, 
                <%= rs.getString("municipality") %>, <%= rs.getString("province") %>
            </span>
        </div>
        <div class="row">
            <span class="label">Contact:</span>
            <span class="value"><%= rs.getString("contact_number") %></span>
        </div>
        <div class="row">
            <span class="label">Sex/Birthdate:</span>
            <span class="value">
                <%= rs.getString("sex") %> | 
                <%= dateFormat.format(rs.getDate("birth_date")) %>
            </span>
        </div>
    </div>

    <!-- Contract Details -->
    <div class="section">
        <h3><i class="fas fa-file-contract"></i> Contract Details</h3>
        <div class="row">
            <span class="label">Period:</span>
            <span class="value">
                <%= dateFormat.format(rs.getDate("start_date")) %> to 
                <%= dateFormat.format(rs.getDate("end_date")) %>
            </span>
        </div>
        <div class="row">
            <span class="label">Status:</span>
            <span class="value status-<%= rs.getString("status").toLowerCase() %>">
                <%= rs.getString("status") %>
            </span>
        </div>
    </div>

    <!-- Work Performance -->
    <div class="section">
        <h3><i class="fas fa-chart-line"></i> Work Performance</h3>
        <div class="grid">
            <div class="grid-item">
                <span class="label">Days Worked</span>
                <span class="value"><%= daysWorked %></span>
            </div>
            <div class="grid-item">
                <span class="label">Absences</span>
                <span class="value"><%= absences %></span>
            </div>
            <div class="grid-item">
                <span class="label">Late Count</span>
                <span class="value"><%= rs.getInt("number_late") %></span>
            </div>
            <div class="grid-item">
                <span class="label">Total Late (mins)</span>
                <span class="value"><%= totalLate %></span>
            </div>
        </div>
    </div>

    <!-- Salary Computation -->
    <div class="section">
        <h3><i class="fas fa-calculator"></i> Salary Computation</h3>
        <div class="salary-breakdown">
            <div class="salary-row">
                <span class="label">Basic Salary (<%= daysWorked %> days × ₱<%= dailyWage %>):</span>
                <span class="value">₱<%= String.format("%.2f", amountWages) %></span>
            </div>
            <div class="salary-row deduction">
                <span class="label">Late Deductions (<%= totalLate %> mins × ₱2):</span>
                <span class="value">-₱<%= String.format("%.2f", totalLate * 2) %></span>
            </div>
            <div class="salary-row deduction">
                <span class="label">Absence Deductions (<%= absences %> days × ₱<%= dailyWage %>):</span>
                <span class="value">-₱<%= String.format("%.2f", absences * dailyWage) %></span>
            </div>
            <div class="salary-row total">
                <span class="label">Net Amount:</span>
                <span class="value">₱<%= String.format("%.2f", netAmount) %></span>
            </div>
        </div>
    </div>
</div>

<style>
.gip-details {
    font-family: 'Roboto', sans-serif;
    color: #333;
    padding: 10px;
}
.section {
    margin-bottom: 20px;
    padding-bottom: 15px;
    border-bottom: 1px solid #eee;
}
.section h3 {
    color: #004d99;
    margin-bottom: 15px;
    display: flex;
    align-items: center;
    gap: 8px;
}
.row {
    display: flex;
    margin-bottom: 8px;
}
.label {
    font-weight: 500;
    width: 150px;
    color: #555;
}
.value {
    flex: 1;
}
.grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 15px;
}
.grid-item {
    background: #f8f9fa;
    padding: 10px;
    border-radius: 5px;
}
.grid-item .label {
    display: block;
    width: 100%;
    margin-bottom: 5px;
    font-size: 0.9em;
}
.grid-item .value {
    font-weight: bold;
    font-size: 1.1em;
}
.salary-breakdown {
    margin-top: 10px;
}
.salary-row {
    display: flex;
    justify-content: space-between;
    padding: 8px 0;
}
.deduction {
    color: #d32f2f;
}
.total {
    border-top: 1px solid #ddd;
    margin-top: 5px;
    padding-top: 10px;
    font-weight: bold;
}
.status-active { color: #2e7d32; }
.status-renewed { color: #ff8f00; }
.status-completed { color: #666; }
</style>
<%
        } else {
            out.print("<div class='error-message'>Error: GIP record not found</div>");
        }
    } catch (Exception e) {
        out.print("<div class='error-message'>Database error: " + e.getMessage() + "</div>");
        e.printStackTrace();
    }
%>