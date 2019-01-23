<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>    
    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>

	<h1>회원가입</h1>
	
	<form action="User.ho" method="get">
		<input type="hidden" name="command" value="insert_user" />
		<table border="1">
			<tr>
				<th>이메일</th>
				<td>
					<input type="text" name="useremail" title="n" required="required" />
			</tr>		
			<tr>
				<th>비밀번호</th>
				<td><input type="text" name="userpw" required="required">
				</td>
			</tr>
			<tr>
				<th>이름</th>
				<td><input type="text" name="username" required="required">
			</tr>
			<tr>
				<th>성별</th>
				<td>
				남 <input type="radio" name="usergender" value="M"/>
				여 <input type="radio" name="usergender" value="W"/>
				</td>
			</tr>
			<tr>
				<td colspan="2">
				<input type="submit" value="가입" />
				<input type="button" onclick="location.href='/index.jsp'" value="취소" />
			</tr>
			
		</table>
	</form>

</body>
</html>