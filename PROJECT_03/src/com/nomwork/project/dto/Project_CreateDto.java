package com.nomwork.project.dto;

public class Project_CreateDto {
	
	private int p_createno;
	private Double userno;
	private int pno;
	
	public Project_CreateDto() {
		super();
	}
	
	public Project_CreateDto(Double userno, int pno) {
		super();
		this.userno = userno;
		this.pno = pno;
	}
	
	public int getP_createno() {
		return p_createno;
	}
	public void setP_createno(int p_createno) {
		this.p_createno = p_createno;
	}
	public Double getUserno() {
		return userno;
	}
	public void setUserno(Double userno) {
		this.userno = userno;
	}
	public int getPno() {
		return pno;
	}
	public void setPno(int pno) {
		this.pno = pno;
	}
	
	@Override
	public String toString() {
		
		return "[ " + p_createno + " , " + userno + " , " + pno + " ]";
	}
	
}
