package com.nomwork.map.web;

import java.io.IOException;
import java.io.PrintWriter;

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
import com.nomwork.map.dao.MapDao;
import com.nomwork.map.dto.MapDto;
import com.nomwork.project.dao.ProjectDao;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dao.UserDao;
import com.nomwork.user.dto.UserDto;

/**
 * Servlet implementation class MapServlet
 */
@WebServlet("/MapServlet")
public class MapServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	// 각 DAO 객체 생성
	private static final ProjectDao P_DAO = new ProjectDao();
	private static final UserDao U_DAO = new UserDao();
	private static final ChannelDao C_DAO = new ChannelDao();
	private static final MapDao M_DAO = new MapDao();
	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;

	private HttpSession session;
	private PrintWriter out;

	public MapServlet() {
		super();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");

		String command = request.getParameter("command");
		System.out.println("[MapServlet - " + command + "]");

		session = request.getSession();
		out = response.getWriter();

		int insert_map_res = 0;

		if (command.equals("insert_map")) {

			// 파라미터로 위도 경도값 받기
			double latitude = Double.parseDouble(request.getParameter("latitude"));
			double longitude = Double.parseDouble(request.getParameter("longitude"));

			mdto = new MapDto(latitude, longitude);

			insert_map_res = M_DAO.insert(mdto);

			if (insert_map_res > 0) {
				dispatch(request, response, "project/main_project.jsp");
			}
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
