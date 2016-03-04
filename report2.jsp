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

						PreparedStatement empty = conn.prepareStatement("DELETE FROM S_TEMP");
						empty.executeUpdate();
						conn.commit();						
					
						int id = Integer.parseInt(request.getParameter("ID"));
							
						//get Section_ID and Class_type from TAKES table for that particular student
						PreparedStatement pstmt = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE FROM TAKES WHERE STUDENT_ID = ?");
						pstmt.setInt(1, id);
						ResultSet rs = pstmt.executeQuery();
						%>
						<table border="0"><th><font face = "Monospace" size = "6">STUDENT <%= request.getParameter("ID")%> conflits with the following sections</font></th></table>
						<%
						//get each section info from MEETING table
						while(rs.next()){
							//get all the sections that this student is taking in the corrent quarter
							PreparedStatement stemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, START_H, START_M, START_AMPM, END_H, END_M, END_AMPM FROM MEETING WHERE SECTION_ID = ? AND CLASS_TYPE = ?");
						    stemp.setInt(1, rs.getInt("SECTION_ID"));
							stemp.setString(2, rs.getString("CLASS_TYPE"));
							ResultSet stempRS = stemp.executeQuery();
							
							int secID = rs.getInt("SECTION_ID");
							//loop through each class that the student is taking in the corrent quarter
							while (stempRS.next()) { 
								//get the start hour and end hour; if PM then add 12
								int sh = stempRS.getInt("START_H");
								int eh = stempRS.getInt("END_H");
								int sm = stempRS.getInt("START_M");
								int em = stempRS.getInt("END_M");
								if(stempRS.getString("START_AMPM").equals("PM") && sh != 12)
									sh = sh + 12;
								if(stempRS.getString("END_AMPM").equals("PM") && eh != 12)
									eh = eh + 12;
								
								//check day by day
								if(stempRS.getString("MONDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_M, START_AMPM, END_H, END_M, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND MONDAY = 'M'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										int check_sm = dayQ_rs.getInt("START_M");
										int check_em = dayQ_rs.getInt("END_M");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										//start ends exactly as mine
										//ends before mine
										//start after mine
										//start before mine and ends after mine
										if(check_sh == sh && check_sm == sm && check_eh == eh && check_em == em){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_eh <= eh) && ((check_eh > sh) || (check_eh == sh && check_em > sm))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();											
										}
										else if((check_sh >= sh) && ((check_sh < eh) || (check_sh == eh && check_sm < em))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_sh < sh) || (check_sh == sh && check_sm < sm)){
											if((check_eh > eh) || (check_eh == eh && check_em > em)){
												//conflict
												PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
												query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
												query.executeUpdate();
												conn.commit();
											}
										}										
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("TUESDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_M, START_AMPM, END_H, END_M, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND TUESDAY = 'Tu'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										int check_sm = dayQ_rs.getInt("START_M");
										int check_em = dayQ_rs.getInt("END_M");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										//start ends exactly as mine
										//ends before mine
										//start after mine
										//start before mine and ends after mine
										if(check_sh == sh && check_sm == sm && check_eh == eh && check_em == em){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_eh <= eh) && ((check_eh > sh) || (check_eh == sh && check_em > sm))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();											
										}
										else if((check_sh >= sh) && ((check_sh < eh) || (check_sh == eh && check_sm < em))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_sh < sh) || (check_sh == sh && check_sm < sm)){
											if((check_eh > eh) || (check_eh == eh && check_em > em)){
												//conflict
												PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
												query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
												query.executeUpdate();
												conn.commit();
											}
										}																				
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("WEDNESDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_M, START_AMPM, END_H, END_M, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND WEDNESDAY = 'W'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										int check_sm = dayQ_rs.getInt("START_M");
										int check_em = dayQ_rs.getInt("END_M");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										//check whether time conflicts, add the conflits ones to the s_temp table
										//start ends exactly as mine
										//ends before mine
										//start after mine
										//start before mine and ends after mine
										if(check_sh == sh && check_sm == sm && check_eh == eh && check_em == em){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_eh <= eh) && ((check_eh > sh) || (check_eh == sh && check_em > sm))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();											
										}
										else if((check_sh >= sh) && ((check_sh < eh) || (check_sh == eh && check_sm < em))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_sh < sh) || (check_sh == sh && check_sm < sm)){
											if((check_eh > eh) || (check_eh == eh && check_em > em)){
												//conflict
												PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
												query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
												query.executeUpdate();
												conn.commit();
											}
										}											
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("THURSDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_M, START_AMPM, END_H, END_M, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND THURSDAY = 'Th'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										int check_sm = dayQ_rs.getInt("START_M");
										int check_em = dayQ_rs.getInt("END_M");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										//start ends exactly as mine
										//ends before mine
										//start after mine
										//start before mine and ends after mine
										if(check_sh == sh && check_sm == sm && check_eh == eh && check_em == em){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_eh <= eh) && ((check_eh > sh) || (check_eh == sh && check_em > sm))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();											
										}
										else if((check_sh >= sh) && ((check_sh < eh) || (check_sh == eh && check_sm < em))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_sh < sh) || (check_sh == sh && check_sm < sm)){
											if((check_eh > eh) || (check_eh == eh && check_em > em)){
												//conflict
												PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
												query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
												query.executeUpdate();
												conn.commit();
											}
										}											
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("FRIDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_M, START_AMPM, END_H, END_M, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND FRIDAY = 'F'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										int check_sm = dayQ_rs.getInt("START_M");
										int check_em = dayQ_rs.getInt("END_M");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										//start ends exactly as mine
										//ends before mine
										//start after mine
										//start before mine and ends after mine
										if(check_sh == sh && check_sm == sm && check_eh == eh && check_em == em){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_eh <= eh) && ((check_eh > sh) || (check_eh == sh && check_em > sm))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();											
										}
										else if((check_sh >= sh) && ((check_sh < eh) || (check_sh == eh && check_sm < em))){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();										
										}
										else if((check_sh < sh) || (check_sh == sh && check_sm < sm)){
											if((check_eh > eh) || (check_eh == eh && check_em > em)){
												//conflict
												PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
												query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
												query.executeUpdate();
												conn.commit();
											}
										}										
									}
									dayQ_rs.close();
								}
							}
							

							PreparedStatement conflict = conn.prepareStatement("SELECT DISTINCT CLASS.COURSE_NUM, CLASS.TITLE, S_TEMP.SECTION_ID FROM CLASS INNER JOIN (SECTION INNER JOIN S_TEMP ON SECTION.SECTION_ID = S_TEMP.SECTION_ID) ON CLASS.COURSE_NUM = SECTION.COURSE_NUM");
							ResultSet conflict_rs = conflict.executeQuery();
						%>
						
						<table border="0">
						<%
							while (conflict_rs.next()) {      
						%>
								<tr style="border-bottom: thin solid;">
									<td align="middle">
											<input value="<%= conflict_rs.getInt("SECTION_ID") %>" 
												name="tempSECTION_ID" size="2" readonly>
									</td>
									<td align="middle">
											<input value="<%= conflict_rs.getString("COURSE_NUM") %>" 
												name="tempCOURSE_NUM" size="10" readonly>
									</td>
									<td align="middle">
											<input value="<%= conflict_rs.getString("TITLE") %>" 
												name="tempTITLE" size="30" readonly>
									</td>
								</tr>
						<%
							}
						%>
						</table>
				
				<%		
							conflict_rs.close();
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
                        ("SELECT DISTINCT STUDENT.ID, STUDENT.FIRSTNAME, STUDENT.MIDDLENAME, STUDENT.LASTNAME FROM STUDENT INNER JOIN TAKES ON STUDENT.ID = TAKES.STUDENT_ID");
						
					Statement statement2 = conn.createStatement();	
					ResultSet students = statement2.executeQuery("SELECT DISTINCT S.ID AS ID, S.FIRSTNAME AS FIRSTNAME, S.MIDDLENAME AS MIDDLENAME, S.LASTNAME AS LASTNAME FROM STUDENT S, TAKES T WHERE S.ENROLL = 'Yes' AND S.ID = T.STUDENT_ID");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Report II Currently Enrolled Students</font></th></table>
                <table border="1">
					<form action="report2.jsp" method="get">
						<input type="hidden" value="choose" name="action">
					<tr>
						<th>Student ID</th>	
						<th><name="ID" size="20">
                            <select name = "ID">
                                <% 
                                    while ( students.next() ){
                                %>
                                     <option value=<%= students.getString("ID") %>><%= students.getString("ID") %> | <%= students.getString("FIRSTNAME") %>, <%= students.getString("MIDDLENAME") %>, <%= students.getString("LASTNAME") %></option>
                                <%
                                    }
                                %>
                                 
							</select>
						</th>										

					    <%-- Button --%>
                            <td>
                                <input type="submit" name="choose" value="Select">
                            </td>
					</form>
					</tr>
				</table>
				<table border="1">	
                    <tr>
                        <th>Student ID</th>
						<th>First Name</th>
						<th>Middle Name</th>
                        <th>Last Name</th>
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>

						<%-- Get the ID, which is a number --%>
						<td align="middle">
							<input value="<%= rs.getInt("ID") %>" 
								name="S_ID" size="10" readonly>
						</td>


						<%-- Get the FIRSTNAME --%>
						<td align="middle">
							<input value="<%= rs.getString("FIRSTNAME") %>"
								name="FIRSTNAME" size="15" style="text-align:center;" readonly>
						</td>

						<%-- Get the MIDDLENAME --%>
						<td align="middle">
							<input value="<%= rs.getString("MIDDLENAME") %>" 
								name="MIDDLENAME" size="15" style="text-align:center;" readonly>
						</td>

						<%-- Get the LASTNAME --%>
						<td align="middle">
							<input value="<%= rs.getString("LASTNAME") %>" 
								name="LASTNAME" size="15" style="text-align:center;" readonly>
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
