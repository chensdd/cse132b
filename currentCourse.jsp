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

            <%-- -------- Display Statement Code -------- --%>
            <%

					String action = request.getParameter("action");

					ResultSet rs = null;
					
                    if (action != null && action.equals("choose")) { 
						conn.setAutoCommit(false);
					    PreparedStatement query = conn.prepareStatement("SELECT DISTINCT COURSE.COURSE_NUM, SECTION.SECTION_ID, COURSE.TITLE, COURSE.GRADE_OPT, COURSE.LEVEL, MEETING.BUILDING, MEETING.TIME, MEETING.DAY, COURSE.LAB_REQ, COURSE.UNITS_MIN, COURSE.UNITS_MAX FROM COURSE INNER JOIN (MEETING INNER JOIN SECTION ON MEETING.SECTION_ID = SECTION.SECTION_ID) ON SECTION.COURSE_NUM = COURSE.COURSE_NUM AND SECTION.YEAR = ? AND SECTION.QUARTER = ?");
					    query.setInt(1, Integer.parseInt(request.getParameter("YEAR")));
					    query.setString(2, request.getParameter("quarter_list"));
					    rs = query.executeQuery();
						
						//Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
					}
            %>

            <!-- Add an HTML table header row to format the results -->
				<table border="0"><th><font face = "Arial Black" size = "6">Courses Offered
				<%
					if(request.getParameter("YEAR") != null){						
				%>
					<%= request.getParameter("YEAR")%>
					<%= request.getParameter("quarter_list")%>
				<% 
					}
				%>
				</font></th></table>
				
				<table border="1">
					<form action="currentCourse.jsp" method="get">
						<input type="hidden" value="choose" name="action">
					<tr>
						<th>YEAR</th>	
						<th>
							<input type="text" value = "" name="YEAR" size="5">							
						</th>
						
						<th>QUARTER</th>	
						<th>
							<select name = "quarter_list">
							  <option value="Spring">Spring</option>
							  <option value="Fall">Fall</option>
							  <option value="Winter">Winter</option>
							  <option value="Summer">Summer</option>
							</select>							
						</th>						

					    <%-- Button --%>
                            <td>
                                <input type="submit" name="choose" value="Submit">
                            </td>
					</tr>
					</form>
				</table>
				
			<%
				if(request.getParameter("YEAR") != null){						
			%>
				<table border="1">	
                    <tr>
                        <th>Course No.</th>
						<th>Section ID</th>
                        <th>Title</th>
                        <th>Grade Option</th>
                        <th>Course Level</th>
						<th>Building</th>
						<th>Time</th>
						<th>Day</th>
			            <th>Lab</th>
                        <th>Units</th>						
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet 
					while (rs.next()) {      
            %>
						<tr>                      
								<%-- Get the COURSE_NUM, which is a number --%>							
								<td align="middle">
									<input value="<%= rs.getInt("COURSE_NUM") %>" 
										name="COURSE_NUM" size="10" readonly>
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
									<input value="<%= rs.getString("GRADE_OPT") %>" 
										name="GRADE_OPT" size="10" readonly>
								</td>
		
								<td align="middle">
									<input value="<%= rs.getString("LEVEL") %>"
										name="LEVEL" size="6" readonly>
								</td>
								
								<td align="middle">
									<input value="<%= rs.getString("BUILDING") %>"
										name="BUILDING" size="6" readonly>
								</td>
								
								<td align="middle">
									<input value="<%= rs.getString("TIME") %>"
										name="TIME" size="20" style="text-align:center;" readonly>
								</td>
								
								<td align="middle">
									<input value="<%= rs.getString("DAY") %>"
										name="DAY" size="15" style="text-align:center;" readonly>
								</td>
		
								<td align="middle">
									<input value="<%= rs.getString("LAB_REQ") %>" 
										name="LAB_REQ" size="4" style="text-align:center;" readonly>
								</td>
		
								<td align="middle">
									<input value="<%= rs.getString("UNITS_MIN") %> - <%= rs.getString("UNITS_MAX") %>" 
										name="UNITS" size="6" style="text-align:center;" readonly>
								</td>
						</tr>
            <%
					}
				}
            %>

            <%-- -------- Close Connection Code -------- --%>
            <%
                    //Close the ResultSet
                    if(rs != null)
						rs.close();
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
