<%@page import="com.sist.big.vo.UserVO"%>
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

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	Logger LOG = Logger.getLogger(this.getClass());

	String searchDiv = "";//검색구분
	String searchWord = "";//검색어
	String cId = "";
	
	String pageSize = "10";
	String pageNum = "1";
	
	int totalCnt = 0; //총글수
	int bottomCount = 10; //BottomCount 

	BoardVO param = (BoardVO) request.getAttribute("paramVO");
	if (null != param) {
		searchDiv = StringUtil.nvl(param.getSearchDiv(), "");
		searchWord = StringUtil.nvl(param.getSearchWord(), "");
		cId = StringUtil.nvl(param.getcId(), "");
		pageSize = StringUtil.nvl(param.getPageSize(),"10");
		pageNum = StringUtil.nvl(param.getPageNum(),"1");
	}
	LOG.debug("searchDiv===="+searchDiv);
	int o_page_size = Integer.parseInt(pageSize);
	int o_page_num = Integer.parseInt(pageNum);
	
	String iTotalCnt = (null == request.getAttribute("totalCnt"))?"0":request.getAttribute("totalCnt").toString();
	totalCnt = Integer.parseInt(iTotalCnt);
	
	CodeDAO codeDao = new CodeDAO();

	//검색조건 작성자 내용 제목 
	CodeVO vo01 = new CodeVO();
	vo01.setMst_cd_id("C007");
	List<DTO> codeList = codeDao.do_selectList(vo01);

	//말머리 구분 c50, c60, c70
	CodeVO vo02 = new CodeVO();
	vo02.setMst_cd_id("C002");
	List<DTO> listBoard = codeDao.do_selectList(vo02);
	
	
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
	<!--게시글-->
	<div class="container">

		<div class="row">
			<form class="form-inline" name="frmsb" id="frmsb" action="<%=BIGConst.context%>/board.do" method="post">
				<input type="hidden" name="workDiv" id="workDivsb" /> 
				<input type="hidden" name="bId" id="bIdsb" value="10b"/> 
				<input type="hidden" name="bNo" id="bNosb" />
				<input type="hidden"  name="pageNum" id="pageNumsb" />

			
				<div class="form- group board-top">
					<div class="form-group board-top" id="search-keysb" name="search-key">
					<%=StringUtil.makeSelectBox(codeList,searchDiv, "searchDiv", true)%>
					<input type="text" name=searchWord id="searchWordsb" value="<%=searchWord %>" />
					<button class="btn btn-normal btn-board" id="searchsb"
						onclick="javascript:ctrSelectList();">검색</button>

				</div>
			</form>
		</div>
		<table class="table table-board table-hover" id="listTablesb">
			<thead>
				<tr>
					<th>글번호</th>
					<th>제목</th>
					<th>모집인원</th>
					<th>장소</th>
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
								<td><c:out value="${boardVO.bNo}" /></td>
								<td><c:out value="${boardVO.title}" /></td>
								<td><c:out value="${boardVO.reNum}" /></td>
								<td><c:out value="${boardVO.loc}" /></td>
								<td><c:out value="${boardVO.nickName}" /></td>
								<td><c:out value="${boardVO.writeDate}" /></td>
								<td><c:out value="${boardVO.readCnt}" /></td>
								<td><c:out value="${boardVO.repleCount }"/></td>
							</tr>
						</c:forEach>
					</c:when>
					<c:otherwise>
						<tr>
							<td colspan="99">등록된 게시글이 없습니다.</td>
						</tr>
					</c:otherwise>
				</c:choose>
			</tbody>
		</table>
		
		<%if(login==true){ %>
		<div class="board-bottom">
			<button class="btn btn-normal btn-board pull-right" id="insertsb">글쓰기</button>
		</div>
		<% }%>
		
		<!-- pagination -->
        
        <div class="board-page">
        	<%=StringUtil.renderPaging(totalCnt, o_page_num, o_page_size, bottomCount, "/board.do", "ctrSelectPage") %>
        </div>
        <!--// pagination -->
	<%}%>
	<!--END게시글-->
	
	<script type="text/javascript">
	
		function ctrSelectPage(url, page_num){
			var frm = document.frmsb;
			frm.workDiv.value = "1000";
			frm.pageNum.value = page_num;
			frm.action="/BIG/"+url;
			frm.submit();
		}
	
		/*글 list 조회*/
		function ctrSelectList() {
			var frm = document.frmsb;
			frm.workDiv.value = "1000";
			frm.action = "/BIG/board.do";
			frm.submit();
		}

		$(document).ready(function() {
			$("#listTablesb>tbody").on("click", "tr", function() {

				var curTR = $(this);
				var curTD = curTR.children();
				var bNo = curTD.eq(0).text();

				var frm = document.frmsb;
				frm.workDiv.value = "1100";
				frm.bNo.value = bNo;
				alert(bNo);

				frm.action = "/BIG/board.do";
				frm.submit();
			});

			//글쓰기 화면으로 이동
			$("#insertsb").click(function(){
				var frm = document.frmsb;
				frm.workDiv.value = "2100";
				
				frm.action="/BIG/board.do";
				frm.submit();
			})
			
		});
	
	</script>
</body>
</html>