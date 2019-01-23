<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>  
<%@ page import="java.util.List" %>  
<%@ page import="com.nomwork.user.dto.*" %>
<%@ page import="com.nomwork.project.dao.*" %>
<%@ page import="com.nomwork.project.dto.*" %>

<!DOCTYPE html>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Nomwork - 멤버 초대하기</title>

    <!-- Bootstrap core CSS-->
    <link href="../resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="../resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="../resources/css/sb-admin.css" rel="stylesheet">

	<script type="text/javascript">

		function search_user() {
			window.open("search_user_by_email.jsp","","width=400, height=300");
		}

	</script>

  </head>

  <body class="bg-dark">
  
 <% UserDto udto = (UserDto) session.getAttribute("udto");
    		ProjectDto pdto = (ProjectDto)session.getAttribute("pdto");
    		List<UserDto> add_user_list = (List<UserDto>)session.getAttribute("add_user_list");
%>

    <div class="container">
      <div class="card card-login mx-auto mt-5">
        <div class="card-body">
          <div class="text-center mb-4">
            <p style="font-size: 20px; font-weight: bold;">프로젝트에 멤버를 자유롭게 초대하세요!</p>
            <p style="font-size: 14px;">가능한 한 많은 사람들과 목적을 공유하고 원하는 바를 이루세요.</p>
          </div>
          
		<!-- 프로젝트 초대 이메일 폼 -->
          <form action="Project.ho">
          	<input type="hidden" name="command" value="send_invite_email">
            <div class="form-group">
              <div class="form-label-group">
                <input type="text" id="inputuseremail" name="useremail" class="form-control" required="required" autofocus="autofocus"
                	style="margin-bottom: 2px;">
                <label for="inputuseremail">초대할 멤버 이메일</label>
              </div>
            </div>
            <input class="btn btn-primary btn-block" type="submit" value="초대 이메일 보내기" style="font-size: 14px;">
          </form><br><br>
          
          <div class="text-center mb-4">
            <p style="font-size: 20px; font-weight: bold;">이미 가입된 회원인가요?</p>
            <p style="font-size: 14px;"><a href="#" onclick="search_user();">가입된 이메일을 통해 검색하고, 초대하세요!</a></p>
          </div>
          
          <!-- 프로젝트 참여 폼 -->
          <form action="../Project.ho">
          	<input type="hidden" name="command" value="project_add_user">
            <div class="form-group">
            
            <!-- 프로젝트에 초대할 참가자 목록을 보여줄 DIV -->
              <div id="inputpurl" style="border:1px solid; border-radius: 10px;
              			height: 200px; padding-left: 10px; padding-right: 10px; padding-bottom: 10px; overflow: auto;">
				<label for="inputpurl" style="font-size: 12px;">초대차 추가한 멤버 목록</label><br>
				
				<!-- 검색해서 추가한 유저 표시 -->

<%
				if(add_user_list!=null){
				for(int i=0; i<add_user_list.size(); i++) {
%> 

				<input type="hidden" name="useremail" readonly="readonly"
					value="<%=add_user_list.get(i).getUseremail() %>" />
					<%=add_user_list.get(i).getUsername() %>님 (<%=add_user_list.get(i).getUseremail() %>)
					<a href="../Project.ho?command=remove_user_from_list&useremail=<%=add_user_list.get(i).getUseremail() %>" ><img src="../resources/image/icon/minusicon.png" width="18px" height="auto"></a>
					<br>
<%
					}
				}
%> 	
         	
              </div>
            </div>
            <input class="btn btn-primary btn-block" type="submit" value="프로젝트 초대하기" style="font-size: 14px;">
          </form>
          
          <div class="text-center">
            <a class="d-block small mt-3" href="../Project.ho?command=to_main_project">이전 페이지로 이동</a>
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