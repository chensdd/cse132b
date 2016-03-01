<html>

<body>
    <table border="1">
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

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Probation VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("STUDENT_ID")));
                        pstmt.setString(2, request.getParameter("START_QUARTER"));
                        pstmt.setString(3, request.getParameter("START_YEAR"));
                       pstmt.setString(4, request.getParameter("END_QUARTER"));
                        pstmt.setString(5, request.getParameter("END_YEAR"));
                        pstmt.setString(6, request.getParameter("REASON"));
                        int rowCount = pstmt.executeUpdate();

                        // Commit transaction
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
                            "UPDATE Probation SET END_QUARTER = ?, END_YEAR = ?, REASON = ? " +
                            " WHERE START_QUARTER = ? AND START_YEAR = ? AND STUDENT_ID = ?");

                        pstmt.setString(1, request.getParameter("END_QUARTER"));
                        pstmt.setString(2, request.getParameter("END_YEAR"));
                        pstmt.setString(3, request.getParameter("REASON"));
                        pstmt.setString(4, request.getParameter("START_QUARTER"));
                        pstmt.setString(5, request.getParameter("START_YEAR"));
                        pstmt.setInt(
                            6, Integer.parseInt(request.getParameter("STUDENT_ID")));
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
                            "DELETE FROM Probation WHERE STUDENT_ID = ? AND START_QUARTER = ? " +
                            " AND START_YEAR = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("STUDENT_ID")));
                        pstmt.setString(2, request.getParameter("START_QUARTER"));
                        pstmt.setString(3, request.getParameter("START_YEAR"));
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
                        ("SELECT * FROM Probation");
            %>

            <!-- Add an HTML table header row to format the results -->
			    <table border="0"><th><font face = "Arial Black" size = "6">Probation</font></th></table>
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Start Quarter</th>
                        <th>Start Year</th>
			            <th>End Quarter</th>
                        <th>End Year</th>
                        <th>Reason</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENT_ID" size="10"></th>
                            <th><input value="" name="START_QUARTER" size="10"></th>
                            <th><input value="" name="START_YEAR" size="15"></th>
			                <th><input value="" name="END_QUARTER" size="15"></th>
                            <th><input value="" name="END_YEAR" size="15"></th>
                            <th><input value="" name="REASON" size="140"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the STUDENT_ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("STUDENT_ID") %>" 
                                    name="STUDENT_ID" size="10">
                            </td>
    
                            <%-- Get the START_QUARTER --%>
                            <td>
                                <input value="<%= rs.getString("START_QUARTER") %>" 
                                    name="START_QUARTER" size="10">
                            </td>
    
                            <%-- Get the START_YEAR --%>
                            <td>
                                <input value="<%= rs.getString("START_YEAR") %>"
                                    name="START_YEAR" size="15">
                            </td>
    
                            <%-- Get the END_QUARTER --%>
                            <td>
                                <input value="<%= rs.getString("END_QUARTER") %>" 
                                    name="END_QUARTER" size="15">
                            </td>
    
			                <%-- Get the END_YEAR --%>
                            <td>
                                <input value="<%= rs.getString("END_YEAR") %>" 
                                    name="END_YEAR" size="15">
                            </td>

                            <%-- Get the REASON --%>
                            <td>
                                <input value="<%= rs.getString("REASON") %>" 
                                    name="REASON" size="140">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="probation.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("STUDENT_ID") %>" name="STUDENT_ID">
                            <input type="hidden" 
                                value="<%= rs.getString("START_QUARTER") %>" name="START_QUARTER">
                            <input type="hidden" 
                                value="<%= rs.getString("START_YEAR") %>" name="START_YEAR">    
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
