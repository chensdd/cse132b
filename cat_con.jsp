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
                        //insert into Thesis Committee table or Advisor table
                        String stu_status = request.getParameter("cat_con_list");
                        if (stu_status.equalsIgnoreCase("Category")){
                            PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO CATEGORIES VALUES (?, ?, ?, ?, ?)");
                            pstmt.setString(1, request.getParameter("DEPT_NAME"));
                            pstmt.setInt(
                                2, Integer.parseInt(request.getParameter("COURSE_NUM")));
                            pstmt.setString(3, request.getParameter("NAME"));
                            pstmt.setString(4, request.getParameter("MIN_UNITS"));
                            pstmt.setString(5, request.getParameter("MIN_GPA"));
                            int rowCount = pstmt.executeUpdate();
                        }
                        else{
                            PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO CONCENTRATION VALUES (?, ?, ?, ?, ?)");
                            pstmt.setString(1, request.getParameter("DEPT_NAME"));
                            pstmt.setInt(
                                2, Integer.parseInt(request.getParameter("COURSE_NUM")));
                            pstmt.setString(3, request.getParameter("NAME"));
                            pstmt.setString(4, request.getParameter("MIN_UNITS"));
                            pstmt.setString(5, request.getParameter("MIN_GPA"));
                            int rowCount = pstmt.executeUpdate();
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
                        if(request.getParameter("CAT_CON_ROLE").equalsIgnoreCase("Category")){
                            PreparedStatement pstmt = conn.prepareStatement(
                                "UPDATE CATEGORIES SET MIN_UNITS = ?, MIN_GPA = ? WHERE DEPT_NAME = ? AND COURSE_NUM = ? AND NAME = ?");
                            pstmt.setString(1, request.getParameter("MIN_UNITS"));
                            pstmt.setString(2, request.getParameter("MIN_GPA"));
                            pstmt.setString(3, request.getParameter("DEPT_NAME"));
                            pstmt.setInt(
                                4, Integer.parseInt(request.getParameter("COURSE_NUM")));
                            pstmt.setString(5, request.getParameter("NAME"));
                            int rowCount = pstmt.executeUpdate();
                        }
                        else{
                            PreparedStatement pstmt = conn.prepareStatement(
                                "UPDATE CONCENTRATION SET MIN_UNITS = ?, MIN_GPA = ? WHERE DEPT_NAME = ? AND COURSE_NUM = ? AND NAME = ?");
                            pstmt.setString(1, request.getParameter("MIN_UNITS"));
                            pstmt.setString(2, request.getParameter("MIN_GPA"));
                            pstmt.setString(3, request.getParameter("DEPT_NAME"));
                            pstmt.setInt(
                                4, Integer.parseInt(request.getParameter("COURSE_NUM")));
                            pstmt.setString(5, request.getParameter("NAME"));
                            int rowCount = pstmt.executeUpdate();
                        }
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
                        if(request.getParameter("CAT_CON_ROLE").equalsIgnoreCase("Category")){
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM CATEGORIES WHERE DEPT_NAME = ? AND COURSE_NUM = ? AND NAME = ?");
                            pstmt.setString(1, request.getParameter("DEPT_NAME"));
                            pstmt.setInt(
                                2, Integer.parseInt(request.getParameter("COURSE_NUM")));
                            pstmt.setString(3, request.getParameter("NAME"));
                            int rowCount = pstmt.executeUpdate();
                        }
                        else{
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM CONCENTRATION WHERE DEPT_NAME = ? AND COURSE_NUM = ? AND NAME = ?");
                            pstmt.setString(1, request.getParameter("DEPT_NAME"));
                            pstmt.setInt(
                                2, Integer.parseInt(request.getParameter("COURSE_NUM")));
                            pstmt.setString(3, request.getParameter("NAME"));
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
                        ("SELECT * FROM CATEGORIES");
  
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Categories/Concentration Info</font></th></table>
                <table border="1">
                    <tr>
                        <th>Department Name</th>
                        <th>Course Number</th>
                        <th>Name</th>
                        <th>Minimum Units</th>
                        <th>Minimum GPA</th>
                        <th>Type</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="cat_con.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="DEPT_NAME" size="20"></th>
                            <th><input value="" name="COURSE_NUM" size="15"></th>
                            <th><input value="" name="NAME" size="30"></th>
                            <th><input value="" name="MIN_UNITS" size="15"></th>
                            <th><input value="0.000" name="MIN_GPA" size="15"></th>
                            <th><name="CAT_CON_ROLE" size="20">
                            <select name = "cat_con_list">
                              <option value="Category">Category</option>
                              <option value="Concentration">Concentration</option>
                            </select></th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet       
                    while ( rs1.next() ) {        
            %>
                    <tr>
                        <form action="cat_con.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the DEPT_NAME --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("DEPT_NAME") %>" 
                                    name="DEPT_NAME" size="20" readonly>
                            </td>

                            <%-- Get the COURSE_NUM, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs1.getInt("COURSE_NUM") %>" 
                                    name="COURSE_NUM" size="15" readonly>
                            </td>
    
                            <%-- Get the NAME --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("NAME") %>" 
                                    name="NAME" size="30" readonly>
                            </td>

                            <%-- Get the MIN_UNITS --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("MIN_UNITS") %>" 
                                    name="MIN_UNITS" size="15">
                            </td>

                            <%-- Get the MIN_GPA --%>
                            <td align="middle">
                                <input value="<%= rs1.getString("MIN_GPA") %>" 
                                    name="MIN_GPA" size="15">
                            </td>
    
                           
                            <td align="middle">
                                <input value="Category"
                                    name="CAT_CON_ROLE" size="20" readonly>
                            </td>
                            <%-- Button --%>
                            <td align="middle">
                                <input type="submit" value="Update">
                            </td>
                        </form>

                        <form action="cat_con.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs1.getString("DEPT_NAME") %>" name="DEPT_NAME">
                            <input type="hidden" 
                                value="<%= rs1.getInt("COURSE_NUM") %>" name="COURSE_NUM">
                            <input type="hidden" 
                                value="<%= rs1.getString("NAME") %>" name="NAME">
                            <input type="hidden" 
                                value="Category" name="CAT_CON_ROLE">    
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
                        ("SELECT * FROM CONCENTRATION");
  
            %>

            <%
                    // Iterate over the ResultSet
        
                    while ( rs2.next() ) {
        
            %>

                    <tr>
                        <form action="cat_con.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the DEPT_NAME --%>
                            <td>
                                <input value="<%= rs2.getString("DEPT_NAME") %>" 
                                    name="DEPT_NAME" size="20" readonly>
                            </td>

                            <%-- Get the COURSE_NUM, which is a number --%>
                            <td>
                                <input value="<%= rs2.getInt("COURSE_NUM") %>" 
                                    name="COURSE_NUM" size="15" readonly>
                            </td>
    
                            <%-- Get the NAME --%>
                            <td>
                                <input value="<%= rs2.getString("NAME") %>" 
                                    name="NAME" size="30" readonly>
                            </td>

                            <%-- Get the MIN_UNITS --%>
                            <td>
                                <input value="<%= rs2.getString("MIN_UNITS") %>" 
                                    name="MIN_UNITS" size="15">
                            </td>

                            <%-- Get the MIN_GPA --%>
                            <td>
                                <input value="<%= rs2.getString("MIN_GPA") %>" 
                                    name="MIN_GPA" size="15">
                            </td>
    
                           
                            <td>
                                <input value="Concentration"
                                    name="CAT_CON_ROLE" size="20" readonly>
                            </td>
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>

                        <form action="cat_con.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs2.getString("DEPT_NAME") %>" name="DEPT_NAME">
                            <input type="hidden" 
                                value="<%= rs2.getInt("COURSE_NUM") %>" name="COURSE_NUM">
                            <input type="hidden" 
                                value="<%= rs2.getString("NAME") %>" name="NAME">
                            <input type="hidden" 
                                value="Concentration" name="CAT_CON_ROLE">    
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
Status API Training Shop Blog About Pricing
© 2016 GitHub, Inc. Terms Privacy Security Contact Help