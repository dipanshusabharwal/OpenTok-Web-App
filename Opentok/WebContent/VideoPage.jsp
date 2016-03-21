<%@ page import="com.opentok.OpenTok"%>
<%@ page import="com.opentok.SessionProperties"%>
<%@ page import="com.opentok.MediaMode"%>
<%@ page import="com.opentok.Session"%>
<%@ page import="com.opentok.TokenOptions"%>
<%@ page import="com.opentok.Role"%>
<%@ page import="com.opentok.Archive"%>

<!DOCTYPE html>
<html>

	<head>
		<meta http-equiv = "Content-Type" content = "text/html; charset=ISO-8859-1">
		<title> Video Page </title>
		
		<style>
			button {background-color: pink; padding:5px;}
		</style>

		<script src = "//static.opentok.com/v2/js/opentok.min.js"></script>
		<script src = "jquery-1.11.3.min.js"></script>
	</head>
	
	<body>
	
		<%!
			 String apiKey = "";
			 String apiSecret = "";
			 String sessionID = "";		 
			 String token = "";
			 String role = "";
			 String session = "";
			 String publisher="";
		 %>
		 
		 <% 
			if(request.getAttribute("APIKEY") != null)
				apiKey = request.getAttribute("APIKEY").toString();
		 
			if(request.getAttribute("APISECRET") != null)
				apiSecret =request.getAttribute("APISECRET").toString();
			
			if(request.getAttribute("SESSIONID") != null)
				sessionID =request.getAttribute("SESSIONID").toString();
			
			if(request.getAttribute("TOKEN") != null)
				token =request.getAttribute("TOKEN").toString();
			
			if(request.getAttribute("ROLE") != null)
				role =request.getAttribute("ROLE").toString();
		%>
				
		<p id = "connectionStatusPara"> Connecting......</p>
		<p id = "publisherCountPara"></p>
		<p id = "totalCountPara"></p>
		<form action = "StartArchive" name = "myForm" id = "myForm">
		
			<input type = "hidden" name = "apiKey"    id = "apiKey"    value = "<%=apiKey%>" />
			<input type = "hidden" name = "apiSecret" id = "apiSecret" value = "<%=apiSecret%>" />
			<input type = "hidden" name = "sessionID" id = "sessionID" value = "<%=sessionID%>" />
			<input type = "hidden" name = "role"      id = "role"      value = "<%=role%>" />
			<input type = "hidden" name = "archiveID" id = "archiveID" value = "" />
				
			<button type = "button" name = "disconnect" id = "disconnect" onclick = "this.disabled=true;
																			 	  	functionHandler('<%=apiKey%>','<%=sessionID%>','<%=token%>','<%=apiSecret%>','Disconnect')"disabled>
			 Disconnect
			</button>
			
			<button type = "button" name = "connect" id = "connect" onclick = "this.disabled=true;
																			  functionHandler('<%=apiKey%>','<%=sessionID%>','<%=token%>','<%=apiSecret%>','Connect')"disabled>
			 Connect
			</button>	
			
			<button type = "button" name = "startArchive" id = "startArchive" onclick = "this.disabled=true;
																	                    document.getElementById('publish').disabled=true;
																	   		            document.getElementById('unpublish').disabled=true;
																	   		            document.getElementById('stopArchive').disabled=false;
																	   		            functionHandler('<%=apiKey%>','<%=sessionID%>','<%=token%>','<%=apiSecret%>','StartArchive')"disabled>
			 Start Archive
			</button>
			<button type = "button" name = "stopArchive" id = "stopArchive" onclick = "this.disabled=true;
																			   		  document.getElementById('startArchive').disabled=false;
																			   		  document.getElementById('unpublish').disabled=false;
																			   		  document.getElementById('publish').disabled=true;
																			  		  functionHandler('<%=apiKey%>','<%=sessionID%>','<%=token%>','<%=apiSecret%>','StopArchive')"disabled>
			 Stop Archive
			</button>
			<button type = "button" name = "publish" id = "publish" onclick = "this.disabled=true;
																		  	  functionHandler('<%=apiKey%>','<%=sessionID%>','<%=token%>','<%=apiSecret%>','Publish')" disabled>
			 Start Publish
			</button>
			<button type = "button" name = "unpublish" id = "unpublish" onclick = "this.disabled=true;
																			 	  functionHandler('<%=apiKey%>','<%=sessionID%>','<%=token%>','<%=apiSecret%>','Unpublish')"disabled>
			 Stop Publish
			</button>
			
		</form>
		
		<br> <div id="publisherDiv"></div>
		
		
		<script type="text/javascript">
		
			document.getElementById('disconnect').style.visibility = 'visible';
			
			if('<%=role%>' == "Subscriber"){
				document.getElementById('startArchive').style.visibility = 'hidden';
				document.getElementById('stopArchive').style.visibility  = 'hidden';
				document.getElementById('publish').style.visibility      = 'hidden';
				document.getElementById('unpublish').style.visibility    = 'hidden';
				document.getElementById('connect').style.visibility      = 'hidden';
				var element = document.getElementById("publisherDiv");
				element.parentNode.removeChild(element);
			}
		
			session = OT.initSession(<%=apiKey%>,'<%=sessionID%>');
			
			if('<%=role%>' == "Publisher" || '<%=role%>' == "Moderator" ){
			publisher = OT.initPublisher('publisherDiv');
			document.getElementById('publisherDiv').style.visibility = 'hidden';
			}
		
			session.connect('<%=token%>', function(error) {
			      if (error) {
			        console.log(error.message);
			        console.log("Error in connecting");
			      } else {
			        console.log("Connecting......");
			      }
			    });
			
			session.on({sessionConnected: function(event) {
					console.log("CONNECTED !");
					document.getElementById("connectionStatusPara").innerHTML    = 'Connected to Session';
					document.getElementById('publish').disabled    = false;
					document.getElementById('connect').disabled    = true;
					document.getElementById('disconnect').disabled = false;
					document.getElementById('connect').style.visibility      = 'visible';
					document.getElementById('disconnect').style.visibility   = 'visible';
			      }
			    });
			
			session.on({sessionDisconnected: function(event) {
					console.log("Disconnected");
					connectionCount = 0;
					document.getElementById('publish').disabled = true;
					document.getElementById("connectionStatusPara").innerHTML = 'Disconnected from Session. Click connect to reconnect.'; 
					document.getElementById("totalCountPara").innerHTML = '';
					document.getElementById('connect').style.visibility = 'visible';
					document.getElementById('startArchive').disabled = true;
					document.getElementById('stopArchive').disabled  = true;
					document.getElementById('publish').disabled      = true;
					document.getElementById('unpublish').disabled    = true;
					document.getElementById('connect').disabled      = false;
					document.getElementById('disconnect').disabled   = true;
			      }
			    });

			if('<%=role%>' == "Publisher"||'<%=role%>' == "Moderator"){
				publisher.on('streamCreated', function (event) {
						document.getElementById('publisherDiv').style.visibility = 'visible';
						document.getElementById('startArchive').disabled = false;
					  	document.getElementById('unpublish').disabled    = false;
					  	document.getElementById('stopArchive').disabled  = true;
					  	document.getElementById("connectionStatusPara").innerHTML    = 'Connected to Session and publishing';
						console.log('Started Publishing');
					}); 
				
		      	publisher.on("streamDestroyed", function (event) {
			      document.getElementById('publisherDiv').style.visibility = 'hidden';
				  document.getElementById('publish').disabled      = false;
				  document.getElementById('startArchive').disabled = true;
				  document.getElementById('stopArchive').disabled  = true;
				  document.getElementById("connectionStatusPara").innerHTML    = 'Connected to Session but stopped publishing';
		          event.preventDefault();
		          console.log('Stopped Publishing');
		        });
			}
	        
	      	var connectionCount = 0;
	      	var publisherCount = 0;	      
	      
	      	session.on({
	        connectionCreated: function (event) {
	          if (event.connection.connectionId != session.connection.connectionId) {
	            connectionCount++;
	            console.log('Another client connected. ' + connectionCount + ' total.');
	            document.getElementById("totalCountPara").innerHTML = connectionCount + ' client(s) connected to session';
	          }
	        },
	        connectionDestroyed: function connectionDestroyedHandler(event) {
	          connectionCount--;
	          console.log('A client disconnected. ' + connectionCount + ' total.');
	          document.getElementById("totalCountPara").innerHTML = connectionCount + ' client(s) connected to session';
	        }
	       });
	      	
	        //another client publishes and we subscribe
	        session.on("streamCreated", function (event) {
	          publisherCount++;
	          var subscriber = session.subscribe(event.stream, null, {insertMode: 'APPEND'}); 
	          document.getElementById('startArchive').disabled = false;
	          document.getElementById("publisherCountPara").innerHTML = publisherCount + ' client(s) publishing.';
	        });
	          
	        var destroyElement = null;
	        //other client stops publishing
	        session.on("streamDestroyed", function (event) {
	          console.log("Other client has stopped publishing");
	          publisherCount--;
	    	  document.getElementById('startArchive').disabled = true;
	    	  document.getElementById('stopArchive').disabled  = true;
	    	  document.getElementById("publisherCountPara").innerHTML = publisherCount + ' client(s) publishing.';
	        });
	      
	      
			function functionHandler(apiKey,sessionId,token,apiSecret,actionName){
				
			if(actionName == 'Publish')	{
			   
			   //start publishing
			   session.publish(publisher);
			   
			} else if(actionName == 'Unpublish')	{
				   
				   //stop publishing
				   session.unpublish(publisher);
				   
			 } else if(actionName =='StartArchive')	{	
				 
				 //start archiving
				 $.ajax({
					    url: 'StartArchive?APIKEY='+apiKey+'&APISECRET='+apiSecret+'&SESSIONID='+sessionId,
					    type: 'GET',
					    contentType: 'text/plain',
					    success: function(archiveIds) {
						    document.getElementById("archiveID").value=archiveIds;
					    }
					});
			   } else if(actionName =='StopArchive')	{	
				   
				    //stop archiving 
					var archiveID = document.getElementById("archiveID").value;				
					
					 $.ajax({
						    url: 'StopArchive?&APIKEY='+apiKey+'&APISECRET='+apiSecret+'ARCHIVEID='+archiveID,
						    type: 'GET',
						    contentType: 'text/plain',
						    success: function(data) {
						    }
						});
				} else if(actionName == 'Connect')	{
						document.getElementById("connectionStatusPara").innerHTML    = 'Connecting...';
						session.connect('<%=token%>', function(error) {
						      if (error) {
						        console.log(error.message);
						        console.log("Error in connecting");
						      } else {
						        console.log("Connecting......");
						      }
						    });
					
				} else if(actionName == 'Disconnect')	{
					session.unpublish(publisher);
					session.disconnect();
				}
			 }
			
		</script>
	</body>
</html>