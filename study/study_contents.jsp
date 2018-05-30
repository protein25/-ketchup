<%@page import="com.sist.big.vo.UserVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.vo.BoardVO"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@page import="com.sist.big.common.DTO"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.big.common.StringUtil"%>
<%@page import="com.sist.big.code.dao.CodeDAO"%>
<%@page import="com.sist.big.code.vo.CodeVO"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>


<%
	Logger LOG = Logger.getLogger(this.getClass());

	CodeVO vo01 = new CodeVO();
	vo01.setMst_cd_id("C007");
	CodeDAO codeDao = new CodeDAO();
	List<DTO> list = codeDao.do_selectList(vo01);

	BoardVO vo = null;

	String bId = "";
	int bNo = 0;

	if (null != request.getAttribute("bc_vo")) {
		vo = (BoardVO) request.getAttribute("bc_vo");
		bId = StringUtil.nvl(vo.getbId(), "");
		bNo = vo.getbNo();
		LOG.debug("[study contents]" + bId + "," + bNo);
	} else {
		vo = new BoardVO();
	}
	LOG.debug("[study contents] st_vo.toString()" + vo.toString());
	
	UserVO logVO = null;
	String id = null;
	if(null != (UserVO)session.getAttribute("loginvo")){
		logVO = (UserVO)session.getAttribute("loginvo");
		id = logVO.getEmail();
	LOG.debug("logVO.getEmail()="+id);
	}else{
		logVO = null;
	}
	
	boolean login = logVO == null ? false : true; //로그인 여부 확인
	LOG.debug(login);
	
	//줄바꿈
	pageContext.setAttribute("br", "<br/>");
	pageContext.setAttribute("cn", "\n");
%>


<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>

	<form name="frmsc" id="frmsc"
		action="<%=BIGConst.context%>/board.do" method="post">
		<!--글쓰기 -->
		<!-- <form id="boardContentsForm"> -->
		<input type="hidden" name="workDiv" id="workDivsc" /> 
		<input type="hidden" name="bId" id="bIdsc" value="<%=vo.getbId()%>" /> 
		<input type="hidden" name="bNo" id="bNosc" value="<%=vo.getbNo()%>" /> 
		<input type="hidden" name="cId" id="cIdsc" value="${bc_vo.cId}" />
		<input type="hidden" name="reNum" id="reNumsc" value="${bc_vo.reNum }" />
		<input type="hidden" name="loc" id="locsc" value="${bc_vo.loc }" />
		<input type="hidden" name="contents" id="contentssc" value="${bc_vo.contents}" />
		<input type="hidden" name="title" id="titlesc" value="${bc_vo.title}" />
		<input type="hidden" name="writeDate" id="writeDatesc" value="${bc_vo.writeDate}" />
		<input type="hidden" name="email" id="emailsc" value="${bc_vo.email}" />
		
		<div class="container boardContents">
			<table width="100%" border="0" summary>
				<tbody>
					<tr>
						
							<div class="context">
								<td><c:out value="${bc_vo.title}" /></td>
						
						<td class="wdate" colspan="3"><c:out
								value="${bc_vo.writeDate }" /></td>
					</tr>
					<tr class="detail">
						<td>모집인원 : <c:out value="${bc_vo.reNum }" /></td>
						<td>장소 : <c:out value="${bc_vo.loc }" /></td>
						<td>작성자 : <c:out value="${bc_vo.nickName}" /></td>
						<td>조회수 : <c:out value="${bc_vo.readCnt}" /></td>
					</tr>
					<tr>
						<td colspan="4" height="200">
							<div class="context">
								${fn:replace(bc_vo.contents,cn,br) }
							</div>
						</td>
					</tr>
				</tbody>
			</table>
			
			<!-- 즐찾/신고 -->
			<div class="contents-footer" id="sfavofavo">
            	<p class="footer-p"> 
		            <c:choose>
		            <c:when test="${faflag == 'false' }" >
		            <a href="#" id="favoa" class="favorite" onclick="addsfa();">즐찾</a>
		            </c:when>
		            <c:when test="${faflag == 'true' }">
		            <a href="#" id="favoadel" class="favorite" onclick="delsfa();">즐찾 해제</a>
		            </c:when>
		            </c:choose>
            	</p>  
  			<!--// 즐찾/신고 -->
        </div>
        <c:if test="${loginvo.email == bc_vo.email}">
	         <div class="board-contents-bottom">
	            <button class="btn btn-board-write pull-right" id="writesc" onclick="javascript:ctrUpdate()">수정</button>
	            <button class="btn btn-board-write pull-right" id="cancelsc" onclick="javascript:ctrDel()">삭제</button>
	        </div>
        </c:if>
       
        </form>
        
		<form name="frmc2" id="frmc2" action="<%=BIGConst.context%>/comment.do" method="post">
	       	<input type="hidden" id="workDivc2" name="workDiv"/>
	       	<input type="hidden" id="cNoc2" name="cNo"/>
	       	<input type="hidden" name="bId" id="bIdc2" value="${bc_vo.bId}" />  
			<input type="hidden" name="bNo" id="bNoc2" value="${bc_vo.bNo}" />
			<input type="hidden" name="email" id="emailc2" value="${loginvo.email }"/>
			    
			
	        <div>
	            <label>COMMENT</label>
	        </div>
	        <table width="100%" border="0" summary>
	            <div id="studyBoardComment">
	            <tbody>
	            	<c:choose>
	            		<c:when test="${listco.size()>0 }">
	            			<c:forEach var="commentVO" items="${listco }">
	            				<tr>
	            					
	            					<td><c:out value="${commentVO.nickName}"/></td>
				                    <td class="col-xs-7"><c:out value="${commentVO.contents }"/></td>
				                    <td>
				                    	<c:if test="${loginvo.email != commentVO.email}">
				                        <a href="#" class="favorite">신고하기</a>
				                        </c:if>
				                        <c:if test="${loginvo.email == commentVO.email}">
				                        <a href="#" onclick="ctrUpdatec()">수정</a>
	          							<a href="#" onclick="ctrDelc(${commentVO.cNo})">삭제</a>
	          							
				                    	</c:if>
				                    </td>
				                    <td><c:out value="${commentVO.writeDate }"/></td>
				                    
				                    
				                </tr> 
	                </c:forEach>
	                </c:when>
	                <c:otherwise>
	                	<tr>
	                		<td colspan="99"> 등록된 댓글이 없습니다.</td>
	                	</tr>
	                </c:otherwise>
	                </c:choose>
	            </tbody>
	            </div>
	        </table>
	        
	         <%if(login==true){ %>
        <div class="contents-comment">
            <div class="input-group">
                    
            <textarea class="form-control" id="contentsc2" name="contents" rows="3" placeholder="댓글입력해" style="resize: none"></textarea>
            <span class="input-group-addon btn btn-default" id="addBtn" >댓글 쓰기</span>
            </div>

        </div>
		<%} %>
	        
	    <div class="container comments">
	        <table width="100%" border="0" summary>
	            
	        </table>
	    </div>
	
	</form>
	<div class="contents-footer">

		<form name="addFavs" id="addFavs" method="post" action="javascript:addFavs();">
			<input type="hidden" name="workDiv" id="workDiv"/>
			<input type="hidden" name="bId" id="bId" value="<%=vo.getbId()%>" />
			<input type="hidden" name="bNo" id="bNod" value="<%=vo.getbNo()%>" />
			<input type="button" value="favs" />
		</form>
		-->
	</div>

	<!--글쓰기 -->
	
	<script type="text/javascript">

	
	//즐겨찾기 추가
	function addsfa(){
		
		$.ajax({
			  type: 'POST',
			  url: '/BIG/board.json',
			  dataType:"html",// JSON
			  data: {
				 "workDiv": "5000",
				 "bId": "<%=vo.getbId()  %>",
				 "bNo":<%=vo.getbNo() %>,
				 "email":"<%=id %>"
			  },
			  success: function(data){//통신이 성공적으로 이루어 졌을때 받을 함수	 
		          var outMessage = data.split("|");
		          if(outMessage.length>0){
		        	  if(outMessage[0]=="1"){
		        		alert(outMessage[1]+outMessage[2]);
		        		$("#sfavofavo").html("<p><a href='#' id='favoadel' class='favorite' onclick='delsfa();'>즐찾 해제</a></p>");

		        	  } else if(outMessage[0]=="0") {
		        		alert(outMessage[1]);

		        	  }
		          }  
		         },
		         complete: function(data){//무조건 수행
			          
		         },
			  error: function(xhr,status,error){
					  console.log(error)
				  }
		  	});//addfa ajax
	}
	
	//즐겨찾기 해제
	function delsfa(){
		alert("즐겨찾기를 해제하였습니다");
		
		$.ajax({
			  type: 'POST',
			  url: '/BIG/board.json',
			  dataType:"html",// JSON
			  data: {
				 "workDiv": "6000",
				 "bId": "<%=vo.getbId()  %>",
				 "bNo":<%=vo.getbNo() %>,
				 "email":"<%=id %>"
			  },
			  success: function(data){//통신이 성공적으로 이루어 졌을때 받을 함수	 
		          var outMessage = data.split("|");
		          if(outMessage.length>0){
		        	  if(outMessage[0]=="1"){
		        		alert(outMessage[1]);
		        		$("#sfavofavo").html("<p><a href='#' id='favoa' class='favorite' onclick='addsfa();'>즐찾</a></p>");

		        	  } else if(outMessage[0]=="0") {
		        		alert(outMessage[1]);

		        	  }
		          }  
		         },
		         complete: function(data){//무조건 수행
			          
		         },
			  error: function(xhr,status,error){
					  console.log(error)
				  }
		  	});//addfa ajax
	
	/*글수정*/
	function ctrUpdate(){
		if(false == confirm("수정 하시겠습니까?")) return;
		
		var frm = document.frmsc;
		frm.workDiv.value = "2100";
		frm.bId.value = $("#bIdsc").val();
		frm.bNo.value = $("#bNosc").val();
		frm.cId.value = $("#cIdsc").val();
		
		frm.action = "/BIG/board.do";
		frm.submit();
	}
	
	/*삭제*/
	function ctrDel(){
		if(false == confirm("삭제 하시겠습니까?")) return;
		
		var frm = document.frmsc;
		frm.workDiv.value = "4000";
		alert(frm.workDiv.value);
		frm.action = "/BIG/board.do";
		frm.submit();
	}
	
	function addFavs(){
		if (false==cofirm("즐겨찾기에 추가하시겠습니까?")) return;
		
		var flag = -1;
		
		var frm = document.addFavs;
		
		frm.workDiv.value = "5000"
		frm.action = "/BIG/board.do";
		frm.submit();
	}	

	
	function ctrUpdatec(){
		if(false == confirm("댓글 수정 하시겠습니까?")) return;
			$("#contentsc2").focus();
	}
			
	}
	
	function ctrDelc(commentNo){
		var cNo = commentNo;
		
		//$("#cNoc2").val(cNo);
		//$("#workDivc2").val('4000');
		
		var frm1 = document.frmc2;
		frm1.cNo.value=cNo;
		frm1.workDiv.value = "4000";
		alert(frm1.cNo.value);
		alert(frm1.workDiv.value);
		
		frm1.action = "/BIG/comment.do";
		frm1.submit();
		
		
	}
	
	/*
	data={"cNo":205,"contents":"dddd","writeDate":"2018-05-03 11:31:48.0","email":"yy","bId":"10b","bNo":82,"nickName":"상추상yy","messageDiv":"1","message":"등록 되었습니다.","num":0,"totalCnt":0,"pageNum":1,"pageSize":10,"searchDiv":0}
	*/	
	
	 $(document).ready(function(){
	
		 /*댓글 추가*/
		 $("#addBtn").on("click", function(){
			 console.log("ctrAddc=");
			 $("#workDivc2").val('2000');
			 $.ajax({
				    type:"POST",
				    url:'/BIG/comment.json',
				    dataType:"html", //option default : html
				    data: $("#frmc2").serialize(),
				    success: function(data){ //통신이 성공적으로 이루어 졌을 때 받을 함수
				    	var commentVO = $.parseJSON(data);
				        var outMessage = commentVO.messageDiv;
				    	console.log("commentVO.messageDiv="+commentVO.messageDiv);
				    	console.log("commentVO.message="+commentVO.message);
				    	alert(commentVO.message);
				    	if(outMessage=="1"){
				    		//$("#studyBoardComment").append("<tr> <td>"+commentVO.nickName+"</td> <td class='col-xs-7'>"+commentVO.contents+"</td> <td>"+commentVO.writeDate+"</td> </tr>");
				    		location.reload();
				    	}else{
				    		
				    	}
				    },
				    complete: function(data){ //실패 성공 상관없이 무조건 수행
				     
				    }, 
				    error: function(xhr, status, error){
				     
				    }
				  });			 
		 });

		 //<button id="delbtn" value="${commentVO.cNo}">삭제</button>
		 
		
	 });
	
	
</script>
</body>
</html>