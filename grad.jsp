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
                            "UPDATE GRAD SET DEPT_NAME = ?, " +
                            "CONCENTRATION = ? WHERE GRAD_ID = ?");

                        pstmt.setString(1, request.getParameter("DEPT_NAME"));
                        pstmt.setString(2, request.getParameter("CONCENTRATION"));
                        pstmt.setInt(
                            3, Integer.parseInt(request.getParameter("GRAD_ID")));
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
                        ("SELECT * FROM GRAD");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Grad Students</font></th></table>
                <table border="1">
                    <tr>
                        <th>Grad ID</th>
                        <th>Status</th>
						<th>Department</th>
						<th>Concentration</th>
                        <th>Action</th>
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="grad.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the UNDERGRAD_ID, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("GRAD_ID") %>" 
                                    name="GRAD_ID" size="10" readonly>
                            </td>
    
                            <td align="middle">
                                <input value="<%= rs.getString("G_STATUS") %>" 
                                    name="G_STATUS" size="10" style="text-align:center;" readonly>
                            </td>
    
							<td align="middle">
                                <input value="<%= rs.getString("DEPT_NAME") %>" 
                                    name="DEPT_NAME" size="40">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("CONCENTRATION") %>" 
                                    name="CONCENTRATION" size="10">
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
