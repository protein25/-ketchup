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

<%
	Logger LOG = Logger.getLogger(this.getClass());

	//말머리 구분 c50, c60, c70
	CodeDAO codeDao = new CodeDAO();
	CodeVO vo02 = new CodeVO();
	vo02.setMst_cd_id("C002");
	List<DTO> listBoard = codeDao.do_selectList(vo02);

	String bId = "";
	int bNo = 0;
	String cId="";
	String email="";
	
	BoardVO param = (BoardVO)request.getAttribute("inVOooo");
	
	if(null != param){
		bId = param.getbId();
		bNo = Integer.parseInt(StringUtil.nvl(param.getbNo(), ""));
		cId =param.getcId();
		email = param.getEmail();
	}else{
		param = new BoardVO();
	}
	
	LOG.debug("paramparamparamparamparam===="+param.toString());
	LOG.debug("param.getReNum()"+param.getReNum());
	
	UserVO logVO = (UserVO)session.getAttribute("loginvo");
	String id = logVO.getEmail();
	LOG.debug("logVO.getEmail()="+id);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<body>


	<!--글쓰기 -->
    <form name="frmsw" id="frmsw" action="<%=BIGConst.context %>/board.do" method="post">
		<input type="hidden" name="workDiv" id="workDivsw">
		<input type="hidden" name="bId" id="bIdsw" value="${param.bId }" />
    	<input type="hidden" name="bNo" id="bNosw" value="${param.bNo }" />
    	<input type="hidden" name="cId" id="cIdsw" value="${param.cId }"/>
    	<input type="hidden" name="email" id="emailsw" value="${loginvo.email }"/>
    	<input type="hidden" name="writeDate" id="writeDatesw" value="${param.writeDate }"/>
		<div class="container boardWrite">
			<table width="100%" border="0" summary>
				<tbody>

					<div class="board-top-left">
						<select id="search-keysw" name="search-key">
							<option value="subject">말머리 선택</option>
							<option value="content">취업</option>
							<option value="writer">어학</option>
							<option value="writer">기타</option>

						</select>
					</div>
					<tr class="first">
						<th scope="row" class="thead txtLess">제목</th>
						<td>
							<div class="col-xs-11">
								<input class="form-control " id="ctitlesw" name="title" type="text" required="required" placeholder="제목을 입력하세요" value="${param.title }">
							</div>
						</td>
					</tr>
					<tr class="first">
						<th scope="row" class="thead txtLess">모집인원</th>
						<td>
							<div class="col-xs-11">
								<input class="form-control " id="crenumsw" name="reNum" type="text" required="required" placeholder="모집인원 입력하세요" value="${param.reNum }">
									
							</div>
						</td>
					</tr>
					<tr class="first">
						<th scope="row" class="thead txtLess">장소</th>
						<td>
							<div class="col-xs-11">
								<input class="form-control " id="clocsw" name="loc" type="text" required="required" placeholder="장소 입력하세요" value="${param.loc }">
							</div>
						</td>
					</tr>
					<tr class="first">
						<th scope="row" class="thead txtLess">내용</th>
						<td>
							<div class="col-xs-11">
								<textarea class="form-control " id="ccontentssw" name="contents"  rows="10" placeholder="내용을 입력하세요">${param.contents }</textarea>
							</div>
						</td>
					</tr>
					
				</tbody>
			</table>
			<div class="board-write-bottom">
				<br>
				
				<button type="submit" class="btn btn-board-write pull-right" id="writesw">글쓰기</button>
				<button type="submit" class="btn btn-board-write pull-right" id="updatesw">수정하기</button>
				<button class="btn btn-board-write pull-right" id="cancelsw">취소</button>
			</div>
		</div>

	</form>

	<!--글쓰기 -->


	
<script type="text/javascript">

	
$(document).ready(function(){
		
		/*글 쓰기*/
		$("#writesw").click(function(){
			var frm = document.frmsw;
			frm.workDiv.value = "2000";
			frm.cId.value="c60";
			frm.email.value = <%=id%>;
			
			frm.action = "/BIG/board.do"
	    	frm.submit();
    	});
		
		$("#updatesw").click(function(){
			var frm = document.frmsw;
	    	frm.workDiv.value = "3000";
	    	
	    	frm.action="/BIG/board.do";
	    	frm.submit();
		});
		
	});

</script>

</body>
</html>