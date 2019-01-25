package com.nomwork.project.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.websocket.Session;

import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;

/**
 * Servlet implementation class ProjectsServlet
 */
@WebServlet("/ProjectsServlet")
public class ProjectServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 각 DAO 객체 공유
	private static final ProjectDao P_DAO = new ProjectDao();
	private static final UserDao U_DAO = new UserDao();
	private static final ChannelDao C_DAO = new ChannelDao();
	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	//
	private HttpSession session;
	private PrintWriter out;

	public ProjectServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[ProjectServlet - " + command + "]");
		//
		session = request.getSession();
		out = response.getWriter();

		if (command.equals("to_main_project")) { // 메인 프로젝트 페이지로 이동

			response.sendRedirect("project/main_project.jsp");

		} // 프로젝트 추가 생성
		else if (command.equals("project_add")) {

			List<ProjectDto> pdtos = null;

			String pname = request.getParameter("pname");
			String purl = request.getParameter("purl") + "@nomwork.com";
			// 파라미터로 넘겨받은 값으로 필요한 DTO 객체 생성
			pdto = new ProjectDto(pname, purl);
			udto = (UserDto) session.getAttribute("udto");
			// 파라미터로 객체들을 넘겨주기 위한 작업
			HashMap<String, Object> parameters = new HashMap<String, Object>();
			parameters.put("pdto", pdto);
			parameters.put("udto", udto);

			int insert_project_res = P_DAO.insert(parameters);

			if (insert_project_res > 0) { // 프로젝트, 프로젝트참여, 채널, 채널참여 테이블 생성 성공시
				// 새로 추가한 프로젝트를 포함하는 프로젝트 목록으로 최신화
				pdtos = P_DAO.select_project_list(udto);
				session.setAttribute("pdtos", pdtos);
				// 유저가 참여하고 있는 프로젝트 중 프로젝트번호가 가장 작은 프로젝트로 이동하기 위한 작업
				out.print("<script type='text/javascript'>"
						+ "location.href='Project.ho?command=project_detail';" + "</script>");
			} else { // 테이블 생성 실패시
				out.print("<script type='text/javascript'>" + "location.href='project/index_project.jsp';"
						+ "</script>");
			}
		} // 해당 프로젝트 내로 이동
		else if (command.equals("project_detail")) {

			List<ProjectDto> pdtos = null;
			List<UserDto> channel_user_list = null;
			List<UserDto> udtos = null;
			List<ChannelDto> cdtos = null;

			// 로그인한 유저 정보 세션으로 받기
			udto = (UserDto) session.getAttribute("udto");
			int pno;

			// 프로젝트 번호를 파라미터로 받기
			try {
				pno = Integer.parseInt(request.getParameter("pno"));
			} // 파라미터로 받은 프로젝트번호가 없는 경우
				// 유저가 참여하고 있는 프로젝트 중 프로젝트번호가 가장 작은 프로젝트 조회
			catch (NumberFormatException nfe) {
				System.out.println("[ProjectServlet - 파라미터로 받은 프로젝트 번호가 없는 경우]");
				pdto = P_DAO.select_project_default(udto);
				if(pdto==null) {
					dispatch(request, response, "project/index_project.jsp");
					return;
				} else {
				pno = pdto.getPno();
				}
			}

			pdtos = (List<ProjectDto>) session.getAttribute("pdtos");
			// 현재 세션에 등록된 프로젝트 목록에서 파라미터로 전해받은 프로젝트 검색
			for (int i = 0; i < pdtos.size(); i++) {
				if (pdtos.get(i).getPno() == pno) {
					System.out.println("[ProjectServlet - 현재 세션에 등록된 프로젝트 목록에서 파라미터로 전해받은 프로젝트 검색 성공]");
					pdto = pdtos.get(i);
				}
			}
			// 해당 프로젝트 내 유저가 속한 채널 목록 검색
			c_cdto = new Channel_CreateDto(udto.getUserno(), pno);
			cdtos = C_DAO.select(c_cdto);
			// 최초 프로젝트 내로 진입시 메인 채널을 기본값으로 설정하기 위한 작업
			for (ChannelDto tmp_cdto : cdtos) {
				if (tmp_cdto.getCname().equals("MAIN")) {
					System.out.println("[ProjectServlet - 현재 세션에 등록된 프로젝트 목록에서 메인 채널 검색 성공]");
					cdto = tmp_cdto;
					// 메인 채널에 속한 유저 목록 검색
					channel_user_list = U_DAO.select(cdto);
				}
			}
			// 프로젝트 내에 속한 유저 목록 검색
			udtos = U_DAO.select(pdto);
			//
			session.setAttribute("udtos", udtos);
			session.setAttribute("pdto", pdto);
			session.setAttribute("cdto", cdto);
			session.setAttribute("cdtos", cdtos);
			dispatch(request, response, "project/main_project.jsp");

		} // 프로젝트에 참여시킬 유저 목록
		else if (command.equals("to_project_add_user")) {

			response.sendRedirect("project/add_project_user.jsp");

		} // 프로젝트에 참여시킬 유저 목록
		else if (command.equals("project_add_user_list")) {

			// 새로 추가할 유저 목록과 기존 프로젝트 참여 유저 목록
			List<UserDto> add_user_list = null;
			List<UserDto> udtos = null;

			// 파라미터로 전해받은 이메일값을 통한 유저 정보 검색
			String useremail = request.getParameter("useremail");
			udto = U_DAO.select(useremail);
			//
			try {
				// 이미 프로젝트 참가자 목록에 추가한 경우
				add_user_list = (List<UserDto>) session.getAttribute("add_user_list");
				udtos = (List<UserDto>) session.getAttribute("udtos");

				System.out.println("[ProjectServlet - 초대 목록 " + add_user_list + "]");
				System.out.println("[ProjectServlet - 기존 참여자 목록 " + udtos + "]");

				// 초대목록과 비교
				for (int i = 0; i < add_user_list.size(); i++) {
					if (add_user_list.get(i).getUseremail().equals(useremail)) {
						add_user_list.remove(i);
						System.out.println("[ProjectServlet - 초대 목록 중 추가하려는 이메일과 중복 발생 ]");
					}
				}

				add_user_list.add(udto);
				System.out.println("[ProjectServlet - 초대 목록 갱신 성공 " + add_user_list + "]");

			} // 최초 프로젝트 참가자 추가시
			catch (Exception e) {

				add_user_list = new ArrayList<UserDto>();
				add_user_list.add(udto);

			} // 추가하려는 이메일과 중복 확인하기
			finally {

				// 기존 프로젝트 참여자 목록과 비교
				for (int i = 0; i < udtos.size(); i++) {
					for (int j = 0; j < add_user_list.size(); j++) {
						if (udtos.get(i).getUseremail().equals(add_user_list.get(j).getUseremail())) {
							add_user_list.remove(j);
							System.out.println("[ProjectServlet - 기존 프로젝트 참여자 목록 중 추가하려는 이메일과 중복 발생 ]");
						}
					}
				}
			}
			// 새로운 프로젝트 참가자 목록으로 세션 최신화
			session.removeAttribute("add_user_list");
			session.setAttribute("add_user_list", add_user_list);
			response.sendRedirect("project/add_project_user.jsp");

		} // 해당 유저 초대 목록에서 제거
		else if (command.equals("remove_user_from_list")) {

			List<UserDto> add_user_list = add_user_list = (List<UserDto>) session.getAttribute("add_user_list");

			// 파라미터로 해당 이메일 받기
			String useremail = request.getParameter("useremail");

			// 초대 목록 중 이메일과 일치하는 항목 제거하기
			for (int i = 0; i < add_user_list.size(); i++) {
				if (add_user_list.get(i).getUseremail().equals(useremail)) {
					add_user_list.remove(i);
				}
			}
			// 새로운 프로젝트 참가자 목록으로 세션 최신화
			session.removeAttribute("add_user_list");
			session.setAttribute("add_user_list", add_user_list);
			response.sendRedirect("project/add_project_user.jsp");
		}

		// 프로젝트 참가 유저 추가
		else if (command.equals("project_add_user")) {

			List<UserDto> udtos = null;
			List<ChannelDto> cdtos = null;

			int add_project_create_res = 0;
			int add_channel_create_res = 0;
			// 현재 프로젝트 정보, 채널 정보, 추가할 유저 정보 받아오기
			String[] add_user_list = request.getParameterValues("useremail");
			pdto = (ProjectDto) session.getAttribute("pdto");
			cdto = (ChannelDto) session.getAttribute("cdto");

			// 추가할 유저마다 처리할 작업
			// 해당 프로젝트 및 기본 채널인 메인 채널 참여 테이블 또한 생성시켜야함
			for (int i = 0; i < add_user_list.length; i++) {

				// 이메일 정보로 찾은 유저정보로 프로젝트 참여 테이블 생성
				udto = U_DAO.select(add_user_list[i]);
				p_cdto = new Project_CreateDto(udto.getUserno(), pdto.getPno());
				add_project_create_res = P_DAO.insert(p_cdto);

				if (add_project_create_res > 0) { // 프로젝트 참여 테이블 생성 성공시

					c_cdto = new Channel_CreateDto(udto.getUserno(), cdto.getCno(), pdto.getPno());
					add_channel_create_res = C_DAO.insert(c_cdto);

					// 채널 참여 테이블 생성 실패시
					// 이미 생성된 프로젝트 참여 테이블을 제거해야함 (미구현)
					if (!(add_channel_create_res > 0))
						dispatch(request, response, "add_project_user.jsp");
				} else {
					dispatch(request, response, "add_project_user.jsp");
				}

			}
			// 현재 로그인한 유저 정보 및 채널 정보를 다시 가져온다
			udto = (UserDto) session.getAttribute("udto");
			c_cdto = new Channel_CreateDto(udto.getUserno(), pdto.getPno());
			cdtos = C_DAO.select(c_cdto);

			// 프로젝트 참여 유저목록을 최신화
			udtos = U_DAO.select(pdto);
			session.setAttribute("udtos", udtos);
			session.setAttribute("cdtos", cdtos);
			dispatch(request, response, "project/main_project.jsp");

		}

	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}

	public void dispatch(HttpServletRequest request, HttpServletResponse response, String URL)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher(URL);
		dispatcher.forward(request, response);
	}

}
