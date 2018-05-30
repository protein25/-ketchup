<%@page import="java.util.ArrayList"%>
<%@page import="com.sist.big.vo.StatisticsVO"%>
<%@page import="java.util.List"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
	Logger log = Logger.getLogger(this.getClass());

%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>
	<table id="chartTable" style="width: 100%;">
	   <tbody>
	   <tr style="width: 100%;">
	   <td>
		<!-- 회사 pie chart -->
		<div id="cocc"></div>
	  </td>
      <td>
		<!-- 직무 bar chart -->
		<div id="jobcc"></div>
	  </td>
      <td>
		<!-- 로그인 타임 line chart -->
		<div id="logincc"></div>
	  </td>
       </tr>
       </tbody>
    </table>

	<script type="text/javascript">
	//회사
	google.charts.load('current', {'packages':['corechart']});
    google.charts.setOnLoadCallback(coChart);
    //직무
    google.charts.load('current', {packages: ['corechart', 'bar']});
    google.charts.setOnLoadCallback(jobChart);
    //로그인 타임
    google.charts.load('current', {packages: ['corechart', 'line']});
    google.charts.setOnLoadCallback(loginChart);

	function coChart(){
		var coJsonData = $.ajax({
			url: "/BIG/main.json",
			  dataType:"html",// JSON
			  data: {
				  workDiv: "3000"
				  },
			  async: false
			}).responseText;
		
		var coArr = JSON.parse(coJsonData);
		
		var data = new google.visualization.DataTable();
		data.addColumn('string', '회사명');
	    data.addColumn('number', '회원 수');
	    
	    for(var i =0;i<coArr.length;i++){
	    	  data.addRow(coArr[i]);
	      }
		
	      var options = {
	        title: '유저 선호 회사 순위',
	        chartArea: {width: '50%'},
	        colors: ['#ED242D', '#F37720', '#FFCD34','#0080A4','#23A1A4'],
	      };
	      
	      var chart = new google.visualization.PieChart(document.getElementById('cocc'));

	        chart.draw(data, options);
	}
    
    //직무 bar chart
	function jobChart() {
    	
		var jobJsonData = $.ajax({
  		  url: "/BIG/main.json",
  		  dataType:"html",// JSON
  		  data: {
  			  workDiv: "1000"
  			  },
  		  async: false
		}).responseText;
		
		var jobArr = JSON.parse(jobJsonData);
		//console.log("newArr = "+ jobArr);
		//console.log("newArr[0]="+ jobArr[0]);

        var data = new google.visualization.DataTable();
	      
	      data.addColumn('string', '직업');
	      data.addColumn('number', '회원 수');

	      
	      for(var i =0;i<jobArr.length;i++){
	    	  data.addRow(jobArr[i]);
	      }
		
	      var options = {
	        title: '유저 선호 직무 순위',
	        chartArea: {width: '50%'},
	        colors: ['#F96360'],
	      };
		
	      var chart = new google.visualization.BarChart(document.getElementById('jobcc'));
	
	      chart.draw(data, options);
	}
    
	function loginChart() {
		var loginJsonData = $.ajax({
	  		  url: "/BIG/main.json",
	  		  dataType:"html",// JSON
	  		  data: {
	  			  workDiv: "2000"
	  			  },
	  		  async: false
			}).responseText;
		
		var loginArr = JSON.parse(loginJsonData);
		//console.log("loginArr = "+ loginArr);
		//console.log("loginArr[0]="+ loginArr[0]);
		
		var data = new google.visualization.DataTable();
			data.addColumn('string', '로그인시간');
	      	data.addColumn('number', '회원 수');
	      	
      	for(var i =0;i<loginArr.length;i++){
	    	  data.addRow(loginArr[i]);
	      }
      	var options = {
    	        title: '유저 로그인 시간',
    	        chartArea: {width: '50%'},
    	        colors: ['#F8BD25'],
    	      };
      	var chart = new google.visualization.LineChart(document.getElementById('logincc'));

        chart.draw(data, options);
	}
    
    

      

      
    </script>
	
</body>
</html>