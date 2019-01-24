<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>  
<%@ page import="java.util.List" %>  
<%@ page import="com.nomwork.user.dto.*" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Nomwork - 채널 생성</title>

    <!-- Bootstrap core CSS-->
    <link href="../resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="../resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="../resources/css/sb-admin.css" rel="stylesheet">

  </head>

  <body class="bg-dark">
  
 <% UserDto udto = (UserDto) session.getAttribute("udto");
	List<UserDto> udtos = (List<UserDto>) session.getAttribute("udtos");
%>

    <div class="container">
      <div class="card card-login mx-auto mt-5">
        <div class="card-body">
          <div class="text-center mb-4">
            <p style="font-size: 20px; font-weight: bold;">자유롭게 팀원을 초대하고 채널을 생성하세요!</p>
            <p style="font-size: 14px;">여러 주제에 맞는, 기능에 따른, 분류에 따른, 채널을 생성하고 목적에 맞는 사람들과 소통하세요!</p>
          </div>
          
          <!-- 프로젝트 생성 폼 -->
          <form action="../Channel.ho">
          	<input type="hidden" name="command" value="add_channel">
            <div class="form-group">
              <div class="form-label-group">
                <input type="text" id="inputpname" name="cname" class="form-control" required="required" autofocus="autofocus"
                	style="margin-bottom: 2px;">
                <label for="inputpname">채널 이름</label>
              </div>
            </div>
          
          <div class="text-center mb-4">
            <p style="font-size: 20px; font-weight: bold;">새로만들 채널에 초대할 동료를 선택하세요!</p>
            <p style="font-size: 14px;">지금바로 선택하지않아도 언제든 다시 초대하실 수 있습니다.</p>
          </div>

            <div class="form-group">
            <!-- 채널에 초대할 참가자 목록을 보여줄 DIV -->
              <div id="inputpurl" style="border:1px solid; border-radius: 10px;
              			height: 200px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; overflow: auto;">
				<label for="inputpurl" style="font-size: 12px;">현재 프로젝트 참가자 목록</label><br>
				<!-- 채널에 참여하고 있는 유저의 수만큼 표시 -->

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
         	
              </div>
            </div>
            <input class="btn btn-primary btn-block" type="submit" value="채널 생성하기" style="font-size: 14px;">
          </form>
          
          <div class="text-center">
            <a class="d-block small mt-3" href="javascript:history.back();">이전 페이지로 이동</a>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="../resources/vendor/jquery/jquery.min.js"></script>
    <script src="../resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="../resources/vendor/jquery-easing/jquery.easing.min.js"></script>

  </body>


</body>
</html>