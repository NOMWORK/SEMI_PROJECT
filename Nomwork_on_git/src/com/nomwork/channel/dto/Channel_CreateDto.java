package com.nomwork.channel.dto;

public class Channel_CreateDto {
	
	private int c_cno;
	private int userno;
	private int cno;
	private int pno;
	
	public int getPno() {
		return pno;
	}

	public void setPno(int pno) {
		this.pno = pno;
	}

	public Channel_CreateDto() {
		super();
	}
	
	public Channel_CreateDto(int userno, int cno, int pno) {
		super();
		this.c_cno = c_cno;
		this.userno = userno;
		this.cno = cno;
		this.pno = pno;
	}
	
	public Channel_CreateDto(int userno, int pno) {
		super();
		this.c_cno = c_cno;
		this.userno = userno;
		this.pno = pno;
	}
	
	public int getC_cno() {
		return c_cno;
	}
	public void setC_cno(int c_cno) {
		this.c_cno = c_cno;
	}
	public int getUserno() {
		return userno;
	}
	public void setUserno(int userno) {
		this.userno = userno;
	}
	public int getCno() {
		return cno;
	}
	public void setCno(int cno) {
		this.cno = cno;
	}
	
	
	@Override
	public String toString() {
		return "[ " + c_cno + ", " + userno + ", " + cno + " ]";
	}
}
