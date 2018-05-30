<%@page import="com.sist.big.vo.UserVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.vo.BoardVO"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@page import="com.sist.big.common.DTO"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.big.common.StringUtil"%>
<%@page import="com.sist.big.code.dao.CodeDAO"%>
<%@page import="com.sist.big.code.vo.CodeVO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%
	Logger LOG = Logger.getLogger(this.getClass());

	String searchDiv="";//검색구분
	String searchWord="";//검색어
	String jobId = "";
	String pageSize = "10";
	String pageNum = "1";
	
	int totalCnt = 0; //총글수
	int bottomCount = 10; //BottomCount 
	
	BoardVO param = (BoardVO)request.getAttribute("paramVO");
	
	LOG.debug("param===="+param.toString());
	
	if(null != param){
		searchDiv =  StringUtil.nvl(param.getSearchDiv(), "");
		searchWord = StringUtil.nvl(param.getSearchWord(),"");
		jobId = StringUtil.nvl(param.getJobId(), "");
		pageSize = StringUtil.nvl(param.getPageSize(),"10");
		pageNum = StringUtil.nvl(param.getPageNum(),"1");
	}else {
		param = new BoardVO();
	}
	
	int o_page_size = Integer.parseInt(pageSize);
	int o_page_num = Integer.parseInt(pageNum);
	
	String iTotalCnt = (null == request.getAttribute("totalCnt"))?"0":request.getAttribute("totalCnt").toString();
	totalCnt = Integer.parseInt(iTotalCnt);
	
	LOG.debug("searchDiv===="+searchDiv);
	LOG.debug("searchWord===="+searchWord);
	LOG.debug("jobIdjobId===="+jobId);
	LOG.debug("iTotalCnt===="+iTotalCnt);
	LOG.debug(pageNum);
	
	//검색조건
	CodeVO vo01 = new CodeVO();
	vo01.setMst_cd_id("C007");
	CodeDAO codeDao = new CodeDAO();
	List<DTO> list1 = codeDao.do_selectList(vo01);
	
	//게시판 구분
	CodeVO vo02 = new CodeVO();
	vo02.setMst_cd_id("C001");
	List<DTO> listBoard = codeDao.do_selectList(vo02);
	
	//말머리
	CodeVO vo03 = new CodeVO();
	vo03.setMst_cd_id("C002");
	List<DTO> listCategory = codeDao.do_selectList(vo03);
	
	UserVO logVO = null;
	if(null != (UserVO)session.getAttribute("loginvo")){
		logVO = (UserVO)session.getAttribute("loginvo");
		String id = logVO.getEmail();
		LOG.debug("logVO.getEmail()="+id);
	}else{
		logVO = null;
	}
	
	boolean login = logVO == null ? false : true; //로그인 여부 확인
	LOG.debug(login);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<%if(login==true || login==false){ %>
<body>
	<!-- 사이드바 -->
	 
		<div id="sidebar" class="container-fluid" align="left">
		<form class= "form-inline" name="frmbb" id="frmbb" action="<%=BIGConst.context %>/board.do" method="post">
			<div class="col-sm-3 col-md-2" >
				<div >
					<%= StringUtil.makeUList(listBoard,jobId) %>
				</div>
			</div>
    <!-- END 사이드바 -->	
    
        	<!-- Grid영역 -->
        	<div class="table-responsive">
        
            <!--게시글 div container-->
    <div class="container" >
    	<!-- 검색영역 -->
    	<div class="row">
	       
	        	<input type="hidden" name="workDiv" id="workDivbb" />
	        	<input type="hidden" name="bId" id="bIdbb" value="20b"/>
	        	<input type="hidden" name="jobId" id="jobIdbb">
	        	<input type="hidden"  name="bNo" id="bNobb" />
	        	<input type="hidden"  name="pageNum" id="pageNumbb" />
		        <div class="form-group board-top" id="search-keybb" name="search-key">
		            <%= StringUtil.makeSelectBox(list1, searchDiv, "searchDiv",true) %>    
		                
		            <input type="text" name=searchWord id="searchWordbb" value="<%=searchWord %>" />
		       		<!-- todo: 조회버튼 채용이야기 버튼으로 바꾸기. -->
		            <button class="btn btn-normal" id="searchbb">검색</button>
		            
		        </div>
	        
        </div>
        &nbsp;
        <!--// 검색영역 -->
	        <table class="table table-board table-hover" id="listTablebb">  
	        
	        
	            <thead>
	                <tr>
	                    <th>글번호</th>
	                    <th>제목</th>
	                    <th>작성자</th>
	                    <th>작성일</th>
	                    <th>조회수</th>
	                    <th>댓글수</th>
	                </tr>
	            </thead>
	            <tbody>
	            	<c:choose>
	            		<c:when test="${list1.size()>0}">
	            			<c:forEach var="boardVO" items="${list1}">
	            				<tr>
	            					
				                    <td><c:out value="${boardVO.bNo }"/></td> 
				                    <td class="title-left"><c:out value="${boardVO.title}"/></td>
				                    <td><c:out value="${boardVO.nickName }"/></td>
				                    <td><c:out value="${boardVO.writeDate }"/></td>
				                    <td><c:out value="${boardVO.readCnt }"/></td>
				                    <td><c:out value="${boardVO.repleCount }"/></td>
				                    <td><c:out value="${boardVO.bId }"/></td>
				                </tr>
				                
	            			</c:forEach>
	                	</c:when>
	                	<c:otherwise>
	                		<tr>
	                			<td colspan="99"> 등록된 글이 없습니다. </td>
	                		</tr>
	                	</c:otherwise>
	                </c:choose> 
	            </tbody>
	        </table>
       
        <!-- //Grid영역 -->
        
        <%if(login==true){ %>
        <!-- 글쓰기 버튼 -->
        <div class="board-bottom">
            <button class="btn btn-normal pull-right" id="insertbb" >글쓰기</button>
        </div>
        <!--// 글쓰기 버튼 -->
        
        <% }%>
        
        <!-- pagination -->
        
        <div class="board-page">
        	<%=StringUtil.renderPaging(totalCnt, o_page_num, o_page_size, bottomCount, "/board.do", "ctrSelectPage") %>
        </div>
        <!--// pagination -->
        
   		</div>
    </div>
    </form>
    </div>
    
    <% } %>
     <!--게시글 div container-->     
	<script type="text/javascript">
	

	
	function ctrSelectPage(url, page_num){
		var frm = document.frmbb;
		frm.workDiv.value = "1000";
		frm.pageNum.value = page_num;
		frm.jobId.value = <%=jobId %>
		alert(frm.jobId.value);
		frm.action="/BIG/"+url;
		frm.submit();
	}

	$(document).ready(function(){
		$('td:nth-child(7)').hide();
		
		$("#searchbb").click(function(){
			var frm = document.frmbb;
			frm.workDiv.value = "1000";
			frm.action="/BIG/board.do";
			frm.submit();
		})
		
		
		
		/*글 list 조회*/
		$("#jobPage>li").click(function(){
			
			var frm = document.frmbb;
			var jobId = $(this).val();
			frm.workDiv.value = "1000";
			$("#jobIdbb").val(jobId);
			frm.action="/BIG/board.do";
			frm.submit();

		})

		$("#listTablebb>tbody").on("click","tr",function(){
			
			var curTR = $(this);
			var curTD = curTR.children();
			var bNo = curTD.eq(0).text();
			
			var bId = curTD.eq(6).text();
			
			var frm = document.frmbb;
			frm.workDiv.value = "1100";
			frm.bNo.value = bNo;
			frm.bId.value = bId;
			
			frm.action="/BIG/board.do";
			frm.submit();
		});
		
		
		
		//글쓰기 화면으로 이동
		$("#insertbb").click(function(){
			var frm = document.frmbb;
			frm.workDiv.value = "2100";
			
			frm.jobId.value = <%=jobId %>
			frm.action="/BIG/board.do";
			frm.submit();
		})
	});
	
	

</script>

</body>
</html>