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

		session.close();
		return udto;
	}

	// API 로그인
	public UserDto login_by_api(Double userno) {

		session = getSqlSessionFactory().openSession(true);
		udto = session.selectOne("select_user_by_api", userno);

		session.close();

		return udto;
	}

	// 이메일을 통한 유저 정보 조회
	public UserDto select(String useremail) {

		session = getSqlSessionFactory().openSession(true);
		udto = session.selectOne("select_user", useremail);

		session.close();
		return udto;
	}

	// 회원가입 시, 이메일 중복 확인 AJAX에 보낼 데이터
	public int check_email_overlaped(String useremail) {

		session = getSqlSessionFactory().openSession(true);
		
		//이메일 중복 여부에 따른 반환값 유도 작업
		try {
			udto = session.selectOne("select_user", useremail);
			session.close();
			return 1;
		} catch (Exception e) {
			session.close();
			return 0;
		}
		
	}

	// 프로젝트에 속한 유저 목록 조회
	public List<UserDto> select(ProjectDto pdto) {

		List<UserDto> project_user_list = null;
		session = getSqlSessionFactory().openSession(true);

		project_user_list = session.selectList("select_project_user_list", pdto);

		session.close();
		return project_user_list;
	}

	// 채널에 속한 유저 목록 조회
	public List<UserDto> select(ChannelDto cdto) {

		List<UserDto> channel_user_list = null;
		session = getSqlSessionFactory().openSession(true);

		channel_user_list = session.selectList("select_channel_user_list", cdto);

		session.close();
		return channel_user_list;
	}

	// 회원 정보 데이터베이스에 추가
	public int insert(UserDto dto) {

		int result = 0;

		session = getSqlSessionFactory().openSession(true);
		result = session.insert("insert_user", dto);

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

	// 유저 정보 갱신
	public int update(UserDto udto) {

		int result = 0;
		session = getSqlSessionFactory().openSession(true);

		result = session.update("update_userinfo", udto);

		session.commit();
		session.close();

		return result;
	}

}
