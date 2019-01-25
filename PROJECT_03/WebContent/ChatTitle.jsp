<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>
<% int projectno = Integer.parseInt(request.getParameter("projectno"));%>
<% int pageno = Integer.parseInt(request.getParameter("pageno")); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="resources/css/ChatTitle.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	$(function() {
	    
	    $("#search").click(function(){
	    	var txt = $("#search_input").val();
	    	var url = "ChatBoardServlet.do?command=search_title&projectno="+<%=projectno%>+"&pageno=1&searchtxt="+txt;
	    	window.location.href = url;
	    	return false;
	    });
	});

	//승빈
	// 모두 체크
	function allChk(bool){
		var chks = document.getElementsByName("chk");
		for(var i=0;i<chks.length;i++){
			chks[i].checked = bool;
		}
	}
	
	// 유효성 검사
	$(function(){
		$("#board-table").submit(function(){
			if($("input[name=chk]:checked").length==0){
				alert("하나 이상 체크해 주세요.");
				return false;
			}
		});
	});
	
	// detail
	function detailBoard(boardno){
		$.ajax({
			url : "ChatBoardServlet.do?command=detailboard&boardno="+boardno,
			dataType:"json",
			success:function(msg){
				var filetitle = decodeURIComponent(msg.filetitle);
 				var userno = decodeURIComponent(msg.userno);
 				var regdate = decodeURIComponent(msg.regdate);	
 				var content = decodeURIComponent(msg.content);
 				var title = decodeURIComponent(msg.title);
 				
 				//날짜 설정
  				var regdate_ = regdate.split(" ");
				if(regdate_[1]=="Jan"){regdate_[1]="1";}else if(regdate_[1]=="Feb"){regdate_[1]="2";}else if(regdate_[1]=="Mar"){regdate_[1]="3";}
				else if(regdate_[1]=="Apr"){regdate_[1]="4";}else if(regdate_[1]=="May"){regdate_[1]="5";}else if(regdate_[1]=="Jun"){regdate_[1]="6";}
				else if(regdate_[1]=="Jul"){regdate_[1]="7";}else if(regdate_[1]=="Aug"){regdate_[1]="8";}else if(regdate_[1]=="Sep"){regdate_[1]="9";}
				else if(regdate_[1]=="Oct"){regdate_[1]="10";}else if(regdate_[1]=="Nov"){regdate_[1]="11";}else if(regdate_[1]=="Dec"){regdate_[1]="12";}

				$("#detail_user").attr("value",userno);
				$("#detail_date_").show();
				$("#detail_date").show();
				$("#detail_date").attr("value",regdate_[5]+"/"+regdate_[1]+"/"+regdate_[2]);
				$("#detail_title").attr("value",title);
				$("#detail_content").text(content);
				$("#board_thread-insertbtn").css("visibility","hidden");
				
				// 파일 다운로드
				if(msg.filetitle=="파일이 없습니다."){
					$("#binfile").html("<div id='filedown_board'>파일이 없습니다.</div>");
				} else{
					$("#binfile").html("<a id='filedown_board' href='#'>"+msg.filetitle+"</a>");
				}
				
				document.getElementById("filedown_board").addEventListener("click", function(event) {  
					event.stopPropagation(); 
            	    event.preventDefault(); 
					window.location.href = "ChatBoardServlet.do?command=filedown_board&fileName="+msg.filetitle;
				});
				
	
			},
			error: function(jqXHR, textStatus, errorThrown) {
	            console.log('ERRORS: ' + textStatus);
	        }
		});
	}
	
	// 글쓰기 버튼 눌렀을 때
	function showInsertbtn(){
		//작성완료 버튼 띄우기
		$("#board_thread-insertbtn").css("visibility","visible");
		
		// 내용 비우기
		$("#detail_user").attr("value","");
		$("#detail_date").hide();
		$("#detail_date_").hide();
		$("#detail_title").attr("value","");
		$("#detail_content").text("");
		$("#binfile").html("<input type='file' name='file' id='detail_file' />");
		$("#detail_file").attr("value","");
		
	}

	//write
	function addFile(event){
	    // ajax로
 	    var files =$("#detail_file").prop("files"); 
	    data = new FormData();
	    $.each(files, function(key, value)
	    {
	        data.append(key, value);
	    });
	    command="writeboard";
	    
	    var form = document.getElementById("board_thread");
	    //form.encoding = "application/x-www-form-urlencoded";
	    
	    uploadFilesData(data,command);  
	  
	}
	
	function uploadFilesData(data,command) {
		var user = escape(encodeURIComponent($("#detail_user").val()));
		var title = escape(encodeURIComponent($("#detail_title").val()));
		var content = escape(encodeURIComponent($("#detail_content").val()));
		$.ajax({
	        url: 'ChatBoardServlet.do?command='+command+'&user='+user+'&title='+title+'&content='+content,
	        type: 'POST',
	        data: data,
	        cache: false,
	        dataType: 'text',
	        processData: false, 
	        contentType: false, 
	        success: function(msg) {
			    if(msg>0){
			        window.location.href="ChatBoardServlet.do?command=selectTen&projectno=1&pageno=1";
			    } else {
			        window.location.href="ChatBoardServlet.do?command=selectTen&projectno=1&pageno=1";
			    }	 		                

	        },
	        error: function(jqXHR, textStatus, errorThrown) {
	            console.log('ERRORS: ' + textStatus);
	        }
		});
	}
	
	$(function(){
		$("#detail_file").hide();
	});
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
	    		<form action="ChatBoardServlet.do" method="post" id="board-table">
		    		<input type="hidden" name="command" value="deleteboard" />
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
		    					<th scope="col">제목</th>
		    					<th scope="col">작성일</th>
		    					<th scope="col">첨부파일</th>
		    				</tr>
		    			</thead>
						<tbody class="titlelist">
		    				<c:forEach items="${titlelist }" var="title">
			    				<tr>
			    					<td><input type="checkbox" name="chk" value="" /></td>
			    					<th scope="row">${title.boardno }</th>
			    					<td><a href="javascript:detailBoard(${title.boardno });">${title.boardtitle}</a></td>
			    					<th scope="row"><fmt:formatDate pattern = "yy/MM/dd" value = "${title.regdate }" /></th>
			    					<td></td>
			    				</tr>
		    				</c:forEach>

		    			</tbody>
		    			<tfoot>
		    				<tr>
		    					<td colspan="5">
									<input type="button" value="글쓰기" onclick="showInsertbtn();" class="board-btn-blue"/>
									<input type="submit" value="삭제" class="board-btn-green"/>
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
						<input type="search" id="search_input" placeholder="내용을 입력하세요"/>
						<input type="submit" id="search" value="검색"/>
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
				<form action="ChatBoardServlet.do" method="post" id="board-thread">
					<input type="hidden" name="command" value="writeboard"/>
					<table>
						<tr>
							<th>작성자</th>
							<td><input type="text" name="user" id="detail_user" style="width:230px;"/></td>
							<th id="detail_date_">작성일</th>
							<td><input type="text" id="detail_date" style="width:269px;"/></td>
						</tr>
						<tr>
							<th>제목</th>
							<td colspan="3"><input type="text" name="title" id="detail_title" style="width:579px;"/></td>
						</tr>
						<tr>
							<th>내용</th>
							<td colspan="3"><textarea rows="45" cols="80" name="content" id="detail_content" style="overflow-x:hidden; overflow-y:auto;"></textarea></td>
						</tr>
						<tr>
							<th>첨부파일</th>
							<td id="binfile"><input type="file" name="file" id="detail_file" /></td>						
						</tr>
						<tr>
							<td colspan="2" align="right">
								<input type="button" value="작성 완료" class="board-btn-blue" id="board_thread-insertbtn" onclick="addFile();"/>
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