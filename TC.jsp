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
                        String stu_status = request.getParameter("role_list");
                        if (stu_status.equalsIgnoreCase("Thesis Committee")){
                            PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO THESIS_COMMITTEE VALUES (?, ?)");
                            pstmt.setInt(
                                1, Integer.parseInt(request.getParameter("GRAD_ID")));
                            pstmt.setString(2, request.getParameter("F_NAME"));
                            int rowCount = pstmt.executeUpdate();
                        }
                        else{
                            PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO ADVISOR VALUES (?, ?)");
                            pstmt.setInt(
                                1, Integer.parseInt(request.getParameter("GRAD_ID")));
                            pstmt.setString(2, request.getParameter("F_NAME"));
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

                        if(request.getParameter("FACULTY_ROLE").equalsIgnoreCase("Thesis Committee")){
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM THESIS_COMMITTEE WHERE GRAD_ID = ? AND F_NAME = ? ");
                            pstmt.setInt(
                                1, Integer.parseInt(request.getParameter("GRAD_ID")));
                            pstmt.setString(2, request.getParameter("F_NAME"));
                            int rowCount = pstmt.executeUpdate();
                        }
                        else{
                            PreparedStatement pstmt = conn.prepareStatement(
                                "DELETE FROM ADVISOR WHERE GRAD_ID = ? AND F_NAME = ? ");
                            pstmt.setInt(
                                1, Integer.parseInt(request.getParameter("GRAD_ID")));
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
                        ("SELECT * FROM THESIS_COMMITTEE");
  
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Thesis Committee</font></th></table>
                <table border="1">
                    <tr>
                        <th>Graduate ID</th>
                        <th>Faculty Name</th>
                        <th>TC or Advisor</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="TC.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="GRAD_ID" size="10"></th>
                            <th><input value="" name="F_NAME" size="20"></th>
                            <th><name="FACULTY_ROLE" size="20">
                            <select name = "role_list">
                              <option value="Thesis Committee">Thesis Committee</option>
                              <option value="Advisor">Advisor</option>
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
                        <form action="TC.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the GRAD_ID, which is a number --%>
                            <td>
                                <input value="<%= rs1.getInt("GRAD_ID") %>" 
                                    name="GRAD_ID" size="10" readonly>
                            </td>
    
                            <%-- Get the F_NAME --%>
                            <td>
                                <input value="<%= rs1.getString("F_NAME") %>" 
                                    name="F_NAME" size="20" readonly>
                            </td>
    
                           
                            <td>
                                <input value="Thesis Committee"
                                    name="FACULTY_ROLE" size="40" readonly>
                            </td>

                        </form>

                        <form action="TC.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs1.getInt("GRAD_ID") %>" name="GRAD_ID">
                            <input type="hidden" 
                                value="<%= rs1.getString("F_NAME") %>" name="F_NAME">
                            <input type="hidden" 
                                value="Thesis Committee" name="FACULTY_ROLE">    
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
                        ("SELECT * FROM ADVISOR");
  
            %>

            <%
                    // Iterate over the ResultSet
        
                    while ( rs2.next() ) {
        
            %>

                    <tr>

                            <%-- Get the GRAD_ID, which is a number --%>
                            <td>
                                <input value="<%= rs2.getInt("GRAD_ID") %>" 
                                    name="GRAD_ID" size="10" readonly>
                            </td>
    
                            <%-- Get the F_NAME --%>
                            <td>
                                <input value="<%= rs2.getString("F_NAME") %>" 
                                    name="F_NAME" size="20" readonly>
                            </td>
    
                           
                            <td>
                                <input value="Advisor"
                                    name="FACULTY_ROLE" size="40" readonly>
                            </td>

                        <form action="TC.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" 
                                value="<%= rs2.getInt("GRAD_ID") %>" name="GRAD_ID">
                            <input type="hidden" 
                                value="<%= rs2.getString("F_NAME") %>" name="F_NAME">
                            <input type="hidden" 
                                value="Advisor" name="FACULTY_ROLE">    
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
