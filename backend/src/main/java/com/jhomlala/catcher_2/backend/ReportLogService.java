package com.jhomlala.catcher_2.backend;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Service;

@Service
public class ReportLogService {

	private List<ReportLog> reportLogs = new ArrayList<ReportLog>();
	
	public void addReportLog(ReportLog log) {
		reportLogs.add(log);
	}
	
	public List<ReportLog> getReportLogs(){
		return reportLogs;
	}
	
}
