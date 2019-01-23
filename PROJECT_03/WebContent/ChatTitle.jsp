<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<% int pageno = Integer.parseInt(request.getParameter("pageno")); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="resources/css/ChatTitle.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
$(function() {
    /*insert-main*/
    $(".on").click(function(){

    });
});
    
function pagechange(pagenumber) {
 	$.ajax({
		url:"ChatBoardServlet?command=pagechange",
		dataType:"text",
		success:function(msg){
	    	$(".titlelist").html(
		        	"<c:forEach items='${titlelist }' var='title'>"
    					+"<tr>"
						+"<td><input type='checkbox' name='chk' value='' /></td>"
						+"<th scope='row'>${title.userno }</th>"
						+"<td>${title.title}</td>"
						+"<th scope='row'><fmt:formatDate pattern = 'yy/MM/dd' value = '${title.regdate }' /></th>"
						+"<td>itworks</td>"
					+"</tr>"
				+"</c:forEach>"
		   	);
		},
		error:function(){
			alert("서블렛 오류");
		}
 	})
		

}
</script>

</head>

<body>
   
   
    <!-- sidebar:top -->
    <nav class="topsidebar">
    	<div class=logo><img src="resource/Nomwork_logo.png"></div>

   		<div class="topside-1">
	    	<select class="select">
				<option>프로젝트1</option>
	    	</select>
   		</div>
   		<div class="topside-2"></div>
   		<div class="topside-3">
   			<div class="topprofile"><img src="resource/sample.jpg"></div>
			<div class="top-dropmenu" style="display:block">
           		<div class="">회원정보 수정</div>
				<div class="">로그아웃</div>
			</div>
   		</div>
   		<div class="topside-4">
   			천유정
   		</div>
   		<div class="topside-5">
   			<img src="unread.jpg">
   		</div>
   		<div class="topside-6">
   			<img src="unread.jpg">
   		</div>
   		<div class="topside-7">
   			<img src="unread.jpg">
   		</div>
    </nav>
    <!-- /sidebar:top -->
	<!-- sidebar:left -->
    <nav class="leftsidebar">
    	<div class="leftside-project">프로젝트1</div>
    	<div class="myprofile">
	       	<div class="leftside-1">
	    		<div></div>
	   		</div>
	   		<div class="leftside-2">
		    	<div>천유정</div>
	   		</div>
   		</div>
    	<div class="leftside-share"><img src="http://simpleicon.com/wp-content/uploads/Calendar-1.png">공유캘린더</div>
    	<div class="leftside-share"><img src="https://img.icons8.com/metro/50/000000/edit-property.png">공유게시판</div>
    	<br>
    	<hr>
    	
    	<div class="labels">
    		<div>채널<div id="plus"></div></div>
    	</div>
    	<div class="channel_wrapper">
	    	<ul class="channel">
	    		<li><a href="#">회의채팅방</a></li>
	    		<li><a href="#">사원채팅방</a></li>
	    		<li><a href="#">몰라</a></li>
	    		<li><a href="#">eng?</a></li>
	    		<li><a href="#">eng?</a></li>
	    	</ul>
    	</div>
    	<br>
    	<hr>
       	<div class="labels">
       		<div>멤버<div id="plus"></div></div>
       	</div>
       	<div class="member_wrapper">
    		<ul class="member">
    		
	    		<li><a href="#">천씨</a></li>
	    		<li><a href="#">이씨</a></li>
	    		<li><a href="#">김씨</a></li>
	    		<li><a href="#">최씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    		<li><a href="#">lee씨</a></li>
	    	</ul>
    	</div>
    </nav>
	<!-- /sidebar:left -->
	
	<!-- inside wrapper -->
	<div class="inside-wrapper">

		<!-- content:main -->
	    <div class="maincontent">
	    	<!-- boardwrapper -->
	    	<div class="boardwrapper">
	    		<!-- board-table -->
	    		<form action="" method="post" id="board-table">
		    		<table class="board-table">
		    			<col width="10px"/>
		    			<col width="100px"/>
	        			<col width="500px"/>
	        			<col width="100px"/>
	        			<col width="100px"/>
		    			<thead>
		    				<tr>
		    					<th><input type="checkbox" name="all" onclick="allChk(this.checked)" /></th>
		    					<th scope="col">작성자</th>
		    					<th scope="col">내용</th>
		    					<th scope="col">작성일</th>
		    					<th scope="col">첨부파일</th>
		    				</tr>
		    			</thead>
		    			<tbody class="titlelist">
		    			
		    				<c:forEach items="${titlelist }" var="title">
			    				<tr>
			    					<td><input type="checkbox" name="chk" value="" /></td>
			    					<th scope="row">${title.titleno }</th>
			    					<td>${title.title}</td>
			    					<th scope="row"><fmt:formatDate pattern = "yy/MM/dd" value = "${title.regdate }" /></th>
			    					<td></td>
			    				</tr>
		    				</c:forEach>

		    			</tbody>
		    			<tfoot>
		    				<tr>
		    					<td colspan="5">
									<input type="button" value="글쓰기" onclick="showInsertbtn();" />
									<input type="submit" value="삭제" />
							</td>
		    				</tr>
		    			</tfoot>
		    		</table>
	    		</form>
	    		<!-- /board-table -->
	    		
	    		<!-- .paging -->
	    		<div class="paging">  
	    		<a href="ChatBoardServlet.do?command=selectTen&projectno=1&pageno=<%=pageno-1 %>" class="btn_arr prev"><span class="hide">◀</span></a>  
			    		<c:forEach items="${numofpage }" var="page">
			    		<c:set var= "pageno" value="${pageno }"/>
			    		<c:choose>
			    			<c:when test = "${page==pageno}">
			    				<a class="on" href="ChatBoardServlet.do?command=selectTen&projectno=1&pageno=${page }">${page }</a>
			    			</c:when>
			    			<c:otherwise>
			    				<a href="ChatBoardServlet.do?command=selectTen&projectno=1&pageno=${page }">${page }</a>
			    			</c:otherwise>
			    		</c:choose>
			    		</c:forEach>
					<a href="ChatBoardServlet.do?command=selectTen&projectno=1&pageno=<%=pageno+1 %>" class="btn_arr next"><span class="hide">▶</span></a>            
				</div>
				<!-- /.paging -->
				
				<!-- .search -->
				<div class="search">
					<form action="" method="post">
						<input type="search" placeholder="내용을 입력하세요"/>
						<input type="submit" value="검색"/>
					</form>
				</div>
				<!-- /.search -->
	        </div>
	        <!-- /boardwrapper -->
		</div>
		<!-- /content:main -->
		
		
		<div class="thread-margin">
			<!-- thread wrapper -->
			<div class="thread-wrapper">
				<!-- board-thread -->
				<form action="" method="post" id="board-thread">
					<table>
						<tr>
							<th>작성자</th>
							<td><input type="text"/></td>
						</tr>
						<tr>
							<th>작성일</th>
							<td><input type="text"/></td>
						</tr>
						<tr>
							<th>내용</th>
							<td><textarea rows="45" cols="80" style="overflow-x:hidden; overflow-y:auto;"></textarea></td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td><input type="file" name="" id=""/></td>
						</tr>
						<tr>
							<td colspan="2" align="right">
								<input type="button" value="작성 완료"  id="board-thread-insertbtn"/>
							</td>
						</tr>
					</table>
				</form>
				<!-- /board-thread -->
		    </div>
			<!-- /.thread-wrapper -->
			</div>	
	</div>
	<!-- /inside-wrapper -->
</body>
</html>