<html>

<head>
	<title> Welcome to OpenTok </title>
	
	<style>
	h1 {background-color: green; padding:15px;}
	div {background-color: lightblue;}
	form {background-color: lightblue; padding:15px;}
	button {background-color: pink; padding:5px;}
	</style>

</head>

<body>
	<h1> Welcome to WebRTC Application </h1>
	
	<script type = "text/javascript">

	 function checkTextField(field) {
	     if (field.value == '') {
	         alert("Room name cannot be empty");
		     document.getElementById('existingBTN').disabled = true;
		     document.getElementById('createBTN').disabled   = true;
	     }
	     else{
	    	document.getElementById('existingBTN').disabled = false;
	    	document.getElementById('createBTN').disabled   = false;
	     }
	 }
	 
	</script>
	
	<button type = "button" name = "btn1" id = "existingSession" onclick = "this.disabled=true; document.getElementById('createSession').disabled=false; document.getElementById('existingSessionDiv').hidden=false; document.getElementById('createSessionDiv').hidden=true;"> Enter existing room </button>
	<button type = "button" name = "btn2" id = "createSession" onclick = "this.disabled=true; document.getElementById('existingSession').disabled=false; document.getElementById('existingSessionDiv').hidden=true; document.getElementById('createSessionDiv').hidden=false;"> Create new room </button>

	<div id = "existingSessionDiv" hidden = "true">

	   <form action="ExistingSession">
	    Enter the room name: <input type = "text" name = "room" onblur = "checkTextField(this);"> 
	    <input type = "submit" name = "enter" id = "existingBTN" value = "Enter" disabled> <br>
	    Join as: <select name = "tokenType">
  				 	<option value = "Subscriber" selected> Subscriber </option>
  				 	<option value = "Publisher"> Publisher </option>
				 </select>
	   </form>
    </div>
    
    <div id="createSessionDiv" hidden="true">
       	<form action="CreateSession">
       	 Enter the room name: <input type = "text" name = "room" onblur = "checkTextField(this);">
		 <input type = "submit" name = "create" id = "createBTN" value = "Create" disabled>
	    </form>
    </div>
    
</body>
</html>