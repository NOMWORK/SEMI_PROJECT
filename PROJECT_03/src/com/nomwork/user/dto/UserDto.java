package com.nomwork.user.dto;

import java.math.BigInteger;

public class UserDto {
	
	private Double userno;
	private String useremail;
	private String userpw;
	private String username;
	private String usergender;
	private String userenabled;
	private String userrole;
	private String userurl;
	
	public UserDto() {
		super();
	}

	public UserDto(String useremail, String userpw, String username, String userurl) {
		this.useremail = useremail;
		this.userpw = userpw;
		this.username = username;
		this.userurl = userurl;
	}
	
	//api 회원가입에 필요한 생성자
	public UserDto(Double userno, String useremail, String username, String userurl) {
		this.userno = userno;
		this.useremail = useremail;
		this.username = username;
		this.userurl = userurl;
	}
	
	public UserDto(String useremail, String userpw, String username, String usergender, String userurl) {
		this.useremail = useremail;
		this.userpw = userpw;
		this.username = username;
		this.usergender = usergender;
		this.userurl = userurl;
	}
	//회원정보 수정을 위한 생성자
	public UserDto(Double userno, String useremail, String userpw, String username, String usergender, String userurl) {
		this.userno = userno;
		this.useremail = useremail;
		this.userpw = userpw;
		this.username = username;
		this.usergender = usergender;
		this.userurl = userurl;
	}
	
	
	public Double getUserno() {
		return userno;
	}

	public void setUserno(Double userno) {
		this.userno = userno;
	}

	public String getUseremail() {
		return useremail;
	}

	public void setUseremail(String useremail) {
		this.useremail = useremail;
	}

	public String getUserpw() {
		return userpw;
	}

	public void setUserpw(String userpw) {
		this.userpw = userpw;
	}

	public String getUsername() {
		return username;
	}

	public void setUsername(String username) {
		this.username = username;
	}

	public String getUsergender() {
		return usergender;
	}

	public void setUsergender(String usergender) {
		this.usergender = usergender;
	}

	public String getUserenabled() {
		return userenabled;
	}

	public void setUserenabled(String userenabled) {
		this.userenabled = userenabled;
	}

	public String getUserrole() {
		return userrole;
	}

	public void setUserrole(String userrole) {
		this.userrole = userrole;
	}

	
	public String getuserurl() {
		return userurl;
	}

	public void setuserurl(String userurl) {
		this.userurl = userurl;
	}

	@Override
	public String toString() {
		
		return "[ " + userno + " , " + useremail + " , " + userpw + " , " + username + " , " 
				+ usergender + " , " + userenabled + " , " + userrole +" , " + userurl + " ]";
	}
}


