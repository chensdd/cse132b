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
                            "UPDATE TAKES SET GRADE_OPTION = ?, UNITS = ? WHERE STUDENT_ID = ? AND SECTION_ID = ? AND CLASS_TYPE LIKE ?");

                        pstmt.setString(1, request.getParameter("GRADE_OPTION"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("UNITS")));
						pstmt.setInt(3, Integer.parseInt(request.getParameter("STUDENT_ID")));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("SECTION_ID")));
						pstmt.setString(5, "LEC%");
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>


            <%-- -------- DELETE Code -------- --%>
            <%
                    // Check if a delete is requested
                    if (action != null && action.equals("delete")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // DELETE the faculty FROM the FACULTY table 
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM TAKES WHERE STUDENT_ID = ? AND SECTION_ID = ? AND CLASS_TYPE = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STUDENT_ID")));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("SECTION_ID")));
						pstmt.setString(3, request.getParameter("CLASS_TYPE"));
                        int rowCount = pstmt.executeUpdate();

                        //Commit transaction
                         conn.commit();
                         conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the faculty attributes FROM the FACULTY table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM TAKES");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Courses Enrollment</font></th></table>
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Section ID</th>
						<th>Class Type</th>
						<th>Grade Option</th>
						<th>Units</th>
                    </tr>			

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="takes.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Name --%>
                            <td align="middle">
                                <input value="<%= rs.getString("STUDENT_ID") %>" 
                                    name="STUDENT_ID" size="10">
                            </td>

                            <td align="middle">
                                <input value="<%= rs.getString("SECTION_ID") %>"
                                    name="SECTION_ID" size="10">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("CLASS_TYPE") %>"
                                    name="CLASS_TYPE" style="text-align:center;"  size="6">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("GRADE_OPTION") %>"
                                    name="GRADE_OPTION" style="text-align:center;"  size="10">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("UNITS") %>"
                                    name="UNITS" size="5">
                            </td>
							
							<%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="takes.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("STUDENT_ID") %>" name="STUDENT_ID">
							<input type="hidden" value="<%= rs.getString("SECTION_ID") %>" name="SECTION_ID">
							<input type="hidden" value="<%= rs.getString("CLASS_TYPE") %>" name="CLASS_TYPE">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
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
