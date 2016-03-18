package com.Opentok;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.opentok.OpenTok;
import com.opentok.Role;
import com.opentok.TokenOptions;
import com.opentok.exception.OpenTokException;

@WebServlet("/ExistingSession")
public class ExistingSession extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
       
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		final String JDBC_DRIVER = "com.mysql.jdbc.Driver";  
		final String DB_URL = "jdbc:mysql://localhost/WEBRTC";
		final String USER = "root";
		final String PASS = "Dipanshu02@";
		Connection conn = null;
		Statement stmt = null;
		
		int apiKey = 45501942 ;
		String apiSecret = "c29466810c08b4792114338919be1fd3a9c7b8ba";
		String dbSessionId=null;
		
		OpenTok openTok = new OpenTok(apiKey,apiSecret);
		
		String roomName = request.getParameter("room");
		roomName=roomName.toLowerCase();
		
		try{			
			
		    Class.forName(JDBC_DRIVER);
		    conn = DriverManager.getConnection(DB_URL,USER,PASS);
		    stmt = conn.createStatement();
		    
		    String sql = "SELECT * FROM ROOMID WHERE roomName='"+roomName+"'";
		    
		    ResultSet rs = stmt.executeQuery(sql);
		    		    
    	    while(rs.next()){
		      String room = rs.getString("roomName");
		      dbSessionId = rs.getString("sessionId");
		      System.out.print("Room Name: " + room);
		      System.out.println(", Session: " + dbSessionId);
		      }
    	    	    
    	    System.out.println(", Session: " + dbSessionId);
    	    
    	    if(dbSessionId == null)
    	    {
    	    	    System.out.println("hi");
    		        RequestDispatcher requestDispatcher = request.getRequestDispatcher("/Welcome.jsp");
    	            requestDispatcher.forward(request, response);
    	            return;	
    			    
    	    }

		    rs.close();
		    stmt.close();
		    conn.close();
		 }catch(SQLException se){
		    se.printStackTrace();
		 }catch(Exception e){
		    e.printStackTrace();
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
		
		String token=null;
		
		String roleIsSubscriber = "Subscriber";
		String roleIsPublisher = "Publisher";
		
		String role = request.getParameter("tokenType");
		
		Role roleProperty = null;
		
		if(role.equals(roleIsSubscriber)){
			roleProperty = Role.SUBSCRIBER;
		} else if(role.equals(roleIsPublisher)){
			roleProperty = Role.PUBLISHER;
		}
		
        TokenOptions tokenOpts = new TokenOptions.Builder()
        .role(roleProperty)
        .expireTime((System.currentTimeMillis() / 1000) + (7 * 24 * 60 * 60))
        .build();
	
		try {
			token = openTok.generateToken(dbSessionId, tokenOpts);
		} catch (OpenTokException e) {
			System.out.println("Error in generating token");
			System.out.println(e);
		}
		
		request.setAttribute("APIKEY", apiKey);
		request.setAttribute("APISECRET", apiSecret);
		request.setAttribute("SESSIONID", dbSessionId);
		request.setAttribute("TOKEN", token);
		request.setAttribute("ROLE", role);
		
		request.getRequestDispatcher("/VideoPage.jsp").forward(request,response);
	}
}
