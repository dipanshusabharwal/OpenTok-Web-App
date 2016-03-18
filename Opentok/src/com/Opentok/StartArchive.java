package com.Opentok;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import com.opentok.Archive.OutputMode;
import com.opentok.ArchiveProperties;
import com.opentok.OpenTok;

@WebServlet("/StartArchive")

public class StartArchive extends HttpServlet {
	
	private static final long serialVersionUID = 1L;
  
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		//extract values passed through request
		String apiKey = request.getParameter("APIKEY");
		//converting apikey from string to integer
		int apiKeyInt = Integer.parseInt(apiKey);
		String apiSecret = request.getParameter("APISECRET");
		String sessionID = request.getParameter("SESSIONID");
		
		//create opentok object
		OpenTok openTok = new OpenTok(apiKeyInt,apiSecret);
		
		//declarting archive varialbes
		com.opentok.Archive archive = null;
		String archiveID = null;
		
		try {
			
			//starting archive
			archive = openTok.startArchive(sessionID, new ArchiveProperties.Builder().outputMode(OutputMode.INDIVIDUAL).build());	
			
			//fetch archive id
			archiveID = archive.getId();			 
			
		} catch (Exception e) {			
			e.printStackTrace();
		}

		//send response back as archiving has started
		response.getWriter().write(archiveID);
		
	}

}
