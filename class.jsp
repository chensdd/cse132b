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
                            "INSERT INTO CLASS VALUES (?, ?, ?, ?)");
							
                        pstmt.setString(1, request.getParameter("COURSE_NUM"));
						pstmt.setString(2, request.getParameter("TITLE"));
                        pstmt.setString(3, request.getParameter("quarter_list"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("YEAR")));
                        int rowCount = pstmt.executeUpdate();

                        //Commit transaction
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
                            "DELETE FROM CLASS WHERE COURSE_NUM = ? AND QUARTER = ? AND YEAR = ?;");

                        pstmt.setString(1, request.getParameter("COURSE_NUM"));
                        pstmt.setString(2, request.getParameter("QUARTER"));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("YEAR")));
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
                    // the student attributes FROM the Student table.
                    ResultSet rs = statement.executeQuery
                        ("SELECT * FROM CLASS");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Classes</font></th></table>
                <table border="1">
                    <tr>
                        <th>Course No.</th>
						<th>Title</th>
                        <th>Quarter</th>
                        <th>Year</th>
                        <th>Action</th>
                    </tr>

                    <tr>
                        <form action="class.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="COURSE_NUM" size="10"></th>
							<th><input value="" name="TITLE" size="40"></th>
                            <th><name="QUARTER" size="10">
							<select name = "quarter_list">
							  <option value="Spring">Spring</option>
							  <option value="Fall">Fall</option>
							  <option value="Winter">Winter</option>
							  <option value="Summer">Summer</option>
							</select></th>
                            <th><input value="" name="YEAR" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="class.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the COURSE_NUM, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getString("COURSE_NUM") %>" 
                                    name="QUARTER" size="10" readonly>
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("TITLE") %>" 
                                    name="TITLE" size="40" style="text-align:center;" readonly>
                            </td>

                            <td align="middle">
                                <input value="<%= rs.getString("QUARTER") %>" 
                                    name="GRADE_OPT" style="text-align:center;" size="20">
                            </td>
    
                            <%-- Get the COURSE LEVEL --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("YEAR") %>"
                                    name="YEAR" style="text-align:center;" size="5">
                            </td>
                    
                        </form>
						<%-- Button --%>
                        <form action="class.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("COURSE_NUM") %>" name="COURSE_NUM">
							<input type="hidden" 
                                value="<%= rs.getString("QUARTER") %>" name="QUARTER">
							<input type="hidden" 
                                value="<%= rs.getInt("YEAR") %>" name="YEAR">
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
