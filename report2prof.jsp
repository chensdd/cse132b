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
                    if (action != null && action.equals("choose")) {
						
                        conn.setAutoCommit(false);  

						PreparedStatement empty = conn.prepareStatement("DELETE FROM NOTPOSSIBLE_TEMP");
						empty.executeUpdate();
						conn.commit();						
					
						//get all students who takes this section
						PreparedStatement pstmt = conn.prepareStatement("SELECT DISTINCT STUDENT_ID FROM TAKES WHERE SECTION_ID = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
  
						ResultSet rs = pstmt.executeQuery();			
						%>
						<table border="0"><th><font face = "Arial Black" size = "4">Available Time for Review Session <%= request.getParameter("SECTION_ID")%></font></th></table>
						<%
						//loop for each student who takes this section
						while(rs.next()){
							
							//get all the sections that this student is taking in the corrent quarter
							PreparedStatement stemp = conn.prepareStatement("SELECT MEETING.SECTION_ID, MEETING.CLASS_TYPE, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, START_H, START_AMPM, END_H, END_M, END_AMPM FROM MEETING INNER JOIN TAKES ON TAKES.STUDENT_ID = ? AND MEETING.SECTION_ID = TAKES.SECTION_ID");
						    stemp.setInt(1, rs.getInt("STUDENT_ID"));
							ResultSet stempRS = stemp.executeQuery();
							
							//loop each class
							while (stempRS.next()) {								
								if(stempRS.getString("MONDAY") != null){
									int sh = stempRS.getInt("START_H");
									if(stempRS.getString("START_AMPM").equals("PM") && sh != 12)
										sh = sh + 12;
									
									PreparedStatement query = conn.prepareStatement("INSERT INTO NOTPOSSIBLE_TEMP VALUES (?, ?)");
									query.setString(1, "Mon");
									query.setInt(2, sh);
									query.executeUpdate();
									conn.commit();
								}
								if(stempRS.getString("TUESDAY") != null){
									int sh = stempRS.getInt("START_H");
									if(stempRS.getString("START_AMPM").equals("PM") && sh != 12)
										sh = sh + 12;
									
									PreparedStatement query = conn.prepareStatement("INSERT INTO NOTPOSSIBLE_TEMP VALUES (?, ?)");
									query.setString(1, "Tue");
									query.setInt(2, sh);
									query.executeUpdate();
									conn.commit();
								}
								if(stempRS.getString("WEDNESDAY") != null){
									int sh = stempRS.getInt("START_H");
									if(stempRS.getString("START_AMPM").equals("PM") && sh != 12)
										sh = sh + 12;
									
									PreparedStatement query = conn.prepareStatement("INSERT INTO NOTPOSSIBLE_TEMP VALUES (?, ?)");
									query.setString(1, "Wed");
									query.setInt(2, sh);
									query.executeUpdate();
									conn.commit();
								}
								if(stempRS.getString("THURSDAY") != null){
									int sh = stempRS.getInt("START_H");
									if(stempRS.getString("START_AMPM").equals("PM") && sh != 12)
										sh = sh + 12;
									
									PreparedStatement query = conn.prepareStatement("INSERT INTO NOTPOSSIBLE_TEMP VALUES (?, ?)");
									query.setString(1, "Thu");
									query.setInt(2, sh);
									query.executeUpdate();
									conn.commit();
								}
								if(stempRS.getString("FRIDAY") != null){
									int sh = stempRS.getInt("START_H");
									if(stempRS.getString("START_AMPM").equals("PM") && sh != 12)
										sh = sh + 12;
									
									PreparedStatement query = conn.prepareStatement("INSERT INTO NOTPOSSIBLE_TEMP VALUES (?, ?)");
									query.setString(1, "Fri");
									query.setInt(2, sh);
									query.executeUpdate();
									conn.commit();
								}
							}
							
							PreparedStatement conflict = conn.prepareStatement("SELECT DISTINCT DATE, TIME FROM NOTPOSSIBLE_TEMP");
							ResultSet conflict_rs = conflict.executeQuery();
						%>
						
						<table border="1">
						<%
							while (conflict_rs.next()) {      
						%>
								<tr>
									<td align="middle">
											<input value="<%= conflict_rs.getString("DATE")%>" 
												name="tempSID" size="5" readonly>
									</td>
									<td align="middle">
											<input value="<%= conflict_rs.getInt("TIME") %>" 
												name="tempSECTION_ID" size="2" readonly>
									</td>
								</tr>
						<%
							}
						%>
						</table>
				
				<%		
							stempRS.close();
						}
						rs.close();
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
                        ("SELECT DISTINCT CLASS.COURSE_NUM, SECTION.SECTION_ID FROM CLASS INNER JOIN SECTION ON CLASS.COURSE_NUM = SECTION.COURSE_NUM AND SECTION.YEAR = 2016 AND SECTION.QUARTER = 'Winter'");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Report II Schedule for Review Session</font></th></table>
                <table border="1">
					<form action="report2prof.jsp" method="get">
						<input type="hidden" value="choose" name="action">
					<tr>
						<th>Section ID</th>	
						<th>
							<input type="text" value = "" name="SECTION_ID" size="10">							
						</th>
						
						<th>Time Period</th>	
						<th>
							<select name="startMonth_list">
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
							</select>
							<select name = "startDay_list">
							<%
								for(int i = 1; i < 32; i++){
							%>								
								<option><%=i%></option>
							<%
								}
							%>
							</select>							
						</th>
						<th style="border:thin;"> -- </th>
						<th>
							<select name="endMonth_list">
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
							</select>
							<select name = "endDay_list">
							<%
								for(int i = 1; i < 32; i++){
							%>								
								<option><%=i%></option>
							<%
								}
							%>
							</select>							
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
                        <th>Section ID</th>
						<th>Course Num</th>
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>

						<%-- Get the SSN, which is a number --%>
						<td align="middle">
							<input value="<%= rs.getInt("SECTION_ID") %>" 
								name="SECTION_ID_SHOW" size="10" readonly>
						</td>

						<td align="middle">
							<input value="<%= rs.getString("COURSE_NUM") %>"
								name="COURSE_NUM_SHOW" size="10" style="text-align:center;" readonly>
						</td>

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
