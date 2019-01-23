package com.dto;

public class FileDBDto {

	private int fileno;
	private String files;
	private String filetitle;
	
	public FileDBDto() {
		
	}

	public FileDBDto(int fileno, String files, String filetitle) {
		super();
		this.fileno = fileno;
		this.files = files;
		this.filetitle = filetitle;
	}

	public int getFileno() {
		return fileno;
	}

	public void setFileno(int fileno) {
		this.fileno = fileno;
	}

	public String getFiles() {
		return files;
	}

	public void setFiles(String files) {
		this.files = files;
	}

	public String getFiletitle() {
		return filetitle;
	}

	public void setFiletitle(String filetitle) {
		this.filetitle = filetitle;
	}
	
	
}
