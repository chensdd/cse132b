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
                            "INSERT INTO FINANCE VALUES (?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ACCOUNT_NUM")));
                        pstmt.setInt(2, Integer.parseInt(request.getParameter("SALARY")));
                        int rowCount = pstmt.executeUpdate();

                        //insert into Thesis Committee table or Advisor table
                        String stu_status = request.getParameter("work_list");
                        if (stu_status.equalsIgnoreCase("Part Time")){
                            PreparedStatement pstmt1 = conn.prepareStatement(
                            "INSERT INTO PART_TIME VALUES (?, ?)");
                            pstmt1.setInt(1, Integer.parseInt(request.getParameter("ACCOUNT_NUM")));
                            pstmt1.setInt(2, Integer.parseInt(request.getParameter("IDENTIFIER")));
                            pstmt1.executeUpdate();
                        }
                        else{
                            PreparedStatement pstmt1 = conn.prepareStatement(
                            "INSERT INTO FULL_TIME VALUES (?, ?)");
                            pstmt1.setInt(1, Integer.parseInt(request.getParameter("ACCOUNT_NUM")));
                            pstmt1.setString(2, request.getParameter("IDENTIFIER"));
                            pstmt1.executeUpdate();
                        }

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
                        PreparedStatement pstmt1 = conn.prepareStatement(
                            "UPDATE FINANCE SET SALARY = ? WHERE ACCOUNT_NUM = ?");
                        pstmt1.setInt(1, Integer.parseInt(request.getParameter("SALARY")));
                        pstmt1.setInt(2, Integer.parseInt(request.getParameter("ACCOUNT_NUM")));
                        pstmt1.executeUpdate();
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

                        if(request.getParameter("WORK_ROLE").equalsIgnoreCase("Part Time")){
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM PART_TIME WHERE ACCOUNT_NUM = ? AND STUDENT_ID = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("ACCOUNT_NUM")));
                            pstmt.setInt(2, Integer.parseInt(request.getParameter("STUDENT_ID")));
                            int rowCount = pstmt.executeUpdate();
                        }
                        else{
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM FULL_TIME WHERE ACCOUNT_NUM = ? AND F_NAME = ?");
                            pstmt.setInt(1, Integer.parseInt(request.getParameter("ACCOUNT_NUM")));
                            pstmt.setString(2, request.getParameter("F_NAME"));
                            int rowCount = pstmt.executeUpdate();
                        }

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
                    ResultSet rs1 = statement.executeQuery
                        ("SELECT * FROM FINANCE f, PART_TIME pt WHERE f.ACCOUNT_NUM = pt.ACCOUNT_NUM");
  
            %>

            <!-- Add an HTML table header row to format the results -->
                <table border="1">
                    <tr>
                        <th>Account Number</th>
                        <th>Student ID/Faculty Name</th>
                        <th>Status</th>
                        <th>Salary</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="salary.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="ACCOUNT_NUM" size="20"></th>
                            <th><input value="" name="IDENTIFIER" size="20"></th>
                            <th><name="WORK_ROLE" size="20">
                            <select name = "work_list">
                              <option value="Part Time">Part Time</option>
                              <option value="Full Time">Full TIme</option>
                            </select></th>
                            <th><input value="" name="SALARY" size="20"></th>
                            
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet
        
                    while ( rs1.next() ) {
        
            %>

                    <tr>
                        <form action="salary.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the ACCOUNT_NUM --%>
                            <td>
                                <input value="<%= rs1.getInt("ACCOUNT_NUM") %>" 
                                    name="ACCOUNT_NUM" size="20" readonly>
                            </td>

                            <%-- Get the STUDENT_ID, which is a number --%>
                            <td>
                                <input value="<%= rs1.getInt("STUDENT_ID") %>" 
                                    name="STUDENT_ID" size="20" readonly>
                            </td>

                            <td>
                                <input value="Part Time"
                                    name="WORK_ROLE" size="20" readonly>
                            </td>
    
                            <%-- Get the SALARY --%>
                            <td>
                                <input value="<%= rs1.getInt("SALARY") %>" 
                                    name="SALARY" size="20" >
                            </td>   
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>

                        <form action="salary.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs1.getInt("ACCOUNT_NUM") %>" name="ACCOUNT_NUM">
                            <input type="hidden" 
                                value="<%= rs1.getInt("STUDENT_ID") %>" name="STUDENT_ID">
                            <input type="hidden" 
                                value="Part Time" name="WORK_ROLE">
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Delete">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- SELECT Statement Code -------- --%>
            <%
                    // Create the statement
                    //Statement statement = conn.createStatement();

                    // Use the created statement to SELECT
                    // the student attributes FROM the Student table.
                    ResultSet rs2 = statement.executeQuery
                        ("SELECT * FROM FINANCE f, FULL_TIME ft WHERE f.ACCOUNT_NUM = ft.ACCOUNT_NUM");
  
            %>

            <%
                    // Iterate over the ResultSet
        
                    while ( rs2.next() ) {
        
            %>

                    <tr>
                        <form action="salary.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the ACCOUNT_NUM --%>
                            <td>
                                <input value="<%= rs2.getInt("ACCOUNT_NUM") %>" 
                                    name="ACCOUNT_NUM" size="20" readonly>
                            </td>

                            <%-- Get the F_NAME, which is a number --%>
                            <td>
                                <input value="<%= rs2.getString("F_NAME") %>" 
                                    name="F_NAME" size="20" readonly>
                            </td>

                            <td>
                                <input value="Full Time"
                                    name="WORK_ROLE" size="20" readonly>
                            </td>
    
                            <%-- Get the SALARY --%>
                            <td>
                                <input value="<%= rs2.getInt("SALARY") %>" 
                                    name="SALARY" size="20" >
                            </td>   
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>

                        <form action="salary.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs2.getInt("ACCOUNT_NUM") %>" name="ACCOUNT_NUM">
                            <input type="hidden" 
                                value="<%= rs2.getString("F_NAME") %>" name="F_NAME">
                            <input type="hidden" 
                                value="Full Time" name="WORK_ROLE">
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
                    rs1.close();
                    rs2.close();
    
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
