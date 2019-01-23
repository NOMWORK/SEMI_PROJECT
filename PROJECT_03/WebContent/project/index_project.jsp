<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>

    <meta charset="utf-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="description" content="">
    <meta name="author" content="">

    <title>Nomwork - 협업 프로젝트</title>

    <!-- Bootstrap core CSS-->
    <link href="resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="resources/css/sb-admin.css" rel="stylesheet">

  </head>

  <body class="bg-dark">

    <div class="container">
      <div class="card card-login mx-auto mt-5">
        <div class="card-body">
          <div class="text-center mb-4">
            <p style="font-size: 20px; font-weight: bold;">참여하고 계신 프로젝트가 없으신가요?</p>
            <p style="font-size: 14px;">새로운 프로젝트를 개설하고, 초대하고, 완성하세요!</p>
          </div>
          
          <!-- 프로젝트 생성 폼 -->
          <form action="Project.ho">
          	<input type="hidden" name="command" value="project_add">
            <div class="form-group">
              <div class="form-label-group">
                <input type="text" id="inputpname" name="pname" class="form-control" required="required" autofocus="autofocus"
                	style="margin-bottom: 2px;">
                <label for="inputpname">프로젝트 이름</label>
              </div>
              <div class="form-label-group">
                <input type="text" id="inputpurl" name="purl" class="form-control" required="required" autofocus="autofocus">
                <label for="inputptitle">프로젝트 경로</label>
              </div>
            </div>
            <input class="btn btn-primary btn-block" type="submit" value="프로젝트 생성하기" style="font-size: 14px;">
          </form><br><br>
          
          <div class="text-center mb-4">
            <p style="font-size: 20px; font-weight: bold;">참여할 프로젝트를 알고계신가요?</p>
            <p style="font-size: 14px;">동료에게 프로젝트 URL을 물어보고 지금 바로 참여하세요!</p>
          </div>
          <!-- 프로젝트 참여 폼 -->
          <form action="Project.ho">
          	<input type="hidden" name="command" value="project_url_add_user">
            <div class="form-group">
              <div class="form-label-group">
                <input type="text" id="inputpurl" name="purl" class="form-control" required="required" autofocus="autofocus"
                	style="margin-bottom: 2px;">
                <label for="inputpurl">프로젝트 URL</label>
              </div>
            </div>
            <input class="btn btn-primary btn-block" type="submit" value="프로젝트 참여하기" style="font-size: 14px;">
          </form>
          
          <div class="text-center">
            <a class="d-block small mt-3" href="index.jsp">로그인 페이지로 이동</a>
          </div>
        </div>
      </div>
    </div>

    <!-- Bootstrap core JavaScript-->
    <script src="resources/vendor/jquery/jquery.min.js"></script>
    <script src="resources/vendor/bootstrap/js/bootstrap.bundle.min.js"></script>

    <!-- Core plugin JavaScript-->
    <script src="resources/vendor/jquery-easing/jquery.easing.min.js"></script>

  </body>


</body>
</html>