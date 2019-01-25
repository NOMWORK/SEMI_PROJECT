package com.nomwork.text.dto;

import java.util.Date;

public class TextDto {

	private int tno;
    private Double userno;
    private int cno;
    private int answersq;
    private String tcontent;
    private String tip;
    private Date ttime;
    private int mno;
    private int fno;
    
	public TextDto() {
		super();
	}

	public TextDto(Double userno, int cno, String tcontent) {
		super();
		this.userno = userno;
		this.cno = cno;
		this.tcontent = tcontent;
	}
	
	public TextDto(Double userno, int cno, int mno) {
		super();
		this.userno = userno;
		this.cno = cno;
		this.mno = mno;
	}



	public TextDto(int tno, Double userno, int cno, int answersq, String tcontent, String tip, Date ttime, int mno,
			int fno) {
		super();
		this.tno = tno;
		this.userno = userno;
		this.cno = cno;
		this.answersq = answersq;
		this.tcontent = tcontent;
		this.tip = tip;
		this.ttime = ttime;
		this.mno = mno;
		this.fno = fno;
	}

	public int getTno() {
		return tno;
	}

	public void setTno(int tno) {
		this.tno = tno;
	}

	public Double getUserno() {
		return userno;
	}

	public void setUserno(Double userno) {
		this.userno = userno;
	}

	public int getCno() {
		return cno;
	}

	public void setCno(int cno) {
		this.cno = cno;
	}

	public int getAnswersq() {
		return answersq;
	}

	public void setAnswersq(int answersq) {
		this.answersq = answersq;
	}

	public String getTcontent() {
		return tcontent;
	}

	public void setTcontent(String tcontent) {
		this.tcontent = tcontent;
	}

	public String getTip() {
		return tip;
	}

	public void setTip(String tip) {
		this.tip = tip;
	}

	public Date getTtime() {
		return ttime;
	}

	public void setTtime(Date ttime) {
		this.ttime = ttime;
	}

	public int getMno() {
		return mno;
	}

	public void setMno(int mno) {
		this.mno = mno;
	}

	public int getFno() {
		return fno;
	}

	public void setFno(int fno) {
		this.fno = fno;
	}
    
    @Override
    public String toString() {
    	return "["+ tno + ", " + userno + ", " + cno + ", " + answersq + ", " + tcontent
    			+ ", " + tip + ", " + ttime + ", " + mno + ", " + fno + "]";
    }

}
