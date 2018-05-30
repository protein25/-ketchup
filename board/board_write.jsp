<%@page import="com.sist.big.vo.UserVO"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.vo.BoardVO"%>
<%@page import="com.sist.big.code.dao.CodeDAO"%>
<%@page import="com.sist.big.common.DTO"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.big.code.vo.CodeVO"%>
<%@page import="com.sist.big.common.StringUtil"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>	
<%
	Logger LOG = Logger.getLogger(this.getClass());
	
	
	int jobId = 0;
	String bId = "";
	int bNo = 0;
	String cId="";
	int pfId=0;
	String email="";
	
	BoardVO param = (BoardVO)request.getAttribute("inVOooo");
	
	if(null != param){
		jobId = Integer.parseInt(StringUtil.nvl(param.getJobId(), ""));
		bId = param.getbId();
		bNo = Integer.parseInt(StringUtil.nvl(param.getbNo(), ""));
		cId =param.getcId();
		pfId = Integer.parseInt(StringUtil.nvl(param.getPfId(), ""));
		email = param.getEmail();
	}else{
		param = new BoardVO();
	}
	
	LOG.debug("paramparamparamparamparam===="+param.toString());
	LOG.debug("inVOooojobIdjobId===="+jobId);
	
	UserVO logVO = (UserVO)session.getAttribute("loginvo");
	String id = logVO.getEmail();
	LOG.debug("logVO.getEmail()="+id);
	
	
	
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>

<body>
	
	 <!--글쓰기 -->
    <form name="frmbw" id="frmbw" action="<%=BIGConst.context %>/board.do" method="post">
    <input type="hidden" name="workDiv" id="workDivbw" />
    <input type="hidden" name="bId" id="bIdbw" value="${param.bId }" />
    <input type="hidden" name="bNo" id="bNobw" value="${param.bNo }" />
    <input type="hidden" name="cId" id="cIdbw" value="${param.cId }"/>
    <input type="hidden" name="jobId" id="jobIdbw" value="${param.jobId }"/>
    <input type="hidden" name="email" id="emailbw" value="${loginvo.email }"/>
    <input type="hidden" name="pfId" id="pfIdbw" value="${param.pfId }"/>
    <input type="hidden" name="writeDate" id="writeDatebw" value="${param.writeDate }"/>
    <div class="container boardWrite">
        <table width="100%" border="0" summary>
            <tbody>
                <tr class="first">
                    <th scope="row" class="thead txtLess">제목</th>
                    <td>
                        <div class="col-xs-11">
                            <input class="form-control " id="ctitlebw" name="title" type="text" required="required" placeholder="제목을 입력하세요" value="${param.title }">
                           
                           
                        </div>
                    </td>
                </tr>
                <tr class="first">
                    <th scope="row" class="thead txtLess">본문</th>
                    <td>
                        <div class="col-xs-11">
                            <textarea class="form-control " id="ccontentsbw" name="contents" rows="10" placeholder="내용을 입력하세요" >${param.contents }</textarea>
                        </div>
                    </td>
                </tr>
                
                 <tr class="first">
                    <th scope="row" class="thead txtLess">첨부파일</th>
                    <td>
                     <form class="form-horizontal" action="<%=BIGConst.context%>/upload.do"  method="POST" enctype="multipart/form-data">
                        <div class="col-xs-10">
                        <div class="form-group">
                             <div class="filebox"> 
                               <input class="upload-name" value="파일선택" disabled="disabled"> 
                               
                               <label for="ex_filename">파일찾기</label> 
                               
                                <input type="file" name="uploadFile01" class="form-control" id="title" placeholder="파일">
                                 </div>
						</div>
                        </div>
                        </form>
                    </td>
                </tr>
            </tbody>
        </table>
        <div class="board-write-bottom">
            <br>
            <button type="submit" class="btn btn-board-write pull-right" id="writeeebw" >글쓰기</button>
            <button type="submit" class="btn btn-board-write pull-right" id="updateeebw">수정하기</button>
            <button class="btn btn-board-write pull-right" id="cancelbw" onclick="">취소</button>
        </div>
    </div>
        
    </form>
    
    <!--글쓰기 -->
	<script type="text/javascript">
    
	$(document).ready(function(){
		
		/*글 쓰기*/
		$("#writeeebw").click(function(){
	    	var frm = document.frmbw;
	    	frm.workDiv.value = "2000";
	    	alert(frm.workDiv.value);
	    	frm.bId.value = "20b";
	    	frm.cId.value="c10";
	    	//frm.pfId.value=64;
	    	frm.jobId.value = <%= jobId %>;
	    	
	    	frm.email.value = <%=id%>;
	    	
	    	frm.action="/BIG/board.do";
	    	frm.submit();
    	});
		
		$("#updateeebw").click(function(){
			var frm = document.frmbw;
	    	frm.workDiv.value = "3000";
	    	alert(frm.workDiv.value);
	    	frm.action="/BIG/board.do";
	    	frm.submit();
		});
		
	});
    
</script>
</body>
</html>