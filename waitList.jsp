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

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {
						
						//Begin transaction
                        conn.setAutoCommit(false);
                        
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO TAKES VALUES (?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("STU_ID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("SEC_ID")));
                        pstmt.setString(3, request.getParameter("GRADE_OPTION"));
						pstmt.setInt(4, Integer.parseInt(request.getParameter("UNITS")));
                        int rowCount = pstmt.executeUpdate();

                        //Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE COURSE SET TITLE = ?, GRADE_OPT = ?, LEVEL = ?, " +
                            "LAB_REQ = ?, UNITS = ? WHERE COURSE_NUM = ?");

                        pstmt.setString(1, request.getParameter("TITLE"));
                        pstmt.setString(2, request.getParameter("GRADE_OPT"));
                        pstmt.setString(3, request.getParameter("LEVEL"));
                        pstmt.setString(4, request.getParameter("LAB_REQ"));
                        pstmt.setString(5, request.getParameter("UNITS"));
                        pstmt.setInt(6, Integer.parseInt(request.getParameter("COURSE_NUM")));
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
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM WAITLISTED_FOR WHERE SECTION_ID = ? AND STUDENT_ID = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("STUDENT_ID")));
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
                    // the faculty attributes FROM the FACULTY table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM WAITLISTED_FOR");
            %>
			


            <!-- Add an HTML table header row to format the results -->
				<table border="0"><th><font face = "Arial Black" size = "6">Waiting List</font></th></table>
                <table border="1">	
                    <tr>
                        <th>Student ID</th>
						<th>Section ID</th>
                        <th>Position</th>
                        <th>Grade Option</th>
                        <th>Units</th>
                        <th>Action</th>						
                    </tr>
			<%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="waitList.jsp" method="get">
                            <input type="hidden" value="delete" name="action">

                            <td>
                                <input value="<%= rs.getInt("STUDENT_ID") %>" 
                                    name="STUDENT_ID" size="10" readonly>
                            </td>
    
                            <td>
                                <input value="<%= rs.getInt("SECTION_ID") %>" 
                                    name="SECTION_ID" size="10">
                            </td>
    
							<td>
                                <input value="<%= rs.getInt("POSITION") %>" 
                                    name="POSITION" size="5">
                            </td>
							
							<td>
                                <input value="<%= rs.getString("GRADE_OPTION") %>" 
                                    name="GRADE_OPTION" size="10">
                            </td>
							
							<td>
                                <input value="<%= rs.getInt("UNITS") %>" 
                                    name="UNITS" size="5">
                            </td>
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
