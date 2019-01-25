<%@page import="com.nomwork.user.dto.UserDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="UTF-8">
<title>Nomwork - 외부 로그인 회원가입</title>

	<!-- Bootstrap core CSS-->
    <link href="resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="resources/css/sb-admin.css" rel="stylesheet">
    
    <script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
    <script type="text/javascript">
    
    //비밀번호가 일치하지 않으면 안넘어감
    function pwCheck() {
		var inputPassword = $("#inputPassword").val();
		var confirmPassword = $("#confirmPassword").val();
		if(inputPassword != confirmPassword) {
		    alert("비밀번호가 일치하지 않습니다.");
		}else if(inputPassword == confirmPassword){
			$("#registerForm").submit();
		}
	}
    
    //성별 선택시 색 선택
    function genderChk(){
		var chk_radio = document.getElementsByClassName('chk');

		for(var i=0;i<chk_radio.length;i++){
			if(chk_radio[i].checked == true){ 
				chk_radio[i].parentNode.style.backgroundColor="#EBFBD0";
			}else if(chk_radio[i].checked == false){
				chk_radio[i].parentNode.style.backgroundColor="white";
			}
		}
	}
    
    //이메일 중복 확인
    function overlap(){
    	if($("#inputEmail").val()!=null&&$("#inputEmail").val()!=""){
		$.ajax({
            url : "User.ho?command=check_email_overlaped&useremail="+$("#inputEmail").val(),
            type: "GET",		
            success : function(data){
                 if(data == 1){
                	 $("#inputEmail").css("background-color","#ECB2AC");
                	 $("#emailoverlap").html('중복된 이메일 계정이 존재합니다 :(')
                	 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
                 }else{
                	 $("#inputEmail").css("background-color","#EBFBD0");
                	 $("#emailoverlap").html('');
                 }
            }
        });
    	}
	}
    
    </script>
	<style type="text/css">
    
    #gender{
			width: 46.9%;
			height: 50px;
			border: 1px solid #CED4DA;
			border-radius: 0.25rem;
			margin-left: 4px;
			margin-right: 4px;
		}
		
    #woman{
			float: left;
			width: 50%;
			line-height: 50px;
			cursor: pointer; 
			text-align: center;
			border-right: 1px solid #CED4DA;
			border-radius: 0rem;
			
		}
		
	#man{
			float: right;
			width: 50%;
			line-height: 50px;
			cursor: pointer; 
			text-align: center;
			border-radius: 0rem;
		}
	div > label > input[type=radio] {
			visibility: hidden;
		}
		
	div > label > span {
			margin-right: 20px;
			color: #495057;
		}	
		
	</style>
</head>
<%
	UserDto udto = (UserDto) session.getAttribute("udto");
%>
<body class="bg-dark">

	<div class="container">
      	<div class="card card-register mx-auto mt-5">
        	<div class="card-header">회원가입 - 빈칸을 입력해주세요 :)</div>
        	<div class="card-body">
          	<form id="registerForm" action="User.ho" method="get">
          		<input type="hidden" name="command" value="insert_user"/>
          		<input type="hidden" name="userno" value="${udto.userno}"/>
          		<input type="hidden" name="userurl" value="${udto.userurl}"/>
          		
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="text" name="username" value="${udto.username}" id="Name" class="form-control" placeholder="name" required="required" autofocus="autofocus">
                    	<label for="Name">이름</label>
                  	</div>
                	</div>
                	
                  	<div id="gender">
                    		<label id="woman">
							<input type="radio" class="chk" name="usergender" value="W" onclick="genderChk()">
							<span>여성</span>
							</label>
		
							<label id="man">
							<input type="radio" class="chk" name="usergender" value="M" onclick="genderChk()">
							<span>남성</span>
							</label>
                  	</div>
                    	
              	</div>
            	</div>
            	<div class="form-group">
              	<div class="form-label-group">
                	<input type="email" name="useremail" value="${udto.useremail}" id="inputEmail" class="form-control" placeholder="Email address" required="required" oninput="overlap()">
                	<div id="emailoverlap"></div>
                	<label for="inputEmail">이메일 주소</label>
              	</div>
            	</div>
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="password" name="userpw" id="inputPassword" class="form-control" placeholder="Password" required="required">
                    	<label for="inputPassword">비밀번호</label>
                  	</div>
                	</div>
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="password" id="confirmPassword" class="form-control" placeholder="Confirm password" required="required">
                    	<label for="confirmPassword">비밀번호 확인</label>
                  	</div>
                	</div>
              	</div>
            	</div>
            	<input id="btn_register" class="btn btn-primary btn-block" type="button" onclick="pwCheck()" value="다음" />
          	</form>
        	</div>
      	 </div>
    	</div>

    <!-- Bootstrap core JavaScript-->
    <script src="resources/vendor/jquery/jquery.min.js"></script>
    <script src="resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="resources/vendor/jquery-easing/jquery.easing.min.js"></script>

</body>
</html>