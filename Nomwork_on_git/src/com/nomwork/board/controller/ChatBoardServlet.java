package com.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Date;
import java.util.Enumeration;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import com.dao.ChatBoardDao;
import com.dto.ChatBoardDto;
import com.dto.FileDBDto;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;

/**
 * Servlet implementation class ChatBoardServlet
 */
@WebServlet("/ChatBoardServlet")
@ javax.servlet.annotation.MultipartConfig
public class ChatBoardServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    public ChatBoardServlet() {
    }

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		
		String command = request.getParameter("command");
		System.out.println("["+command+"]");
		
		ChatBoardDao dao = new ChatBoardDao();
		
		if(command.equals("selectboardno")) {
			int projectno = 1;
			List<ChatBoardDto> titlelist = dao.selectProjectno(projectno);
			request.setAttribute("titlelist", titlelist);
			dispatch(request, response, "LayoutBoard.jsp");
			
		}
		
		
		
		//게시판///////////////////////////////////////////////////////////////////////////////
		if(command.equals("boardlist")) {
			List<ChatBoardDto> list = dao.selectBoardlist();		
			request.setAttribute("list", list);
			dispatch(request, response, "LayoutBoard.jsp");
		} else if(command.equals("detailboard")) {
			
			int titleno = Integer.parseInt(request.getParameter("titleno"));
			ChatBoardDto dto = dao.selectBoardone(titleno);
		
			PrintWriter pw = response.getWriter();			
			JSONObject obj = new JSONObject();
			
			// filedb에서 select (fileno에 맞는 filetitle 갖고오기)
			FileDBDto filedto = dao.selectBoardfileone(dto.getFileno());
			
			obj.put("filetitle",filedto.getFiletitle());
			//obj.put("fileno", dto.getFileno());
			obj.put("userno",dto.getUserno());
			obj.put("regdate", dto.getRegdate().toString());	
			obj.put("content", dto.getContent());
			obj.put("title", dto.getTitle());

			pw.println(obj.toJSONString());

		} else if(command.equals("writeboard")) {			
			int user = Integer.parseInt(request.getParameter("user"));
			String title = request.getParameter("title");
			String content = request.getParameter("content");
			String fileurl = request.getParameter("fileurl");
			String filetitle = request.getParameter("file");

			
			//FileDB에 파일 저장
			FileDBDto dtofile1 = new FileDBDto();
			FileDBDto dtofile2 = new FileDBDto();
			int resfile = 0;	
			int resfile2 = 0;
			
			if(!(fileurl.equals(""))) {
				dtofile1.setFiles(fileurl+"\\"+filetitle);
				dtofile1.setFiletitle(filetitle);
				
				resfile = dao.writeBoardfile(dtofile1);
			}
	
			ChatBoardDto dto = new ChatBoardDto();
			dto.setUserno(user);
			dto.setTitle(title);
			dto.setContent(content);
			dto.setFileno(0);
			if(resfile>0) {
				resfile2 = dao.selectBoardfileno();
				dto.setFileno(resfile2);		
			}
			
			int res = dao.writeBoard(dto);
			
			if(res>0) {
				jsResponse(response,"ChatBoardServlet.do?command=boardlist","글 작성 완료");
			} else {
				jsResponse(response,"ChatBoardServlet.do?command=boardlist","글 작성 실패");
			}
			

			
			
		} else if(command.equals("deleteboard")) {
			String[] chks = request.getParameterValues("chk");
			
			int res = dao.multiDelete(chks);
			
		    if(res>0){    	
		    	jsResponse(response,"ChatBoardServlet.do?command=boardlist","삭제 성공");
		    }else{
		    	jsResponse(response,"ChatBoardServlet.do?command=boardlist","삭제 실패");        
		    }
		} else if(command.equals("filedown_board")) {
		    String fileName_ = request.getParameter("fileName");
		    String fileName = fileName_.trim();

		    String savePath = "uploadFile"; 
		    String sDownPath = request.getSession().getServletContext().getRealPath(savePath);
		     
		    System.out.println("다운로드 폴더 절대 경로 위치 : " + sDownPath);
		    System.out.println("fileName1 : " + fileName);
		     
		    String sFilePath = sDownPath + "\\" + fileName;
		    System.out.println("sFilePath : " + sFilePath);

		    File outputFile = new File(sFilePath);
		    byte[] temp = new byte[1024*1024*15]; // 15MB
		     
		    FileInputStream in = new FileInputStream(outputFile);
		     
		    String sMimeType = getServletContext().getMimeType(sFilePath);
		    System.out.println("유형 : " + sMimeType);

		    if ( sMimeType == null ){
		        sMimeType = "application.octec-stream"; 
		    }

		    response.setContentType(sMimeType); 

		    String sEncoding = new String(fileName.getBytes("euc-kr"),"8859_1");

		    String AA = "Content-Disposition";
		    String BB = "attachment;filename="+sEncoding;
		    response.setHeader(AA,BB);

		    ServletOutputStream out2 = response.getOutputStream();

		    int numRead = 0;

		    while((numRead = in.read(temp,0,temp.length)) != -1){
		        out2.write(temp,0,numRead);
		    }

		    out2.flush();
		    out2.close();
		    in.close();
		}
	}
	
	public void jsResponse(HttpServletResponse response, String url, String msg) throws IOException {
		String tmp = "<script type='text/javascript'>"+"alert('"+msg+"');"+"location.href='"+url+"';"+"</script>";
		PrintWriter out = response.getWriter();
		out.print(tmp);
	}

	private void dispatch(HttpServletRequest request, HttpServletResponse response, String url) throws ServletException, IOException {

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);
		
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		doPost(request, response);
	}

}
