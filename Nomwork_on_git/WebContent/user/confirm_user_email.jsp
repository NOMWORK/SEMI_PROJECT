<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<%
response.setHeader("pragma","No-cache");
response.setHeader("Cache-Control","no-cache");
response.addHeader("Cache-Control","No-store");
response.setDateHeader("Expires",1L);
%>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Nomwork-이메일 인증</title>

    <!-- Bootstrap core CSS-->
    <link href="vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="css/sb-admin.css" rel="stylesheet">
    
    <style type="text/css">
    	
    div{
    	text-align: center;
    }
    	
    </style>
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script type="text/javascript">
    var missCount = 0;
		function check() {
			var appro = ${appro};
			if(appro != $("#appro").val()) {
    		    alert("인증번호가 다릅니다.");
    		    missCount++;
    		    if(missCount == 3){
    		    	//3번 잘못 입력하면 창이 꺼짐
    		    	location.href="index.jsp";
    		    }
    		    return false;
			}else{
				return true;
			}
		}
    </script>
</head>
<body>

	<div>
		<img src="https://cdn.jandi.com/landing/assets/images/register/edd774fb.invite-done.png">
		<p>인증번호 이메일을 발송했습니다<br/>받으신 인증번호를 입력해주세요.<h4>${udto.useremail }</h4></p>
		<form action="User.ho" method="get" onsubmit="return check()">
			<input type="text" id="appro" value=""/>
			<input type="hidden" name="command" value="insert_user">
			<input type="hidden" name="useremail" value="${udto.useremail}">
			<input type="hidden" name="userpw" value="${udto.userpw}">
			<input type="hidden" name="username" value="${udto.username}">
			<input type="hidden" name="usergender" value="${udto.usergender}">
			<input type="submit" value="회원가입 완료"/>
		</form>
		<span href="#">이메일을 받지 못하셨나요? 재전송</span>
	</div>
</body>
</html>