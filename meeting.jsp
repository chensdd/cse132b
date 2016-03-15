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
                        // INSERT the faculty attributes INTO the FACULTY table.
                        PreparedStatement pstmt = conn.prepareStatement(
                            "INSERT INTO MEETING_TEMP VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
						
						//String checkedValue = "";	
						//String[] days = request.getParameterValues("day_list");
						   //if (days != null) 
							  //for (int i = 0; i < days.length; i++) 
								 //checkedValue = checkedValue + " " + days[i];
						
						String time = request.getParameter("start_h") + ":" + request.getParameter("start_m") + request.getParameter("start_ampm") + " - " + request.getParameter("end_h") + ":" + request.getParameter("end_m") + request.getParameter("end_ampm");
						
						String day = "";
						if(request.getParameter("M") != null)
								day = day + request.getParameter("M");
						if(request.getParameter("Tu") != null){
							if(day == "")
								day = day + request.getParameter("Tu");
							else
								day = day + " " + request.getParameter("Tu");
						}
						if(request.getParameter("W") != null){
							if(day == "")
								day = day + request.getParameter("W");
							else
								day = day + " " + request.getParameter("W");
						}
						if(request.getParameter("Th") != null){
							if(day == "")
								day = day + request.getParameter("Th");
							else
								day = day + " " + request.getParameter("Th");
						}
						if(request.getParameter("F") != null){
							if(day == "")
								day = day + request.getParameter("F");
							else
								day = day + " " + request.getParameter("F");
						}
						
                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
                        pstmt.setString(2, request.getParameter("BUILDING"));
                        pstmt.setString(3, request.getParameter("ROOM"));
                        pstmt.setString(4, time);
                        pstmt.setString(5, day);
                        pstmt.setString(6, request.getParameter("m_list"));
						pstmt.setString(7, request.getParameter("type_list"));
						
						pstmt.setString(8, request.getParameter("M"));
						pstmt.setString(9, request.getParameter("Tu"));
						pstmt.setString(10, request.getParameter("W"));
						pstmt.setString(11, request.getParameter("Th"));
						pstmt.setString(12, request.getParameter("F"));
						
						int sh = Integer.parseInt(request.getParameter("start_h"));
						int eh = Integer.parseInt(request.getParameter("end_h"));
						String shampm = request.getParameter("start_ampm");
						String ehampm = request.getParameter("end_ampm");
						if(shampm.equals("PM") && sh != 12)
							sh = sh + 12;
						if(ehampm.equals("PM") && eh != 12)
							eh = eh + 12;
						pstmt.setInt(13, sh);
						pstmt.setInt(14, Integer.parseInt(request.getParameter("start_m")));
						pstmt.setString(15, request.getParameter("start_ampm"));
						pstmt.setInt(16, eh);
						pstmt.setInt(17, Integer.parseInt(request.getParameter("end_m")));
						pstmt.setString(18, request.getParameter("end_ampm"));
						
						pstmt.setInt(19, Integer.parseInt(request.getParameter("startMonth_list")));
						pstmt.setInt(20, Integer.parseInt(request.getParameter("startDay_list")));
						pstmt.setInt(21, Integer.parseInt(request.getParameter("endMonth_list")));
						pstmt.setInt(22, Integer.parseInt(request.getParameter("endDay_list")));
						
						String classType = request.getParameter("classType_list");
						int secID = Integer.parseInt(request.getParameter("SECTION_ID"));
						PreparedStatement cntQuery = conn.prepareStatement("SELECT COUNT(SECTION_ID) FROM MEETING WHERE SECTION_ID = ? AND CLASS_TYPE LIKE ?");
						cntQuery.setInt(1, secID);
						cntQuery.setString(2, classType+"%");
						ResultSet cntRs = cntQuery.executeQuery();
						int cnt = 0;
						if(cntRs.next())
							cnt = cntRs.getInt(1);
						cnt = cnt + 1;
						classType = classType + "" + cnt;
						pstmt.setString(23, classType);
						
						String fname = "";
						PreparedStatement fQuery = conn.prepareStatement("SELECT DISTINCT FACULTY_NAME FROM SECTION WHERE SECTION.SECTION_ID = ?");
						fQuery.setInt(1, secID);
						ResultSet fRs = fQuery.executeQuery();
						if(fRs.next())
							fname = fRs.getString(1);
						pstmt.setString(24, fname);
					
                        int rowCount = pstmt.executeUpdate();

                        //Commit transaction
                        conn.commit();
                        conn.setAutoCommit(true);
                    }
            %>
			
			            <%-- -------- UPDATE Code -------- --%>
            <%
                    // Check if an update is requested
                    if (action != null && action.equals("update")) {

                        //Begin transaction
                        conn.setAutoCommit(false);
                                             
						int smth = 0;
						PreparedStatement mq = conn.prepareStatement("SELECT M_INT FROM CALENDER_MONTH WHERE M_STRING = ?");
						mq.setString(1, request.getParameter("START_MONTH"));
						ResultSet mRs = mq.executeQuery();
						if(mRs.next())
							smth = mRs.getInt(1);
						int emth = 0;
						mq = conn.prepareStatement("SELECT M_INT FROM CALENDER_MONTH WHERE M_STRING = ?");
						mq.setString(1, request.getParameter("END_MONTH"));
						mRs = mq.executeQuery();
						if(mRs.next())
							emth = mRs.getInt(1);
						
                        PreparedStatement pstmt = conn.prepareStatement(
                            "UPDATE MEETING SET MANDATORY = ?, TYPE = ?, START_MONTH = ?, START_DAY = ?, END_MONTH = ?, END_DAY = ? WHERE SECTION_ID = ? AND BUILDING = ? AND ROOM = ? AND TIME = ? ");
						//out.println(emth);

                        pstmt.setString(1, request.getParameter("MANDATORY"));
                        pstmt.setString(2, request.getParameter("TYPE"));   
						pstmt.setInt(3, smth);  
						pstmt.setInt(4, Integer.parseInt(request.getParameter("START_DAY")));  
						pstmt.setInt(5, emth);  
						pstmt.setInt(6, Integer.parseInt(request.getParameter("END_DAY")));  
                        pstmt.setInt(7, Integer.parseInt(request.getParameter("SECTION_ID")));
						pstmt.setString(8, request.getParameter("BUILDING"));
                        pstmt.setString(9, request.getParameter("ROOM"));
						pstmt.setString(10, request.getParameter("TIME"));
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
                            "DELETE FROM MEETING WHERE SECTION_ID = ? AND CLASS_TYPE = ?");

                        pstmt.setInt(1, Integer.parseInt(request.getParameter("SECTION_ID")));
						pstmt.setString(2, request.getParameter("CLASS_TYPE"));
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
                        ("SELECT * FROM MEETING");
            %>

            <!-- Add an HTML table header row to format the results -->
			<table border="0"><th><font face = "Arial Black" size = "6">Meetings</font></th></table>
                <table border="1">
                    <tr>
                        <th>Section ID</th>
						<th>Class Type</th>
                        <th>Building</th>
						<th>Room</th>
						<th colspan="4">Start Time</th>
						<th colspan="4">End Time</th>
						<th colspan="5">Day</th>
						<th>Mandatory</th>
						<th>Type</th>
						<th colspan="2">Start Date</th>
						<th colspan="2">End Date</th>
                        <th>Action</th>
                    </tr>
                    <tr>
                        <form action="meeting.jsp" method="get">
                            <input type="hidden" value="insert" name="action">
                            <th><input value = "" name="SECTION_ID" size="10"></th>
							<th><name="CLASS_TYPE" size="5">
							<select name = "classType_list">
							<option>LEC</option>
							<option>DIS</option>
							<option>LAB</option>
							<option>REV</option>
							</select></th>
							</th>
                            <th><input value = "" name="BUILDING" size="15"></th>
							<th><input value = "" name="ROOM" size="10"></th>
							
							<th style="border:thin; border-left: thin solid;"><select name = "start_h">
							<%
								int hr = 1;
								while(hr < 13){
							%>								
								<option><%=hr%></option>
							<%
								hr++;}
							%>
							</select></th>
							<th style="border:thin">:</th>
							<th style="border:thin"><select name = "start_m">
								<option>00</option>
							<%
								int min = 10;
								while(min < 60){
							%>								
								<option><%=min%></option>
							<%
								min = min + 10;}
							%>
							</select></th>
							<th style="border:thin; border-right: thin solid;"><select name = "start_ampm">
							<option>AM</option>
							<option>PM</option>
							</select></th>
							<th style="border:thin; border-left: thin solid;"><select name = "end_h">
							<%
								hr = 1;
								while(hr < 13){
							%>								
								<option><%=hr%></option>
							<%
								hr++;}
							%>
							</select></th>
							<th style="border:thin">:</th>
							<th style="border:thin"><select name = "end_m">
								<option>00</option>
							<%
								min = 10;
								while(min < 60){
							%>								
								<option><%=min%></option>
							<%
								min = min + 10;}
							%>
							</select></th>
							<th style="border:thin; border-right: thin solid;"><select name = "end_ampm">
							<option>AM</option>
							<option>PM</option>
							</th>
							
							<th style="border:thin; border-left: thin solid;"><input class="messageCheckbox" type = "checkbox" name="M" value="M">M</th>
							<th style="border:thin"><input class="messageCheckbox" type = "checkbox" name="Tu" value="Tu">Tu</th>
							<th style="border:thin"><input class="messageCheckbox" type = "checkbox" name="W" value="W">W</th>
							<th style="border:thin"><input class="messageCheckbox" type = "checkbox" name="Th" value="Th">Th</th>
							<th style="border:thin; border-right: thin solid;"><input class="messageCheckbox" type = "checkbox" name="F" value="F">F</th>
							
							<th><name="MANDATORY" size="5">
							<select name = "m_list">
							  <option value="Yes">Yes</option>
							  <option value="no">No</option>
							</select></th>
							<th><name="TYPE" size="10">
							<select name = "type_list">
							  <option value="Weekly">Weekly</option>
							  <option value="One Time">One Time</option>
							</select></th>
														
							<th style="border:thin; border-left: thin solid;"><select name="startMonth_list">
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
								<option value="04">April</option>
								<option value="05">May</option>
								<option value="06">June</option>
								<option value="07">July</option>
								<option value="08">August</option>
								<option value="09">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select></th>
							<th style="border:thin; border-right: thin solid;"><select name = "startDay_list">
							<%
								for(int i = 1; i < 32; i++){
							%>								
								<option><%=i%></option>
							<%
								}
							%>
							</select></th>
							<th style="border:thin; border-left: thin solid;"><select name="endMonth_list">
								<option value="01">January</option>
								<option value="02">February</option>
								<option value="03">March</option>
								<option value="04">April</option>
								<option value="05">May</option>
								<option value="06">June</option>
								<option value="07">July</option>
								<option value="08">August</option>
								<option value="09">September</option>
								<option value="10">October</option>
								<option value="11">November</option>
								<option value="12">December</option>
							</select></th>
							<th style="border:thin; border-right: thin solid;"><select name = "endDay_list">
							<%
								for(int i = 1; i < 32; i++){
							%>								
								<option><%=i%></option>
							<%
								}
							%>
							</select></th>
							
							<th><input type="submit" value="Insert"></th>
                        </form>
                    </tr>				

            <%-- -------- Iteration Code -------- --%>
            <%
                    // Iterate over the ResultSet        
                    while ( rs.next() ) {      
            %>
                    <tr>
                        <form action="meeting.jsp" method="get">
                            <input type="hidden" value="update" name="action">

                            <%-- Get the UNDERGRAD_ID, which is a number --%>
                            <td align="middle">
                                <input value="<%= rs.getInt("SECTION_ID") %>" 
                                    name="SECTION_ID" size="10" readonly>
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("CLASS_TYPE") %>" 
                                    name="CLASS_TYPE" size="5" style="text-align:center;" readonly>
                            </td>

                            <td align="middle">
                                <input value="<%= rs.getString("BUILDING") %>" 
                                    name="BUILDING" size="15">
                            </td>
    
							<td align="middle">
                                <input value="<%= rs.getString("ROOM") %>" 
                                    name="ROOM" size="10">
                            </td>
							
							<td align="middle" colspan="8">
                                <input value="<%= rs.getString("TIME") %>" 
                                    name="TIME" size="40" style="text-align:center;" readonly>
                            </td>						
							
							<td align="middle" colspan="5">
                                <input value="<%= rs.getString("DAY") %>" 
                                    name="DAY" size="15" style="text-align:center;">
                            </td>							
							
							<td align="middle">
                                <input value="<%= rs.getString("MANDATORY") %>" 
                                    name="MANDATORY" size="6" style="text-align:center;">
                            </td>
							
							<td align="middle">
                                <input value="<%= rs.getString("TYPE") %>" 
                                    name="TYPE" size="8" style="text-align:center;">
                            </td>
							
							<td align="middle">
							<% 
								String s_mth = "";
								PreparedStatement mq = conn.prepareStatement("SELECT M_STRING FROM CALENDER_MONTH WHERE M_INT = ?");
								mq.setInt(1, rs.getInt("START_MONTH"));
								ResultSet mRs = mq.executeQuery();
								if(mRs.next())
									s_mth = mRs.getString(1);
							%>
                                <input value="<%= s_mth%>" 
                                    name="START_MONTH" size="10" style="text-align:center;">
                            </td>
							<td align="middle">
                                <input value="<%= rs.getInt("START_DAY")%>" 
                                    name="START_DAY" size="2" style="text-align:center;">
                            </td>
							
							<td align="middle">
							<% 
								String e_mth = "";
								mq = conn.prepareStatement("SELECT M_STRING FROM CALENDER_MONTH WHERE M_INT = ?");
								mq.setInt(1, rs.getInt("END_MONTH"));
								mRs = mq.executeQuery();
								if(mRs.next())
									e_mth = mRs.getString(1);
							%>
                                <input value="<%= e_mth%>" 
                                    name="END_MONTH" size="10" style="text-align:center;">
                            </td>
							<td align="middle">
                                <input value="<%= rs.getInt("END_DAY")%>" 
                                    name="END_DAY" size="2" style="text-align:center;">
                            </td>
							
							<%-- Button --%>
                            <td>
                                <input type="submit" value="Update">
                            </td>
                        </form>
                        <form action="meeting.jsp" method="get">
                            <input type="hidden" value="delete" name="action">
                            <input type="hidden" value="<%= rs.getString("SECTION_ID") %>" name="SECTION_ID">
							<input type="hidden" value="<%= rs.getString("CLASS_TYPE") %>" name="CLASS_TYPE">
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
