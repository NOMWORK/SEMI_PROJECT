package com.nomwork.project.dto;

public class ProjectDto {
	
	private int pno;
	private String pname;
	private String purl;
	
	public ProjectDto() {
		super();
	}

	public ProjectDto(String pname, String purl) {
		super();
		this.pname = pname;
		this.purl = purl;
	}

	public int getPno() {
		return pno;
	}

	public void setPno(int pno) {
		this.pno = pno;
	}

	public String getPname() {
		return pname;
	}

	public void setPname(String pname) {
		this.pname = pname;
	}

	public String getpurl() {
		return purl;
	}

	public void setpurl(String purl) {
		this.purl = purl;
	}
	@Override
	public String toString() {
		
		return "[ " + pno + " , " + pname + " , " + purl + " ]";
	}
	
	

}
