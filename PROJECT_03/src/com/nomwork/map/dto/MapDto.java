package com.nomwork.map.dto;

public class MapDto {

	private int mno;
	private double latitude;
	private double longitude;

	public MapDto() {

	}

	public MapDto(int mno) {
		this.mno = mno;
	}

	public MapDto(double latitude, double longitude) {
		this.latitude = latitude;
		this.longitude = longitude;
	}

	public int getmno() {
		return mno;
	}

	public void setmno(int mno) {
		this.mno = mno;
	}

	public double getLatitude() {
		return latitude;
	}

	public void setLatitude(double latitude) {
		this.latitude = latitude;
	}

	public double getLongitude() {
		return longitude;
	}

	public void setLongitude(double longitude) {
		this.longitude = longitude;
	}
}
