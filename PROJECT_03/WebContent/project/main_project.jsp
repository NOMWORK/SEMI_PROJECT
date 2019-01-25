<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
	
<!-- 주요 클래스 IMPORT -->
<%@ page import="java.util.List"%>
<%@ page import="com.nomwork.user.dto.*"%>
<%@ page import="com.nomwork.project.dao.*"%>
<%@ page import="com.nomwork.project.dto.*"%>
<%@ page import="com.nomwork.channel.dto.*"%>
<%@ page import="com.nomwork.map.dto.*" %>
<%@ page import="com.nomwork.map.dao.*" %>

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
<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=bb2984f0bdf61397f855939afa894bbb"></script>
<script>
	$(function() {
        /*thread 숨김/보임 */
		$(".thread-wrapper").hide();
        $(".context").click(function() {
            $(".thread-wrapper").toggle();
            $(".reply-dropmenu").hide();
        });

        /*메인창 드롭업 보임/숨김*/
        $(".input-dropbtn").click(function(){
        	$(".inside-cover").show()
        	$(".input-dropmenu").show();
        })
        /*답글창 드롭업 보임/숨김*/
        $(".reply-dropbtn").click(function() {
        	$(".inside-cover").show();
			$(".reply-dropmenu").show();
		});
        /*insert-취소버든*/
		$(".attach-cancel").click(function(){
        	$(".insert-link-text").hide();
        	$(".inside-cover").hide();
        	$(".insert-video").hide();
        	$(".insert-map").hide();
        	$(".insert-file").hide();
        })
        /*클릭방지커버 클릭-전체 닫힘*/
        $(".inside-cover").click(function() {
        	$(".insert-link-text").hide();
        	$(".input-dropmenu").hide();
        	$(".reply-dropmenu").hide();
        	$(".inside-cover").hide();
        	$(".insert-video").hide();
        	$(".insert-map").hide();
        	$(".insert-file").hide();
        })
        function addRe() {
			$(".attach-submit").addClass("attach-submit-re");
        	$(".attach-submit-re").removeClass("attach-submit");
        	$(".inside-cover").show();
        	$(".reply-dropmenu").hide();
        }
        function removeRe() {
        	$(".attach-submit-re").addClass("attach-submit");
        	$(".attach-submit").removeClass("attach-submit-re");
        	$(".inside-cover").show();
        	$(".input-dropmenu").hide();
        }
         /*메인-링크가져오기 보임*/
        $(".open-link").click(function(){
        	$(".insert-link-text").show();
        	removeRe();
        })
        /*답글-링크가져오기 보임*/
        $(".open-link-re").click(function(){
        	$(".insert-link-text").show();
        	addRe()
        })
		/*동영상 가져오기*/
		$(".open-video").click(function() {
			$(".insert-video").show();
			removeRe();
		})
		$(".open-video-re").click(function() {
			$(".insert-video").show();
			addRe();
		})
		/*지도 가져오기*/
		$(".open-map").click(function() {
			$(".insert-map").show();
			removeRe();
		})
		$(".open-map-re").click(function() {
			$(".insert-map").show();
			addRe();
		})
		/*파일 가져오기*/
		$(".open-file").click(function(){
			$(".insert-file").show();
			removeRe();
		})
		$(".open-file-re").click(function(){
			$(".insert-file").show();
			addRe();
		})
		$(".insert-link-text").on('click','.attach-submit-re',function(){
			var txt = $(".link-output").text();
			$(".link-output").val("");
			$(".reply-input").html(txt);
		})
		$(".insert-link-text").on('click','.attach-submit',function(){
			var txt = $(".link-output").text();
			$(".link-output").val("");
			$(".input_text").html(txt);
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
			
			$(".input_submit").click(function(event) {
				Chat.sendMessage();
			});
			
			$(".input_text").on("keydown", function(event) {
				
				//엔터키가 눌린 경우, 서버로 메세지를 전송함
				if(event.keyCode==13) {
					Chat.sendMessage();
				}
				
			});
			
			//지도 마크 전송 버튼 이벤트 생성
			$(".attach-submit:eq(2)").click(function(event) {
				
				//지도 첨부 창 닫기
				$(".insert-map").hide();
				$(".inside-cover").hide();
				
				//서버로 메세지 전송하기
				Chat.sendMap();
			});
		}
		
		//연결이 끊어진 경우에 호출되는 콜백함수
		Chat.socket.onclose = function () {
			
			//채팅 작성 버튼 이벤트를 제거한다.
			$(".input_submit").click(null);
			//채팅창 이벤트 제거
			$(".input_text").on("keydown", null);
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
		
		var message = $(".input_text").text();
		var arr = [];
		//공백의 경우는 제외시킨다
		if(message != ''){
			var obj = {};
			var jsonStr;
			
			//채널에 포함된 인원에게만 메세지 보내기
			obj.command = "HandleMessage";
			obj.purpose = "Chat"
			obj.tcontent = message;
			jsonStr = JSON.stringify(obj);
			
			Chat.socket.send(jsonStr);
					
			//입력창에서 텍스트 제거
			$(".input_text").remove("div");
			$(".input_text").text('');
					
		}
	});
	
	//서버로 지도를 전송하기 위한 함수 정의
	Chat.sendMap = (function() {
		
		//위도, 경도값 설정
		var latitude = document.getElementById("latitude").value;
		var longitude = document.getElementById("longitude").value;

		//JSON
		if(!(latitude==""&&longitude=="")){
			var arr = [];
			var obj = {};
			var jsonStr;
			
			//JSON형태로 웹소켓 서버에 메세지 보내기
			obj.command = "HandleMessage";
			obj.purpose = "Map"
			obj.latitude = latitude;
			obj.longitude = longitude;
			jsonStr = JSON.stringify(obj);
			
			Chat.socket.send(jsonStr);
		}
					
		//지도 레이아웃 창 닫기 ();
		
	});
	
	//화면에 메세지를 출력하기 위한 객체 생성, json Object
	var Console = {};
	
	//log() 함수 정의
	Console.log = (function(message) {
		var $console = $(".chatwrapper");
		
		if(message!=""||message!=null){
			if(message.purpose=="Map"){
				
				$console.append(
					"<div class='chat'>"
						+"<div class='profile-pic'><img src='"+ message.userurl +"'></div>"
						+"<div class='contextbody'>"
						+"<div class='writer'>"+ message.username +"</div>"
						+"<div class='context'>"
						+"<div class='context-map' id='" + message.tno +"'></div>"
						+"<script>"
							+"var mapContainer = document.getElementById('" + message.tno + "'),"
								+"mapOption = {"
									+"center: new daum.maps.LatLng(" + + message.latitude + "," + message.longitude + "),"
									+"level: 3};"
								+"var chatmap = new daum.maps.Map(mapContainer, mapOption); "
								+"var markerPosition  = new daum.maps.LatLng(" + message.latitude + "," + message.longitude + ");"
								+"var chatmarker = new daum.maps.Marker({"
									+"position: markerPosition });"
								+"chatmarker.setMap(chatmap);"
								+"<\/script></div></div></div>"
						);
			} else if(message.purpose=="Chat"){
				 $console.append(	    		
		        	"<div class='chat'>"
		        		+"<div class='profile-pic'><img src='"+ message.userurl +"'></div>"
		        		+"<div class='contextbody'>"
	    	        		+"<div class='writer'>"+ message.username +"</div>"
	    	        		+"<div class='context'>"+ message.tcontent +"</div>"
		        		+"</div>"
		        	+"</div>"
		   	)};
		}
        
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
    	<div class=logo><a href="Project.ho?command=to_main_project"><img src="resources/image/main/Nomwork_logo.png"></a></div>

		<!-- 해당 유저의 프로젝트 목록 표시 -->
   		<div class="topside-1">
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
   		<div class="topside-2"></div>
   		
   		<!-- 프로필 관련 -->
   		<!-- 프로필 이미지 가져오기 -->
   		<div class="topside-3">
   			<img src="<%=udto.getuserurl()%>">
   		</div>
   		<!-- 프로필 이름 가져오기 -->
   		<div class="topside-4">
   			<%=udto.getUsername() %>
   		</div>
   		
   		<div class="topside-5">
   			<img src="">
   		</div>
   		<div class="topside-6">
   			<img src="">
   		</div>
   		<div class="topside-7">
   			<img src="">
   		</div>
    </nav>
    <!-- /sidebar:top -->
	<!-- sidebar:left -->
    <nav class="leftsidebar">
    	<!-- 프로젝트 이름 가져오기 -->
    	<div class="leftside-project"><%=pdto.getPname() %></div>
    	<div class="myprofile">
	       	<div class="leftside-1">
	    		<div></div>
	   		</div>
	   		<!-- 프로필 이름 가져오기 -->
	   		<div class="leftside-2">
		    	<div><%=udto.getUsername()%></div>
	   		</div>
   		</div>
    	<div class="leftside-share"><img src="http://simpleicon.com/wp-content/uploads/Calendar-1.png">공유캘린더</div>
    	<div class="leftside-share"><a href="ChatBoardServlet.do?command=selectTen&projectno=<%=pdto.getPno() %>&pageno=1"><img src="https://img.icons8.com/metro/50/000000/edit-property.png">공유게시판</a></div>
    	<br>
    	<hr>
    	
    	<div class="labels">
    		<div>채널<div id="plus" onclick="location.href='Channel.ho?command=to_add_channel'"></div></div>
    	</div>
    	<div class="channel_wrapper">
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
    	</div>
    	<br>
    	<hr>
       	<div class="labels">
       		<div>멤버<div id="plus" onclick="location.href='Project.ho?command=to_project_add_user'"></div></div>
       	</div>
       	<div class="member_wrapper">
    		<ul class="member">
<%
				if (udtos != null) {

					for (int i = 0; i < udtos.size(); i++) {
%>
			<li><a id="<%=udtos.get(i).getUserno() %>" href=""> #<%=udtos.get(i).getUsername() %></a></li>

<%
					}
				}
%>    		
	    	</ul>
    	</div>
    </nav>
	<!-- /sidebar:left -->
	
	<!-- inside wrapper -->
	<div class="inside-cover" style="display:none">
	</div>
	<div class="inside-wrapper">

<!-- display:none 모음
다른 창들을 무시하고 뜨는 postion: absolute 입력창들-->

<!-- link 가져오기 -->
<div class="insert-link-text" style="display:none">
	<div class="attach-title">링크 내 텍스트 가져오기</div>
	<div class="attach-label">링크주소</div>
	<div class="link-input-wrapper">
		<div class="link-input" contentEditable="true"></div>
		<div class="link-ok">가져오기</div>
	</div>
	<div class="attach-label">텍스트</div>
	<div class="link-output" contenteditable="true"></div>
	<div class="attach-submit">입력</div><div class="attach-cancel">취소</div>
</div>
<!-- /link 가져오기 -->

<!-- 동영상 가져오기 -->
<div class="insert-video" style="display:none">
	<div class="attach-title">동영상 첨부</div>
	<div class="attach-label">Youtube링크</div>
	<div class="link-input-wrapper">
		<div class="link-input" contentEditable="true"></div>
		<div class="link-ok">가져오기</div>
	</div>
	<div class="video-detail"></div>
	<div class="attach-submit">전송</div><div class="attach-cancel">취소</div>
</div>
<!-- /동영상 가져오기 -->



<!-- 지도 가져오기 -->
<div class="insert-map" style="display:none">
	<div class="attach-title">지도 첨부</div>
	<div class="map-show" id="map"></div>
	
	<!-- 위도와 경도를 담을 INPUT 태그 -->
	<input id="latitude" type="hidden" value=""/>
	<input id="longitude" type="hidden" value=""/>
	
	<!-- 카카오 지도 API 적용 스크립트 -->
	<script>
		var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
		 	mapOption = { 
		        center: new daum.maps.LatLng(37.49802241874058, 127.02777407827081), // 지도의 중심좌표
		        level: 3 // 지도의 확대 레벨
		    };
			
			//Map.relayout();
			
			var map = new daum.maps.Map(mapContainer, mapOption);
			
			var marker = new daum.maps.Marker({ 
			    position: map.getCenter() 
			}); 
			marker.setMap(map);
			
			daum.maps.event.addListener(map, 'click', function(mouseEvent) {        
			    
			    var latlng = mouseEvent.latLng; 
			    
			    marker.setPosition(latlng);
			    
			    document.getElementById("latitude").value=latlng.getLat();	//위도
				document.getElementById("longitude").value=latlng.getLng(); //경도
			    
			});
	</script>
		
	<div class="attach-label">위치 설명(옵션)</div>
	<textarea class="map-input"></textarea>
	<div class="attach-submit">전송</div><div class="attach-cancel">취소</div>
</div>
<!-- 파일 가져오기 -->
<div class="insert-file" style="display:none">
	<div class="attach-title">파일 첨부</div>
	<div class="link-input-wrapper">
		<input class="link-input"></input>
		<div class="link-ok">가져오기</div>
	</div>
	<div class="file-size">*첨부하는 파일의 크기는 15MB를 넘을 수 없습니다</div>
	<div class="attach-label">파일이름 설정(옵션)</div>
	<input class="map-input"></input>
	<div class="attach-submit">전송</div><div class="attach-cancel">취소</div>
</div>
<!-- /파일 가져오기 -->

<!-- display:none 모음 끝 -->

		<!-- content:main -->
	    <div class="maincontent">
	    	<!-- chatwrapper -->
	    	<div class="chatwrapper">
		        <!-- chat-->
		        
				<!-- 게시글 가져오기-->
				<c:forEach items="${titlelist }" var="title">
				<div class="chat">
		            <div class="profile-pic"><img src=""></div>
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
            	<div class="input-dropup">
	         		<div class="input-dropbtn"></div>
	         		<div class="input-dropmenu" style="display:none">
	         			<div class="attach">attach..</div>
                   		<div class="dropmenu open-file">파일 업로드</div>
                   		<div class="dropmenu open-map">지도 첨부하기</div>
                   		<div class="dropmenu open-video">동영상 첨부하기</div>
						<div class="dropmenu open-link">링크 내 텍스트 가져오기</div>
					</div>
	         	</div>
	         	<div class="input_text" contentEditable="true"></div>
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
					<div class="profile-pic"><img src=""></div>
					<div class="board-context">
						<div class="board-writer">노조원1</div>
						<div class="board-content">
						아 cap키도 고장났니..?...하.....
						select * from text where textno= # { textno } and channelno= # { channelno } and answersq=1
						textno를 context근처에 hidden으로 넣어서 가져오기..가능하려나...
						</div>
					</div>
				</div>
				<!-- 답글1 -->
				<div class="board-reply">
					<div class="profile-pic"><img src=""></div>
					<div class="reply-context">
						<div class="reply-writer">노조원2</div>
						<div class="reply-context-body">
						select * from text where textno= # { textno }and channelno= # {channelno } and answersq>1
						</div>
					</div>
				</div>
				<!-- /답글1 -->
				<!-- 답글2 -->
				<div class="board-reply">
					<div class="profile-pic"><img src=""></div>
					<div class="reply-context">
						<div class="reply-writer">노조원2</div>
						<div class="reply-context-body">
						insert into text values(textnoseq.nextval, # { userno }, # { channelno }, answerseq.nextval, # { textcontent })
						</div>
					</div>
				</div>
				<!-- /답글 2-->
				<!-- /작성자+내용 -->
				
				<!-- 답글입력 -->
				<div class="board-insertReply">
					<div class="reply-dropup">
	                     	<a class="reply-dropbtn" type="button"></a>
	                     	<div class="reply-dropmenu" style="display:none">
	                    		<div class="attach">attach..</div>
		                   		<div class="dropmenu open-map-re">지도 첨부하기</div>
		                   		<div class="dropmenu open-video-re">동영상 첨부하기</div>
								<div class="dropmenu open-link-re">링크 내 텍스트 가져오기</div>
							</div>
		            </div>
		            <div class="reply-input" contentEditable="true"><br></div>
		            <div class="reply-submit">작성</div>
		        </div>
		    </div>
			<!-- /.thread-wrapper -->
			</div>
		
	</div>
	<!-- /inside-wrapper -->
</body>
</html>