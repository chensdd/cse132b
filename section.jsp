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
                            "INSERT INTO SECTION VALUES (?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("CLASS_SIZE")));
                        pstmt.setInt(3, Integer.parseInt(request.getParameter("COURSE_NUM")));
                        pstmt.setString(4, request.getParameter("FACULTY_NAME"));
						pstmt.setString(5, request.getParameter("quarter_list"));
						pstmt.setInt(6, Integer.parseInt(request.getParameter("YEAR")));
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
                            "UPDATE SECTION SET CLASS_SIZE = ?, COURSE_NUM = ?, " +
                            "FACULTY_NAME = ? WHERE SECTION_ID = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("CLASS_SIZE")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("COURSE_NUM")));
                        pstmt.setString(3, request.getParameter("FACULTY_NAME"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("SECTION_ID")));
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
                            "DELETE FROM SECTION WHERE SECTION_ID = ?");

                        pstmt.setInt(
                            1, Integer.parseInt(request.getParameter("SECTION_ID")));
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
                        ("SELECT * FROM SECTION");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Sections</font></th></table>
                <table border="1">
                    <tr>
                        <th>Section ID</th>
                        <th>Class Size</th>
                        <th>Course No.</th>
			            <th>Faculty Name</th>
						<th>Quarter</th>
						<th>Year</th>
                        <th>Action</th>
                    </tr>

                    <tr>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SECTION_ID" size="10"></th>
                            <th><input value="" name="CLASS_SIZE" size="5"></th>
							<th><input value="" name="COURSE_NUM" size="10"></th>
							<th><input value="" name="FACULTY_NAME" size="20"></th>
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
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SECTION ID, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("SECTION_ID") %>" 
                                    name="SECTION_ID" size="10">
                            </td>

                            <td align="middle">
                                <input value="<%= rs.getString("CLASS_SIZE") %>" 
                                    name="CLASS_SIZE" size="5">
                            </td>

                            <td align="middle">
                                <input value="<%= rs.getString("COURSE_NUM") %>"
                                    name="COURSE_NUM" size="10">
                            </td>
    
                            <td align="middle">
                                <input value="<%= rs.getString("FACULTY_NAME") %>" 
                                    name="FACULTY_NAME" size="20">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("QUARTER") %>" 
                                    name="QUARTER" size="10">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("YEAR") %>" 
                                    name="YEAR" size="5">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="section.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getInt("SECTION_ID") %>" name="SECTION_ID">
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
