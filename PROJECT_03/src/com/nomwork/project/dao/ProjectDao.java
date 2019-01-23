package com.nomwork.project.dao;

import java.util.HashMap;
import java.util.List;

import org.apache.ibatis.session.SqlSession;

import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.mybatis.SqlMapConfig;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.user.dto.UserDto;

public class ProjectDao extends SqlMapConfig {
	
	private SqlSession session;
	//각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	
	public List<ProjectDto> select_project_list(UserDto udto) {
		
		List<ProjectDto> pdtos = null;
		
		session = getSqlSessionFactory().openSession(true);
		pdtos = session.selectList("select_project_list", udto);
		
		session.commit();
		session.close();
		return pdtos;
	}
	
	public ProjectDto select_project_default(UserDto udto) {
		
		session = getSqlSessionFactory().openSession(true);
		pdto = session.selectOne("select_project_default", udto);
		
		session.commit();
		session.close();
		return pdto;
	}
	
	//프로젝트 추가 생성
	//프로젝트 생성시마다 해당 프로젝트의 기본값으로 메인 채널 생성 요구
	//프로젝트, 프로젝트참여, 채널, 채널참여의 테이블 생성이 한번의 절차에 처리
	public int insert(HashMap<String, Object> parameters) {
		
		//
		int insert_project_res = 0;
		int insert_project_create_res = 0;
		int insert_channel_res = 0;
		int insert_channel_create_res = 0;
				
		session = getSqlSessionFactory().openSession(true);
		//
		pdto = (ProjectDto) parameters.get("pdto");
		udto = (UserDto) parameters.get("udto");
		
		// 프로젝트 테이블 생성	
		insert_project_res = session.insert("insert_project",pdto);
		
		if(insert_project_res>0) {	// INSERT_PROJECT 성공시
			
			p_cdto = new Project_CreateDto(udto.getUserno() ,pdto.getPno());
			insert_project_create_res = session.insert("insert_project_create",p_cdto);
			
			if(insert_project_create_res>0) { 	// INSERT_PROJECT_CREATE 성공시
				
				//MABATIS 맵퍼 설정시 cdto.getCname이 NULL일시 
				//자동으로 이름을 MAIN으로 하는 테이블을 생성하도록함
				cdto = new ChannelDto();
				//INSERT의 결과가 cdto 객체에 반환된다.
				insert_channel_res = session.insert("insert_channel", cdto);
				
				if(insert_channel_res>0) {	// INSERT_CHANNEL 성공시
					
					c_cdto = new Channel_CreateDto(udto.getUserno(),cdto.getCno(), pdto.getPno());
					insert_channel_create_res = session.insert("insert_channel_create", c_cdto);
					
					if(insert_channel_create_res>0) {
						session.commit();
						
					} else session.rollback();
				} else session.rollback();
			} else session.rollback();	
		} else session.rollback();
		
		session.commit();
		session.close();
		
		return insert_channel_create_res;
	}
	
	//프로젝트 참여 테이블 생성
	public int insert(Project_CreateDto p_cdto) {
		
		int result = 0;
		
		session = getSqlSessionFactory().openSession(true);
		//
		result = session.insert("insert_project_create",p_cdto);
		
		session.commit();
		session.close();
		
		return result;
	}
}
