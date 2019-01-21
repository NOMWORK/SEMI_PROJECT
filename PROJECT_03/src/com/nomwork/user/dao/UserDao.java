package com.nomwork.user.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import com.nomwork.channel.dto.ChannelDto;
import com.nomwork.channel.dto.Channel_CreateDto;
import com.nomwork.mybatis.SqlMapConfig;
import com.nomwork.project.dto.ProjectDto;
import com.nomwork.project.dto.Project_CreateDto;
import com.nomwork.user.dto.UserDto;

public class UserDao extends SqlMapConfig {

	private SqlSession session;
	// 각 DTO 선언
	private ProjectDto pdto;
	private Project_CreateDto p_cdto;
	private ChannelDto cdto;
	private Channel_CreateDto c_cdto;
	private UserDto udto;

	public UserDto login(UserDto parameter_udto) {

		session = getSqlSessionFactory().openSession(true);
		udto = session.selectOne("login", parameter_udto);

		session.commit();
		session.close();
		return udto;
	}

	public UserDto select(String useremail) {

		session = getSqlSessionFactory().openSession(true);
		udto = session.selectOne("select_user", useremail);

		session.commit();
		session.close();
		return udto;
	}
	
	// 회원가입 시, 이메일 중복 확인 AJAX에 보낼 데이터
	public int check_user_email(String useremail) {

		session = getSqlSessionFactory().openSession(true);
		udto = session.selectOne("select_user", useremail);
		
		if (udto != null) {
			session.commit();
			session.close();
			return 1;
		} else {
			session.commit();
			session.close();
			return 0;
		}
	}

	public List<UserDto> select(ProjectDto pdto) {

		List<UserDto> project_user_list = null;
		session = getSqlSessionFactory().openSession(true);

		project_user_list = session.selectList("select_project_user_list", pdto);

		session.commit();
		session.close();
		return project_user_list;
	}

	public List<UserDto> select(ChannelDto cdto) {

		List<UserDto> channel_user_list = null;
		session = getSqlSessionFactory().openSession(true);

		channel_user_list = session.selectList("select_channel_user_list", cdto);

		session.commit();
		session.close();
		return channel_user_list;
	}

	public int insert(UserDto dto) {

		int result = 0;

		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_member", dto);
		System.out.println(result);
		session.commit();
		session.close();
		return result;
	}


	// 비밀번호 찾기
	public String forgetPw(String useremail) {
		
		String userpw = null;

		session = getSqlSessionFactory().openSession(true);
		userpw = session.selectOne("select_userpw", useremail);
		
		session.commit();
		session.close();
		return userpw;
	}

	// 프로필 사진 바꾸기
	public int update(String userurl, String useremail) {
		
		int result = 0;
		session = getSqlSessionFactory().openSession(true);

		Map<String, String> parameters = new HashMap<String, String>();
		parameters.put("userurl", userurl);
		parameters.put("useremail", useremail);

		result = session.update("update_profile", parameters);

		session.commit();
		session.close();
		return result;
	}

}
