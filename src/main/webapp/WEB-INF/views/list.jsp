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
<%-- 				<td>${dto.title}</td> --%>
				<td>
				<!-- 			content_view : 컨트롤러단 호출 -->
					<a href="content_view?board_id=${dto.board_id}">${dto.title}</a>
				</td>
<%-- 				<td>${dto.created_at}</td> --%>
				<td>${dto.created_at2}</td>
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
</body>
</html>
















