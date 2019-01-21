<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!-- 주요 클래스 IMPORT -->
<%@ page import="java.util.List"%>
<%@ page import="com.nomwork.user.dto.*"%>
<%@ page import="com.nomwork.project.dao.*"%>
<%@ page import="com.nomwork.project.dto.*"%>
<%@ page import="com.nomwork.channel.dto.*"%>

<!-- TAGLIB 정의 -->
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>

<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<link rel="stylesheet" type="text/css" href="resources/css/ChatBoard.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.3.1/jquery.min.js"></script>
<script>
	$(function() {
        /*thread 숨김/보임 */
		$(".thread-wrapper").hide();
        $(".context").click(function() {
            $(".thread-wrapper").toggle();
        });
        $(".reply-dropbtn").click(function() {
			$(".reply-dropmenu").toggle();
		})
    });
</script>

<!-- 웹소켓을 이용한 채팅 관련 스크립트 -->
<script type="text/javascript" src="https://code.jquery.com/jquery-3.3.1.js"></script>
<script type="application/javascript">	
	
	var Chat = {};
	
	Chat.socket = null;
	
	//connect() 함수 정의
	Chat.connect = (function (host) {
		
		//서버에 접속 시도
		//브라우저마다 WebScoket이 지원되지 않는 경우가 있기 때문에 조건문으로 판단한다.
		//window 객체에 WebSocket 속성이 있다면 if문 실행
		if('WebSocket' in window) {
			
			//WebSocket은 브라우저가 제공하는 시스템 객체이다.
			Chat.socket = new WebSocket(host);
			
		} else {
			
			alert('해당 브라우저는 웹소켓을 지원하지 않습니다.');
			return;
		}
		
		//서버에 접속이 되면 호출되는 콜백함수
		//소켓에 정의된 속성에 함수주소를 저장한다.
		Chat.socket.onopen = function () {
			
			//Console은 개발자가 만든 객체
			alert('웹소켓 연결에 성공하였습니다.');
			//채팅 작성 버튼 이벤트 생성
			 document.getElementsByClassName("input-submit")[0].onclick = function(event) {
				
				Chat.sendMessage();
			}
			//채팅창 이벤트 생성
			 document.getElementsByClassName("inputtext")[0].onkeydown = function(event) {
				
				//엔터키가 눌린 경우, 서버로 메세지를 전송함
				if(event.keyCode==13) {
					Chat.sendMessage();
				}
			}
		};
		
		//연결이 끊어진 경우에 호출되는 콜백함수
		Chat.socket.onclose = function () {
			
			//채팅 작성 버튼 이벤트를 제거한다.
			document.getElementsByClassName("input-submit").onclick = null;
			//채팅창 이벤트 제거
			document.getElementsByClassName("inputtext")[0].onkeydown = null;
			alert('웹소켓 연결이 해제되었습니다.');
			
		};
		
		//서버로부터 메세지를 받은 경우에 호출되는 콜백함수
		Chat.socket.onmessage = function (message) {
			
			//수신된 메세지를 화면에 출력함.
			var obj = eval(message.data);
			var pass = false;
			//$("#guestList").empty();
			
			for(var i=0; i<obj.length; i++){
				ok = false;
				//웹소켓 연결 성공시 이벤트
				if(obj[i].command=="HandleOpen") {
						
					$(".member").find("li").find("a").each(function(idx) {
						
						//웹소켓 연결 사용자 처리
						if($(this).attr('id')==obj[i].userno) {
							
							pass = true;
							if(!$(this).text().match(/ON/)){
								$(this).append('[ON]');
								$(this).css("font-weight","bold");
							}
						}
					});
						//웹소켓 연결 사용자를 제외한 사용자 처리
						if(!pass) {
							//
						}
					
				} else if(obj[i].command=="HandleMessage") {
					
					Console.log(obj[i]);
					
				} else if(obj[i].command=="HandleClose") {
					
					$(".member").find("li").find("a").each(function(idx) {
						//연결종료된 사용자 처리
						if($(this).attr('id')==obj[i].userno) {
							
							if(!$(this).text().match(/ON/)){
								$(this).text(text.replace('[ON]',''));
								$(this).css("font-weight","normal");
							}
						}
					});
				} 
			}
		};
	}); //connect() 함수 정의 끝
	
	//위에서 정의한 connect() 함수를 호출하여 접속을 시도함.
	Chat.initialize = function() {
		
		if(window.location.protocol=='http:') {
			
			//Chat.connect('ws://' + window.location.host + 'websocket/chat');
			//connect 함수에 파라미터를 전달해서 접속 시도, 콜백함수 등록
			//ws : tcp/ip 기반 프로토콜
			Chat.connect('ws://localhost:8787/PROJECT_03/ChatWS');
			
		} else {
			
			Chat.connect('wss://' + window.location.host + '/websocket/chat');
			
		}
	};
	
	//서버로 메세지를 전송하고 입력창에서 메세지를 제거함
	Chat.sendMessage = (function() {
		
		var message = $(".inputtext").text();
		var arr = [];
		//공백의 경우는 제외시킨다
		if(message != ''){
			var obj = {};
			var jsonStr;
			
			//채널에 포함된 인원에게만 메세지 보내기
			obj.command = "HandleMessage";
			obj.tcontent = message;
			jsonStr = JSON.stringify(obj);
			
			Chat.socket.send(jsonStr);
					
			//입력창에서 텍스트 제거
			$(".inputtext").text('');
					
		}
	});
	
	//화면에 메세지를 출력하기 위한 객체 생성, json Object
	var Console = {};
	
	//log() 함수 정의
	Console.log = (function(message) {
		
		var $console = $(".chatwrapper");
		
		if(message!=""||message!=null){
		 $console.append(	    		
		        	"<div class='chat'>"
		        		+"<div class='profile-pic'><img src='"+ message.userurl +"'></div>"
		        		+"<div class='contextbody'>"
	    	        		+"<div class='writer'>"+ message.username +"</div>"
	    	        		+"<div class='context'>"+ message.tcontent +"</div>"
		        		+"</div>"
		        	+"</div>"
		   	)};
        
        //스크롤을 최상단에 있도록 설정함
        $console.scrollTop($console.prop("scrollHeight"));
       
	});
	
	//위에 정의된 함수(접속시도)를 호출함
    Chat.initialize();

    // $("<p/>")// $("<p></p>") // jQuery 함수를 이용하여 메모리에 p 태그 DOM 객체를 생성한다

</script>

</head>
<body>

	<!-- 주요 클래스 객체 생성 -->
	<%
		UserDto udto = (UserDto) session.getAttribute("udto");
		ProjectDto pdto = (ProjectDto) session.getAttribute("pdto");
		ChannelDto cdto = (ChannelDto) session.getAttribute("cdto");
		List<UserDto> udtos = (List<UserDto>) session.getAttribute("udtos");
		List<ChannelDto> cdtos = (List<ChannelDto>) session.getAttribute("cdtos");
		List<ProjectDto> pdtos = (List<ProjectDto>) session.getAttribute("pdtos");
	%>
	
    <!-- sidebar:top -->
    <nav class="topsidebar">
    	<div class=logo><img src="resources/image/main/Nomwork_logo.png"></div>

   		<div class="topside-3">
	    	<select class="select">
	    	
<%
				if (pdtos != null) {

					for (int i = 0; i < pdtos.size(); i++) {
%>
			<option><%=pdtos.get(i).getPname()%></option>

<%
					}
				}
%>	    	
	    	</select>
   		</div>
    </nav>
    <!-- /sidebar:top -->
	<!-- sidebar:left -->
    <nav class="leftsidebar">
    	<div class="myprofile">
	       	<div class="leftside-1">
	       	
	       		<!-- 프로필 이미지 가져오기 -->
	    		<div class="profile-pic">
	    		<img src="<%=udto.getuserurl()%>">
	    		</div>
	   		</div>
	   		
	   		<!-- 프로필 이름 가져오기 -->
	   		<div class="leftside-2">
		    	<div><%=udto.getUsername()%></div>
	   		</div>
   		</div>
   		
   		<!-- 프로젝트 이름 가져오기 -->
    	<div class="leftside-project"><%=pdto.getPname() %></div>
    	<div class="leftside-share"><img src="resources/image/leftside/calendar.png">공유캘린더</div>
    	<div class="leftside-share"><img src="resources/image/leftside/board.png">공유게시판</div>
    	
    	<hr>
    	
    	<div class="channels"><div> 채널 목록<div id="plus" onclick="Channel.ho?command=to_add_channel">
    	</div></div></div></div>
    	<ul class="channel">
<%
				if (cdtos != null) {

					for (int i = 0; i < cdtos.size(); i++) {
%>
			<li><a href=""> #<%=cdtos.get(i).getCname()%></a></li>

<%
					}
				}
%>
    	</ul>
    	
    	<hr>
    	
    	<div class="members"><div> 참가자 목록<div id="plus"></div></div></div></div>
    	<ul class="member">
<%
				if (udtos != null) {

					for (int i = 0; i < udtos.size(); i++) {
%>
			<li><a id="<%=udtos.get(i).getUserno()%>" href=""> #<%=udtos.get(i).getUsername() %></a></li>

<%
					}
				}
%>
    	</ul>
    </nav>
	<!-- /sidebar:left -->
	
	<!-- inside wrapper -->
	<div class="inside-wrapper">
		
		
		<!-- content:main -->
	    <div class="maincontent">
	    	<!-- chatwrapper -->
	    	<div class="chatwrapper">
	    		<!--chat-->
				<div class="chat">
		            <div class="profile-pic"><img src="resource/sample.jpg"></div>
					<div class="contextbody">
						<div class="writer">노조원1</div>
						<div class="context">일단 예시용</div>
		            </div>
		        </div>
		        <!-- chat-->
				<!-- 게시글 가져오기-->
				<c:forEach items="${titlelist }" var="title">
				<div class="chat">
		            <div class="profile-pic"><img src="resource/sample.jpg"></div>
					<div class="contextbody">
						<div class="writer">${title.userno }</div>
						<div class="context">${title.content}</div>
		            </div>
		        </div>
		        </c:forEach>
		        <!-- 게시글 가져오기 -->
		        <!-- 웹소켓에서 가져오기 -->
		        <!-- /웹소켓에서 가져오기 -->
	        </div>
	        <!-- /chatwrapper -->
	        
	        <!-- 채팅 입력창 -->
	         <div class="inputwrapper">
	         	<div class="input-dropbtn"></div>
	         	<div class="inputtext" contentEditable="true"></div>
	         	<div class="input-submit">작성</div>
	         </div>
	     	<!-- 채팅 입력창 끝 -->
		</div>
		<!-- /content:main -->
		
		<div class="thread-margin">
			<!-- thread wrapper -->
			<div class="thread-wrapper">
				<!-- 작성자+내용 -->
				<div class="thread-board">
					<div class="profile-pic"><img src="resource/sample.jpg"></div>
					<div class="board-context">
						<div class="board-writer"></div>
						<div class="board-content"></div>
					</div>
				</div>
				<!-- 답글1 -->
				<div class="board-reply">
					<div class="profile-pic"><img src="resource/sample.jpg"></div>
					<div class="reply-context">
						<div class="reply-writer">노조원2</div>
						<div class="reply-context-body">
						Lorem ipsum dolor sit amet, consectetur adipiscing elit,
						sed do eiusmod tempor incididunt ut labore et dolore magna
						aliqua.
						</div>
					</div>
				</div>
				<!-- /답글1 -->
				<!-- 답글2 -->
				<div class="board-reply">
					<div class="profile-pic"><img src="resource/sample.jpg"></div>
					<div class="reply-context">
						<div class="reply-writer">노조원2</div>
						<div class="reply-context-body">
						Lorem ipsum dolor sit amet, consectetur adipiscing elit,
						sed do eiusmod tempor incididunt ut labore et dolore magna
						aliqua.
						</div>
					</div>
				</div>
				<!-- /답글 2-->
				<!-- /작성자+내용 -->
				
				<!-- 답글입력 -->
				<div class="board-insertReply">
					<div class="reply-dropup">
	                     	<a class="reply-dropbtn" type="button"></a>
	                     	<span class="reply-dropmenu"> 
	                     		<a href="#">파일 업로드</a>
	                     		<a href="#">Another action</a>
	                     		<a href="#">Something else here</a>
								<a href="#">Separated link</a>
							</span>
		            </div>
		            <div class="reply-input" contentEditable="true"></div>
		            <div class="reply-submit">작성</div>
		        </div>
		    </div>
			<!-- /.thread-wrapper -->
			</div>
		
	</div>
	<!-- /inside-wrapper -->
</body>
</html>