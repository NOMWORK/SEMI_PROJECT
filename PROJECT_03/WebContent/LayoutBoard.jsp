<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix = "fmt" uri = "http://java.sun.com/jsp/jstl/fmt" %>

<%@ page import="com.nomwork.board.dto.ChatBoardDto" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>

	/* 웹소켓연결 */
	var webSocket = new WebSocket('ws://192.168.10.157:8787/Nomwork/broadcasting');
	webSocket.onerror = function(event) {
	      onError(event)
	};
	webSocket.onopen = function(event) {
	      onOpen(event)
	};
	webSocket.onmessage = function(event) {
	      onMessage(event)
	};
	
	/*웹소켓에서 메세지 받을 시*/
	function onMessage(event) {
		$(".chatwrapper").append(	    		
	        	"<div class='chat'>"
	        		+"<div class='profile-pic'><img src='"+"resource/sample.jpg"+"'></div>"
	        		+"<div class='contextbody'>"
    	        		+"<div class='writer'>"+"name"+"</div>"
    	        		+"<div class='context'>"+event.data+"</div>"
	        		+"</div>"
	        	+"</div>"
	   	);
	}
	/*웹소켓 연결 후*/
	function onOpen(event) {
		//alert("debug: 웹소켓 연결");
	}
	function onError(event) {
	   //alert(event.data);
	}
	$(function() {
   
        /*insert-main*/
        $(".input-submit").click(function(){
        	var inputtext = $(".inputtext").text();
        	if(!inputtext==''){
        	    send(inputtext);
        	}
        });
    
	    function send(inputtext) {
 	    	$.ajax({
				url:"ChatBoardServlet?command=inserttext&inputtext="+inputtext,
				dataType:"text",
				success:function(msg){
			    	$(".chatwrapper").append( 		
				        	"<div class='chat'>"
				        		+"<div class='profile-pic'><img src='"+"resource/sample.jpg"+"'></div>"
				        		+"<div class='contextbody'>"
			    	        		+"<div class='writer'>"+"name"+"</div>"
			    	        		+"<div class='context'>"+msg+"</div>"
				        		+"</div>"
				        	+"</div>"
				   	);
			        webSocket.send(inputtext);
				},
				error:function(){
					alert("서블렛 오류");
				}
 	    	})

	    }

	    function enter(){
	    	if(window.event.keyCode == 13) {
	    		send(inputtext);
	    	}
	    }
	    window.setInterval(function() {
	        var elem = document.getElementById('messageWindow');
	    }, 0); 
    });
    
	
	
	/*게시판*/
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
	function detailBoard(titleno){
		$.ajax({
			url : "ChatBoardServlet.do?command=detailboard&titleno="+titleno,
			dataType:"json",
			success:function(msg){
				//var fileno = decodeURIComponent(msg.fileno);
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
				//$("#detail_file").attr("value",fileno);
				$("#detail_file").hide();
				$("#board_thread-insertbtn").css("visibility","hidden");
				
				// 파일 다운로드
				if(msg.filetitle=="파일이 없습니다."){
					document.getElementById("binfile").innerHTML = "<div id='filedown_board'>파일이 없습니다.</div>";
				} else{
					document.getElementById("binfile").innerHTML = "<a id='filedown_board' href='#'>"+msg.filetitle+"</a>"; 
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
		$("#filedown_board").remove();
		$("#detail_file").show();
		$("#detail_file").attr("value","");
		
	}

	
	function addFile(){
		var fileurl_ = document.getElementById("detail_file").value; 
		document.getElementById("detail_fileurl").value = fileurl_; 
	}
</script>
<link rel="stylesheet" type="text/css" href="js/layoutBoard.css">
</head>

<body>
    <!-- sidebar:top -->
    <nav class="topsidebar">
   		<ul>
			<li><a href="#">0.1</a></li>
			<li><a>0.2</a></li>
   			<li><a>1</a></li>
   			<li><a>2</a></li>
   		</ul>
    </nav>
    <!-- /sidebar:top -->
	<!-- sidebar:left -->
    <nav class="leftsidebar">
    	<div>
    		<a href="ChatBoardServlet.do?command=boardlist">boardlist</a>
    		<a href="#">1</a>
    		<a href="#">1</a>
    		<a href="#">1</a>
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
		    			<tbody>
							<c:choose>
								<c:when test="${empty list }">
									<td colspan="5">----------작성된 글이 없습니다----------</td>
								</c:when>
								<c:otherwise>
									<c:forEach items="${list }" var="dto">
										<tr>
											<td><input type="checkbox" name="chk" value="${dto.titleno}" /></td>
											<th scope="row">${dto.userno }</th>
											<td><a href="javascript:detailBoard(${dto.titleno });">${dto.title }</a></td>
											<th scope="row"><fmt:formatDate pattern = "yy/MM/dd" value = "${dto.regdate }" /></th>
											<td><c:if test="${dto.fileno ne '0'}"><img id="clip_img" src="resource/clip.png"/></c:if></td>
											
										</tr>
									</c:forEach>
								</c:otherwise>
							</c:choose>
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
					<a href="#" class="btn_arr prev"><span class="hide">◀</span></a>     
					<a href="#" class="on">1</a><!-- D : 활성화페이지일 경우 : on 처리 -->
					<a href="#">2</a>
					<a href="#">3</a>
					<a href="#">4</a>
					<a href="#">5</a>
					<a href="#" class="btn_arr next"><span class="hide">▶</span></a>            
				</div>
				<!-- /.paging -->
				
				<!-- .search -->
				<div class="search">
					<form action="" method="post">
						<input type="search" placeholder="내용을 입력하세요"/>
						<input type="submit" value="검색" class="board-btn-green"/>
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
				<!-- board_thread -->
				<form action="ChatBoardServlet.do" method="post" id="board_thread" >
					<input type="hidden" name="command" value="writeboard"/>
					<input type="hidden" name="fileurl" id="detail_fileurl" />
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
								<input type="submit" value="작성 완료" class="board-btn-blue" id="board_thread-insertbtn" onclick="addFile();"/>
							</td>
						</tr>
					</table>
				</form>
				<!-- /board_thread -->
		    </div>
			<!-- /.thread-wrapper -->
			</div>	
	</div>
	<!-- /inside-wrapper -->
</body>
</html>