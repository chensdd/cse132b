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
                        // INSERT the course attributes INTO the COURSE table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO COURSE VALUES (?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NUM")));
                        pstmt.setString(2, request.getParameter("grade_list"));
                        pstmt.setString(3, request.getParameter("level_list"));
						pstmt.setString(4, request.getParameter("TITLE"));
                        pstmt.setString(5, request.getParameter("lab_list"));
                        pstmt.setString(6, request.getParameter("UNITS_MIN"));
						pstmt.setString(7, request.getParameter("UNITS_MAX"));
                        int rowCount = pstmt.executeUpdate();
						
						PreparedStatement stmt = conn.prepareStatement(
                            "INSERT INTO OFFERED_BY VALUES (?, ?)");

                        stmt.setInt(1, Integer.parseInt(request.getParameter("COURSE_NUM")));
                        stmt.setString(2, request.getParameter("DEPT_NAME"));
                        stmt.executeUpdate();

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
                            "UPDATE COURSE SET TITLE = ?, GRADE_OPT = ?, LEVEL = ?, " +
                            "LAB_REQ = ?, UNITS_MIN = ?, UNITS_MAX = ? WHERE COURSE_NUM = ?");

                        pstmt.setString(1, request.getParameter("TITLE"));
                        pstmt.setString(2, request.getParameter("GRADE_OPT"));
                        pstmt.setString(3, request.getParameter("LEVEL"));
                        pstmt.setString(4, request.getParameter("LAB_REQ"));
                        pstmt.setInt(5, Integer.parseInt(request.getParameter("UNITS_MIN")));
						pstmt.setInt(6, Integer.parseInt(request.getParameter("UNITS_MAX")));
                        pstmt.setInt(7, Integer.parseInt(request.getParameter("COURSE_NUM")));
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
                            "DELETE FROM COURSE WHERE COURSE_NUM = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("COURSE_NUM")));
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
                        ("SELECT * FROM COURSE INNER JOIN OFFERED_BY ON COURSE.COURSE_NUM = OFFERED_BY.COURSE_NUM");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Courses</font></th></table>
                <table border="1">
                    <tr>
                        <th>Course No.</th>
                        <th>Title</th>
						<th>Department</th>
                        <th>Grade Option</th>
                        <th>Course Level</th>
			            <th>Lab</th>
                        <th>Minimum Units</th>
						<th>Maximum Units</th>
                        <th>Action</th>
                    </tr>

                    <tr>
                        <form action="course.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSE_NUM" size="10"></th>
                            <th><input value="" name="TITLE" size="20"></th>
							<th><input value="" name="DEPT_NAME" size="20"></th>
                            <th><name="GRADE_OPT" size="20">
							<select name = "grade_list">
							  <option value="letter">letter only</option>
							  <option value="S/U">S/U only</option>
							  <option value="letter or S/U">letter or S/U</option>
							</select></th>
                            <th><name="LEVEL" size="15">
							<select name = "level_list">
							  <option value="lower">lower</option>
							  <option value="upper">upper</option>
							  <option value="grad">grad</option>
							</select></th>
							<th><name="LAB_REQ" size="5">
							<select name = "lab_list">
								<option value="no">no</option>
								<option value="yes">yes</option>
							</th>
                            <th><input value="" name="UNITS_MIN" size="5"></th>
							<th><input value="" name="UNITS_MAX" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="course.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the COURSE_NUM, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("COURSE_NUM") %>" 
                                    name="COURSE_NUM" size="10">
                            </td>

                            <%-- Get the TITLE --%>
                            <td align="middle">
                                <input value="<%= rs.getString("TITLE") %>" 
                                    name="TITLE" size="20">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("DEPT_NAME") %>" 
                                    name="DEPT_NAME" size="20">
                            </td>
    
                            <%-- Get the GRADE_OPT --%>
                            <td align="middle">
                                <input value="<%= rs.getString("GRADE_OPT") %>" 
                                    name="GRADE_OPT" size="20">
                            </td>
    
                            <%-- Get the COURSE LEVEL --%>
                            <td align="middle">
                                <input value="<%= rs.getString("LEVEL") %>"
                                    name="LEVEL" size="15">
                            </td>
    
                            <%-- Get the LAB --%>
                            <td align="middle">
                                <input value="<%= rs.getString("LAB_REQ") %>" 
                                    name="LAB_REQ" size="5">
                            </td>
    
							<%-- Get the UNITS --%>
                            <td align="middle">
                                <input value="<%= rs.getString("UNITS_MIN") %>" 
                                    name="UNITS_MIN" size="5">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("UNITS_MAX") %>" 
                                    name="UNITS_MAX" size="5">
                            </td>
    
                            <%-- Button --%>
                            <td align="middle">
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="course.jsp" method="get">
                        <form action="course.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("COURSE_NUM") %>" name="COURSE_NUM">
                            <%-- Button --%>
                            <td align="middle">
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
