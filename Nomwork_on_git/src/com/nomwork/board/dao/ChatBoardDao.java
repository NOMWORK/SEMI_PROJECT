package com.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.dto.ChatBoardDto;
import com.dto.FileDBDto;

public class ChatBoardDao extends SqlMapConfig{
	private String namespace="com.my.mapper.";
	
	public List<ChatBoardDto> selectProjectno(int projectno){
		SqlSession session = null;
		List<ChatBoardDto> list = null;
		session = getSqlSessionFactory().openSession(true);
		
		list = session.selectList(namespace + "selectprojectno", projectno);

		return list;
	}
	
	public int insertContent(ChatBoardDto dto) {
		SqlSession session = null;
		int result = 0;
		session = getSqlSessionFactory().openSession(true);
		result = session.insert(namespace + "insertContent", dto);
		return result;
		
	}
	
	
	//////////////////게시판/////////////////////////////////////////////////
	public List<ChatBoardDto> selectBoardlist(){
		SqlSession session = null;
		List<ChatBoardDto> list = null;
		
		session = getSqlSessionFactory().openSession(true);
		
		list = session.selectList(namespace + "selectBoardlist");
		
		return list;
	}
	
	public ChatBoardDto selectBoardone(int titleno) {
		SqlSession session = null;
		ChatBoardDto res = null;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.selectOne(namespace + "selectBoardone", titleno);
		
		return res;
	}
	
	public int writeBoard(ChatBoardDto dto) {
		SqlSession session = null;
		int res = 0;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.insert(namespace + "writeBoard", dto);
		
		return res;
	}
	
	public int multiDelete(String[] titleno) {
		int count = 0;
		
		Map<String,String[]> map = new HashMap<String,String[]>();
		map.put("titlenos", titleno);
		
		SqlSession session = null;
		
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
		SqlSession session = null;
		int res = 0;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.insert(namespace + "writeBoardfile", dto);
		
		return res;
	}
	
	public int selectBoardfileno() {
		SqlSession session = null;
		int res = 0;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.selectOne(namespace + "selectBoardfileno");
		
		return res;
	}
	
	public FileDBDto selectBoardfileone(int fileno) {
		SqlSession session = null;
		FileDBDto res = null;
		
		session = getSqlSessionFactory().openSession(true);
		res = session.selectOne(namespace + "selectBoardfileone", fileno);
		
		return res;
	}
}
