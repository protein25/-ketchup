<%@page import="com.sist.big.vo.UserVO"%>
<%@page import="com.sist.big.vo.CommentVO"%>
<%@page import="com.sist.big.common.StringUtil"%>
<%@page import="com.sist.big.vo.BoardVO"%>
<%@page import="com.sist.big.common.DTO"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.big.code.dao.CodeDAO"%>
<%@page import="com.sist.big.code.vo.CodeVO"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
	int jobId = 0;
	
	if(null != request.getAttribute("bc_vo")){
		vo=(BoardVO)request.getAttribute("bc_vo");
		bId = StringUtil.nvl(vo.getbId(), "");
		bNo = vo.getbNo();
		jobId = vo.getJobId();
	}else{
		vo = new BoardVO();
	}
	
	LOG.debug("vo, bid, bno, jobId ========="+vo.toString()+"\n"+bId+bNo+jobId);
	
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


</head>
<body>

	
	<!-- 글내용 -->
	<form name="frmbc" id="frmbc" action="<%=BIGConst.context%>/board.do" method="post">
	<!-- list(다른 페이지)로 보내줄 떄 hidden하셈. -->
	<input type="hidden" name="workDiv" id="workDivbc" />
	<input type="hidden" name="bId" id="bIdbc" value="<%=vo.getbId()  %>" />  
	<input type="hidden" name="bNo" id="bNobc" value="<%=vo.getbNo() %>" />
	<input type="hidden" name="jobId" id="jobIdbc" value="<%=vo.getJobId() %>" />
	<input type="hidden" name="cId" id="cIdbc" value="${bc_vo.cId}" />
	<input type="hidden" name="title" id="titlebc" value="${bc_vo.title}" />
	<input type="hidden" name="contents" id="contentsbc" value="${bc_vo.contents}" />
	<input type="hidden" name="writeDate" id="writeDatebc" value="${bc_vo.writeDate}" />
	<input type="hidden" name="email" id="emailbc" value="${bc_vo.email}" />
	<!--<form id="boardContentsForm">-->
    <div class="container boardContents">

        <table width="100%" border="0" summary>
            <tbody>
                
                	
                <tr class="first">
                    <div class="col-xs-11">
                    <td><c:out value="${bc_vo.title }"/>
                    </td>
                    </div>
                </tr>
                <tr class="first">
                    <div class="col-xs-11">
                    	<td height="200">
                        	${fn:replace(bc_vo.contents,cn,br) }
                    	</td>
                    </div>
                </tr>
               
                        	
         
            </tbody>
        </table>
        <div class="contents-footer" id="favofavo">
            <p class="footer-p"> 
            <c:choose>
            <c:when test="${faflag == 'false' }" >
            <a href="#" id="favoa" class="favorite" onclick="addfa();">즐찾</a>
            </c:when>
            <c:when test="${faflag == 'true' }">
            <a href="#" id="favoadel" class="favorite" onclick="delfa();">즐찾 해제</a>
            </c:when>
            </c:choose>
            </p>   
    
        </div>
        
        <c:if test="${loginvo.email == bc_vo.email}">
         <div class="board-contents-bottom">
            <button class="btn btn-board-write pull-right" id="writebc" onclick="javascript:ctrUpdate()">수정</button>
            <button class="btn btn-board-write pull-right" id="cancelbc" onclick="javascript:ctrDel()">삭제</button>
        </div>
        </c:if>
       
        </form>
        <form name="frmc1" id="frmc1" action="<%=BIGConst.context%>/comment.do" method="post">
       	<input type="hidden" id="workDivc1" name="workDiv"/>
       	<input type="hidden" id="cNoc1" name="cNo"/>
       	<input type="hidden" name="bId" id="bIdc1" value="${bc_vo.bId}" />  
		<input type="hidden" name="bNo" id="bNoc1" value="${bc_vo.bNo}" />
		<input type="hidden" name="email" id="emailc1" value="${loginvo.email }"/>

		<div id="jobBoardComment">
        <div>
            <label>COMMENT</label>
        </div>
        <table width="100%" border="0" summary>
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
        </table>
        
        <%if(login==true){ %>
        <div class="contents-comment">
            <div class="input-group">
                    
            <textarea class="form-control" id="contentsc1" name="contents" rows="3" placeholder="댓글입력해" style="resize: none"></textarea>
            <span class="input-group-addon btn btn-default" onclick="javascript:ctrAddc()">댓글 쓰기</span>
            </div>

        </div>
		<%} %>
	
       
    
    <div class="container comments">
        <table width="100%" border="0" summary>
            
        </table>
    </div>
    </div>
    </form>
	
	<script type="text/javascript">
	

	/*삭제*/
	function ctrDel(){
		if(false == confirm("삭제 하시겠습니까?")) return;
		
		var frm = document.frmbc;
		frm.workDiv.value = "4000";
		alert(frm.workDiv.value);
		frm.action = "/BIG/board.do";
		frm.submit();
	}
	
	/*글수정*/
	function ctrUpdate(){
		if(false == confirm("수정 하시겠습니까?")) return;
		
		var frm = document.frmbc;
		frm.workDiv.value = "2100";
		frm.bId.value = $("#bIdbc").val();
		frm.bNo.value = $("#bNobc").val();
		frm.jobId.value = $("#jobIdbc").val();
		frm.action = "/BIG/board.do";
		frm.submit();
	}
	
	function ctrDelc(commentNo){
		var cNo = commentNo;
		if(false == confirm("삭제 하시겠습니까?")) return;
		
		var frm1 = document.frmc1;
		frm1.cNo.value = cNo;
		frm1.workDiv.value = "4000";
		alert(frm1.workDiv.value);
		
		frm1.action = "/BIG/comment.do";
		frm1.submit();
	}
	

	function ctrUpdatec(){
		if(false == confirm("댓글 수정 하시겠습니까?")) return;
			$("#contentsc1").focus();
		
	}
	
	//즐겨찾기 추가
	function addfa(){
		
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
		        		$("#favofavo").html("<p><a href='#' id='favoadel' class='favorite' onclick='delfa();'>즐찾 해제</a></p>");

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
	function delfa(){
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
		        		$("#favofavo").html("<p><a href='#' id='favoa' class='favorite' onclick='addfa();'>즐찾</a></p>");

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
	
	$(document).ready(function(){

	});

</script>
</body>
</html>