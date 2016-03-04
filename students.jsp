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
                        // INSERT the student attributes INTO the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO Student VALUES (?, ?, ?, ?, ?, ?, ?, ?)");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN")));
                        pstmt.setString(2, request.getParameter("ID"));
                        pstmt.setString(3, request.getParameter("FIRSTNAME"));
                        pstmt.setString(4, request.getParameter("MIDDLENAME"));
                        pstmt.setString(5, request.getParameter("LASTNAME"));
                        pstmt.setString(6, request.getParameter("RESIDENCY"));
						pstmt.setString(7, request.getParameter("status_list"));
						pstmt.setString(8, request.getParameter("enroll_list"));
                        int rowCount = pstmt.executeUpdate();
						
						//insert into Undergrad table or Grad table
						String stu_status = request.getParameter("status_list");
						if (stu_status.equalsIgnoreCase("Undergrad")){
							PreparedStatement sstmt = conn.prepareStatement(
                            "INSERT INTO UNDERGRAD VALUES (?, ?, ?, ?, ?)");
							sstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
							sstmt.setString(2, "School");
							sstmt.setString(3, "Undecided");
							sstmt.setString(4, "Undecided");
							sstmt.setString(5, "No");
							sstmt.executeUpdate();
						}
						else{
							PreparedStatement sstmt = conn.prepareStatement(
                            "INSERT INTO GRAD VALUES (?, ?, ?, ?)");
							sstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
							sstmt.setString(2, request.getParameter("status_list"));
							sstmt.setString(3, "Undecided");
							sstmt.setString(4, "<--->");
							sstmt.executeUpdate();
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
                        // UPDATE the student attributes in the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE Student SET FIRSTNAME = ?, " +
                            "MIDDLENAME = ?, LASTNAME = ?, RESIDENCY = ? , STU_STATUS = ?, ENROLL = ? WHERE ID = ?");

                        pstmt.setString(1, request.getParameter("FIRSTNAME"));
                        pstmt.setString(2, request.getParameter("MIDDLENAME"));
                        pstmt.setString(3, request.getParameter("LASTNAME"));
                        pstmt.setString(4, request.getParameter("RESIDENCY"));
						pstmt.setString(5, request.getParameter("STU_STATUS"));
						pstmt.setString(6, request.getParameter("ENROLL"));
                        pstmt.setInt(7, Integer.parseInt(request.getParameter("ID")));
                        int rowCount = pstmt.executeUpdate();
						
						//if update to undergrad, also inserted into the undergrad table
						if(request.getParameter("STU_STATUS").equalsIgnoreCase("Undergrad")){
							PreparedStatement sstmt = conn.prepareStatement("if not exists (select * from UNDERGRAD where UNDERGRAD_ID = ?) " +  
									"INSERT INTO UNDERGRAD VALUES (?, ?, ?, ?, ?)");
									
							sstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
							sstmt.setInt(2, Integer.parseInt(request.getParameter("ID")));
							sstmt.setString(3, "School <-need to be entered->");
							sstmt.setString(4, "Undecided");
							sstmt.setString(5, "Undecided");
							sstmt.setString(6, "No");
							sstmt.executeUpdate(); 
							
							//if the student was grad, remove the student from the grad table
							PreparedStatement gstmt = conn.prepareStatement("if exists (select * from GRAD where GRAD_ID = ?) " +  
									"DELETE FROM GRAD WHERE GRAD_ID = ?");
									
							gstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
							gstmt.setInt(2, Integer.parseInt(request.getParameter("ID")));
							gstmt.executeUpdate();
						}
						else{
							PreparedStatement sstmt = conn.prepareStatement("if not exists (select * from GRAD where GRAD_ID = ?) " +  
									"INSERT INTO GRAD VALUES (?, ?, ?, ?)");
									
							sstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
							sstmt.setInt(2, Integer.parseInt(request.getParameter("ID")));
							sstmt.setString(3, request.getParameter("STU_STATUS"));
							sstmt.setString(4, "Undecided");
							sstmt.setString(5, "<--->");
							sstmt.executeUpdate();
							
							//if the student was underGrad, remove the student from the undergrad table
							PreparedStatement gstmt = conn.prepareStatement("if exists (select * from UNDERGRAD where UNDERGRAD_ID = ?) " +  
									"DELETE FROM UNDERGRAD WHERE UNDERGRAD_ID = ?");
									
							gstmt.setInt(1, Integer.parseInt(request.getParameter("ID")));
							gstmt.setInt(2, Integer.parseInt(request.getParameter("ID")));
							gstmt.executeUpdate();
						}

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
                        
						//if delete from the student, also delete from the undergrad table
						if(request.getParameter("STU_STATUS").equalsIgnoreCase("Undergrad")){
							PreparedStatement sstmt = conn.prepareStatement("DELETE FROM UNDERGRAD WHERE UNDERGRAD_ID = ?");
							sstmt.setInt(1, Integer.parseInt(request.getParameter("ID"))); 
							sstmt.executeUpdate();
						}
						else{
							PreparedStatement sstmt = conn.prepareStatement("DELETE FROM GRAD WHERE GRAD_ID = ?");
							sstmt.setInt(1, Integer.parseInt(request.getParameter("ID"))); 
							sstmt.executeUpdate();
						}
						
                        // Create the prepared statement and use it to
                        // DELETE the student FROM the Student table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "DELETE FROM Student WHERE ID = ?");
						
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("ID"))); 									
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
                        ("SELECT * FROM Student");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Students</font></th></table>
                <table border="1">
                    <tr>
                        <th>SSN</th>
                        <th>ID</th>
                        <th>First</th>
			            <th>Middle</th>
                        <th>Last</th>
                        <th>Residency</th>
						<th>Status</th>
						<th>Enrolled</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value="" name="SSN" size="10"></th>
                            <th><input value="" name="ID" size="10"></th>
                            <th><input value="" name="FIRSTNAME" size="15"></th>
							<th><input value="" name="MIDDLENAME" size="15"></th>
                            <th><input value="" name="LASTNAME" size="15"></th>
                            <th><input value="" name="RESIDENCY" size="10"></th>
							<th><name="STU_STATUS" size="10">
							<select name = "status_list">
							  <option value="Undergrad">Undergrad</option>
							  <option value="MS">MS</option>
							  <option value="PhD candidates">phD candidates</option>
							  <option value="PhD pre-candidacy">phD pre-candidacy</option>
							</select></th>
							<th><name="ENROLL" size="5">
							<select name = "enroll_list">
							  <option value="Yes">Yes</option>
							  <option value="No">No</option>
							</select>
							</th>
                            <th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the SSN, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("SSN") %>" 
                                    name="SSN" size="10">
                            </td>
    
                            <%-- Get the ID --%>
                            <td align="middle">
                                <input value="<%= rs.getString("ID") %>" 
                                    name="ID" size="10">
                            </td>
    
                            <%-- Get the FIRSTNAME --%>
                            <td align="middle">
                                <input value="<%= rs.getString("FIRSTNAME") %>"
                                    name="FIRSTNAME" size="15">
                            </td>
    
                            <%-- Get the MIDDLENAME --%>
                            <td align="middle">
                                <input value="<%= rs.getString("MIDDLENAME") %>" 
                                    name="MIDDLENAME" size="15">
                            </td>
    
							<%-- Get the LASTNAME --%>
                            <td align="middle">
                                <input value="<%= rs.getString("LASTNAME") %>" 
                                    name="LASTNAME" size="15">
                            </td>

                            <%-- Get the RESIDENCY --%>
                            <td align="middle">
                                <input value="<%= rs.getString("RESIDENCY") %>" 
                                    name="RESIDENCY" style="text-align:center;" size="10">
                            </td>
							
							<%-- Get the STATUS --%>
                            <td align="middle">
                                <input value="<%= rs.getString("STU_STATUS") %>" 
                                    name="STU_STATUS" style="text-align:center;" size="15">
                            </td>
							
							<%-- Get the ENROLLMENT --%>
                            <td align="middle">
                                <input value="<%= rs.getString("ENROLL") %>" 
                                    name="ENROLL" size="5">
                            </td>
    
                            <%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="students.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                                <input type = "hidden" value="<%= rs.getString("ID") %>" 
                                    name="ID" size="10">
                                <input type = "hidden" value="<%= rs.getString("STU_STATUS") %>" 
                                    name="STU_STATUS" size="20">
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
