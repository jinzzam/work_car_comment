<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<script type="text/javascript">

// ========================fn_open_reply_form(parent_comment_id) =====================
		// '대댓글 작성' 버튼 클릭 시 호출될 함수
		function fn_open_reply_form(parent_comment_id) {
			// 1. 폼의 ref_id 필드 값을 부모 댓글 ID로 설정
			     $("#parent_comment_id").val(parent_comment_id);
		    
			// 2. 폼 제목 변경 및 포커스
				console.log("@# 부모 댓글 번호=>" + parent_comment_id);
				// $("#content").focus();
				
				// 3. '대댓글 취소' 버튼 표시
				$("#cancel_reply_btn").show();
			}
			
// ========================fn_cancel_reply() =====================
			// '대댓글 취소' 버튼 클릭 시 호출될 함수
			function fn_cancel_reply() {
				// 1. ref_id를 최상위 댓글인 0으로 재설정
				$("#parent_comment_id").val('');
				
				// 2. 폼 초기화
				//     $("#form-title").text("새 댓글 작성");
				//     $("#content").val('');
				console.log("@# 부모 댓글 번호=>" + parent_comment_id);
			 
			// 3. 취소 버튼 숨기기
			$("#cancel_reply_btn").hide();
		}
		
</script>
</head>
<body>
	<table width="500" border="1">
		<form method="post" action="modify">
			<input type="hidden" name="board_id" id="board_id" value="${content_view.board_id}">
			<input type="hidden" name="parent_comment_id" id="parent_comment_id" value="">
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

	<div id="comment-form-area">
			<input type="text" id="member_id" placeholder="작성자">
			<input type="text" id="comment_content" placeholder="내용">
			<button onclick="commentWrite()">댓글작성</button>
			<button id="cancel_reply_btn" onclick="fn_cancel_reply()" style="display: none;">대댓글 취소</button>
		</div>

		<div id="comment-list">
	    </div>

	<script>
		const commentWrite = () => {

			const writer = document.getElementById("member_id").value;
			const commentContent = document.getElementById("comment_content").value;
			const boardId = document.getElementById("board_id").value;
			const parentCommentId = document.getElementById("parent_comment_id").value;
			
			if (!writer || !commentContent) {
			    alert("작성자와 내용을 모두 입력해주세요.");
			    return; 
			}
			
			$.ajax({
				type:"post"
				,url:"/comment/save"
				,data:{
				   	board_id : boardId,
					member_id : writer,
				   	comment_content : commentContent,
					parent_comment_id : parentCommentId
					
				}
				,success: function(commentList){
					console.log("작성 성공");
					console.log(commentList);
					
					const paddingLeft = '30px'; 
					let output = ''; 
					
					output += '<p style="font-weight: bold;">댓글 목록</p>';
					
					output = "<div>";
					output += "<div><div>댓글번호</div>";
					output += "<div>작성자</div>";
					output += "<div>내용</div>";
					output += "<div>작성시간</div>";
					output += "</div>";
					
					for(let i in commentList){
						
						let isCurrentReply = commentList[i].parent_comment_id > 0;
						
						let commentStyle = 'border: 1px solid #007bff; margin-bottom: 5px; padding: 5px;';
						        
				        if(isCurrentReply){
				            commentStyle += `padding-left: ${paddingLeft};`; // 대댓글 들여쓰기
				        }
						
						output += `<div style="${commentStyle}">`;
						
						output += `<div>`;
						output += `<strong>${commentList[i].member_id}</strong> (${commentList[i].comment_id})`;
						output += `| ${commentList[i].created_at}`;
				        output += `</div>`;
						
						output += `<div style="margin-top: 5px;">${commentList[i].comment_content}</div>`;
						        
				        // 대댓글 버튼
				        // **주의: fn_open_reply_form의 인자는 현재 댓글의 ID(comment_id)여야 합니다.**
				        output += `<div><input type='button' name='reply' onclick='fn_open_reply_form(${commentList[i].comment_id})' value='대댓글작성'></div>`;
				        
				        output += `</div>`; // <div> 닫기
					}
					console.log("@# output =>" + output);

					document.getElementById("comment-list").innerHTML = output;
				}
				,error: function(){
					console.log("작성 실패");
				}
			});
		}
	</script>
	<%-- JSP 파일 내 --%>
	<c:choose>
	    <c:when test="${not empty commentList}">
	        <c:forEach var="comment" items="${commentList}">
	            <div class="comment-item" data-id="${comment.commentId}">
	                <%-- 1. 내용 출력 확인 --%>
	                <p>${comment.commentContent}</p> 
	                
	                <%-- 2. 작성자 확인 --%>
	                <small>작성자: ${comment.memberId}</small>
	                
	                <%-- 3. 대댓글 버튼이 포함된 HTML이 있는지 확인 --%>
	                <button type="button" onclick="fn_show_reply_form('${comment.commentId}')">대댓글</button>
	            </div>
	        </c:forEach>
	    </c:when>
	    <c:otherwise>
	        <p>등록된 댓글이 없습니다.</p> </c:otherwise>
	</c:choose>
</body>
</html>


