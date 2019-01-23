package com.nomwork.user.dto;

public class UserDto {
	
	private int userno;
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
	
	public UserDto(String useremail, String userpw, String username, String usergender, String userurl) {
		this.useremail = useremail;
		this.userpw = userpw;
		this.username = username;
		this.usergender = usergender;
		this.userurl = userurl;
		
	}
	
	public int getUserno() {
		return userno;
	}

	public void setUserno(int userno) {
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


