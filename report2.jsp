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
					
						PreparedStatement pstmt = conn.prepareStatement("SELECT ID FROM STUDENT WHERE SSN = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_NUM")));
  
						ResultSet rs = pstmt.executeQuery();
                        
						//get student ID
						int id = 0;
						if(rs.next())
							id = rs.getInt(1);
						
						//get Section_ID and Class_type from TAKES table for that particular student
						pstmt = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE FROM TAKES WHERE STUDENT_ID = ?");
						pstmt.setInt(1, Integer.parseInt(request.getParameter("SSN_NUM")));
						rs = pstmt.executeQuery();
						%>
						<table border="0"><th><font face = "Arial Black" size = "4">STUDENT <%= request.getParameter("SSN_NUM")%> conflits with the following sections</font></th></table>
						<%
						//get each section info from MEETING table
						while(rs.next()){
							//get all the sections that this student is taking in the corrent quarter
							PreparedStatement stemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, MONDAY, TUESDAY, WEDNESDAY, THURSDAY, FRIDAY, START_H, START_AMPM, END_H, END_AMPM FROM MEETING WHERE SECTION_ID = ? AND CLASS_TYPE = ?");
						    stemp.setInt(1, rs.getInt("SECTION_ID"));
							stemp.setString(2, rs.getString("CLASS_TYPE"));
							ResultSet stempRS = stemp.executeQuery();
							
							int secID = rs.getInt("SECTION_ID");
							//loop through each class that the student is taking in the corrent quarter
							while (stempRS.next()) { 
								//get the start hour and end hour; if PM then add 12
								int sh = stempRS.getInt("START_H");
								int eh = stempRS.getInt("END_H");
								if(stempRS.getString("START_AMPM").equals("PM") && sh != 12)
									sh = sh + 12;
								if(stempRS.getString("END_AMPM").equals("PM") && eh != 12)
									eh = eh + 12;
								
								//check day by day
								if(stempRS.getString("MONDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_AMPM, END_H, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND MONDAY = 'M'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										if(sh >= check_sh && sh < check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}
										else if(eh > check_sh && eh <= check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}										
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("TUESDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_AMPM, END_H, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND TUESDAY = 'Tu'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										if(sh >= check_sh && sh < check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}
										else if(eh > check_sh && eh <= check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}										
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("WEDNESDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_AMPM, END_H, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND WEDNESDAY = 'W'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										if(sh >= check_sh && sh < check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}
										else if(eh > check_sh && eh <= check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}										
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("THURSDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_AMPM, END_H, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND THURSDAY = 'Tu'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										if(sh >= check_sh && sh < check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}
										else if(eh > check_sh && eh <= check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}										
									}
									dayQ_rs.close();
								}
								if(stempRS.getString("FRIDAY") != null){
									PreparedStatement dayTemp = conn.prepareStatement("SELECT SECTION_ID, CLASS_TYPE, START_H, START_AMPM, END_H, END_AMPM FROM MEETING WHERE SECTION_ID <> ? AND FRIDAY = 'F'");
									dayTemp.setInt(1, secID);
									ResultSet dayQ_rs = dayTemp.executeQuery();
									
									//loop through all courses offered in the day specified
									while(dayQ_rs.next()){										
										//get the start hour and end hour; if PM then add 12
										int check_sh = dayQ_rs.getInt("START_H");
										int check_eh = dayQ_rs.getInt("END_H");
										if(dayQ_rs.getString("START_AMPM").equals("PM") && check_sh != 12)
											check_sh = check_sh + 12;
										if(dayQ_rs.getString("END_AMPM").equals("PM") && check_eh != 12)
											check_eh = check_eh + 12;
										
										//check whether time conflicts, add the conflits ones to the s_temp table
										if(sh >= check_sh && sh < check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}
										else if(eh > check_sh && eh <= check_eh){
											//conflict
											PreparedStatement query = conn.prepareStatement("INSERT INTO S_TEMP VALUES (?)");
											query.setInt(1, dayQ_rs.getInt("SECTION_ID"));
											query.executeUpdate();
											conn.commit();
										}										
									}
									dayQ_rs.close();
								}
							}
							

							PreparedStatement conflict = conn.prepareStatement("SELECT DISTINCT CLASS.COURSE_NUM, CLASS.TITLE, S_TEMP.SECTION_ID FROM CLASS INNER JOIN (SECTION INNER JOIN S_TEMP ON SECTION.SECTION_ID = S_TEMP.SECTION_ID) ON CLASS.COURSE_NUM = SECTION.COURSE_NUM");
							ResultSet conflict_rs = conflict.executeQuery();
						%>
						
						<table border="1">
						<%
							while (conflict_rs.next()) {      
						%>
								<tr>
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
                        ("SELECT DISTINCT STUDENT.SSN, STUDENT.FIRSTNAME, STUDENT.MIDDLENAME, STUDENT.LASTNAME FROM STUDENT INNER JOIN TAKES ON STUDENT.ID = TAKES.STUDENT_ID");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Report II Currently Enrolled Students</font></th></table>
                <table border="1">
					<form action="report2.jsp" method="get">
						<input type="hidden" value="choose" name="action">
					<tr>
						<th>Student SSN</th>	
						<th>
							<input type="text" value = "" name="SSN_NUM" size="10">							
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
                        <th>Student SSN</th>
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

						<%-- Get the SSN, which is a number --%>
						<td align="middle">
							<input value="<%= rs.getInt("SSN") %>" 
								name="SSN" size="10" readonly>
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
