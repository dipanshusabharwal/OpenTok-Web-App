package com.Opentok;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.opentok.OpenTok;

@WebServlet("/StopArchive")

public class StopArchive extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//extract values passed through request
		String apiKey = request.getParameter("APIKEY");
		//converting apikey from string to integer
		int apiKeyInt = Integer.parseInt(apiKey);
		String apiSecret = request.getParameter("APISECRET");
		String archiveID = request.getParameter("ARCHIVEID");
		
		//create opentok object
		OpenTok openTok = new OpenTok(apiKeyInt, apiSecret);
		
		try {
			//Stopping archive
			openTok.stopArchive(archiveID);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		//send response back as archiving has been stopped
		response.getWriter().write("Done");
		
	}

}