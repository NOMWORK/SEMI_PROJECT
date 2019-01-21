<%@page import="com.nomwork.channels.dto.ChannelDto"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<% request.setCharacterEncoding("UTF-8"); %>
<% response.setContentType("text/html; UTF-8"); %>    
<%@ page import="com.nomwork.members.dto.*" %>
<%@ page import="java.util.List" %>
<%@ page import="com.nomwork.projects.dao.*" %>
<%@ page import="com.nomwork.projects.dto.*" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>

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
			
			Console.log('해당 브라우저는 웹소켓을 지원하지 않습니다.');
			return;
		}
		
		//서버에 접속이 되면 호출되는 콜백함수
		//소켓에 정의된 속성에 함수주소를 저장한다.
		Chat.socket.onopen = function () {
			
			//Console은 개발자가 만든 객체
			Console.log('웹소켓 연결에 성공하였습니다.');
			
			//텍스트창 이벤트
            document.getElementById('chat').onkeydown = function(event) {

            // 엔터키가 눌린 경우, 서버로 메시지를 전송함
            if (event.keyCode == 13) {

                Chat.sendMessage();

            }
        }; 
        
		};
		
		//연결이 끊어진 경우에 호출되는 콜백함수
		Chat.socket.onclose = function () {
			
			//채팅 입력창 이벤트를 제거한다.
			document.getElementById('chat').onkeydown = null;

			Console.log('웹소켓 연결이 해제되었습니다.');
			
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
						
					$("#channel_user_list").find("a").each(function(idx) {
						
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
					
				} else if(obj[i].command=="message") {
					
					Console.log(obj[i].userno + " : " + obj[i].tcontent);
					
				} else if(obj[i].command=="SocketEnd") {
					
					Console.log(obj[i].userno + " : " + obj[i].tcontent);
					
					$("#channel_user_list").find("a").each(function(idx) {
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
			
			Chat.connect('ws://172.20.10.3:8787/PROJECT_01/ChatWS');
			
		} else {
			
			Chat.connect('wss://' + window.location.host + '/websocket/chat');
			
		}
		
	};
	
	//서버로 메세지를 전송하고 입력창에서 메세지를 제거함
	Chat.sendMessage = (function() {
		
		//var message = document.getElementById('chat').value;
		var message = $("#chat").val();
		var arr = [];
	
		if(message != ''){
			var obj = {};
			var jsonStr;
			
			//채널에 포함된 인원에게만 메세지 보내기
			Console.log($(this).parent().text());
			obj.command = "message";
			obj.tcontent = message;
			jsonStr = JSON.stringify(obj);
			
			Chat.socket.send(jsonStr);
					
			// document.getElementById('chat').value = '';
			$("#chat").val("");
					
		}
	});
	
	//화면에 메세지를 출력하기 위한 객체 생성, json Object
	var Console = {};
	
	//log() 함수 정의
	
	Console.log = (function(message) {
		
		var $console = $("#console");
		
        /*  
        var console = document.getElementById('console');
        var p = document.createElement('p');

        // wordWrap 문자열이 창 최대 오른쪽 벽에 닿으면 줄바꿈
        p.style.wordWrap = 'break-word';
        p.innerHTML = message;
        console.appendChild(p); // 전달된 메시지를 하단에 추가함
		 */
		
		$console.append("<p/>");
		$console.find("p:last").css("wordWrap","break-word");
		$console.find("p:last").html(message);
		
		// 추가된 메시지가 25개를 초과하면 가장 먼저 추가된 메시지를 한개 삭제한다.
		
		/* while (console.childNodes.length > 25) {

            console.removeChild(console.firstChild);

        } */
		
		while ($console.find("p").length > 25) {

        	$console.find("p:first").remove();

        }
        
        // 스크롤을 최상단에 있도록 설정함
        // console.scrollTop = console.scrollHeight;
        $console.scrollTop($console.prop("scrollHeight"));
       
		
	});
	
	 // 위에 정의된 함수(접속시도)를 호출함

    Chat.initialize();

    // $("<p/>")// $("<p></p>") // jQuery 함수를 이용하여 메모리에 p 태그 DOM 객체를 생성한다
	
	
	
</script>

</head>
<body>
<% 	MembersDto mdto = (MembersDto) session.getAttribute("mdto");
	ProjectsDto pdto = (ProjectsDto)session.getAttribute("pdto");
	ChannelDto cdto = (ChannelDto) session.getAttribute("cdto");
	List<MembersDto> mdtos = (List<MembersDto>) session.getAttribute("mdtos");
	List<ChannelDto> cdtos = (List<ChannelDto>) session.getAttribute("cdtos");
%>
	 
	 
<div id="container" style="width:50%; height: 100%">

	<div id="header">
	
		<h1 style="margin-bottom:10;"><%=pdto.getPname() %> 타이틀</h1>
		<h2> <%=mdto.getUsername() %>님 환영합니다.</h2>
		
	</div>
	
	<div id="sidemenu" style="border:1px solid black; height: 300px; width: 200px; margin-right:2px; float: left;
			padding-left: 10px; overflow:scroll;">
	
		<h3>좌측 사이드 타이틀</h3><br>
		Channels<br>
<%
		if(cdtos!=null) {
			
			for(int i=0; i<cdtos.size(); i++) {
%>
				<a href="">
				#<%=cdtos.get(i).getCname() %></a><br>

<%				
			}
		}
%>		
		
		<a href="add_channel.jsp">+</a><br>
		<div id="channel_user_list">
		Direct Messages<br>
<%
		if(mdtos!=null) {
			
			for(int i=0; i<mdtos.size(); i++) {
%>				

			<a id="<%=mdtos.get(i).getUserno() %>" href="">
			#<%=mdtos.get(i).getUsername() %></a><br>
				
<%				
			}
			
		}
%>		

		<a href="add_project_userform.jsp">+</a><br>
		</div>
	</div>
		<div id="content" style="border:1px solid black; height: 300px; width: 480px; float: left;
		padding-left: 10px;">
		<div id="channel_detail">
			<input type="hidden" name="cno" value=<%=cdto.getCno() %> />
			<h3>#<%=cdto.getCname()%> 채팅하기</h3>
			<br>
		</div>
			<input id="chat" type="text"> 
			<input onclick="sendMessage()" value="전송" type="button"> 
			<input onclick="disconnect()" value="연결끊기" type="button">
			<br>
			<div id="console" style="border: 4px dashed #bcbcbc; width: 400px; height: 150px; overflow: scroll;"></div>
		</div>
	<div id="footer" style="clear:both;">
		@SEMI-PROJECT
	</div>
</div>
</body>
</html>