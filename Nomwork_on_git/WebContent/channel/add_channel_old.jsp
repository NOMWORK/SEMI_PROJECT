<%@page import="com.nomwork.channel.dto.ChannelDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>    
<%@ page import="com.nomwork.user.dto.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nomwork.project.dao.*" %>
<%@ page import="com.nomwork.project.dto.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<% 	UserDto udto = (UserDto) session.getAttribute("udto");
	ProjectDto pdto = (ProjectDto)session.getAttribute("pdto");
	List<UserDto> udtos = (List<UserDto>) session.getAttribute("udtos");
	List<ChannelDto> cdtos = (List<ChannelDto>) session.getAttribute("cdtos");
%>
	 
	 
<div id="container" style="width:50%; height: 100%">

	<div id="header">
	
		<h1 style="margin-bottom:10;"><%=pdto.getPname() %> 타이틀</h1>
		<h2> <%=udto.getUsername() %>님 환영합니다.</h2>
		
	</div>
	
	<div id="sidemenu" style="border:1px solid black; height: 300px; width: 200px; margin-right:2px; float: left;
			padding-left: 10px; overflow:scroll;">
	
		<h3>좌측 사이드 타이틀</h3><br>
		channel<br>
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
		if(udtos!=null) {
			
			for(int i=0; i<udtos.size(); i++) {
%>				

			<a href="">
			#<%=udtos.get(i).getUsername() %></a><br>
				
<%				
			}
			
		}
%>		
		
		<a href="add_project_userform.jsp">+</a><br>
		
		
	</div>
	
		<div id="content" style="border:1px solid black; height: 300px; width: 480px; float: left;
		padding-left: 10px;">
		
			<h3>채널 생성</h3><br>
			<form action="channel.ho" method="get">
				<input type="hidden" name="command" value="channel_add" />
				<p>채널 이름 <input type="text" name="cname" required="required" /></p>
				<p>채널 참가자 목록 
				<br>
				
<%
			 	if(udto!=null) {
			 		for(int j=0; j<udtos.size(); j++) {
%>

					<input type="checkbox" name="checked_userno" value="<%=udtos.get(j).getUserno() %>"/>
					<%=udtos.get(j).getUsername()%>님 (<%=udtos.get(j).getUseremail()%>)<br>  

<%
			 		}
			 	}
%>				
				</p><br>
			<input type="submit" value="생성하기">		
			</form>
		
		</div>
	<div id="footer" style="clear:both;">
		@SEMI-PROJECT
	</div>
</div>

</body>
</html>