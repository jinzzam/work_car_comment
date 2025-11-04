<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
</head>
<body>
	<table width="500" border="1">
		<form method="post" action="modify">
			<input type="hidden" name="board_id" value="${content_view.board_id}">
			<tr>
				<td>번호</td>
				<td>
					${content_view.board_id}
				</td>
			</tr>
			<tr>
				<td>히트</td>
				<td>
					${content_view.view_count}
				</td>
			</tr>
			<tr>
				<td>이름</td>
				<td>
<%-- 					${content_view.member_id} --%>
					<input type="text" name="member_id" value="${content_view.member_id}">
				</td>
			</tr>
			<tr>
				<td>제목</td>
				<td>
<%-- 					${content_view.title} --%>
					<input type="text" name="title" value="${content_view.title}">
				</td>
			</tr>
			<tr>
				<td>내용</td>
				<td>
<%-- 					${content_view.content} --%>
					<input type="text" name="content" value="${content_view.content}">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<input type="submit" value="수정">
					&nbsp;&nbsp;<a href="list">목록보기</a>
					&nbsp;&nbsp;<a href="delete?board_id=${content_view.board_id}">삭제</a>
				</td>
			</tr>
		</form>
	</table>

	<div>
		<input type="text" id="member_id" placeholder="작성자">
		<input type="text" id="comment_content" placeholder="내용">
<!--		<input type="hidden" name="board_id" value="${content_view.board_id}">-->
		<button onclick="commentWrite()">댓글작성</button>
	</div>

	<div id="comment-list">
		<table>
			<tr>
				<td>댓글번호</td>
				<td>작성자</td>
				<td>내용</td>
				<td>작성시간</td>
			</tr>
			<c:forEach items="${commentList}" var="comment">
				<tr>
					<td>${comment.comment_id}</td>
					<td>${comment.member_id}</td>
					<td>${comment.comment_content}</td>
					<td>${comment.created_at}</td>
					<input type=hidden name=comment_content value="${comment.comment_content}">
				</tr>
			</c:forEach>
		</table>
	</div>

	<script>
		const commentWrite = () => {
<!--			const content = document.getElementById("content").value;-->
<!--			const writer = "${content_view.member_id}";-->
<!--			const commentContent ="${comment.comment_content}";-->

			const writer = document.getElementById("member_id").value;
			const commentContent = document.getElementById("comment_content").value;
			const boardId = "${content_view.board_id}";
			
			if (!writer || !commentContent) {
			    alert("작성자와 내용을 모두 입력해주세요.");
			    return; 
			}

			$.ajax({
				type:"post"
				,url:"/comment/save"
				,data:{
				   	board_id : boardId,
					member_id : writer
				   ,comment_content : commentContent
				}
				,success: function(commentList){
					console.log("작성 성공");
					console.log(commentList);

					let output = "<table>";
						output += "<tr><th>댓글번호</th>";
						output += "<th>작성자</th>";
						output += "<th>내용</th>";
						output += "<th>작성시간</th>";
						output += "</tr>";
						for(let i in commentList){
							output += "<tr>";
							output += "<td>"+commentList[i].comment_id+"</td>";
							output += "<td>"+commentList[i].member_id+"</td>";
							output += "<td>"+commentList[i].comment_content+"</td>";
							output += "<td>"+commentList[i].created_at+"</td>";
							output += "</tr>";

						}
						output += "</table>";
						console.log("@# output =>" + output);

						document.getElementById("comment-list").innerHTML = output;
						return commemtList;
				}
				,error: function(){
					console.log("작성 실패");
				}
			});
		}
	</script>
</body>
</html>
















