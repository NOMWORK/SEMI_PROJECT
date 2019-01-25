package com.nomwork.text.dao;

import org.apache.ibatis.session.SqlSession;

import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.map.dto.MapDto;
import com.nomwork.mybatis.SqlMapConfig;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.text.dto.TextDto;
import com.nomwork.user.dto.UserDto;

public class TextDao extends SqlMapConfig {
	
	private SqlSession session;
	//각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;
	private MapDto mdto;
	
	public int insert(TextDto tdto) {

		int result;

		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_text", tdto);

		session.commit();
		session.close();
		return result;
	}
	
	

}
