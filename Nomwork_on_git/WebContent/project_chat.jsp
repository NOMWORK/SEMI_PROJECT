<%@page import="com.nomwork.channels.dto.ChannelDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>    
<%@ page import="com.nomwork.members.dto.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nomwork.projects.dao.*" %>
<%@ page import="com.nomwork.projects.dto.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript">
		var webSocket = new WebSocket("ws://localhost:8787/PROJECT_01/ChatWS");
		var messageTextArea = document.getElementById("messageTextArea");
		webSocket.onopen = function(message) {
			processOpen(message)
		};
		webSocket.onclose = function(message) {
			processClose(message)
		};
		webSocket.onerror = function(message) {
			processError(message)
		};
		webSocket.onmessage = function(message) {
			processMessage(message)
		};

		function processOpen(message) {
			messageTextArea.value += "Server connected...\n";
		}

		function processClose(message) {
			messageTextArea.value += "Server disconnected...\n";
		}

		function processError(message) {
			messageTextArea.value += "Error...\n";
		}

		function processMessage(message) {
			messageTextArea.value += "Recieved From Server... " + message.data
					+ "\n";
		}

		function sendMessage() {
			var message = document.getElementById("textMessage");
			webSocket.send(message.value);
			message.value = "";
		}

		function disconnect() {
			webSocket.close();
		}
	</script>

</head>
<body>
<% 	MembersDto mdto = (MembersDto) session.getAttribute("mdto");
	ProjectsDto pdto = (ProjectsDto)session.getAttribute("pdto");
	List<MembersDto> mdtos = (List<MembersDto>) session.getAttribute("mdtos");
	List<ChannelDto> cdtos = (List<ChannelDto>) session.getAttribute("cdtos");
%>
	 
	 
<div id="container" style="width:50%; height: 100%">

	<div id="header">
	
		<h1 style="margin-bottom:10;"><%=pdto.getPname() %> 타이틀</h1>
		<h2> <%=mdto.getUsername() %>님 환영합니다.</h2>
		
	</div>
	
	<div id="sidemenu" style="border:1px solid black; height: 300px; width: 200px; margin-right:2px; float: left;
			padding-left: 10px; overflow:scroll;">
	
		<h3>좌측 사이드 타이틀</h3><br>
		Channels<br>
<%
		if(cdtos!=null) {
			
			for(int i=0; i<cdtos.size(); i++) {
%>
				<a href="">
				#<%=cdtos.get(i).getCname() %></a><br>

<%				
			}
		}
%>		
		
		<a href="add_channel.jsp">+</a><br>
		Direct Messages<br>
<%
		if(mdtos!=null) {
			
			for(int i=0; i<mdtos.size(); i++) {
%>				

			<a href="">
			#<%=mdtos.get(i).getUsername() %></a><br>
				
<%				
			}
			
		}
%>		
		
		<a href="add_project_userform.jsp">+</a><br>
		
		
	</div>
	
		<div id="content" style="border:1px solid black; height: 300px; width: 480px; float: left;
		padding-left: 10px;">
		
		<h1>채팅하기</h1>
		<br />
			<form>
			<input id="textMessage" type="text"> <input
				onclick="sendMessage()" value="전송" type="button"> <input
				onclick="disconnect()" value="연결끊기" type="button">
			</form>
			<textarea id="messageTextArea" rows="10" cols="50"></textarea>
		</div>
	<div id="footer" style="clear:both;">
		@SEMI-PROJECT
	</div>
</div>

</body>
</html>