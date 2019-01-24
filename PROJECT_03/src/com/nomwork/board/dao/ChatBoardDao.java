package com.nomwork.board.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import com.nomwork.board.dto.ChatBoardDto;
import com.nomwork.board.dto.FileDBDto;
import com.nomwork.mybatis.SqlMapConfig;

public class ChatBoardDao extends SqlMapConfig{
	
	private String namespace = "";
	private SqlSession session;
	//승혜파트-----------------

	public List<ChatBoardDto> selectProjectno(int projectno){

		List<ChatBoardDto> list = null;
		session = getSqlSessionFactory().openSession(true);
		
		list = session.selectList("selectprojectno", projectno);
		return list;
	}
	
	public int insertContent(ChatBoardDto dto) {
		int result = 0;
		session = getSqlSessionFactory().openSession(true);
		result = session.insert(namespace + "insertContent", dto);
		return result;
		
	}
	public int selectcountall(int projectno) {
		int countall = 0;
		session = getSqlSessionFactory().openSession(true);
		System.out.println(session);
		countall = session.selectOne("selectcountall", projectno );
		System.out.println(countall);
		return countall;
		
	}
	
	public List<ChatBoardDto> selectTen(int projectno, int pageno){
		List<ChatBoardDto> list = null;
		session = getSqlSessionFactory().openSession(true);
		ChatBoardDto dto = new ChatBoardDto();
		dto.setProjectno(projectno);
		dto.setTitleno(pageno);
		list = session.selectList(namespace + "selectten", dto);
		return list;
	}
	//end of 승혜파트--------------
	
	
	//게시판-승빈파트-------------------------------------------------
	public List<ChatBoardDto> selectBoardlist(){
		List<ChatBoardDto> list = null;
		
		session = getSqlSessionFactory().openSession(true);
		
		list = session.selectList(namespace + "selectBoardlist");
		
		return list;
	}
	
	public ChatBoardDto selectBoardone(int titleno) {
		ChatBoardDto res = null;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.selectOne(namespace + "selectBoardone", titleno);
		
		return res;
	}
	
	public int writeBoard(ChatBoardDto dto) {
		int res = 0;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.insert(namespace + "writeBoard", dto);
		
		return res;
	}
	
	public int multiDelete(String[] titleno) {
		int count = 0;
		
		Map<String,String[]> map = new HashMap<String,String[]>();
		map.put("titlenos", titleno);
		
		try {
			session = getSqlSessionFactory().openSession(true);
			count = session.delete(namespace+"multiDelete", map);
			
			if(count==titleno.length) {
				session.commit();
			}
		}catch(Exception e) {
			e.printStackTrace();
		}finally {
			session.close();
		}
		
		return count;
	}
	
	public int writeBoardfile(FileDBDto dto) {
		int res = 0;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.insert(namespace + "writeBoardfile", dto);
		
		return res;
	}
	
	public int selectBoardfileno() {
		int res = 0;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.selectOne(namespace + "selectBoardfileno");
		
		return res;
	}
	
	public FileDBDto selectBoardfileone(int fileno) {
		FileDBDto res = null;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.selectOne(namespace + "selectBoardfileone", fileno);
		
		return res;
	}
	//end of 승빈파트----------

}
