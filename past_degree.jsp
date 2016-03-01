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
                            "INSERT INTO PAST_DEGREE VALUES (?, ?, ?, ?)");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("STUDENT_ID")));
                        pstmt.setString(2, request.getParameter("YEAR"));
                        pstmt.setString(3, request.getParameter("TITLE"));
                       pstmt.setString(4, request.getParameter("UNIVERSITY"));
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
                            "DELETE FROM PAST_DEGREE WHERE STUDENT_ID = ? AND YEAR = ? " +
                            " AND TITLE = ? AND UNIVERSITY = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("STUDENT_ID")));
                        pstmt.setString(2, request.getParameter("YEAR"));
                        pstmt.setString(3, request.getParameter("TITLE"));
                        pstmt.setString(4, request.getParameter("UNIVERSITY"));
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
                        ("SELECT * FROM PAST_DEGREE");
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Year</th>
                        <th>Degree Title</th>
			            <th>University</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="past_degree.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENT_ID" size="10"></th>
                            <th><input value="" name="YEAR" size="10"></th>
                            <th><input value="" name="TITLE" size="40"></th>
			                <th><input value="" name="UNIVERSITY" size="40"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="past_degree.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the STUDENT_ID, which is a number --%>
                            <td>
                                <input value="<%= rs.getInt("STUDENT_ID") %>" 
                                    name="STUDENT_ID" size="10" readonly>
                            </td>
    
                            <%-- Get the YEAR --%>
                            <td>
                                <input value="<%= rs.getString("YEAR") %>" 
                                    name="YEAR" size="10" readonly>
                            </td>
    
                            <%-- Get the TITLE --%>
                            <td>
                                <input value="<%= rs.getString("TITLE") %>"
                                    name="START_YEAR" size="40" readonly>
                            </td>
    
                            <%-- Get the UNIVERSITY --%>
                            <td>
                                <input value="<%= rs.getString("UNIVERSITY") %>" 
                                    name="UNIVERSITY" size="40" readonly>
                            </td>
                        </form>
                        <form action="past_degree.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("STUDENT_ID") %>" name="STUDENT_ID">
                            <input type="hidden" 
                                value="<%= rs.getString("YEAR") %>" name="YEAR">
                            <input type="hidden" 
                                value="<%= rs.getString("TITLE") %>" name="TITLE">    
                            <input type="hidden" 
                                value="<%= rs.getString("UNIVERSITY") %>" name="UNIVERSITY">  
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
