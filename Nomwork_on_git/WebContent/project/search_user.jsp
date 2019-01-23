<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>
<%@ page import="com.nomwork.user.dto.*" %>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

<script type="text/javascript">

	function search() {
		var useremail = document.getElementsByName("useremail")[0].value;
		location.href='/PROJECT_01/Members.do?command=search_userinfo&useremail='+useremail;
	}
	function confirm() {
		var useremail = document.getElementById("useremail").value;
		opener.location.href='/PROJECT_01/Projects.do?command=project_add_user_list&useremail=' + useremail;
		self.close();
	}

</script>

</head>
<body>

	<h1>회원 검색창</h1>
		<p>이메일로 찾기 
			<input type="text" name="useremail" placeholder="TEST@TEST.COM"/>
			<input type="button" onclick="search();" value="검색하기">
		</p>
		<p style="border:1px solid black; padding-left:1px; padding-right: 1px; ">
		
<%
		UserDto udto =(UserDto) request.getAttribute("udto");
		if(udto!=null) {
%>
		<%=udto.getUsername() %>님 (<%=udto.getUseremail() %>)
		</p>
		<br>
		<input type="hidden" id="useremail" value="<%=udto.getUseremail()%>">
		<input type="button" value="추가하기" onclick="confirm();"/>
<%			
		} else {
%>
		<br>
		</p>
		<br>
		<input type="button" value="추가하기" onclick="alert('존재하지않는 회원입니다.')"/>

<%			
		}
%>
		<input type="button" value="뒤로가기">

</body>
</html>