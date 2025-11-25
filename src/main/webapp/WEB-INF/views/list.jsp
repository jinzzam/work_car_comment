<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
	#btn_logout{
		text-align: right;
	}
	.div_page ul{
		display: flex;
		list-style: none;
	}
</style>
</head>
<body>
	<table width="500" border="1">
		<tr>
			<td colspan="5">
				<div id="btn_logout">
					<a href="logout">로그아웃</a>
				</div>
			</td>
		</tr>
		<tr>
			<td>번호</td>
			<td>이름</td>
			<td>제목</td>
			<td>날짜</td>
			<td>히트</td>
		</tr>
<!-- 		조회결과 -->
<!-- 		list : 모델객체에서 보낸 이름 -->
		<c:forEach var="dto" items="${list}">
			<tr>
				<td>${dto.board_id}</td>
				<td>${dto.member_id}</td>
				<td>
				<!-- 			content_view : 컨트롤러단 호출 -->
					<a href="content_view?board_id=${dto.board_id}">${dto.title}</a>
				</td>
				<td>${dto.created_at}</td>
				<td>${dto.view_count}</td>
			</tr>
		</c:forEach>
		<tr>
			<td colspan="5">
			<!-- 			write_view : 컨트롤러단 호출 -->
				<a href="write_view">글작성</a>
			</td>
		</tr>
	</table>
	<h3>${pageMaker}</h3>
		<div class="div_page">
			<ul>
				<c:if test="${pageMaker.prev}">
					<!-- <li class="paginate_button">[Previous]</li> -->
					<li class="paginate_button">
						<a href="${pageMaker.startPage - 1}">
							[Previous]
						</a>
					</li>
				</c:if>
				<c:forEach var="num" begin="${pageMaker.startPage}" end="${pageMaker.endPage}">
					<!-- <li>[${num}]</li> -->
					<li class="paginate_button" ${pageMaker.cri.pageNum == num ? "style='color:red'" : ""}>
						<a href="${num}">
							[${num}]
						</a>
					</li>
				</c:forEach>
				<c:if test="${pageMaker.next}">
					<!-- <li class="paginate_button">[Next]</li> -->
					<li class="paginate_button">
						<a href="${pageMaker.endPage + 1}">
							[Next]
						</a>
					</li>
				</c:if>
			</ul>
		</div>
	<form method="get" id="actionForm" action="list">
	<!-- <form method="get" id="actionForm"> -->
		<input type="hidden" name="pageNum" value="${pageMaker.cri.pageNum}">
		<input type="hidden" name="amount" value="${pageMaker.cri.amount}">
	</form>
</body>
</html>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<script>
	var actionForm = $("#actionForm");

	// 페이지 번호 처리
	$(".paginate_button a").on("click", function (e){
		e.preventDefault();
		console.log("click!");
		console.log("@# href=>" + $(this).attr('href'));

		actionForm.find("input[name='pageNum']").val($(this).attr('href'));
		actionForm.submit();
		// 버그 처리 (게시글 클릭 후 뒤로가기 누른 후 다른 페이지 클릭할 때 content_view가 작동되는 것을 해결)
		// actionForm.attr("action", "list").submit();

	}); // end of paginate_button click
	
	// 게시글 처리
	$(".move_link").on("click", function (e){
		e.preventDefault();
		console.log("move_link click!");
		console.log("@# href=>" + $(this).attr('href'));

		var targetBno = $(this).attr('href');

		// 버그 처리 (게시글 클릭 후 뒤로가기 누른 후 다른 게시글 클릭할 때 %boardNo=번호 누적되는거 방지)
		// var bno = actionForm.find("input[name='boardNo']").val();
		// if (bno!= "") {
		// 	bno = actionForm.find("input[name='boardNo']").remove();
		// }
		actionForm.append("<input type='hidden' name='board_id' value='"+targetBno+"'>");
		actionForm.attr("action", "content_view").submit();
	}); // end of paginate_button click
</script>
















