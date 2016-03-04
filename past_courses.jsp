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
                Connection conn = null;
                Statement statement = null;
                Statement statement2 = null;
                ResultSet rs = null;
                ResultSet courses = null;
                try {
                    // Load Oracle Driver class file
                    DriverManager.registerDriver
                        (new com.microsoft.sqlserver.jdbc.SQLServerDriver());
    
                    // Make a connection to the Oracle datasource "cse132b"
                    conn = DriverManager.getConnection
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
                    statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the faculty attributes FROM the FACULTY table.
                    rs = statement.executeQuery
                        ("SELECT T.STUDENT_ID AS STUDENT_ID, CL.TITLE AS TITLE, S.SECTION_ID AS SECTION_ID, T.GRADE AS GRADE, T.UNITS AS UNITS FROM TAKEN T, SECTION S, COURSE C, CLASS CL WHERE T.SECTION_ID = S.SECTION_ID AND S.COURSE_NUM = C.COURSE_NUM AND S.QUARTER = CL.QUARTER AND S.YEAR = CL.YEAR AND S.COURSE_NUM = CL.COURSE_NUM");

                   //ResultSet rs = statement.executeQuery
                   //     ("SELECT * FROM TAKEN");


                    statement2 = conn.createStatement();
                    courses = statement2.executeQuery("SELECT C.COURSE_NUM AS COURSE_NUM, CL.TITLE AS TITLE FROM COURSE C, CLASS CL, WHERE C.COURSE_NUM = CL.COURSE_NUM");
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
                                <input value="<%= rs.getString("COURSE_NUM") %> <%= rs.getString("TITLE") %>" 
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

                } catch (SQLException sqle) {
                    out.println(sqle.getMessage());
                } catch (Exception e) {
                    out.println(e.getMessage());
                } finally{
                    // Close the ResultSet
                    if (rs!=null)
                        rs.close();

                    if (courses!=null)
                        courses.close();
    
                    // Close the Statement
                    if(statement!=null)
                        statement.close();

                    if(statement2!=null)
                        statement.close();
    
                    // Close the Connection
                    if(conn!=null)
                        conn.close();
                }
            %>
                </table>
				
            </td>
        </tr>
    </table>
</body>

</html>
