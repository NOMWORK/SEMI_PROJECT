package com.nomwork.chat.server;

import java.io.IOException;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.concurrent.CopyOnWriteArraySet;
import java.util.concurrent.atomic.AtomicInteger;

import javax.jws.soap.SOAPBinding.Use;
import javax.servlet.http.HttpSession;
import javax.websocket.EndpointConfig;
import javax.websocket.OnClose;
import javax.websocket.OnError;
import javax.websocket.OnMessage;
import javax.websocket.OnOpen;
import javax.websocket.Session;
import javax.websocket.RemoteEndpoint.Basic;
import javax.websocket.server.ServerEndpoint;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;

//클라이언트가 접속할 때 사용할 URI
@ServerEndpoint(value = "/ChatWS", configurator = GetHttpSessionForWebSocket.class)
public class ChatWSController {
	
	// AtomicInteger 클래스는 getAndIncrement()를 호출할 때마다 카운터를 1씩 증가하는 기능을 가지고 있다.
	private static final AtomicInteger AUTO_INCREASED_TEXT_NO = new AtomicInteger(0);

	private static final java.util.Map<Session, HttpSession> WEBSOCKET_HTTPSESSION_MAP = java.util.Collections
			.synchronizedMap(new java.util.HashMap<Session, HttpSession>());
	private static final java.util.Map<Integer, Session> USERNO_SESSION_MAP = java.util.Collections
			.synchronizedMap(new java.util.HashMap<Integer, Session>());

	// CopyOnWriteArraySey을 사용하면 컬렉션에 저장된 객체를 좀 더 간편하게 추출 할 수 있다.
	// 예를 들어, toArray()메소드를 통해 쉽게 Object[]형의 데이터를 추출할 수 있다.
	private static final Set<ChatWSController> CONNECTION_SET = new CopyOnWriteArraySet<ChatWSController>();
	
	//각 DAO 객체 공유
	private static final ProjectDao P_DAO = new ProjectDao();
	private static final UserDao U_DAO = new UserDao();
	private static final ChannelDao C_DAO = new ChannelDao();
	
	//각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	
	private static JSONArray jsonArr = new JSONArray();
	private static JSONParser jsonParser = new JSONParser();

	// 클라이언트가 새로 접속할 때마다 한 개의 Session 객체가 생성된다.
	// Session 객체를 컬렉션에 보관하여 두고 해당 클라이언트에게 데이터를 전송 할 때마다 사용한다.
	private Session websocket_session;
	private HttpSession http_session;

	// 클라이언트가 새로 접솔할 때마다 이 클래스의 인스턴스가 새로 생성된다.
	// 클라이언트가 새로 접속할 때마다 서버측에서는 Thread가 새로 생성된다.
	private final String THREAD_NAME;

	public ChatWSController() {

		THREAD_NAME = Thread.currentThread().getName();

	}

	// 메소드명은 개발자가 직접 지정할 수 있다.
	// 어노테이션에 따라 구분된다.
	@SuppressWarnings("unchecked")

	@OnOpen
	public void HandleOpen(Session session, EndpointConfig config) {

		// 연결된 클라이언트 정보 받아오기
		// Session : 접속자마다 한 개의 세션이 생성되어 데이터 통신수단으로 사용되며, 접속자마다 구분된다.
		// 한 개의 브라우저에서 여러개의 탭을 사용해서 접속하면 세션은 서로 다르지만 HttpSession은 동일하다.
		this.websocket_session = session;
		this.http_session = (HttpSession) config.getUserProperties().get(HttpSession.class.getName());
		this.udto = (UserDto) http_session.getAttribute("udto");
		this.cdto = (ChannelDto) http_session.getAttribute("cdto");
		int userno = udto.getUserno();
		
		System.out.println("[ChatWsController - 실행된 스레드 : " + THREAD_NAME + "]");
		System.out.println("[ChatWsController - 연결된 웹소켓 세션 : " + websocket_session.getId() + "]");
		System.out.println("[ChatWsController - 연결된 HTTP 세션 : " + http_session.getId() + "]");
		System.out.println("[ChatWsController - 연결된 유저 정보 : " + udto + "]");

		// 사용자 세션이 저장된 객체들을 SET 객체에 저장
		WEBSOCKET_HTTPSESSION_MAP.put(websocket_session, http_session);
		CONNECTION_SET.add(this);
		USERNO_SESSION_MAP.put(userno, websocket_session);

		JSONObject jsonObj = new JSONObject();
		// 클라이언트 쪽에서 해당하는 작업을 하기 위해 명령어를 String으로 준다.
		jsonObj.put("command", "HandleOpen");
		jsonObj.put("userno", udto.getUserno());
		jsonObj.put("cno", cdto.getCno());
		//
		jsonArr.add(jsonObj);
		String jsonStr = jsonArr.toJSONString();
		System.out.println("[ChatWsController - 웹소켓 연결 성공 메세지 : " + jsonStr + "]");

		// 다른 클라이언트에게 접속을 알림
		SendToAll(jsonStr);

	}

	// 현재 세션과 연결된 클라이언트로부터 메세지가 도착할 때마다 새로운 스레드가 실행되어 HandleMessage()를 호출한다.
	@OnMessage
	public void HandleMessage(String json) {
		
		//MAP에서 HTTP 세션 가져오기
		http_session = WEBSOCKET_HTTPSESSION_MAP.get(websocket_session);
		udto = (UserDto) http_session.getAttribute("udto");
		cdto = (ChannelDto) http_session.getAttribute("cdto");
		String thread_name = Thread.currentThread().getName();
		//
		System.out.println("[ChatWsController - 실행된 스레드 : " + thread_name + "]");
		System.out.println("[ChatWsController - 연결된 웹소켓 세션 : " + websocket_session.getId() + "]");
		System.out.println("[ChatWsController - 연결된 HTTP 세션 : " + http_session.getId() + "]");
		System.out.println("[ChatWsController - 연결된 유저 정보 : " + udto + "]");
		
		//메세지가 NULL이거나 비어있는 경우 종료
		if(json == null || json.trim().equals("")) return;
		System.out.println("[ChatWsController - 서버에서 전달받은 메세지 : " + json + "]");
		
		//JSON 관력 객체 선언
		JSONObject jsonObj = null;
		JSONArray jsonArr= null;
				
		try {
			//클라이언트쪽에서 문자열로 넘어온 JSON 오브젝트를 JSON객체로 만들어준다.
			jsonObj = (JSONObject) jsonParser.parse(json);
			jsonArr = new JSONArray();
			//연결중인 세션에서 얻은 채널 객체로 채널에 속한 유저정보를 리스트로 얻는다.
			List<UserDto> channel_user_list = U_DAO.select(cdto);
			//JSON 배열에 메세지를 받을 유저번호를 유저의 수만큼 추가한다.
			for(int i=0; i<channel_user_list.size(); i++) {
				jsonArr.add(new Integer(channel_user_list.get(i).getUserno()));
			}
			SelectUserToMsg(jsonArr, jsonObj);
			
		} catch (ParseException e) {
			e.printStackTrace();
		}
	}

	private void SelectUserToMsg(JSONArray jarr, JSONObject jobj) {

		JSONArray jsonArr = new JSONArray();
		//메세지를 보내는 유저의 이름 정보 추가
		jobj.put("username", udto.getUsername());
		jobj.put("userurl", udto.getuserurl());
		jsonArr.add(jobj);
		System.out.println("[ChatWsController - 뭐가 들었을까? : " + jsonArr + "]");
		
		try {
			int userno = udto.getUserno();
			for (int i = 0; i < jarr.size(); i++) {
				int tmp_userno = 0;
				if(jarr.get(i) instanceof Integer) tmp_userno = (int) jarr.get(i);
				if (!(tmp_userno==(userno))) {
					//접속중인 유저에게만 메세지 보내기
					if(USERNO_SESSION_MAP.get(tmp_userno)!=null) {
					USERNO_SESSION_MAP.get(tmp_userno).getBasicRemote().sendText(jsonArr.toJSONString());
					}
				} else {
				websocket_session.getBasicRemote().sendText(jsonArr.toJSONString());
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	@OnError
	public void HandleError(Throwable t) {
		t.printStackTrace();
	}

	@SuppressWarnings("unchecked")

	@OnClose
	public void HandleClose(Session session) {

		// 사용자가 접속을 중단하면 SET에서 해당 사용자 객체를 삭제
		WEBSOCKET_HTTPSESSION_MAP.remove(this);

		JSONObject jsonObj = new JSONObject();
		// 클라이언트 쪽에서 해당하는 작업을 하기 위해 명령어를 String으로 준다.
		jsonObj.put("command", "HandleClose");
		jsonObj.put("tno", AUTO_INCREASED_TEXT_NO.getAndIncrement());
		jsonObj.put("userno", udto.getUserno());
		jsonObj.put("cno", cdto.getCno());
		jsonObj.put("tcontent", "");
		//
		JSONArray endArr = new JSONArray();
		endArr.add(jsonObj);

		String jsonStr = endArr.toJSONString();
		this.SendToAll(jsonStr);
	}

	private void SendToAll(String jsonStr) {

		Iterator<ChatWSController> tmp_it = CONNECTION_SET.iterator();

		for (int i = 0; i < CONNECTION_SET.size(); i++) {

			ChatWSController client = tmp_it.next();

			try {

				// 여러 사용자의 스레드에서 이 메소드에 접근하기 때문에 ROCK을 건다.
				synchronized (client) {

					// 서버에 접속 중인 모든 이용자에게 메세지를 전송한다.
					// getBasicRemote()로 사용자의 스트림을 얻는다.
					client.websocket_session.getBasicRemote().sendText(jsonStr);
				}
			} catch (IllegalStateException ise) {

				// 특정 클라이언트에게 현재 메세지 보내기 작업 중인 경우에 동시에 쓰기 작업을 요청하면 오류가 발생한다.
				if (ise.getMessage().indexOf("[TEXT_FULL_WRITING]") != -1) {
					new Thread() {

						@Override
						public void run() {

							// 같은 에러가 발생하면 반복문을 통해서 다시 메세지를 전달하게 한다.
							while (true) {

								try {

									client.websocket_session.getBasicRemote().sendText(jsonStr);
									break;
								} catch (IllegalStateException _ise) {

									try {
										// 메세지 보내기 작업을 마치도록 잠시 대기한다.
										Thread.sleep(100);
									} catch (InterruptedException ire) {
										//
									}
								} catch (IOException ioe) {
									ioe.printStackTrace();
								}
							}
						}
					}.start();
				}
			} catch (Exception e) {

				// 메세지 전송 중에 오류가 발생(클라이언트 퇴장을 의미)하면 해당 클라이언트를 서버에서 제거한다.
				System.out.println("ChatWsController(12)"+"오류 발생 : TEXT 전송 중 클라이언트 퇴장");
				CONNECTION_SET.remove(client);

				try {

					// 접속 종료
					client.websocket_session.close();
				} catch (IOException e1) {
					//
				}
				// 해당 클라이언트의 퇴장을 모든 이용자에게 알림
				this.HandleClose(websocket_session);
			}
		}
	}
}
