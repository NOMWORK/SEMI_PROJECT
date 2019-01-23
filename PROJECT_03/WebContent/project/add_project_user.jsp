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

<script type="text/javascript">

	function search_user() {
		window.open("search_user.jsp","","width=400, height=300");
	}

</script>

</head>
<body>
<%
	UserDto udto = (UserDto) session.getAttribute("udto");
	ProjectDto pdto = (ProjectDto)session.getAttribute("pdto");
	List<UserDto> udtos = (List<UserDto>) session.getAttribute("udtos");
	List<UserDto> add_user_list = (List<UserDto>)session.getAttribute("add_user_list");
%>
	 
	 
<div id="container" style="width:50%; height: 100%">

	<div id="header">
	
		<h1 style="margin-bottom:10;"><%=pdto.getPname() %> 타이틀</h1>
		<h2> <%=udto.getUsername() %>님 환영합니다.</h2>
		
	</div>
	
	<div id="sidemenu" style="border:1px solid black; height: 300px; width: 200px; margin-right:2px; float: left;
			padding-left: 10px; overflow:scroll;">
	
		<h3>좌측 사이드 타이틀</h3><br>
		Channels<br>
	
		
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
		
		<a href="#">+</a><br>
		
		
	</div>
	
		<div id="content" style="border:1px solid black; height: 300px; width: 480px; float: left;
		padding-left: 10px;">
		
			<h3>프로젝트 참가자 초대</h3><br>
			<form action="Project.ho" method="get">
				<input type="hidden" name="command" value="project_add_user" />
				<p>프로젝트 참가자 <input type="button" value="검색하기" onclick="search_user();" /></p>
				<p>프로젝트 참가자 목록
				<br>
<%
				if(add_user_list!=null){
				for(int i=0; i<add_user_list.size(); i++) {
%> 

				<input type="hidden" name="useremail" readonly="readonly"
					value="<%=add_user_list.get(i).getUseremail() %>" />
					<%=add_user_list.get(i).getUsername() %>님 (<%=add_user_list.get(i).getUseremail() %>)
					<br>
<%
					}
				}
%> 
				
				</p><br>
			<input type="submit" value="초대하기">		
			</form>
		
		</div>
	<div id="footer" style="clear:both;">
		@SEMI-PROJECT
	</div>
</div>

</body>
</html>