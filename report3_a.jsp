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
			
				<%
				// Create the statement
				Statement statement = conn.createStatement();
				ResultSet c_rs = statement.executeQuery("SELECT DISTINCT COURSE_NUM FROM CLASS");				
				%>
				<!-- Add an HTML table header row to format the results -->
				<table border="0"><th><font face = "Arial Black" size = "6">Report III - part a</font></th></table>
					<table border="1">
						<form action="report3_a.jsp" method="get">
							<input type="hidden" value="choose" name="action">
						<tr>
							<th>Course ID</th>	
							<th>
								<select name="course_list">
								<%
									while(c_rs.next()){
								%>								
									<option><%=c_rs.getString("COURSE_NUM")%></option>
								<%
									}
								%>
								</select>
							</th>
							
							<th>Professor</th>	
							<th>
								<select name="prof_list">
								<%
								ResultSet prof_rs = statement.executeQuery("SELECT DISTINCT F_NAME FROM FACULTY");
									while(prof_rs.next()){
								%>								
									<option><%=prof_rs.getString("F_NAME")%></option>
								<%
									}
								%>
								</select>
							</th>
							
							<th>Quarter</th>	
							<th>
								<select name="year_list">
								<%
								ResultSet y_rs = statement.executeQuery("SELECT DISTINCT YEAR FROM CLASS");
									while(y_rs.next()){
								%>								
									<option><%=y_rs.getString("YEAR")%></option>
								<%
									}
								%>
								</select>
								<select name="quarter_list">
									<option>Spring</option>
									<option>Fall</option>
									<option>Winter</option>
									<option>Summer</option>
								</select>
							</th>

							<%-- Button --%>
								<td>
									<input type="submit" name="choose" value="Select">
								</td>
						</form>
						</tr>
					</table>

            <%-- -------- INSERT Code -------- --%>
            <%
				String action = request.getParameter("action");
				// Check if an insertion is requested
				if (action != null && action.equals("choose")) {
						
					conn.setAutoCommit(false);  						
				
					//get the section ID from the selection
					PreparedStatement pstmt = conn.prepareStatement("SELECT SECTION_ID FROM SECTION WHERE COURSE_NUM = ? AND FACULTY_NAME = ? AND QUARTER = ? AND YEAR = ?");
					pstmt.setString(1, request.getParameter("course_list"));
					pstmt.setString(2, request.getParameter("prof_list"));
					pstmt.setString(3, request.getParameter("quarter_list"));
					pstmt.setInt(4, Integer.parseInt(request.getParameter("year_list")));

					ResultSet rs = pstmt.executeQuery();			
					
					//get the section ID
					int sectionID = 0;						
					if(rs.next())
						sectionID = rs.getInt("SECTION_ID");
					
					int a_grade = 0;
					int b_grade = 0;
					int c_grade = 0;
					int d_grade = 0;
					int other = 0;
					
					
					//get all students who took this section in the past and count the grades
					PreparedStatement stemp = conn.prepareStatement("SELECT GRADE FROM TAKEN WHERE SECTION_ID = ?");
					stemp.setInt(1, sectionID);
					ResultSet stempRS = stemp.executeQuery();
					
					%>
						<table border="0"><th><font face = "Monospace" size = "6">Course ID <%= request.getParameter("course_list")%> <%= request.getParameter("quarter_list")%> <%= request.getParameter("year_list")%></font></th></table>
					<%
					while(stempRS.next()){	
						if(stempRS.getString("GRADE").contains("A"))
							a_grade++;
						else if(stempRS.getString("GRADE").contains("B"))
							b_grade++;
						else if(stempRS.getString("GRADE").contains("C"))
							c_grade++;
						else if(stempRS.getString("GRADE").contains("D"))
							d_grade++;
						else //F,S,U,IN
							other++;			
					}
					
						%>
						<table border="0"><th style="border-bottom: thin solid;"><font face = "Monospace" size = "5">Grade Distribution</font></th></table>
						<table border="0">
						<tr>
							<th style="border-bottom: thin solid;">A Grades: <%=a_grade%></th>
						</tr>
						<tr>
							<th style="border-bottom: thin solid;">B Grades: <%=b_grade%></th>
						</tr>
						<tr>
							<th style="border-bottom: thin solid;">C Grades: <%=c_grade%></th>
						</tr>
						<tr>
							<th style="border-bottom: thin solid;">D Grades: <%=d_grade%></th>
						</tr>
						<tr>
							<th style="border-bottom: thin solid;">Other: <%=other%></th>
						</tr>
						</table>
							
			<%				
					stempRS.close();
					rs.close();
					//Commit transaction					
					conn.commit();
					conn.setAutoCommit(true);				
				}
			%>

            

            <%-- -------- Close Connection Code -------- --%>
            <%
                    // Close the ResultSet
                    c_rs.close();
					y_rs.close();
					prof_rs.close();
    
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
