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
<%
	UserDto udto = (UserDto) session.getAttribute("udto"); 
	List<ProjectDto> pdtos = (List<ProjectDto>) session.getAttribute("pdtos");
%>
	 
	 
<div id="container" style="width:50%; height: 100%">

	<div id="header">
	
		<h1 style="margin-bottom:10;">메인 타이틀</h1>
		<img id="profile" src="<%=udto.getuserurl()%>">
		<h2> <%=udto.getUsername() %>님 환영합니다.</h2>
		
	</div>
	
	<div id="sidemenu" style="border:1px solid black; height: 300px; width: 200px; margin-right:2px; float: left;
			padding-left: 10px; overflow:scroll;">
	
		<h3>좌측 사이드 타이틀</h3><br>
		Projects<br>
<%
		for(int i=0; i<pdtos.size(); i++) {
%>
		<a href="Project.ho?command=project_detail&pno=<%=pdtos.get(i).getPno()%>">
			<%=pdtos.get(i).getPname() %></a><br>
<%
		}
%>		
		
		<a href="add_projectform.jsp">+</a><br>
		Friends<br>
		<a href="#">+</a><br>
		
		
	</div>
	
		<div id="content" style="border:1px solid black; height: 300px; width: 480px; float: left;
		padding-left: 10px;">
		</div>
	<div id="footer" style="clear:both;">
		@SEMI-PROJECT
	</div>
</div>

</body>
</html>