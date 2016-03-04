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

						String before_parse = request.getParameter("quarter_list");
                        String[] tokens = before_parse.split(",");
                        String quarter = tokens[0];
                        String year = tokens[1];
						
					    PreparedStatement query = conn.prepareStatement("SELECT DISTINCT COURSE.COURSE_NUM, SECTION.SECTION_ID, COURSE.GRADE_OPT, COURSE.LEVEL, MEETING.BUILDING, MEETING.TIME, MEETING.DAY, MEETING.CLASS_TYPE, COURSE.LAB_REQ, COURSE.UNITS_MIN, COURSE.UNITS_MAX FROM COURSE INNER JOIN (MEETING INNER JOIN SECTION ON MEETING.SECTION_ID = SECTION.SECTION_ID) ON SECTION.COURSE_NUM = COURSE.COURSE_NUM AND SECTION.YEAR = ? AND SECTION.QUARTER = ?");
					    query.setInt(1, Integer.parseInt(year));
					    query.setString(2, quarter);
					    rs = query.executeQuery();
						
						//Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
					}
					
					//get the year and quarter that offers meetings currently
					Statement statement = conn.createStatement();
                    ResultSet currentRs = statement.executeQuery
                        ("SELECT DISTINCT SECTION.YEAR, SECTION.QUARTER FROM SECTION INNER JOIN MEETING ON MEETING.SECTION_ID = SECTION.SECTION_ID");
            %>

            <!-- Add an HTML table header row to format the results -->
				<table border="0"><th><font face = "Arial Black" size = "6">Sections Offered
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
						<th>Quarter Selection</th>	
						<th><name="quarter_list" size="20">
                            <select name = "quarter_list">
                                <% 
                                    while (currentRs.next()){
                                %>
                                     <option value="<%= currentRs.getString("QUARTER")%>,<%= currentRs.getInt("YEAR") %>"><%= currentRs.getString("QUARTER") %> | <%= currentRs.getInt("YEAR") %></option>
                                <%
                                    }
                                %>
                                 
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
				if(rs.next()){						
			%>
				<table border="1">	
                    <tr>
                        <th>Course No.</th>
						<th>Section ID</th>
						<th>Class Type</th>
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
									<input value="<%= rs.getString("COURSE_NUM") %>" 
										name="COURSE_NUM" size="10" readonly>
								</td>
								
								<td align="middle">
									<input value="<%= rs.getString("SECTION_ID") %>" 
										name="SECTION_ID" size="10" readonly>
								</td>
								
								<td align="middle">
									<input value="<%= rs.getString("CLASS_TYPE") %>" 
										name="CLASS_TYPE" size="4" readonly>
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
								<% 
									String units = "";
									if(rs.getString("CLASS_TYPE").contains("LEC"))
										units = rs.getString("UNITS_MIN") + " - " + rs.getString("UNITS_MAX");
									else
										units = "--";
								%>
									<input value="<%= units%>" 
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
				currentRs.close();
				statement.close();
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
