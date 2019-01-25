package com.nomwork.board.dto;

import java.util.Date;

public class ChatBoardDto {
/*	boardno NUMBER PRIMARY KEY,
	USERNO NUMBER, 
	projectno NUMBER,
	ANSWERSQ NUMBER NOT NULL,
	TITLE VARCHAR2(100) NOT NULL,
	CONTENT VARCHAR2(2000) NOT NULL,
	DELFLAG VARCHAR2(1),
	REGDATE DATE NOT NULL,
	MAPNO NUMBER,
	FILENO NUMBER, */
	
	private int boardno;
	private int userno;
	private int projectno;
	private String boardtitle;
	private String boardcontent;
	private String delflag;
	private Date regdate;
	private int mapno;
	private int fileno;
	
	public ChatBoardDto() {
		
	}
	public ChatBoardDto(int boardno, int userno, int projectno, String boardtitle, String boardcontent, String delflag,
			Date regdate, int mapno, int fileno) {
		this.boardno = boardno;
		this.userno = userno;
		this.projectno = projectno;
		this.boardtitle = boardtitle;
		this.boardcontent = boardcontent;
		this.delflag = delflag;
		this.regdate = regdate;
		this.mapno = mapno;
		this.fileno = fileno;
	}
	public int getBoardno() {
		return boardno;
	}
	public void setBoardno(int boardno) {
		this.boardno = boardno;
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
	public String getBoardtitle() {
		return boardtitle;
	}
	public void setBoardtitle(String boardtitle) {
		this.boardtitle = boardtitle;
	}
	public String getBoardcontent() {
		return boardcontent;
	}
	public void setBoardcontent(String boardcontent) {
		this.boardcontent = boardcontent;
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
	
	
	
	
	
	
	
	
	
	
}
