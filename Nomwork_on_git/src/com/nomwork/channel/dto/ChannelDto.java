package com.nomwork.channel.dto;

import java.util.Date;

public class ChannelDto {
	
	private int cno;
	private String cname;
	private String cstatus;
	private Date ctime;
	
	public ChannelDto() {
		super();
	}
	
	public ChannelDto(String cname) {
		super();
		this.cname = cname;
	}
	
	public ChannelDto(int cno, String cname, String cstatus, Date ctime) {
		super();
		this.cno = cno;
		this.cname = cname;
		this.cstatus = cstatus;
		this.ctime = ctime;
	}
	
	public int getCno() {
		return cno;
	}
	public void setCno(int cno) {
		this.cno = cno;
	}
	public String getCname() {
		return cname;
	}
	public void setCname(String cname) {
		this.cname = cname;
	}
	public String getCstatus() {
		return cstatus;
	}
	public void setCstatus(String cstatus) {
		this.cstatus = cstatus;
	}
	public Date getCtime() {
		return ctime;
	}
	public void setCtime(Date ctime) {
		this.ctime = ctime;
	}
	
	@Override
	public String toString() {
		return "[ " + cno + ", " + cname + ", " + cstatus + ", " + ctime + " ]";
		
	}

}
