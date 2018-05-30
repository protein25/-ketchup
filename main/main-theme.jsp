<%@page import="com.sist.big.common.StringUtil"%>
<%@page import="com.sist.big.common.DTO"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.big.code.dao.CodeDAO"%>
<%@page import="com.sist.big.code.vo.CodeVO"%>
<%@page import="com.sist.big.vo.UserVO"%>
<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="decorator"
	uri="http://www.opensymphony.com/sitemesh/decorator"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%
	Logger log = Logger.getLogger(this.getClass());
	//직무 셀렉트 박스
	String jobsel = "";
	String jobsel2 = "";
	String jobsel3 = "";
	//회원가입
	UserVO voAdd = null;
	UserVO voLogin = null;

	if (null != request.getAttribute("vo")) {
		voAdd = (UserVO) request.getAttribute("vo");
	} else {
		voAdd = new UserVO();
	}

	//로그인 세션
	voLogin = (UserVO) session.getAttribute("loginvo");
	//String id = voLogin.getEmail();

	boolean login = voLogin == null ? false : true;

	if (login) {
		log.debug("로그인 성공");
	} else {
		log.debug("로그인 실패");
	}

	//직업조건
	CodeVO vo01 = new CodeVO();
	vo01.setMst_cd_id("C001");
	CodeDAO codeDao = new CodeDAO();
	List<DTO> joblist = codeDao.do_selectList(vo01);
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>Catch Job</title>
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<!-- calendar -->
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.1/moment.min.js"></script>
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.js"></script>
<link rel="stylesheet"
	href="//cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.css"></link>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.print.css"></link>
<!-- //calendar -->
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<link rel="stylesheet"
	href="<%=BIGConst.context%>/css/common/common.css?v=20180503">
<link rel="stylesheet" href="<%=BIGConst.context%>/css/modal/modal.css">
<script>
	//메인페이지 로딩
	function main() {
		var frm = document.userLogin;
		frm.workDiv.value = "100";
		frm.action = "/BIG/User.do";
		frm.submit();
	}

	//로그인 처리
	function loginch() {
		var frm = document.userLogin;
		frm.workDiv.value = "3000";
		frm.email.value = $('#lemail').val();
		//alert($('#lemail').val());
		frm.password.value = $('#lpassword').val();
		frm.action = "/BIG/User.do";
		frm.submit();
	}

	//마이페이지 화면이동
	function moveMypage() {
		//alert("moveMypage");
		var frm = document.userLogin;
		frm.workDiv.value = "1000";
		frm.action = "/BIG/User.do";
		frm.submit();
	}
	//로그아웃
	function logout() {
		var frm = document.userLogin;
		frm.workDiv.value = "3100";
		frm.action = "/BIG/User.do";
		frm.submit();
	}

	//id찾기
	function findid() {
		$("#workDiv03").val('7000');

		$.ajax({
					type : 'POST',
					url : '/BIG/User.json',
					dataType : "html",// JSON
					data : $("#findfrm").serialize(),
					success : function(data) {//통신이 성공적으로 이루어 졌을때 받을 함수	 
						var outMessage = data.split("|");
						if (outMessage.length > 0) {
							if (outMessage[0] == "1") {
								$("#login-modal").hide();
								$("#find-modal").hide();
								$("#id-modal").show();
								//alert(outMessage[2]);

								document.getElementById('findidid').innerHTML = outMessage[2];
							} else if (outMessage[0] == "0") {
								$("#login-modal").hide();
								$("#find-modal").hide();
								$("#id-modal").show();
								//alert(outMessage[2]);

								document.getElementById('findidid').innerHTML = outMessage[2];
							}
						}
					},
					complete : function(data) {//무조건 수행

					},
					error : function(xhr, status, error) {
						console.log(error)
					}
				});//findidid ajax
	}

	/*등록*/
	function ctrAdd() {
		if (false == confirm("저장 하시겠습니까?"))
			return;

		var frm = document.userJoin;
		frm.workDiv.value = "2000";
		frm.jobId1.value = $('#jobsel option:selected').val();
		frm.jobId2.value = $('#jobsel2 option:selected').val();
		frm.jobId3.value = $('#jobsel3 option:selected').val();
		frm.action = "/BIG/User.do";
		frm.submit();
	}
	function clickValue() {
		console.log("email=" + $("#email").val());
		//email
		if ("" == $("#email").val()) {
			alert("email input");
			$("#email").focus();
			return false;
		}
		//password
		if ("" == $("#password").val()) {
			alert("password input");
			$("#password").focus();
			return false;
		}
		//name
		if ("" == $("#name").val()) {
			alert("name input");
			$("#name").focus();
			return false;
		}
		return true;
	}
	
	/*글 list 조회*/
	function jobMove1(){
		
		var frm = document.movePage;
		frm.bId.value = "20b";
		frm.workDiv.value = "1000";
		frm.action="/BIG/board.do";
		frm.submit();
	}
	
	function jobMove2(){
		
		var frm = document.movePage;
		frm.bId.value = "10b";
		frm.workDiv.value = "1000";
		frm.action="/BIG/board.do";
		frm.submit();
	}

	$(document).ready(function() {
		$("#save_btn").click(function() {
			if (true == clickValue()) {
				//alert(clickValue());
				//alert($('#jobsel option:selected').val());
				//alert($('#jobsel2 option:selected').val());
				//alert($('#jobsel3 option:selected').val());
				ctrAdd();
			}
		});//save_btn
		$("#btn-sign").click(function() {
			loginch();
		});
		//마이페이지 버튼
		$("#btnPage").click(function() {
			moveMypage();
		});
		//아이디찾기 버튼
		$("#find-id-btn").click(function() {
			findid();
		});

		//로그아웃 버튼
		$("#logoutbtn").click(function() {
			logout();
		});

		//아이디 찾기 모달 ok버튼
		$("#findokbtn").click(function() {
			main();
		});
		
		//메인 이미지 클릭 시
		$("#imgLogo").click(function(){
			main();
		});

	});
</script>
<title>catch up</title>

</head>
<body>
	<!-- 상단 네비게이션 FOR LOGIN & JOIN -->
	<div id="navTop" class="navbar navbar-fixed-top container-fluid">
		<div class="row pull-right">
			<%
				if (login) {
			%>
			<button id="btnPage" type="button" class="btn btn-default">MY PAGE</button>
			<button id="logoutbtn" type="button" class="btn btn-default">LOGOUT</button>
			<%
				} else {
			%>
			<button id="btnJoin" type="button" data-toggle="modal"
				data-target="#join-modal">
				<span class="glyphicon glyphicon-user"></span> Sign Up
			</button>
			<button id="btnLogin" type="button" data-toggle="modal"
				data-target="#login-modal">
				<span class="glyphicon glyphicon-log-in"></span> Login
			</button>
			<%
				}
			%>
		</div>
	</div>
	<!-- END 상단 네비게이션 -->
	<!-- 이미지와 게시판 네비게이션이 위치한 점보트론 -->
	<div class="jumbotron">
		<img id="imgLogo" class="img-responsive img-center"
			src="<%=BIGConst.context%>/images/logo.png" alt="Kepchup LOGO">
		<div id="navMiddle" class="navbar navbar-default" role="navigation">
			<div class="container">
				<div class="navbar-header">
					<button type="button" class="navbar-toggle" data-toggle="collapse"
						data-target="#listMiddle">
						<span class="sr-only">Toggle navigation</span> <span
							class="icon-bar"></span> <span class="icon-bar"></span> <span
							class="icon-bar"></span>
					</button>
				</div>
				<div id="listMiddle" class="navbar-collapse collapse">
					<ul class="nav navbar-nav">
						<li><a href="<%=BIGConst.context%>/calendar/calendar.jsp">채용캘린더</a></li>
						<li><a href="<%=BIGConst.context%>/Search.do">채용검색</a></li>
						<li><a href="<%=BIGConst.context%>/board.do?workDiv=1000&bId=20b">채용이야기</a></li>
						<li><a href="<%=BIGConst.context%>/board.do?workDiv=1000&bId=10b">채용스터디</a></li>
						<!--<form name="movePage" id="movePage" action="<%=BIGConst.context%>/board.do" method="post">-->
						<!--	<input type="hidden" name="workDiv" id="workDivMove">                                 -->
						<!--	<input type="hidden" name="bId" id="bIdMove">                                         -->
						<!--	<li><a id="jbMove" onclick="jobMove1();">채용이야기</a></li>                               -->
						<!--	<li><a id="jbMove" onclick="jobMove2();">채용스터디</a></li>                               -->
						<!--</form>                                                                                   -->
					</ul>
				</div>
			</div>
		</div>
	</div>
	<!-- END 점보트론 -->

	<!--register modal-->
	<div id="join-modal" class="modal fade">
		<div class="modal-dialog modal-top">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Register</h4>
					<button type="button" class="close btn-close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				</div>
				<div class="modal-body">
					<form name="userJoin" id="userJoin"
						action="<%=BIGConst.context%>/user.do" method="post">
						<div class="row setup-content" id="step-1">
							<input type="hidden" name="workDiv" id="workDiv01">
							<div class="form-group">
								<!-- 이메일  -->
								<label class="control-label">ID</label>
<!-- 								<div class="input-group"> -->
									<input class="form-control" placeholder="Enter Your ID"
										type="text" name="email" id="email"
										value="<c:out value='${voAdd.email}'/>" /> 
<!-- 										<span -->
<!-- 										class="input-group-btn"> -->
<!-- 										<button class="btn btn-default" type="submit">인증</button> -->
<!-- 									</span> -->
<!-- 								</div> -->
							</div>
<!-- 							<div class="form-group"> -->
<!-- 								<label class="control-label">인증번호</label> -->
<!-- 								<div class="input-group"> -->
<!-- 									<input type="text" class="form-control" -->
<!-- 										placeholder="Enter Number" required="required"> <span -->
<!-- 										class="input-group-btn"> -->
<!-- 										<button class="btn btn-default  " type="submit">확인</button> -->
<!-- 									</span> -->
<!-- 								</div> -->
<!-- 								/input-group -->
<!-- 							</div> -->
							<!-- 패스워드  -->
							<div class="form-group">
								<label class="control-label">Password</label> <input
									type="password" class="form-control"
									placeholder="Enter Password" name="password" id="join_password"
									value="<c:out value='${voAdd.password}'/>" />
							</div>
							<div class="form-group">
								<label class="control-label">Name</label> <input type="text"
									class="form-control" placeholder="Enter Your Name" name="name"
									id="name" value="<c:out value='${voAdd.name}'/>" />
							</div>
							<div class="form-group">
								<label class="control-label">Phone Number</label> <input
									type="text" name="phone" class="form-control"
									placeholder="Enter Your Phone Number" id="join_phone"
									value="<c:out value='${voAdd.phone}'/>" />
							</div>
							<div>
								<label>jobId1</label> <input type="hidden" name="jobId1"
									id="join_jobId1" />
								<%-- 									<input type="text" name="jobId1" class="form-control" id="join_jobId1" value="<c:out value='${voAdd.jobId1}'/>" maxlength="20"/> --%>
								<%=StringUtil.makeSelectBox(joblist, jobsel, "jobsel", false)%>
							</div>
							<div>
								<label>jobId2</label> <input type="hidden" name="jobId2"
									id="join_jobId2" />
								<%-- 									<input type="text" name="jobId2" class="form-control" id="join_jobId2" value="<c:out value='${voAdd.jobId2}'/>" maxlength="20"/> --%>
								<%=StringUtil.makeSelectBox(joblist, jobsel2, "jobsel2", false)%>
							</div>
							<div>
								<label>jobId3</label> <input type="hidden" name="jobId3"
									id="join_jobId3" />
								<%-- 									<input type="text" name="jobId3" class="form-control" id="join_jobId3" value="<c:out value='${voAdd.jobId3}'/>" maxlength="20"/> --%>
								<%=StringUtil.makeSelectBox(joblist, jobsel3, "jobsel3", false)%>
							</div>
							<div>
								<div class="form-group">
									<label class="control-label">Nick Name</label>
<!-- 									<div class="input-group"> -->
										<input type="text" class="form-control"
											placeholder="Enter Number" name="nickName"
											value="<c:out value='${voAdd.nickName}'/>" /> 
<!-- 											<span -->
<!-- 											class="input-group-btn"> -->
<!-- 											<button class="btn btn-default" type="submit">중복확인</button> -->
<!-- 										</span> -->
<!-- 									</div> -->
									<!-- /input-group -->
								</div>
								<button class="btn defaltBtn btn-lg pull-right" value="등록"
									id="save_btn" type="button">Register</button>
							</div>
						</div>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!--register modal end -->

	<!--login modal-->
	<div id="login-modal" class="modal fade">
		<div class="modal-dialog modal-login">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Sign In</h4>
					<button type="button" class="close btn-close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				</div>
				<div class="modal-body">
					<!-- loginform -->
					<form name="userLogin" id="userLogin"
						action="<%=BIGConst.context%>/User.do" method="post">
						<input type="hidden" name="workDiv" id="workDiv02">
						<div class="form-group">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-user"></i></span>
								<input type="text" id="lemail" name="email" class="form-control"
									placeholder="User Email" required="required">
							</div>
						</div>
						<div class="form-group">
							<div class="input-group">
								<span class="input-group-addon"><i class="fa fa-lock"></i></span>
								<input type="password" id="lpassword" class="form-control"
									name="password" placeholder="Password" required="required">
							</div>
						</div>
						<div class="form-group">
							<button type="submit" id="btn-sign"
								class="btn btn-primary btn-block btn-lg">Sign In</button>
						</div>
<!-- 						<p class="hint-text"> -->
<!-- 							<a class="hint-a" data-toggle="modal" href="#find-modal">Forgot -->
<!-- 								ID or Password?</a> -->
<!-- 						</p> -->
					</form>
<!-- 					<div class="or-seperator"> -->
<!-- 						<i>or</i> -->
<!-- 					</div> -->
<!-- 					<p class="text-center">Login with your social media account</p> -->
<!-- 					<div class="text-center social-btn"> -->
<!-- 						<a href="#" class="btn btn-kakao"><i class="fa fa-commenting"></i>&nbsp; -->
<!-- 							Kakao</a> <a href="#" class="btn btn-google"><i -->
<!-- 							class="fa fa-google"></i>&nbsp; Google</a> -->
<!-- 					</div> -->
					<div class="modal-footer">
						Don't have an account? <a class="create-a" data-toggle="modal"
							href="#join-modal">Create one</a>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--login modal end -->

	<!-- find id modal -->
	<div id="find-modal" class="modal fade">
		<div class="modal-dialog modal-top">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Find ID or PW</h4>
					<button type="button" class="close btn-close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				</div>
				<div class="modal-body">
					<div class="row">
						<div class="col-sm-5 col-md-5 col-lg-5 col-xl-5 div-find">
							<h3>Find ID</h3>
							<br>
							<form name="findfrm" id="findfrm"
								action="<%=BIGConst.context%>/User.do" method="post">
								<input type="hidden" name="workDiv" id="workDiv03">
								<div class="form-group">
									<label class="control-label">Your Name</label> <input
										type="text" id="findname" name="name" class="form-control"
										placeholder="Enter Your Name" required="required">
								</div>
								<div class="form-group">
									<label class="control-label">Your Phone Number</label> <input
										type="text" id="findphone" name="phone" class="form-control"
										placeholder="Enter Your Phone Number" required="required">
								</div>
								<button id="find-id-btn" class="btn defaltBtn btn-lg pull-right"
									type="button" data-toggle="modal" data-target="#id-modal">Find</button>
							</form>
						</div>
						<div class="col-sm-5 col-md-5 col-lg-5 col-xl-5 div-find">
							<h3>Find PW</h3>
							<br>
							<form class="form" role="form">
								<div class="form-group">
									<label class="control-label">Your Name</label> <input
										type="text" class="form-control" placeholder="Enter Your Name"
										required="required">
								</div>
								<div class="form-group">
									<label class="control-label">Your E-mail</label> <input
										type="text" class="form-control"
										placeholder="Enter Your Email" required="required">
								</div>
								<button class="btn defaltBtn btn-lg pull-right" type="submit"
									data-toggle="modal" data-target="#pw-modal">Find</button>
							</form>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!--find id or pw modal end -->

	<!-- find id modal -->
	<div id="id-modal" class="modal fade">
		<div class="modal-dialog modal-id">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Find ID</h4>
					<button type="button" class="close btn-close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				</div>
				<div class="modal-body">
					<h3>Your ID</h3>
					<div class="label-div">
						<label id="findidid" class="id-label"></label>
					</div>
					<div class="modal-footer">
						<button id="findokbtn" class="btn defaltBtn btn-lg pull-right"
							type="button" data-dismiss="modal" aria-hidden="true">OK</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- find id modal -->

	<!-- find PW modal -->
	<div id="pw-modal" class="modal fade">
		<div class="modal-dialog modal-pw">
			<div class="modal-content">
				<div class="modal-header">
					<h4 class="modal-title">Find PW</h4>
					<button type="button" class="close btn-close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
				</div>
				<div class="modal-body">
					<h3>Your Password</h3>
					<div class="label-div">
						<label>회원님의 email로 전송되었습니다</label>
					</div>
					<div class="modal-footer">
						<button class="btn defaltBtn btn-lg pull-right" type="button"
							data-dismiss="modal" aria-hidden="true">OK</button>
					</div>
				</div>

			</div>
		</div>
	</div>
	<!-- find PW modal end -->

	<decorator:body>
	</decorator:body>

	<!-- 바닥글 -->
	<hr>
	<footer>
	<div style="text-align: center">
		Powered by <a href="http://www.saramin.co.kr" target="_blank">취업사람인</a>
	</div>
	</footer>
	<!-- END 바닥글 -->
</body>
</html>