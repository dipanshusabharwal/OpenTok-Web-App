package com.Opentok;

import java.io.IOException;
import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import com.opentok.MediaMode;
import com.opentok.OpenTok;
import com.opentok.Role;
import com.opentok.Session;
import com.opentok.SessionProperties;
import com.opentok.TokenOptions;
import com.opentok.exception.OpenTokException;

@WebServlet("/CreateSession")

public class CreateSession extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
 
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//database related variables
		final String jdbcDriver = "com.mysql.jdbc.Driver";  
		final String dbURL = "jdbc:mysql://localhost/WEBRTC";
		final String dbUsername = "root";
		final String dbPassword = "Dipanshu02@";
		Connection conn=null;
		Statement stmt=null;
		
		//getting room name entered at welcomepage.jsp and converting it lower case
		String roomName = request.getParameter("room");
		roomName=roomName.toLowerCase();
		   
		//creating opentok object using apikey and apisecret
		int apiKey = 45502132 ;
		String apiSecret = "5dd0e518687ab329f83e3ea978bf3677dad9d905";		
		OpenTok openTok = new OpenTok(apiKey,apiSecret);
	
		//session related variables
		Session routedSession = null;
		String sessionID = null;
		String role = "Moderator";
		
		//creating a routed session and obtaining its sessionid
		try {
			routedSession = openTok.createSession(new SessionProperties.Builder().mediaMode(MediaMode.ROUTED).build());
			sessionID = routedSession.getSessionId();
		} catch (Exception e) {
			System.out.println("Error in creating session");
			System.out.println(e);
		}
		
		//connecting to database and saving sessionid with its corresponding room name
		try{			
			//connecting to database
		    Class.forName(jdbcDriver);
		    conn = DriverManager.getConnection(dbURL,dbUsername,dbPassword);
		    stmt = conn.createStatement();
		    
		    String sql;
		    
		    //sql query to insert newly created session details into databse
		    sql = "INSERT INTO ROOMID VALUES('"+roomName+"','"+sessionID+"')";
		    stmt.executeUpdate(sql);
		    
		    sql = "SELECT * FROM ROOMID";
		    
		    //fetching data from database into result set
		    ResultSet rs = stmt.executeQuery(sql);

		    while(rs.next()){
		       //String room = rs.getString("roomName");
		       //String session = rs.getString("sessionId");
		      }

		    rs.close();
		    stmt.close();
		    conn.close();
		    
		 }catch(Exception e){
			 
		    e.printStackTrace();
    
		    RequestDispatcher requestDispatcher = request.getRequestDispatcher("/Welcome.jsp");
            requestDispatcher.forward(request, response);
            return;
            
		 }finally{
		    try{
		       if(stmt!=null)
		          stmt.close();
		    }catch(SQLException se2){
		    }
		    try{
		       if(conn!=null)
		          conn.close();
		    }catch(SQLException se){
		       se.printStackTrace();
		    }
		 }

		//token related variables
		String token=null;
				
		//generating token
		try {
			token = routedSession.generateToken(new TokenOptions.Builder().role(Role.MODERATOR).expireTime((System.currentTimeMillis() / 1000L) + (7 * 24 * 60 * 60)).data("Name=Dipanshu").build());
		} catch (OpenTokException e) {
			System.out.println("Error in generating token");
			System.out.println(e);
		}
				
		//settting data to forward it to another page - videopage.jsp
		request.setAttribute("APIKEY", apiKey);
		request.setAttribute("APISECRET", apiSecret);
		request.setAttribute("SESSIONID", sessionID);
		request.setAttribute("TOKEN", token);
		request.setAttribute("ROLE", role);
		
		request.getRequestDispatcher("/VideoPage.jsp").forward(request,response);
	}
}