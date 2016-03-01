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

                        // Begin transaction
                        conn.setAutoCommit(false);
                        
                        // Create the prepared statement and use it to
                        // INSERT the faculty attributes INTO the FACULTY table.
                        PreparedStatement pstmt1 = conn.prepareStatement(
                            "INSERT INTO WORKS_FOR VALUES (?, ?)");
                        pstmt1.setString(1, request.getParameter("F_NAME"));
                        pstmt1.setString(2, request.getParameter("DEPT_NAME"));
                        int rowCount1 = pstmt1.executeUpdate();

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
                        // DELETE the faculty FROM the FACULTY table 

                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM WORKS_FOR WHERE F_NAME = ? AND DEPT_NAME = ?");
                        pstmt.setString(
                            1, request.getParameter("F_NAME"));
                        pstmt.setString(
                            2, request.getParameter("DEPT_NAME"));
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
                        ("SELECT * FROM WORKS_FOR");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Works For</font></th></table>
                <table border="1">
                    <tr>
                        <th>Name</th>
                        <th>Department</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="works_for.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="F_NAME" size="20"></th>
                            <th><input value="" name="DEPT_NAME" size="40"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>			

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                            <%-- Get the Name --%>
                            <td align="middle">
                                <input value="<%= rs.getString("F_NAME") %>" 
                                    name="F_NAME" size="20" readonly>
                            </td>
    
                            <%-- Get the DEPT_NAME --%>
                            <td align="middle">
                                <input value="<%= rs.getString("DEPT_NAME") %>"
                                    name="DEPT_NAME" size="50" readonly>
                            </td>

                        <form action="works_for.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("F_NAME") %>" name="F_NAME">
                            <input type="hidden" 
                                value="<%= rs.getString("DEPT_NAME") %>" name="DEPT_NAME">
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
