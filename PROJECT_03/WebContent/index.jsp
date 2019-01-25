<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; charset=UTF-8"); %>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">
    <meta name="viewport" content="user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0, width=device-width"/>
    <!-- 구글아이디로 로그인에 필요한 meta -->
    <meta name="google-signin-scope" content="profile email">
	<meta name="google-signin-client_id" content="317778192554-jea133gf9tpn217khalf73svqbndfelo.apps.googleusercontent.com">

    <title>Nomwork에 오신걸 환영합니다</title>
	<link rel="shortcut icon" href="resources/image/favicon.ico"/>
	
    <!-- Bootstrap core CSS-->
    <link href="resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="resources/css/sb-admin.css" rel="stylesheet">

	<style type="text/css">
		
		.topwrap{
			display: inline-block;
			width: 100%;
			height: 50px;
			background-color: #393939;
		}
		.topwrap > img{
			float: left;
			margin-left: 10px;
			margin-top: 5px;
			height: 40px;
		}
		
		.topwrap > ul {
			display: inline;
			list-style: none;
			height: 50px;
		}
		
		.topwrap > ul > li {
			float: left;
			border-left: 1px solid gray;
			padding: 10px;
			margin-top: 5px;
			font-size: 14px;
			color: white;
		}
		
		.container{
			width: 90%;
			margin-right: 180px;
		}
		
		.rightwrap{
			padding-top: 47px;
			padding-left: 100px;
			width: 30%;
			height: 973px;
			float: right;
			background-color: #fbfbfb;
			border-bottom: 1px solid #DFDFDF;
			margin-bottom: 10px;
		}
		
		.leftwrap{
			width: 70%;
			height: 973px;
			float: left;
			border-bottom: 1px solid #DFDFDF;
			margin-bottom: 10px;
		}
		
		.leftwrap > a > img{
			width: 100%;
		}
		
		.jbFixed{z-index:9999; position:fixed; left:0; top:0; width:100%;} 
		
		.middle{
			width: 100%;
			height: 200px;
			text-align: center;
			border-bottom: 1px solid gray;
			background-color: gray;
		}
		
		#intro{
			display:inline-block;
			width: 100%;
			height: 50px;
			font-size: 25px;
			text-align: center;
		}
		
		#introtext{
			text-align: center;
			vertical-align: middle;
			line-height: 50px;
			color: #393939;
		}
		
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
	<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
	<script src="//developers.kakao.com/sdk/js/kakao.min.js"></script>
	<script src="https://apis.google.com/js/platform.js" async defer></script>
	<script type="text/javascript">
	
	$(document).ready(function(){

		//스크롤내려도 상단바 메뉴 고정되도록 하는 기능	  
		var jbOffset = $( '.topwrap' ).offset();
		$( window ).scroll( function() {
			if ( $( document ).scrollTop() > jbOffset.top ) {
				$( '.topwrap' ).addClass( 'jbFixed' );
			}else {
	            $( '.topwrap' ).removeClass( 'jbFixed' );
	         }
		});
		
	    // 저장된 쿠키값을 가져와서 email 칸에 넣어준다. 없으면 공백으로 들어감.
	    var userInputId = getCookie("userInputId");
	    $("input[name='useremail']").val(userInputId); 
	     
	    if($("input[name='useremail']").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
	        $("#emailSaveCheck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
	    }
	     
	    $("#emailSaveCheck").change(function(){ // 체크박스에 변화가 있다면,
	        if($("#emailSaveCheck").is(":checked")){ // ID 저장하기 체크했을 때,
	            var userInputId = $("input[name='useremail']").val();
	            setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
	        }else{ // ID 저장하기 체크 해제 시,
	            deleteCookie("userInputId");
	        }
	    });
	     
	    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
	    $("input[name='useremail']").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
	        if($("#emailSaveCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
	            var userInputId = $("input[name='useremail']").val();
	            setCookie("userInputId", userInputId, 7); // 7일 동안 쿠키 보관
	        }
	    });
	    
	});
	
	 //쿠키를 저장
	function setCookie(cookieName, value, exdays){
	    var exdate = new Date();
	    exdate.setDate(exdate.getDate() + exdays);
	    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
	    document.cookie = cookieName + "=" + cookieValue;
	}
	 //쿠키를 삭제
	function deleteCookie(cookieName){
	    var expireDate = new Date();
	    expireDate.setDate(expireDate.getDate() - 1);
	    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
	}
	 //쿠키를 불러오기
	function getCookie(cookieName) {
	    cookieName = cookieName + '=';
	    var cookieData = document.cookie;
	    var start = cookieData.indexOf(cookieName);
	    var cookieValue = '';
	    if(start != -1){
	        start += cookieName.length;
	        var end = cookieData.indexOf(';', start);
	        if(end == -1)end = cookieData.length;
	        cookieValue = cookieData.substring(start, end);
	    }
	    return unescape(cookieValue);
	}
	
	
	//회원가입시 폼의 양식을 검사
	function regiCheck() {
		var check = true;
		var inputPassword = $("#inputPassword").val();
		var confirmPassword = $("#confirmPassword").val();
		var name = $("#Name").val();
		var email = $("#inputEmail").val();
		
		if(name==""){
			$("#Name").css("background-color","#ECB2AC");
    	 	$(".namealert").html('이름을 입력해주세요')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
    	 	check = false;
		}
		if(!$("input:radio[name='usergender']").is(":checked")){
    	 	$(".genderalert").html('성별을 선택해주세요')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
    	 	check = false;
		}
		if(inputPassword != confirmPassword) {
			$("#confirmPassword").css("background-color","#ECB2AC");
    	 	$(".pwalert").html('비밀번호가 일치하지 않습니다')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
		    check = false;
		}
		if(inputPassword == ""){
			$("#inputPassword").css("background-color","#ECB2AC");
			$("#confirmPassword").css("background-color","#ECB2AC");
    	 	$(".pwalert").html('비밀번호를 입력해주세요')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
			check = false;
		}
		if(email.indexOf('@') == -1){
			$("#inputEmail").css("background-color","#ECB2AC");
    	 	$("#emailoverlap").html('이메일 형식이 아닙니다')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
			check = false;
		}
		if(email == ""){
			$("#inputEmail").css("background-color","#ECB2AC");
    	 	$("#emailoverlap").html('이메일을입력해주세요')
    		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
			check = false;
		}
		
		//이메일 중복 검사
		$.ajax({
	      	  url : "User.ho?command=emailOverlap&useremail="+$("#inputEmail").val(),
	        	type: "GET",		
	        	success : function(data){
	            	 if(data == 1){
	            		$("#inputEmail").css("background-color","#ECB2AC");
	            	 	$("#emailoverlap").html('중복된 이메일 계정이 존재합니다')
	            		 .css('color','red').css('font-size','14px').css('margin-left','8px').css('font-weight','bold');
	            	 	check = false;
	         	    }
	       		}
	   		});
		
		if(check){
			$("#registerForm").submit();
		}
	}
	
	//회원가입 폼 입력시 조건에 따른 색 변화와 알림
	function condition_check(){
	            	 	
		if($("#Name").val()!=""){
			$("#Name").css("background-color","#EBFBD0");
    		$(".namealert").html('');
		}
		
		if($("#inputEmail").val()!=""){
			$("#inputEmail").css("background-color","#EBFBD0");
			$("#emailoverlap").html('');
		}
		
		if($("#inputPassword").val()!=""){
			$("#inputPassword").css("background-color","#EBFBD0");
    		$(".pwalert").html('');
		}
		
		if($("#confirmPassword").val()!=""){
			$("#confirmPassword").css("background-color","#EBFBD0");
    		$(".pwalert").html('');
		}
		
	}
	//성별을 선택하면 색이 표시되는 기능
	function genderChk(){
		var chk_radio = document.getElementsByClassName('chk');

		for(var i=0;i<chk_radio.length;i++){
			if(chk_radio[i].checked == true){ 
				chk_radio[i].parentNode.style.backgroundColor="#EBFBD0";
				$(".genderalert").html('');
			}else if(chk_radio[i].checked == false){
				chk_radio[i].parentNode.style.backgroundColor="white";
			}
		}
	}
	
	//구글 로그인 기능
	 function onSignIn(googleUser) {
          var profile = googleUser.getBasicProfile();

          var userno = profile.getId();               //고유아이디
          var useremail = profile.getEmail();           //메일
          var username = profile.getName();         	//이름
          var userurl = profile.getImageUrl();     	//프로필사진
          
          location.href="User.ho?command=regist_user_by_api&userno="
                +userno+"&useremail="+useremail+"&username="+username+"&userurl="+userurl;
      }
	
    </script>
	
  </head>
<body>
	<div class="topwrap">
		<img src="resources/image/main/Nomwork_logo.png">
		<ul>
			<li style="border-left: none;">제품소개</li>
			<li>공지사항</li>
			<li>문의하기</li>
		</ul>
	</div>
	
	
	
	<div class="leftwrap">
		<a><img src="resources/image/main/mainimage1.png"></a>
	</div>
	
	
	
	<div class="rightwrap">
	
		<div class="container">
     	 <div class="card card-login mx-auto mt-5">
        	<div class="card-header">로그인</div>
      	  <div class="card-body">
       	  	<form action="User.ho" method="get">
       	  	<input type="hidden" name="command" value="login"/>
           	 <div class="form-group">
            	  <div class="form-label-group">
            	    <input type="email" name="useremail" id="inputEmailin" class="form-control" placeholder="Email addressin" required="required" autofocus="autofocus">
            	    <label for="inputEmailin">이메일 주소</label>
            	  </div>
            </div>
           	 <div class="form-group">
            	  <div class="form-label-group">
             	   <input type="password" name="userpw" id="inputPasswordin" class="form-control" placeholder="Passwordin" required="required">
            	   <label for="inputPasswordin">비밀번호</label>
              	</div>
           	 </div>
           	 
           	 <!-- 카카오톡 / 구글 로그인 버튼 -->
           	 <a id="kakao-login-btn"></a>
             <div class="g-signin2" data-onsuccess="onSignIn"></div>
       	     <div class="form-group">
             	 <div class="checkbox">
               		 <label>
                  	<input type="checkbox" id="emailSaveCheck" value="remember-me">
                  	Remember Email
                	</label>
              	</div>
            	</div>
            	<input class="btn btn-primary btn-block" type="submit" value="로그인"/>
          	</form>
          	<div class="text-center">
            	<a class="d-block small" href="user/forgot_password.jsp" style="margin-top: 8px;">비밀번호가 생각이 안나시나요?</a>
          	</div>
        	</div>
      	 </div>
    	</div>


    	<div class="container">
      	<div class="card card-register mx-auto mt-5">
        	<div class="card-header">회원가입</div>
        	<div class="card-body">
          	<form id="registerForm" action="User.ho" method="get">
          		<input type="hidden" name="command" value="regist_user"/>
          		<input type="hidden" id="overlap" value="0"/>
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="text" name="username" id="Name" class="form-control" placeholder="name" required="required" autofocus="autofocus" oninput="condition_check()">
                    	<div class="namealert"></div>
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
							<div class="genderalert"></div>
                  	</div>
              	</div>
            	</div>
            	<div class="form-group">
              	<div class="form-label-group">
                	<input type="email" name="useremail" id="inputEmail" class="form-control" placeholder="Email address" required="required" oninput="condition_check()">
                	<div id="emailoverlap"></div>
                	<label for="inputEmail">이메일 주소</label>
              	</div>
            	</div>
            	<div class="form-group">
              	<div class="form-row">
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="password" name="userpw" id="inputPassword" class="form-control" placeholder="Password" required="required" oninput="condition_check()">
                    	<label for="inputPassword">비밀번호</label>
                  	</div>
                	</div>
                	<div class="col-md-6">
                  	<div class="form-label-group">
                    	<input type="password" id="confirmPassword" class="form-control" placeholder="Confirm password" required="required" oninput="condition_check()">
                    	<label for="confirmPassword">비밀번호 확인</label>
                  	</div>
                	</div>
              	</div>
              	<div class="pwalert"></div>
            	</div>
            	<input id="btn_register" class="btn btn-primary btn-block" type="button" onclick="regiCheck()" value="다음" />
          	</form>
        	</div>
      	 </div>
    	</div>
	</div>
	
	
	<div class="middlewrap">
		<div id="intro">
			<span id="introtext">제품 소개</span>
		</div>
		<hr>
	</div>
	
	<script type='text/javascript'>
			// 사용할 앱의 JavaScript 키를 설정해 주세요.
			Kakao.init('7c0b18940751bb33c42de38319530d1c');
			
			// 카카오 로그인 버튼을 생성합니다.
			Kakao.Auth.createLoginButton({
				container: '#kakao-login-btn',
				success: function(authObj) {
					
					// 로그인 성공시, API를 호출합니다.
					Kakao.API.request({
						url: '/v2/user/me',
						success: function(res) {
							var userno = res.id;								//고유 아이디
							var useremail = res.kakao_account.email;			//이메일
							var username = res.properties.nickname;		 		//유저가 등록한 별명
							var userurl = res.properties.thumbnail_image;		//프로필사진
							
							location.href="User.ho?"+
									"command=regist_user_by_api&userno="+userno+"&useremail="+useremail+"&username="+username+"&userurl="+userurl;
							
						},
						fail: function(error) {
							alert(JSON.stringify(error));
						}
					});
				},
				fail: function(err) {
					alert(JSON.stringify(err));
				}
			});
		</script>
	
    <!-- Bootstrap core JavaScript-->
    <script src="resources/vendor/jquery/jquery.min.js"></script>
    <script src="resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="resources/vendor/jquery-easing/jquery.easing.min.js"></script>

  </body>
</html>