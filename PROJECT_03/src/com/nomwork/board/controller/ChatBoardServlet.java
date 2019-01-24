package com.nomwork.board.controller;

import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.URLDecoder;
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

import com.nomwork.board.dto.FileDBDto;
import com.nomwork.board.dao.ChatBoardDao;
import com.nomwork.board.dto.ChatBoardDto;
import com.oreilly.servlet.MultipartRequest;
import com.oreilly.servlet.multipart.DefaultFileRenamePolicy;


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
		
		/*if(command.equals("boardlist")) {
			List<ChatBoardDto> list = dao.selectBoardlist();		
			request.setAttribute("list", list);
			dispatch(request, response, "LayoutBoard.jsp");
		}*/ else if(command.equals("detailboard")) {
			
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
			String uploadPath = request.getSession().getServletContext().getRealPath("/uploadFile");  // uploadPath: 절대경로

			int maxSize = 1024 * 1024 * 15; // 한번에 올릴 수 있는 파일 용량 : 15MB로 제한
			
			String file = ""; // 중복처리된 이름
			String originalName1 = ""; // 중복 처리전 실제 원본 이름
			long fileSize = 0;
			String fileType = "";

			String title = null;
			String content = null;
			int user=0;
			     
			MultipartRequest multi = null;
			
			try{
				multi = new MultipartRequest(request,uploadPath,maxSize,"utf-8",new DefaultFileRenamePolicy());

				user = Integer.parseInt(URLDecoder.decode(multi.getParameter("user").trim(), "UTF-8"));
				title = (URLDecoder.decode(multi.getParameter("title").trim(), "UTF-8"));
				content= (URLDecoder.decode(multi.getParameter("content").trim(), "UTF-8"));
				System.out.println(uploadPath);
		        Enumeration files = multi.getFileNames();
				
				while(files.hasMoreElements()){
		            String file1 = (String)files.nextElement(); 
		            originalName1 = multi.getOriginalFileName(file1);
		            file = multi.getFilesystemName(file1);
		            fileType = multi.getContentType(file1);
		            File f = multi.getFile(file1);
		            fileSize = f.length();
				}

				//FileDB에 파일 저장
				FileDBDto dtofile1 = new FileDBDto();
				FileDBDto dtofile2 = new FileDBDto();
				int resfile = 0;	
				int resfile2 = 0;
				
				if(!(originalName1.equals(""))) {
					dtofile1.setFiles(uploadPath+"\\"+file);
					dtofile1.setFiletitle(originalName1);
					
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
				
				PrintWriter pw = response.getWriter();			
				JSONObject obj = new JSONObject();
				obj.put("res", res);
				
				pw.println(obj.toJSONString());
				
			} catch(Exception e){
				e.printStackTrace();
			}
		
		} else if(command.equals("deleteboard")) {
			String[] chks = request.getParameterValues("chk");
			
			int res = dao.multiDelete(chks);
			
		    if(res>0){    	
		    	jsResponse(response,"ChatBoardServlet.do?command=selectTen&projectno=1&pageno=1","삭제 성공");
		    }else{
		    	jsResponse(response,"ChatBoardServlet.do?command=selectTen&projectno=1&pageno=1","삭제 실패");        
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
	


	private void dispatch(HttpServletRequest request, HttpServletResponse response, String url) throws ServletException, IOException {

		RequestDispatcher dispatcher = request.getRequestDispatcher(url);
		dispatcher.forward(request, response);
		
	}
	
	public void jsResponse(HttpServletResponse response, String url, String msg) throws IOException {
		String tmp = "<script type='text/javascript'>"+"alert('"+msg+"');"+"location.href='"+url+"';"+"</script>";
		PrintWriter out = response.getWriter();
		out.print(tmp);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		response.setContentType("text/html; charset=UTF-8");
		doGet(request, response);
	}

}
