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

    <title>Nomwork - 비밀번호 찾기</title>

    <!-- Bootstrap core CSS-->
    <link href="../resources/vendor/bootstrap/css/bootstrap.min.css" rel="stylesheet">

    <!-- Custom fonts for this template-->
    <link href="../resources/vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">

    <!-- Custom styles for this template-->
    <link href="../resources/css/sb-admin.css" rel="stylesheet">

  </head>

  <body class="bg-dark">

    <div class="container">
      <div class="card card-login mx-auto mt-5">
        <div class="card-header">비밀번호 찾기</div>
        <div class="card-body">
          <div class="text-center mb-4">
            <p style="font-size: 20px; font-weight: bold;">비밀번호가 생각 안나시나요?</p>
            <p style="font-size: 14px;">이메일 계정을 적으시면 <br/>비밀번호를 계정으로 보내드리겠습니다.</p>
            
          </div>
          <form action="User.ho">
          	<input type="hidden" name="command" value="forgetpw">
            <div class="form-group">
              <div class="form-label-group">
                <input type="email" id="inputEmail" name="email" class="form-control" placeholder="Enter email address" required="required" autofocus="autofocus">
                <label for="inputEmail">Enter email address</label>
              </div>
            </div>
            <input class="btn btn-primary btn-block" type="submit" value="비밀번호 보내기" style="font-size: 14px;">
          </form>
          <div class="text-center">
            <a class="d-block small mt-3" href="index.jsp">회원가입</a>
            <a class="d-block small" href="index.jsp">로그인 페이지로 이동</a>
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