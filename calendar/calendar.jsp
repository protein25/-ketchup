<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@page import="org.apache.log4j.Logger"%>
<%@page import="com.sist.big.vo.BoardVO"%>
<%@page import="com.sist.big.vo.UserVO"%>
<%@page import="com.sist.big.common.BIGConst"%>
<%@page import="com.sist.big.common.DTO"%>
<%@page import="java.util.List"%>
<%@page import="com.sist.big.common.StringUtil"%>
<%@page import="com.sist.big.code.dao.CodeDAO"%>
<%@page import="com.sist.big.code.vo.CodeVO"%>
<%@page import="com.sist.big.vo.SearchVO"%>
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
<head>
<script
	https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.js></script>
<link
	https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.min.css></link>
<link
	https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/3.9.0/fullcalendar.print.css></link>
	
</head>

<body>
	<div>
		<div style="text-align: center">
			<button class="" id="prevCal">
				<span class="glyphicon glyphicon-chevron-left"></span>
			</button>
			<button id="nextCal">
				<span class="glyphicon glyphicon-chevron-right"></span>
			</button>
		</div>
		<div id='calendar'></div>
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

					<input name="userEmail" id="userEmail" type="hidden"
						value="${loginvo.email }" />
					<div class = "text-center">
					<br>
					<button id="btnFavs" class="btn btn-default">즐겨찾기</button>
					</div>


				</div>
			</div>
		</div>
	</div>
	<img id="ajaxLoader" src="<%=BIGConst.context%>/images/loader.gif"/>


	<script type="text/javascript">
		$(function() {
			$('#calendar').fullCalendar({
			    header: {
					left: 'prev,next today',
					center: 'title',
					right: 'month,basicWeek,basicDay'
		        },
		        defaultDate: new Date(),
		        navLinks: true, // can click day/week names to navigate views
		        editable: true,
		        eventLimit: true, // allow "more" link when too many events
		        events : function (start, end, timezone, callback) {
		        	events= [];
		        	getList(start, end, timezone, callback);
		        	},
		        eventClick: function(event) {
				    modalOpen(event.item);
				}
			});
			$('#prevCal').click(function(){
				$('#calendar').fullCalendar('prev');
			});
			$('#nextCal').click(function(){
				$('#calendar').fullCalendar('next');
			});
	});
		
		
		var events = [];
		function getList(start, end, timezone, callback, pageStart = 0) {
			var count = 100;
			
			var params = {
				isApi : true,
				start: pageStart,
				stock : 'kosdaq',
				sr : 'directhire',
				jobType : '1',
				count : '100',
				deadline: start.unix(),
			};
			$('#ajaxLoader').show();

			$.ajax({
				url : '/BIG/Search.json',
				type : 'POST',
				data : params,
				dataType : 'text',
				success : function(res) {
					var data = res.replace(/\\/g, '');
					var array = JSON.parse(data);
					var total = array[0].total;
					
					if (!total) return;

					for(var i=1;i<array.length;i++) {
						var item = array[i];
						
						events.push({
							title: '[S]  ' + item.name,
							start: item.postingDate.split('T')[0],
							backgroundColor : 'blue',
							item: item,
							
						});
						
						events.push({
							title: '[E]  ' + item.name,
							start: item.expirationDate.split('T')[0],
							backgroundColor : 'red',
							item: item,
						});
					}
					if(Math.floor(total/count)<= pageStart){
						$('#ajaxLoader').hide();
						callback(events);
					} else {
						getList(start, end, timezone, callback, pageStart + 1);
					}
				},
				error : function(req, status, error) {
					console.log(error);
				},
			});
		}
		function modalOpen(itemData){
			var addFavsItem = [];

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
	}
		function addFavs(Item) {
			var favsItem = {
				isAddFavs : true,
				email : '${loginvo.email}',
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
	</script>
	<!-- CDN header 안에 넣을 것  -->
</body>
</html>