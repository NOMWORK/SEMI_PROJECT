package com.nomwork.channel.web;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Arrays;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.nomwork.channel.dao.ChannelDao;
import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;


@WebServlet("/ChannelsServlet")
public class ChannelServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
	
	//각 DAO 객체 생성
	private static final ProjectDao P_DAO = new ProjectDao();
	private static final UserDao U_DAO = new UserDao();
	private static final ChannelDao C_DAO = new ChannelDao();
	//각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	
	//
	private HttpSession session;
	private PrintWriter out;
       
    public ChannelServlet() {  super(); }
	
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[ChannelsServlet - " + command + "]");
		//
		session = request.getSession();
		out = response.getWriter();
		//
		int insert_channel_res = 0;
		int insert_channel_create_res = 0;
		
		if(command.equals("to_add_channel")) {
			response.sendRedirect("channel/add_channel.jsp");
		} //채널 생성
		else if (command.equals("add_channel")) { 	
		
			//생성할 채널의 이름과 유저 목록 받아오기
			String[] add_channel_user_list = request.getParameterValues("checked_userno");
			System.out.println("[ChannelsServlet] 생성할 채널에 속할 유저 리스트 : "+Arrays.toString(add_channel_user_list));
			String cname = request.getParameter("cname");
			
			//채널 DTO 생성
			cdto = new ChannelDto(cname);
			insert_channel_res = C_DAO.insert(cdto);
			
			//현재 세션에 등록되어있는 프로젝트 정보 받아오기
			pdto = (ProjectDto) session.getAttribute("pdto");
			c_cdto = null;
			List<ChannelDto> cdtos = null;
			//
			int userno = 0;
			if(insert_channel_res>0) {
				for(int i=0; i<add_channel_user_list.length; i++) {
					
					//추가할 채널에 속한 유저들 마다 채널 참여 테이블을 생성
					userno = Integer.parseInt(add_channel_user_list[i]);
					c_cdto = new Channel_CreateDto(userno, cdto.getCno(), pdto.getPno());
					insert_channel_create_res = C_DAO.insert(c_cdto);
					
					//채널 참여 테이블 생성 실패시
					if(!(insert_channel_create_res>0)) {
						
						//이미 생성된 CHANNEL 테이블 삭제할 것 (미구현)
						response.sendRedirect("channel/add_channel.jsp");
					}
				}
				//채널 테이블 생성 실패시
			} else response.sendRedirect("channel/add_channel.jsp");
			cdtos = C_DAO.select(c_cdto);
			
			//채널 목록 세션 최신화
			session.setAttribute("cdtos", cdtos);
			dispatch(request, response, "project/main_project.jsp");
			
		}
	}


	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {		
		
		doGet(request, response);
		
	}
	
	public void dispatch(HttpServletRequest request, HttpServletResponse response, String URL)
			throws ServletException, IOException {
		RequestDispatcher dispatcher = request.getRequestDispatcher(URL);
		dispatcher.forward(request, response);
	}

}
