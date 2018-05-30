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
<%@page import="com.sist.big.vo.SearchVO"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%
	Logger LOG = Logger.getLogger(this.getClass());
	UserVO logVO = null;
	if (null != (UserVO) session.getAttribute("loginvo")) {
		logVO = (UserVO) session.getAttribute("loginvo");
		String id = logVO.getEmail();
		LOG.debug("logVO.getEmail()=" + id);
	} else {
		logVO = null;
	}
	boolean login = logVO == null ? false : true; //로그인 여부 확인
	LOG.debug(login);
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<html>
<!-- 
<head>
<title>Kepchup</title>
<meta charset="utf-8">
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<meta name="viewport"
	content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link rel="stylesheet" href="<%=BIGConst.context%>/css/common/common.css">
<link rel="stylesheet" href="<%=BIGConst.context%>/css/modal/modal.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css">
<script
	src="https://code.jquery.com/jquery-3.3.1.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js"></script>

<script type="text/javascript">	
	function addItem(list, item) {
		var itemHtml = '<tr class="SearchItem" data-id="' + item.id + '">';
		itemHtml += '<td>' + item.name + '</td>';
		itemHtml += '<td>' + item.title + '</td>';
		itemHtml += '<td>' + item.requiredEducationLevel + '</td>';
		itemHtml += '<td>' + item.experienceLevel + '</td>';
		itemHtml += '<td>' + item.expirationDate + '</td></tr>';
		
		list.append(itemHtml);
	}
	
	function addEvent(searchResult){
		$('.SearchItem').click(function() {
			var item = $(this);
			var id = item.data('id');
			var itemData = null;
			for(var i in searchResult) {
				if (searchResult[i].id === id) {
					itemData = searchResult[i];
				}
			}
			
			if (itemData) {
				var modal = $('#resultModal');
				
				var modalTitle = modal.find('p.title');
				var modalBody = modal.find('modal-body');
				
				modalTitle.empty();
				modalBody.empty();
				
				modalTitle.append(itemData.title);
				modalBody.append(itemData.name);
				
				$('#resultModal').modal('show');
			}
		});
	}
 
	function getList() {
		var params = {
				isApi: true,
		};
		
		if ($('input[name=keyword]').val()) {
			params.keywords = $('input[name=keyword]').val();
		}
		
		$.ajax({
			url: '',
			type: 'POST',
			data: params,
			dataType: 'text',
			success: function(res) {
				var data = res.replace(/\\/g, '');
				var array = JSON.parse(data);
				
				searchResult = array;
				
				var searchList = $('#SearchList');
				searchList.empty();
				for(var i in array) {
					addItem(searchList, array[i]);
				}
				
				addEvent(array);
			},
			error: function(req, status, error) {
				console.log(error);
			},
		});
	}
	
	
	$(document).ready(function() {
		getList();
		
		$('#search-btn').click(function() {
			getList();
		});
	});
</script>
</head> -->
<body>
	${logvo.email}
	<div id="searchCondition" class="container">
		<div class="input-group">
			<span class="input-group-addon glyphicon glyphicon-search"></span> <input
				name="keyword" type="text" class="form-control"
				placeholder="keywords..."> <span class="input-group-btn">
				<button id="search-btn" class="btn btn-default" type="button">Go!</button>
			</span>
		</div>

		<table class="col-sm-12">
			<caption class="align-middle">카테고리</caption>
			<tr class="job_category">
				<td><input name="job_category" type="checkbox" value="0">전체</td>
				<td><input name="job_category" type="checkbox" value="1">경영·사무·금융</td>
				<td><input name="job_category" type="checkbox" value="2">영업·고객상담</td>
				<td><input name="job_category" type="checkbox" value="3">생산·제조</td>
				<td><input name="job_category" type="checkbox" value="4">IT·인터넷</td>
				<td><input name="job_category" type="checkbox" value="5">전문직</td>
				<td><input name="job_category" type="checkbox" value="6">교육</td>
			</tr>
			<tr class="job_category">
				<td><input name="job_category" type="checkbox" value="7">미디어</td>
				<td><input name="job_category" type="checkbox" value="8">특수계층·공공</td>
				<td><input name="job_category" type="checkbox" value="9">건설</td>
				<td><input name="job_category" type="checkbox" value="10">유통·무역</td>
				<td><input name="job_category" type="checkbox" value="11">서비스</td>
				<td><input name="job_category" type="checkbox" value="12">디자인</td>
				<td><input name="job_category" type="checkbox" value="13">의료</td>
			</tr>
		</table>

		<table class="col-sm-12">
			<caption>지역</caption>
			<tr class="loc_cd">
				<td><input name="loc_cd" type="checkbox" value="117000">전국</td>
				<td><input name="loc_cd" type="checkbox" value="101000">서울</td>
				<td><input name="loc_cd" type="checkbox" value="102000">경기</td>
				<td><input name="loc_cd" type="checkbox" value="103000">광주</td>
				<td><input name="loc_cd" type="checkbox" value="104000">대구</td>
				<td><input name="loc_cd" type="checkbox" value="105000">대전</td>
			</tr>
			<tr class="loc_cd">
				<td><input name="loc_cd" type="checkbox" value="106000">부산</td>
				<td><input name="loc_cd" type="checkbox" value="107000">울산</td>
				<td><input name="loc_cd" type="checkbox" value="108000">인천</td>
				<td><input name="loc_cd" type="checkbox" value="109000">강원</td>
				<td><input name="loc_cd" type="checkbox" value="110000">경남</td>
				<td><input name="loc_cd" type="checkbox" value="111000">경북</td>
			</tr>
			<tr class="loc_cd">
				<td><input name="loc_cd" type="checkbox" value="112000">전남</td>
				<td><input name="loc_cd" type="checkbox" value="113000">전북</td>
				<td><input name="loc_cd" type="checkbox" value="114000">충북</td>
				<td><input name="loc_cd" type="checkbox" value="115000">충남</td>
				<td><input name="loc_cd" type="checkbox" value="116000">제주</td>
			</tr>
		</table>

		<table class="col-sm-12">
			<caption>채용 형태</caption>
			<tr class="job_type">
				<td><input name="job_type" type="radio" value="1">정규직</td>
				<td><input name="job_type" type="radio" value="2">계약직</td>
				<td><input name="job_type" type="radio" value="3">병역특례</td>
				<td><input name="job_type" type="radio" value="4">인턴직</td>
				<td><input name="job_type" type="radio" value="5">아르바이트</td>
				<td><input name="job_type" type="radio" value="6">파견직</td>
			</tr>
			<tr class="job_type">
				<td><input name="job_type" type="radio" value="7">해외취업</td>
				<td><input name="job_type" type="radio" value="8">위촉직</td>
				<td><input name="job_type" type="radio" value="9">프리랜서</td>
				<td><input name="job_type" type="radio" value="10">계약직
					(정규직 전환가능)</td>
				<td><input name="job_type" type="radio" value="11">인턴직
					(정규직 전환가능)</td>
				<td><input name="job_type" type="radio" value="12">교육직</td>
			</tr>
			<tr class="job_type">
				<td><input name="job_type" type="radio" value="13">별정직</td>
				<td><input name="job_type" type="radio" value="14">파트</td>
				<td><input name="job_type" type="radio" value="15">전임</td>
				<td><input name="job_type" type="radio" value="16">기간제</td>
				<td><input name="job_type" type="radio" value="17">무기계약직</td>
			</tr>
			</tr>
			<tr class="job_type">
				<td><input name="job_type" type="radio" value="18">전문계약직</td>
				<td><input name="job_type" type="radio" value="19">전문연구요원</td>
				<td><input name="job_type" type="radio" value="20">산업기능요원</td>
				<td><input name="job_type" type="radio" value="21">현역</td>
				<td><input name="job_type" type="radio" value="22">보충역</td>
			</tr>
		</table>
	</div>
	<div class="container">
		<table class="table table-board table-hover">
			<thead>
				<tr>
					<th>기업명</th>
					<th>제목</th>
					<!-- position title -->
					<th>지원자격</th>
					<!-- requierd-education-level-->
					<th>근무조건</th>
					<!-- experienceLevel-->
					<th>마감일</th>
					<!-- expiration-date -->
				</tr>
			</thead>
			<tbody id="SearchList">
				<tr>
					<td colspan="99">등록된 게시글이 없습니다.</td>
				</tr>
			</tbody>
		</table>
		<!-- //table list -->
		<div class = "text-center">
		<button id="pager" class="btn btn-default">더보기</button>
		</div>

	</div>
	<div id="resultModal" class="modal fade">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close btn-close" data-dismiss="modal"
						aria-hidden="true">&times;</button>
					<p class="name" id="comNme" align="center"></p>
				</div>
				<div>
					<table>
						<tr>
							<th>사람인 Link</th>
							<td><a class="link" target="_blank"></a></td>
						</tr>
						<tr>
							<th>게시일</th>
							<td class="postingDate"></td>
						</tr>
						<tr>
							<th>마감일자</th>
							<td class="expirationDate"></td>
						</tr>
						<tr>
							<th>멘트</th>
							<td class="title"></td>
						</tr>
						<tr>
							<th>위치</th>
							<td class="location"></td>
						</tr>
						<tr>
							<th>채용형태</th>
							<td class="jobType"></td>
						</tr>
						<tr>
							<th>산업형태</th>
							<td class="industry"></td>
						</tr>
						<tr>
							<th>직종</th>
							<td class="jobCategory"></td>
						</tr>
						<tr>
							<th>채용인원</th>
							<td class="openQuantity"></td>
						</tr>
						<tr>
							<th>요구경력</th>
							<td class="experienceLevel"></td>
						</tr>
						<tr>
							<th>요구교육레벨</th>
							<td class="requiredEducationLevel"></td>
						</tr>
						<tr>
							<th>급여</th>
							<td class="salary"></td>
						</tr>
					</table>
					
					<input name="userEmail" id="userEmail" type="hidden" value="${loginvo.email }"/> 
					<div class = "text-center">
					<br>
					<button id="btnFavs" class="btn btn-default">즐겨찾기</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<script type="text/javascript">
		var params = {};

		function addItem(list, item) {
			var itemHtml = '<tr class="SearchItem" data-id="' + item.id + '">';
			itemHtml += '<td>' + item.name + '</td>';
			itemHtml += '<td>' + item.title + '</td>';
			itemHtml += '<td>' + item.requiredEducationLevel + '</td>';
			itemHtml += '<td>' + item.experienceLevel + '</td>';
			itemHtml += '<td>' + item.expirationDate + '</td></tr>';

			list.append(itemHtml);
		}

		function addEvent(searchResult) {
			$('.SearchItem')
					.click(
							function() {
								var item = $(this);
								var id = item.data('id');
								var itemData = null;
								var addFavsItem = [];

								for ( var i in searchResult) {
									if (searchResult[i].id === id) {
										itemData = searchResult[i];
									}
								}

								if (itemData) {
									var modal = $('#resultModal');

									var modalName = modal.find('p.name');
									var modalUrl = modal.find('a.link');
									var modalPostingDate = modal.find('td.postingDate');
									var modalExpirationDate = modal.find('td.expirationDate');
									var modalTitle = modal.find('td.title');
									var modalLocation = modal.find('td.location');
									var modalJobType = modal.find('td.jobType');
									var modalIndustry = modal.find('td.industry');
									var modalJobCategory = modal.find('td.jobCategory');
									var modalOpenQuantity = modal.find('td.openQuantity');
									var modalExperienceLevel = modal.find('td.experienceLevel');
									var modalRequiredEducationLevel = modal.find('td.requiredEducationLevel');
									var modalSalary = modal.find('td.salary');

									modalName.empty();
									modalUrl.empty();
									modalPostingDate.empty();
									modalExpirationDate.empty();
									modalTitle.empty();
									modalLocation.empty();
									modalJobType.empty();
									modalIndustry.empty();
									modalJobCategory.empty();
									modalOpenQuantity.empty();
									modalExperienceLevel.empty();
									modalRequiredEducationLevel.empty();
									modalSalary.empty();

									modalName.append(itemData.name);
									modalUrl.append(itemData.link);
									modalPostingDate.append(itemData.postingDate);
									modalExpirationDate.append(itemData.expirationDate);
									modalTitle.append(itemData.title);
									modalLocation.append(itemData.location);
									modalJobType.append(itemData.jobType);
									modalIndustry.append(itemData.industry);
									modalJobCategory.append(itemData.jobCategory);
									modalOpenQuantity.append(itemData.openQuantity);
									modalExperienceLevel.append(itemData.experienceLevel);
									modalRequiredEducationLevel.append(itemData.requiredEducationLevel);
									modalSalary.append(itemData.salary);

									$(".link").attr("href", itemData.link);
									$('#resultModal').modal('show');

									addFavsItem.push(itemData.name);
									addFavsItem.push(itemData.link);

									addFavs(addFavsItem);
								}
							});
		}

		function addFavs(Item) {
			var favsItem = {
				isAddFavs : true,
				email : $("#userEmail").val(),
				name : Item[0],
				link : Item[1],
			};

			$('#btnFavs').unbind('click');
			$('#btnFavs').click(function() {

				var flag = [];

				$.ajax({
					url : '/BIG/Search.json',
					type : 'POST',
					data : favsItem,
					dataType : 'text',
					success : function(res) {
						flag = res.split(",");

						if (flag[0] == "1" && flag[1] == "-1") {
							alert("즐겨찾기에 추가하였습니다.");
						} else if (flag[0] == "1" && flag[1] == "1") {
							alert("즐겨찾기 목록에서 삭제하였습니다.");
						}
					},
					error : function(req, status, error) {
						console.log(error);
					},
				});
			});

		}

		function makePagination(item) {
			var start = 0;
			$('#pager').click(function() {
				start++;
				params.start = start;
				
				$.ajax({
					url : '',
					type : 'POST',
					data : params,
					dataType : 'text',
					success : function(res) {
						var data = res.replace(/\\/g, '');
						var array = JSON.parse(data);

						var searchList = $('#SearchList');

						for (var i = 1; i < array.length; i++) {
							addItem(searchList, array[i]);
						}
						addEvent(array);
					},
					error : function(req, status, error) {
						console.log(error);
					},
				});
			});
		}

		function getList() {

			params.isApi = true;
			params.start = 0;

			var checkCate = [];
			var checkLoc = [];

			$('input[name=job_category]:checked').each(function(index, item) {
				checkCate.push($(item).val());
			});

			$('input[name=loc_cd]:checked').each(function(index, item) {
				checkLoc.push($(item).val());
			});

			if (checkCate.length > 0) {
				params.jobCategory = checkCate;
			}
			if (checkLoc.length > 0) {
				params.locCd = checkLoc;
			}
			if ($('input[name=keyword]').val()) {
				params.keywords = $('input[name=keyword]').val();
			}
			if ($('input[name=job_type]:checked').val()) {
				params.jobType = $('input[name=job_type]:checked').val();
			}

			$.ajax({
				url : '',
				type : 'POST',
				data : params,
				dataType : 'text',
				success : function(res) {
					var data = res.replace(/\\/g, '');
					var array = JSON.parse(data);

					var searchList = $('#SearchList');
					searchList.empty();

					for (var i = 1; i < array.length; i++) {
						addItem(searchList, array[i]);
					}

					makePagination(array[0]);
					addEvent(array);
				},
				error : function(req, status, error) {
					console.log(error);
				},
			});
		}

		$(document).ready(function() {
			getList();

			$('#search-btn').click(function() {
				getList();
			});
		});
	</script>

	<script
		src="https://cdnjs.cloudflare.com/ajax/libs/popper.js/1.14.0/umd/popper.min.js"
		integrity="sha384-cs/chFZiN24E4KMATLdqdvsezGxaGsi4hLGOzlXwp5UZB1LY//20VyM2taTB4QvJ"
		crossorigin="anonymous"></script>

</body>
</html>