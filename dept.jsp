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
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO DEPARTMENT VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setString(1, request.getParameter("DEPT_NAME"));
                        pstmt.setString(2, request.getParameter("MIN_GPA"));
                        pstmt.setString(3, request.getParameter("MAJ_UNIT_UPDIV"));
                        pstmt.setString(4, request.getParameter("MAJ_UNIT_LOWDIV"));
                        pstmt.setString(5, request.getParameter("ELECTIVE"));
                        pstmt.setString(6, request.getParameter("GRAD_UNIT"));
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
                        // UPDATE the faculty attributes in the FACULTY table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE DEPARTMENT SET MIN_GPA = ?, MAJ_UNIT_UPDIV = ?, MAJ_UNIT_LOWDIV = ?, "+
                            "ELECTIVE = ?, GRAD_UNIT = ? WHERE DEPT_NAME = ?");
                        pstmt.setString(1, request.getParameter("MIN_GPA"));
                        pstmt.setString(2, request.getParameter("MAJ_UNIT_UPDIV"));
                        pstmt.setString(3, request.getParameter("MAJ_UNIT_LOWDIV"));
                        pstmt.setString(4, request.getParameter("ELECTIVE"));
                        pstmt.setString(5, request.getParameter("GRAD_UNIT"));
                        pstmt.setString(6, request.getParameter("DEPT_NAME"));
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
                        PreparedStatement pstmt2 = conn.prepareStatement("if exists (select * from WORKS_FOR where DEPT_NAME = ?) " + 
                            "DELETE FROM WORKS_FOR WHERE DEPT_NAME = ?");
                        pstmt2.setString(1, request.getParameter("DEPT_NAME"));
                        pstmt2.setString(2, request.getParameter("DEPT_NAME"));
                        int rowCount2 = pstmt2.executeUpdate();

                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM DEPARTMENT WHERE DEPT_NAME = ?");

                        pstmt.setString(
                            1, request.getParameter("DEPT_NAME"));
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
                        ("SELECT * FROM DEPARTMENT");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Departments</font></th></table>
                <table border="1">
                    <tr>
                        <th>Department Name</th>
                        <th>Minimum GPA</th>
                        <th>Major Units (Upper)</th>
                        <th>Major Units (Lower)</th>
                        <th>Tech Elective Unit</th>
                        <th>Grad Units in Major</th>
                    </tr>
                    <tr>
                        <form action="dept.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEPT_NAME" size="40"></th>
                            <th><input value="" name="MIN_GPA" size="5"></th>
                            <th><input value="" name="MAJ_UNIT_UPDIV" size="5"></th>
                            <th><input value="" name="MAJ_UNIT_LOWDIV" size="5"></th>
                            <th><input value="" name="ELECTIVE" size="5"></th>
                            <th><input value="" name="GRAD_UNIT" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>           

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="dept.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the Name --%>
                            <td align="middle">
                                <input value="<%= rs.getString("DEPT_NAME") %>" 
                                    name="DEPT_NAME" size="40" readonly>
                            </td>
    
                            <td align="middle">
                                <input value="<%= rs.getString("MIN_GPA") %>"
                                    name="MIN_GPA" style="text-align:center;" size="5">
                            </td>
                            
                            <td align="middle">
                                <input value="<%= rs.getString("MAJ_UNIT_UPDIV") %>"
                                    name="MAJ_UNIT_UPDIV" style="text-align:center;" size="5">
                            </td>
                            
                            <td align="middle">
                                <input value="<%= rs.getString("MAJ_UNIT_LOWDIV") %>"
                                    name="MAJ_UNIT_LOWDIV" style="text-align:center;" size="5">
                            </td>
                            
                            <td align="middle">
                                <input value="<%= rs.getString("ELECTIVE") %>"
                                    name="ELECTIVE" style="text-align:center;" size="5">
                            </td>
                        
                            <td align="middle">
                                <input value="<%= rs.getString("GRAD_UNIT") %>"
                                    name="GRAD_UNIT" style="text-align:center;" size="5">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="dept.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
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
