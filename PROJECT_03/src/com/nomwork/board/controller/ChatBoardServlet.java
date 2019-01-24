package com.nomwork.board.controller;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.nomwork.board.dao.ChatBoardDao;
import com.nomwork.board.dto.ChatBoardDto;


/**
 * Servlet implementation class ChatBoardServlet
 */
@WebServlet("/ChatBoardServlet")
public class ChatBoardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
    
	public ChatBoardServlet() {
		super();
	}



	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		String command = request.getParameter("command");
		System.out.println("["+command+"]");
		
		ChatBoardDao dao = new ChatBoardDao();
		
		if(command.equals("selectprojectno")) {
			int projectno = 1;
			//현재 게시판은 1게시판 하나. 이후 변경 예정 projectno = request.getParameter("projectno")
			List<ChatBoardDto> titlelist = dao.selectProjectno(projectno);
			request.setAttribute("titlelist", titlelist);
			dispatch(request, response, "ChatTitle.jsp");
			
		}

		if(command.equals("inserttext")) {
			PrintWriter out = response.getWriter();
			String inputtext = request.getParameter("inputtext");
			ChatBoardDto dto = new ChatBoardDto();
			dto.setUserno(1);
			dto.setContent(inputtext);
			int result = dao.insertContent(dto);
			out.println(inputtext+result);
		}
		
		if(command.equals("pagechange")) {
			int projectno = 1;
			int titleno = 2;
			PrintWriter out = response.getWriter();
			List<ChatBoardDto> titlelist = dao.selectProjectno(projectno);
			request.setAttribute("titlelist", titlelist);
			dispatch(request, response, "ChatTitle.jsp");
			out.println("test");
		}
		
		if(command.equals("selectTen")) {
			int projectno = Integer.parseInt(request.getParameter("projectno"));
			int pageno = Integer.parseInt(request.getParameter("pageno"));
			
			//페이지 숫자 정하는 파트
			int countall = dao.selectcountall(projectno);
			int remain = 0;
			if(countall%10 > 0) {
				remain = 1;
			}
			int numofpages= (countall/10)+remain;
			//전체게시물이 44페이지, 현재 셀렉한 페이지가 42페이지라면, 41-44만 보여줘도 되지 않을까?(인덱스 너비로는 4개겠네. numofpages-10*(numofpages/10)하면 되겠다.)
			//현재 셀렉한 페이지가 33이라면 31-40까지 보여주면 되고.
			
			int indexno = Math.min(10, numofpages-10*((pageno-1)/10));
			System.out.println("min number:"+indexno);
			int[] numofpage = new int[indexno];
			for(int i=0 ; i<indexno ; i++){
				numofpage[i] = i+1+10*((pageno-1)/10);
			}
			
			//페이지에 맞는 게시물 10개만 가져오는 파트
			List<ChatBoardDto> titlelist = dao.selectTen(projectno, pageno);
			request.setAttribute("numofpage", numofpage);
			request.setAttribute("titlelist", titlelist);
			request.setAttribute("pageno", pageno);
			dispatch(request, response, "ChatTitle.jsp");
			
		}
	}
	


	private void dispatch(HttpServletRequest request, HttpServletResponse response, String url) throws ServletException, IOException {

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);
		
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		doGet(request, response);
	}

}
