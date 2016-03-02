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

			<%-- empty the table during the start up --%>
			<%
					PreparedStatement empty = conn.prepareStatement(
						"DELETE FROM ENROLL");
					empty.executeUpdate();
					conn.commit();
			%>

            <%-- -------- INSERT Code -------- --%>
            <%
                    String action = request.getParameter("action");
                    // Check if an insertion is requested
                    if (action != null && action.equals("insert")) {
						
						//Begin transaction
                        conn.setAutoCommit(false);
                        
						String value = request.getParameter("buttonCheck");
						//out.print(value);
						if(value.equals("Enroll")){
							PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO ENROLL VALUES (?, ?)");

							pstmt.setInt(1, Integer.parseInt(request.getParameter("STU_ID")));
							pstmt.setInt(2, Integer.parseInt(request.getParameter("SEC_ID")));
							int rowCount = pstmt.executeUpdate();
						}
						else{
							PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO WAITLISTED_FOR VALUES (?, ?)");

							pstmt.setInt(1, Integer.parseInt(request.getParameter("STU_ID")));
							pstmt.setInt(2, Integer.parseInt(request.getParameter("SEC_ID")));
							int rowCount = pstmt.executeUpdate();						
						}
                        

                        //Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>

            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("choose")) {

						//Begin transaction
						conn.setAutoCommit(false);
						
						PreparedStatement pstmt = conn.prepareStatement(
						"INSERT INTO ENROLL VALUES (?, ?)");

						pstmt.setInt(1, Integer.parseInt(request.getParameter("STU_ID")));
						pstmt.setInt(2, Integer.parseInt(request.getParameter("SEC_ID")));
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
                    //Create the statement
                    //Statement statement = conn.createStatement();
					  
                      PreparedStatement query = conn.prepareStatement("SELECT DISTINCT ENROLL.STD_ID, ENROLL.SECTION_ID, COURSE.TITLE, COURSE.GRADE_OPT, COURSE.LAB_REQ, COURSE.UNITS_MIN, COURSE.UNITS_MAX, SECTION.CLASS_SIZE FROM ENROLL INNER JOIN (COURSE INNER JOIN SECTION ON COURSE.COURSE_NUM = SECTION.COURSE_NUM) ON ENROLL.SECTION_ID = SECTION.SECTION_ID");
					  ResultSet rs = query.executeQuery();
            %>

            <!-- Add an HTML table header row to format the results -->
				<table border="0"><th><font face = "Arial Black" size = "6">Courses Enrollment</font></th></table>
                <table border="1">
					<form action="courseEntry.jsp" method="get">
						<input type="hidden" value="choose" name="action">
					<tr>
						<th>Student ID</th>	
						<th>
							<input type="text" value = "" name="STU_ID" size="10">							
						</th>
						
						<th>Section ID</th>	
						<th>
							<input type="text" value = "" name="SEC_ID" size="10">							
						</th>						

					    <%-- Button --%>
                            <td>
                                <input type="submit" name="choose" value="Submit">
                            </td>
					</form>
					</tr>
				</table>
				
				<table border="1">	
                    <tr>
                        <th>Student ID</th>
						<th>Section ID</th>
                        <th>Title</th>
                        <th>Grade Option</th>
			            <th>Lab</th>
                        <th>Units</th>
						<th>Seats</th>
						<th>Action</th>						
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet 
                    while ( rs.next() ) {      
            %>
                    <tr>  
						<form action="courseEntry.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
						
                            <td align="middle">
                                <input value="<%= rs.getInt("STD_ID") %>" 
                                    name="STD_ID" size="10" readonly>
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("SECTION_ID") %>" 
                                    name="SECTION_ID" size="10" readonly>
                            </td>

                            <td align="middle">
                                <input value="<%= rs.getString("TITLE") %>" 
                                    name="TITLE" size="20" readonly>
                            </td>
    
                            <td align="middle">
							<select name="grade_opt">
                            <%
								String opt = rs.getString("GRADE_OPT");
								if(opt.equals("letter or S/U")){
							%>								
								<option>letter</option>
								<option>S/U</option>
							<%
								}
								else{
							%>	
								<option><%=opt%></option>
							<%
								}
							%>
								</select>
                            </td>   
    
                            <td align="middle">
                                <input value="<%= rs.getString("LAB_REQ") %>" 
                                    name="LAB_REQ" size="4" readonly >
                            </td>

							<td align="middle">
							<% 
								int min = rs.getInt("UNITS_MIN");
								int max = rs.getInt("UNITS_MAX");
							%>
								<select name="units_list">
							<%
								for(int i = min; i < max + 1; i++) {
							%>
								<option><%=i%></option>
							<%
								}
							%>
								</select>
							</td>
							
							<td align="middle">
							<%
								int secID = rs.getInt("SECTION_ID");
								PreparedStatement cntQuery = conn.prepareStatement("SELECT COUNT(STUDENT_ID) FROM TAKES WHERE SECTION_ID = ?");
								cntQuery.setInt(1, secID);
								ResultSet cntRs = cntQuery.executeQuery();
								int seats = 0;
								if(cntRs.next())
									seats = cntRs.getInt(1);
								int size = rs.getInt("CLASS_SIZE");
							%>
								<input value="<%=seats%>/<%=size%>" 
                                    name="SEATS" size="5" readonly>
							</td>
							<%-- Button --%>
                            <td>
                                <input type="submit" name="buttonCheck" value="Enroll">
                            </td>
					    <%-- Button --%>
                            <td>
                                <input type="submit" name="buttonCheck" value="Add To WaitList">
                            </td>
                        </form>
                    </tr>
            <%
                    }
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    //Close the ResultSet
                    rs.close();
    
                    // Close the Statement
                    //statement.close();
    
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
