package com.jhomlala.catcher_2.backend;

import java.sql.Timestamp;
import java.util.Map;
import java.util.Map.Entry;

public class ReportLog {
	private String error;
	private String stackTrace;
	private Map<String,Object> deviceParameters;
	private Map<String,String> applicationParameters;
	private Map<String,String> customParameters;
	private Timestamp dateTime;
	public String getError() {
		return error;
	}
	public void setError(String error) {
		this.error = error;
	}
	public String getStackTrace() {
		return stackTrace;
	}
	public void setStackTrace(String stackTrace) {
		this.stackTrace = stackTrace;
	}
	public Map<String, Object> getDeviceParameters() {
		return deviceParameters;
	}
	public void setDeviceParameters(Map<String, Object> deviceParameters) {
		this.deviceParameters = deviceParameters;
	}
	public Map<String, String> getApplicationParameters() {
		return applicationParameters;
	}
	public void setApplicationParameters(Map<String, String> applicationParameters) {
		this.applicationParameters = applicationParameters;
	}
	public Map<String, String> getCustomParameters() {
		return customParameters;
	}
	public void setCustomParameters(Map<String, String> customParameters) {
		this.customParameters = customParameters;
	}
	
	public Timestamp getDateTime() {
		return dateTime;
	}
	public void setDateTime(Timestamp dateTime) {
		this.dateTime = dateTime;
	}
	@Override
	public String toString() {
		return "ReportLog [error=" + error + ", stackTrace=" + stackTrace + ", deviceParameters=" + deviceParameters
				+ ", applicationParameters=" + applicationParameters + ", customParameters=" + customParameters
				+ ", dateTime=" + dateTime + "]";
	}
	
	public String getStackTraceFormatted() {
		return "<small>"+stackTrace.replace("\n", "<br>")+"</small>";
	}
	
	public String getDeviceDataFormatted() {
		String text = "<small>";
		for (Entry<String, Object> entry: deviceParameters.entrySet()) {
			text += "<b>"+entry.getKey()+"</b>:"+entry.getValue() +"<br>";
		}
		text += "</small>";
		return text;
	}
	
	
}
