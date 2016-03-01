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
                            "INSERT INTO PREREQUISITE VALUES (?, ?, ?)");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("PREREQ_NUM")));
                        pstmt.setInt(
                            2, Integer.parseInt(request.getParameter("COURSE_NUM")));
                        pstmt.setString(3, request.getParameter("INSTRUCTOR_CONSENT"));
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
                            "UPDATE PREREQUISITE SET INSTRUCTOR_CONSENT = ? " +
                            " WHERE PREREQ_NUM = ? AND COURSE_NUM = ?");

                        pstmt.setString(1, request.getParameter("INSTRUCTOR_CONSENT"));
                        pstmt.setInt(
                            2, Integer.parseInt(request.getParameter("PREREQ_NUM")));
                        pstmt.setInt(
                            3, Integer.parseInt(request.getParameter("COURSE_NUM")));
        
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
                            "DELETE FROM PREREQUISITE WHERE PREREQ_NUM = ? AND COURSE_NUM = ? ");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("PREREQ_NUM")));
                        pstmt.setInt(
                            2, Integer.parseInt(request.getParameter("COURSE_NUM")));
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
                        ("SELECT * FROM PREREQUISITE");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Pre-Requirements</font></th></table>
                <table border="1">
                    <tr>
                        <th>Prerequisite Number</th>
                        <th>Course Number</th>
                        <th>Instructor Consent Required</th>

                    </tr>
                    <tr>
                        <form action="PreReq.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="PREREQ_NUM" size="10"></th>
                            <th><input value="" name="COURSE_NUM" size="10"></th>
                            <th><input value="" name="INSTRUCTOR_CONSENT" size="10"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs.next() ) {
        
            %>

                    <tr>
                        <form action="PreReq.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the PREREQ_NUM, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("PREREQ_NUM") %>" 
                                    name="PREREQ_NUM" size="10">
                            </td>
    
                            <%-- Get the COURSE_NUM --%>
                            <td align="middle">
                                <input value="<%= rs.getString("COURSE_NUM") %>" 
                                    name="COURSE_NUM" size="10">
                            </td>
    
                            <%-- Get the INSTRUCTOR_CONSENT --%>
                            <td align="middle">
                                <input value="<%= rs.getString("INSTRUCTOR_CONSENT") %>"
                                    name="INSTRUCTOR_CONSENT" size="5">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="PreReq.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("PREREQ_NUM") %>" name="PREREQ_NUM">
                            <input type="hidden" 
                                value="<%= rs.getString("COURSE_NUM") %>" name="COURSE_NUM">
                            <input type="hidden" 
                                value="<%= rs.getString("INSTRUCTOR_CONSENT") %>" name="INSTRUCTOR_CONSENT">    
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
