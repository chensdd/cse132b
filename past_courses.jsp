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
                            "INSERT INTO TAKEN VALUES (?, ?, ?, ?)");
                        pstmt.setString(1, request.getParameter("STUDENT_ID"));
                        pstmt.setString(2, request.getParameter("SECTION_ID"));
                        pstmt.setString(3, request.getParameter("GRADE"));
                        pstmt.setInt(4, Integer.parseInt(request.getParameter("UNITS")));
                        int rowCount1 = pstmt.executeUpdate();

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
                            "UPDATE TAKEN SET GRADE = ?, UNITS = ? WHERE STUDENT_ID = ? AND SECTION_ID = ?");
                        pstmt.setString(1, request.getParameter("GRADE"));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("UNITS")));
                        pstmt.setString(3, request.getParameter("STUDENT_ID"));
                        pstmt.setString(4, request.getParameter("SECTION_ID"));
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
                            "DELETE FROM TAKEN WHERE STUDENT_ID = ? AND SECTION_ID = ?");
                        pstmt.setString(1, request.getParameter("STUDENT_ID"));
                        pstmt.setString(2, request.getParameter("SECTION_ID"));
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
                        ("SELECT * FROM TAKEN, SECTION, COURSE WHERE TAKEN.SECTION_ID = SECTION.SECTION_ID AND SECTION.COURSE_NUM = COURSE.COURSE_NUM");

                   //ResultSet rs = statement.executeQuery
                   //     ("SELECT * FROM TAKEN");


                    Statement statement2 = conn.createStatement();
                    ResultSet courses = statement2.executeQuery("SELECT * FROM COURSE");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Courses Taken in the Past</font></th></table>
                <table border="1">
                    <tr>
                        <th>Student ID</th>
                        <th>Course Taken</th>
                        <th>Section</th>
                        <th>Grade</th>
                        <th>Units</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="past_courses.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="STUDENT_ID" size="20"></th>
                            <th><name="COURSES" size="20">
                            <select>
                                <% 
                                    while ( courses.next() ){
                                %>
                                     <option value="<%= courses.getString("COURSE_NUM") %>"><%= courses.getString("COURSE_NUM") %> <%= courses.getString("TITLE") %></option>
                                <%
                                    }
                                %>
                                 
                            </select></th>

                           
                            <th><input value="" name="SECTION_ID" size="5"></th>
                            <th><input value="" name="GRADE" size="5"></th>
                            <th><input value="" name="UNITS" size="5"></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>			

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="past_courses.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the STUDENT_ID, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("STUDENT_ID") %>" 
                                    name="STUDENT_ID" size="10">
                            </td>

                            <%-- Get the COURSE_NUM, which is a number --%>
                            
                            <td align="middle">
                                <input value="<%= rs.getInt("COURSE_NUM") %> <%= rs.getString("TITLE") %>" 
                                    name="COURSE_NUM" size="10" readonly>
                            </td>
    
                            <%-- Get the SECTION_ID, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("SECTION_ID") %>" 
                                    name="SECTION_ID" size="10" readonly>
                            </td>

                            <%-- Get the GRADE --%>
                            <td align="middle">
                                <input value="<%= rs.getString("GRADE") %>" 
                                    name="GRADE" size="5">
                            </td>

                            <%-- Get the UNITS, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("UNITS") %>" 
                                    name="UNITS" size="5">
                            </td>

    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="past_courses.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs.getString("STUDENT_ID") %>" name="STUDENT_ID">
                            <input type="hidden" 
                                value="<%= rs.getString("SECTION_ID") %>" name="SECTION_ID">
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
                    courses.close();
    
                    // Close the Statement
                    statement.close();
                    statement2.close();
    
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
