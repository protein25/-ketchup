<%@page import="com.sist.big.vo.BoardVO"%>
<%@page import="com.sist.big.common.StringUtil"%>
<%@page import="com.sist.big.common.DTO"%>
<%@page import="com.sist.big.code.dao.CodeDAO"%>
<%@page import="com.sist.big.code.vo.CodeVO"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.big.vo.UserVO"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	Logger log = Logger.getLogger(this.getClass());

	List<Integer> inList = (List<Integer>) request.getAttribute("inList");
	boolean pwch = false;
	UserVO userVO = (UserVO) request.getAttribute("vo");

	if (null != userVO) {
		userVO = (UserVO) request.getAttribute("vo");
	} else {
		userVO = new UserVO();
	}
	log.debug("mypage userVO=" + userVO);

	//페이징
	String pageSize = "100";
	String pageNum = "1";

	int totalCnt1 = 0; //내가쓴글총글수
	int totalCnt2 = 0; //내즐찾글총글수
	int totalCnt3 = 0; //내기업즐찾글총글수
	int bottomCount = 10; //BottomCount 

	BoardVO bvo = (BoardVO) request.getAttribute("paramVO");

	log.debug("mypage bvo=" + bvo.toString());

	if (null != bvo) {
		pageSize = StringUtil.nvl(bvo.getPageSize(), "10");
		pageNum = StringUtil.nvl(bvo.getPageNum(), "1");

		log.debug("mypage pageNum=" + pageNum);
	}

	int o_page_size = Integer.parseInt(pageSize);
	int o_page_num = Integer.parseInt(pageNum);

	String iTotalCnt1 = (null == request.getAttribute("totalCnt1"))
			? "0"
			: request.getAttribute("totalCnt1").toString();
	totalCnt1 = Integer.parseInt(iTotalCnt1);

	String iTotalCnt2 = (null == request.getAttribute("totalCnt2"))
			? "0"
			: request.getAttribute("totalCnt2").toString();
	totalCnt2 = Integer.parseInt(iTotalCnt2);

	String iTotalCnt3 = (null == request.getAttribute("totalCnt3"))
			? "0"
			: request.getAttribute("totalCnt3").toString();
	totalCnt3 = Integer.parseInt(iTotalCnt3);

	log.debug("boVO" + bvo.toString());
	log.debug("bvo.getPageNum()" + bvo.getPageNum());
	log.debug("o_page_num" + o_page_num);
	//--페이징

	if (true != pwch) {
		pwch = (boolean) request.getAttribute("check");
	} else {
		pwch = false;
	}
	log.debug("pwch =========" + pwch);
	if (null != request.getAttribute("inList")) {
		inList = (List<Integer>) request.getAttribute("inList");
	} else {
		inList = new ArrayList<>();
	}

	//직업조건
	CodeVO vo01 = new CodeVO();
	vo01.setMst_cd_id("C001");
	CodeDAO codeDao = new CodeDAO();
	List<DTO> joblist = codeDao.do_selectList(vo01);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<body>

	<!-- my page -->
	<div class="container">

		<!--수정 비밀번호 체크pwch modal -->
		<div class="modal fade" id="modify_pwd" role="dialog">
			<div class="modal-dialog modal-sm">
				<!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header" id=profileMoWi>
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<br>
					</div>
					<div class="modal-body">
						<form name="frmmodipw" id="frmmodipw"
							action="<%=BIGConst.context%>/user.do" method="post">
							<input type="hidden" name="workDiv" id="modifych_workDiv" />
							<div class="form-group">
								<label for="pwd">PW</label> <input type="password"
									class="form-control" id="modifych_password"
									placeholder="비밀번호를 입력하세요." name="password">
							</div>
						</form>
						<button type="submit" id="modify_page"
							class="btn btn-default center-block profileMoWi">확인</button>
					</div>
				</div>
			</div>
		</div>
		<!-- END pwch modal -->

		<!-- 삭제 비밀번호 체크pwch modal -->
		<div class="modal fade" id="del_pwd" role="dialog">
			<div class="modal-dialog modal-sm">
				<!-- Modal content-->
				<div class="modal-content">
					<div class="modal-header" id=profileMoWi>
						<button type="button" class="close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
						<br>
					</div>
					<div class="modal-body">
						<form name="frmpwdel" id="frmpwdel"
							action="<%=BIGConst.context%>/user.do" method="post">
							<input type="hidden" name="workDiv" id="del_workDiv" />
							<div class="form-group">
								<label for="pwd">PW</label> <input type="password"
									class="form-control" id="del_password"
									placeholder="비밀번호를 입력하세요." name="password">
							</div>
						</form>
						<button type="submit" id="del_page"
							class="btn btn-default center-block profileMoWi">확인</button>
					</div>
				</div>
			</div>
		</div>
		<!-- END pwch modal -->

		<!-- modify modal -->
		<div id="update-user-modal" class="modal fade">
			<div class="modal-dialog modal-top">
				<div class="modal-content">
					<div class="modal-header">
						<h4 class="modal-title">회원 정보 수정</h4>
						<button type="button" class="close btn-close" data-dismiss="modal"
							aria-hidden="true">&times;</button>
					</div>
					<div class="modal-body">
						<form name="userUpdate" id="userUpdate"
							action="<%=BIGConst.context%>/User.do" method="post">
							<div class="row setup-content" id="step-1">
								<input type="hidden" name="workDiv" id="modify_workDiv">
								<input type="hidden" name="email" id="modify_email"
									value="<%=userVO.getEmail()%>">
								<!-- 패스워드  -->
								<div class="form-group">
									<label class="control-label">Password</label> <input
										type="password" class="form-control"
										placeholder="Enter Password" name="password"
										id="modify_password" />
								</div>
								<div class="form-group">
									<label class="control-label">Phone Number</label> <input
										type="text" name="phone" class="form-control"
										placeholder="Enter Your Phone Number" id="modify_phone"
										value="<%=userVO.getPhone()%>" />
								</div>
								<div>
									<label>jobId1</label> <input type="hidden" name="jobId1"
										id="modify_jobId1" />
									<%-- 											<input type="text" name="jobId1" class="form-control" id="modify_jobId1" value="<%=userVO.getJobId1() %>"/> --%>
									<%=StringUtil.makeSelectBox(joblist, userVO.getJobId1(), "jobmodi", false)%>
								</div>
								<div>
									<label>jobId2</label> <input type="hidden" name="jobId2"
										id="modify_jobId2" />
									<%-- 											<input type="text" name="jobId2" class="form-control" id="modify_jobId2" value="<%=userVO.getJobId2()%>"/> --%>
									<%=StringUtil.makeSelectBox(joblist, userVO.getJobId2(), "jobmodi2", false)%>
								</div>
								<div>
									<label>jobId3</label> <input type="hidden" name="jobId3"
										id="modify_jobId3" />
									<%-- 											<input type="text" name="jobId3" class="form-control" id="modify_jobId3" value="<%=userVO.getJobId3()%>"/> --%>
									<%=StringUtil.makeSelectBox(joblist, userVO.getJobId3(), "jobmodi3", false)%>
								</div>
								<div>
									<div class="form-group">
										<label class="control-label">Nick Name</label>
<!-- 										<div class="input-group"> -->
											<input type="text" class="form-control"
												placeholder="Enter Number" name="nickName"
												value="<%=userVO.getNickName()%>" /> 
<!-- 												<span -->
<!-- 												class="input-group-btn"> -->
<!-- 												<button class="btn btn-default" type="submit">중복확인</button> -->
<!-- 											</span> -->
<!-- 										</div> -->
										<!-- /input-group -->
									</div>
									<button class="btn defaltBtn btn-lg pull-right" value="수정"
										id="update_btn" type="button">수정</button>
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
		<!-- modify modal -->

		<!-- user profile table -->
		<h1>
			<b>PROFILE</b>
		</h1>
		<form name="frm" id="frm" action="<%=BIGConst.context%>/user.do"
			method="post">
			<div class="pull-right">
				<button type="button" class="btn btn-info btn-lg" id="btnModify"
					data-toggle="modal" data-target="#modify_pwd">수정</button>
				<button type="button" class="btn btn-info btn-lg" id="btnWithdrawal"
					data-toggle="modal" data-target="#del_pwd">탈퇴</button>
			</div>
			<input type="hidden" name="workDiv" id="modifytest_workDiv" /> <input
				type="hidden" name="email" id="profile_email"
				value="<%=userVO.getEmail()%>" />
			<table class="table profileList" id="profile-table">
				<tbody>
					<tr>
						<tread>
						<td scope="row" rowspan="5" width="300" height="300"
							align="center"><img id="imgLogo"
							class="img-responsive img-center"
							src="<%=BIGConst.context%>/images/logo.png" alt="Kepchup LOGO">
						</td>
						</tread>
						<tread>
						<th scope="col" class="text-right" width="200">NAME</th>
						</tread>
						<td width="600"><c:out value="${sessionScope.loginvo.name}" /></td>
					</tr>
					<tr>
						<tread>
						<th scope="col" class="text-right">PHONE</th>
						</tread>
						<td><c:out value="${sessionScope.loginvo.phone}" /></td>
					</tr>
					<tr>
						<tread>
						<th scope="col" class="text-right">E-MAIL</th>
						</tread>
						<td><c:out value="${sessionScope.loginvo.email}" /></td>
					</tr>
					<tr>
						<tread>
						<th scope="col" class="text-right">NICKNAME</th>
						</tread>
						<td><c:out value="${sessionScope.loginvo.nickName}" /></td>
					</tr>
					<tr>
						<tread>
						<th scope="col" class="text-right">JOB</th>
						</tread>
						<td><c:out value="${getjob.get(0).toString()}" /> | <c:out
								value="${getjob.get(1).toString()}" /> | <c:out
								value="${getjob.get(2).toString()}" /></td>
					</tr>
				</tbody>
			</table>
			<table class="table">
				<tbody>
					<tr>
						<td class="text-center" width="50">총 방문</td>
						<td class="text-center" width="1">:</td>
						<td class="text-center" width="50"><b><c:out
									value="${cnttt}" /></b></td>
						<td class="text-center" width="10">회</td>
						<td class="text-center" width="1">|</td>

						<td class="text-center" width="50">총 게시글</td>
						<td class="text-center" width="50">총 게시글</td>
						<td class="text-center" width="1">:</td>
						<td class="text-center" width="50"><b><c:out
									value="${inList.get(1).toString()}" /></b></td>
						<td class="text-center" width="10">개</td>
						<td class="text-center" width="1">|</td>

						<td class="text-center" width="50">총 댓글</td>
						<td class="text-center" width="1">:</td>
						<td class="text-center" width="50"><b><c:out
									value="${inList.get(2).toString()}" /></b></td>
						<td class="text-center" width="10">개</td>
				</tbody>
			</table>
			<!-- END user profile table -->
		</form>
		<div class="container">
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<br>
			<!-- tab -->
			<div class="tab">
				<form class="form-inline" name="favoritefrm" id="favoritefrm"
					action="<%=BIGConst.context%>/User.do" method="post">
					<input type="hidden" name="workDiv" id="favoriteworkDiv" /> <input
						type="hidden" name="email" id="favoriteEmail" /> <input
						type="hidden" name="bNo" id="favoriteBNo" /> <input type="hidden"
						name="bId" id="favoriteBId" /> <input type="hidden"
						name="pageSize" id="favoritepageSize" /> <input type="hidden"
						name="pageNum" id="favoritepageNum" />
					<ul class="nav nav-tabs">
						<li class="active"><a data-toggle="tab" href="#myWriting">내가
								쓴 글</a></li>
						<li class><a data-toggle="tab" href="#favCom">즐겨찾는 기업</a></li>
						<li class><a data-toggle="tab" href="#favPost">북마크한 글</a></li>
					</ul>
					<div class="tab-content">
						<div id="myWriting" class="tab-pane in active">
							<table id="mycontents" class="table table-hover">
								<thead>
									<tr>
										<th class="text-center no">NO</th>
										<th class="text-center title">제목</th>
										<th class="text-center date">작성일</th>
										<th class="text-center comment">댓글수</th>
										<th class="text-center hits">조회수</th>
									</tr>
								</thead>
								<tbody class="text-center">
									<c:choose>
										<c:when test="${list.size()>0}">
											<c:forEach var="boardVO" items="${list}">
												<tr>
													<td><c:out value="${boardVO.bNo }" /></td>
													<td class="title-left"><c:out value="${boardVO.title}" /></td>
													<td><c:out value="${boardVO.writeDate }" /></td>
													<td><c:out value="${boardVO.repleCount }" /></td>
													<td><c:out value="${boardVO.readCnt }" /></td>
													<td><c:out value="${boardVO.bId }" /></td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td colspan="99">등록된 글이 없습니다</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>

						<div id="favCom" class="tab-pane fade">
							<table id="myCoContents" class="table table-hover">
								<thead>
									<tr>
										<th class="no">NO</th>
										<th class="title">회사명</th>
										<th class="date">공고</th>
									</tr>
								</thead>
								<tbody class="text-center">
									<c:choose>
										<c:when test="${faCoList.size()>0}">
											<c:forEach var="boardVO" items="${faCoList}">
												<tr>
													<td><c:out value="${boardVO.bNo }" /></td>
													<td class="title-left"><c:out value="${boardVO.cCode}" /></td>
													<td class="col-sm-6"><a href="${boardVO.message }"
														target="_blank"><c:out value="${boardVO.message }" /></a></td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td colspan="99">등록된 글이 없습니다</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
						</div>

						<div id="favPost" class="tab-pane fade">
							<table id="myFacontents" class="table table-hover">
								<thead>
									<tr>
										<th class="text-center no">NO</th>
										<th class="text-center title">제목</th>
										<th class="text-center date">작성일</th>
										<th class="text-center comment">댓글수</th>
										<th class="text-center hits">조회수</th>
									</tr>
								</thead>
								<tbody class="text-center" id="tabContext">
									<c:choose>
										<c:when test="${list.size()>0}">
											<c:forEach var="boardVO" items="${falist}">
												<tr>
													<td><c:out value="${boardVO.bNo }" /></td>
													<td class="title-left"><c:out value="${boardVO.title}" /></td>
													<td><c:out value="${boardVO.writeDate }" /></td>
													<td><c:out value="${boardVO.repleCount }" /></td>
													<td><c:out value="${boardVO.readCnt }" /></td>
													<td><c:out value="${boardVO.bId }" /></td>
												</tr>
											</c:forEach>
										</c:when>
										<c:otherwise>
											<tr>
												<td colspan="99">등록된 글이 없습니다</td>
											</tr>
										</c:otherwise>
									</c:choose>
								</tbody>
							</table>
							<div>
				</form>
			</div>
		</div>
	</div>
	<!-- END tab -->

	</div>
	</div>
	<script>
    
   //회원탈퇴 패스워트 체크
  function del_pwcheck(){
	  $("#del_workDiv").val('4000');
	  
	  $.ajax({
 		  type: 'POST',
 		  url: '/BIG/User.json',
 		  dataType:"html",// JSON
 		  data: $("#frmpwdel").serialize(),
 		  success: function(data){//통신이 성공적으로 이루어 졌을때 받을 함수
 	          //console.log(data); 	 
 	          var outMessage = data.split("|");
 	          if(outMessage.length>0){
 	        	 if(outMessage[0]=="1"){
 	        		$("#del_pwd").hide();
 	 		          userdelete();
		          }
 		          
 	          }  
 	         },
 	         complete: function(data){//무조건 수행
		          
 	         },
 		  error: function(xhr,status,error){
 				  console.log(error)
 			  }
 	  	});//pw ajax
	  
  }
  
  //회원탈퇴
  function userdelete(){
	  var frm = document.frm;
	  if(<%=pwch%> == true){
		  alert("success!");
		  frm.workDiv.value="6000";
		  frm.action="/BIG/User.do";
		  frm.submit();
	  } else {
		  alert("fail!"); 
	  }
  }
//수정 패스워트 체크
  function modify_pwcheck(){
	  $("#modifych_workDiv").val('4000');
	  
	  $.ajax({
		  type: 'POST',
		  url: '/BIG/User.json',
		  dataType:"html",// JSON
		  data: $("#frmmodipw").serialize(),
		  success: function(data){//통신이 성공적으로 이루어 졌을때 받을 함수
	          console.log(data); 	 
	          var outMessage = data.split("|");
	          if(outMessage.length>0){
		          $("#modify_pwd").hide();
		          $("#update-user-modal").modal();
	          }  
	         },
	         complete: function(data){//무조건 수행
		          
	         },
		  error: function(xhr,status,error){
				  console.log(error)
			  }
	  	});//pw ajax
	  
  }
  
  //수정 유효성 검사
  function updateValide(){			
			//비번
			if(""== $("#modify_password").val()){
				alert("비번을 입력 하세요.");
				$("#modify_password").focus();
			    return false;	
			}
			
			return true;
		}
  
  //수정
  function update(){
	  //alert("업데이트");
	  
	  var frm = document.userUpdate;
	  frm.workDiv.value="5000";
	  frm.jobId1.value=$('#jobmodi option:selected').val();
	  frm.jobId2.value=$('#jobmodi2 option:selected').val();
	  frm.jobId3.value=$('#jobmodi3 option:selected').val();
	  frm.action="/BIG/User.do";
	  frm.submit();
  }
  
  //페이징
  function ctrSelectPage(url, pagenum){
		var frm = document.favoritefrm;
		frm.workDiv.value = "1000";
		
		frm.email.value = "<%=userVO.getEmail()%>		";
			frm.pageNum.value = pagenum;
			//alert(frm.pageNum.value);
			frm.action = "/BIG/" + url;
			frm.submit();
		}

		$(document)
				.ready(
						function() {
							$('td:nth-child(6)').hide();
							$(
									'#jobmodi option[value='
											+
	<%=userVO.getJobId1()%>
		+ ']')
									.attr('selected', 'selected');
							$(
									'#jobmodi2 option[value='
											+
	<%=userVO.getJobId2()%>
		+ ']')
									.attr('selected', 'selected');
							$(
									'#jobmodi3 option[value='
											+
	<%=userVO.getJobId3()%>
		+ ']')
									.attr('selected', 'selected');

							//회원탈퇴 패스워트 체크
							$("#del_page").click(function() {
								del_pwcheck();

							});
							//수정 패스워트 체크
							$("#modify_page").click(function() {
								modify_pwcheck();
							});

							//수정버튼
							$("#update_btn").click(function() {
								//alert($('#jobmodi option:selected').val());
								if (true == updateValide()) {
									update();
								}
							});

							//상세보기
							$("#mycontents>tbody").on("click", "tr",
									function() {
										//alert("yab");
										var curTR = $(this);
										var curTD = curTR.children();
										var bNo = curTD.eq(0).text();
										var bId = curTD.eq(5).text();
										//alert(bNo);

										var frm = document.favoritefrm;
										frm.workDiv.value = "1100";
										frm.bNo.value = bNo;
										frm.bId.value = bId;
										//alert(bNo);

										frm.action = "/BIG/board.do";
										frm.submit();
									});

							//favo
							$("#myFacontents>tbody").on("click", "tr",
									function() {
										//alert("yab");
										var curTR = $(this);
										var curTD = curTR.children();
										var bNo = curTD.eq(0).text();
										var bId = curTD.eq(5).text();
										//alert(bId);

										var frm = document.favoritefrm;
										frm.workDiv.value = "1100";
										frm.bNo.value = bNo;
										frm.bId.value = bId;
										//alert(bNo);

										frm.action = "/BIG/board.do";
										frm.submit();
									});
						});
	</script>
</body>