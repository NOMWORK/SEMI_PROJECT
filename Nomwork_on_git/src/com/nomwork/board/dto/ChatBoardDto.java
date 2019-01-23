package com.dto;

import java.util.Date;

public class ChatBoardDto {
/*	TITLENO NUMBER PRIMARY KEY,
	USERNO NUMBER, 
	projectno NUMBER,
	ANSWERSQ NUMBER NOT NULL,
	TITLE VARCHAR2(100) NOT NULL,
	CONTENT VARCHAR2(2000) NOT NULL,
	DELFLAG VARCHAR2(1),
	REGDATE DATE NOT NULL,
	MAPNO NUMBER,
	FILENO NUMBER, */
	
	private int titleno;
	private int userno;
	private int projectno;
	private String title;
	private String content;
	private String delflag;
	private Date regdate;
	private int mapno;
	private int fileno;
	
	
	public int getTitleno() {
		return titleno;
	}

	public void setTitleno(int titleno) {
		this.titleno = titleno;
	}

	public int getUserno() {
		return userno;
	}

	public void setUserno(int userno) {
		this.userno = userno;
	}

	public int getProjectno() {
		return projectno;
	}

	public void setProjectno(int projectno) {
		this.projectno = projectno;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getContent() {
		return content;
	}

	public void setContent(String content) {
		this.content = content;
	}

	public String getDelflag() {
		return delflag;
	}

	public void setDelflag(String delflag) {
		this.delflag = delflag;
	}

	public Date getRegdate() {
		return regdate;
	}

	public void setRegdate(Date regdate) {
		this.regdate = regdate;
	}

	public int getMapno() {
		return mapno;
	}

	public void setMapno(int mapno) {
		this.mapno = mapno;
	}

	public int getFileno() {
		return fileno;
	}

	public void setFileno(int fileno) {
		this.fileno = fileno;
	}

	public ChatBoardDto() {
	}

	public ChatBoardDto(int titleno, int userno, int projectno, String title, String content,
			String delflag, Date regdate, int mapno, int fileno) {
		this.titleno = titleno;
		this.userno = userno;
		this.projectno = projectno;
		this.title = title;
		this.content = content;
		this.delflag = delflag;
		this.regdate = regdate;
		this.mapno = mapno;
		this.fileno = fileno;
	}
	
	
	
	
	
	
}
