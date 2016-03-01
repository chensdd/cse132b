<html>

<body>
    <table border="3">
        <tr>
            <td valign="top">
                <%-- -------- Include menu HTML code -------- --%>
                <jsp:include page="menu.html" />
            </td>
            <td>

            <%-- Set the scripting language to Java and --%>
            <%-- Import the java.sql package --%>
            <%@ page language="java" import="java.sql.*" %>
    
            <%-- -------- Open Connection Code -------- --%>
            <%
                try {
                    // Load Oracle Driver class file
                    DriverManager.registerDriver
                        (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    Connection conn = DriverManager.getConnection
                        ("jdbc:sqlserver://DOUBLED\\SQLEXPRESS:1433;databaseName=cse132b", 
                            "sa", "Ding8374");

            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
					String action = request.getParameter("action");
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE UNDERGRAD SET COLLEGE_NAME = ?, " +
                            "MAJOR = ?, MINOR = ?, FIVEYEAR = ? WHERE UNDERGRAD_ID = ?");

                        pstmt.setString(1, request.getParameter("COLLEGE_NAME"));
                        pstmt.setString(2, request.getParameter("MAJOR"));
                        pstmt.setString(3, request.getParameter("MINOR"));
                        pstmt.setString(4, request.getParameter("FIVEYEAR"));
                        pstmt.setInt(
                            5, Integer.parseInt(request.getParameter("UNDERGRAD_ID")));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                         conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>


            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM UNDERGRAD");
            %>

            <!-- Add an HTML table header row to format the results -->
				<table border="0"><th><font face = "Arial Black" size = "6">Undergrad Students</font></th></table>
                <table border="1">
                    <tr>
                        <th>Undergrad ID</th>
                        <th>College Name</th>
						<th>Major</th>
						<th>Minor</th>
						<th>5 Year MS</th>
                        <th>Action</th>
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="undergrad.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the UNDERGRAD_ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("UNDERGRAD_ID") %>" 
                                    name="UNDERGRAD_ID" size="10" readonly>
                            </td>
    
                            <%-- Get the COLLEGE --%>
                            <td>
                                <input value="<%= rs.getString("COLLEGE_NAME") %>" 
                                    name="COLLEGE_NAME" size="50">
                            </td>
    
							<td>
                                <input value="<%= rs.getString("MAJOR") %>" 
                                    name="MAJOR" size="10">
                            </td>
							
							<td>
                                <input value="<%= rs.getString("MINOR") %>" 
                                    name="MINOR" size="10">
                            </td>
							
							<td>
                                <input value="<%= rs.getString("FIVEYEAR") %>" 
                                    name="FIVEYEAR" size="5">
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    statement.close();
    
                    // Close the Connection
                    conn.close();
                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                }
            %>
                </table>
				
            </td>
        </tr>
    </table>
</body>

</html>
