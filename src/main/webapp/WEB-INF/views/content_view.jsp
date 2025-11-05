<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="${pageContext.request.contextPath}/js/jquery.js"></script>
<style>
	.comment-header-row {
	    display: flex;
	    font-weight: bold;
	    border-bottom: 2px solid #000;
	    padding: 5px 0;
	}
	.comment-header-row > div {
	    flex: 1;
	    text-align: center;
	}
</style>
<script type="text/javascript">

// ========================fn_open_reply_form(parent_comment_id) =====================
		// '대댓글 작성' 버튼 클릭 시 호출될 함수
		function fn_open_reply_form(parent_comment_id) {
			// 1. 폼의 ref_id 필드 값을 부모 댓글 ID로 설정
			     $("#parent_comment_id").val(parent_comment_id);
		    
				console.log("@# 부모 댓글 번호=>" + parent_comment_id);
				console.log(">> 대댓글 작성 모드 전환.");
				
				// 3. '대댓글 취소' 버튼 표시
				$("#cancel_reply_btn").show();
			}
			
// ========================fn_cancel_reply() =====================
			// '대댓글 취소' 버튼 클릭 시 호출될 함수
		function fn_cancel_reply() {
			// 최상위 댓글
			$("#parent_comment_id").val('');
			
			console.log(">> 댓글 작성 모드 전환.");
			
			$("#cancel_reply_btn").hide();
	}
		
</script>
</head>
<body>
	<div style="margin-bottom: 30px;">
		    <h2>게시글 상세</h2>
		    <table width="500" border="1">
		        <form method="post" action="modify">
		            <input type="hidden" name="board_id" id="board_id" value="${content_view.board_id}">
		            <tr><td>번호</td><td>${content_view.board_id}</td></tr>
					<tr><td>히트</td><td>${content_view.view_count}</td></tr>
					<tr><td>이름</td><td><input type="text" name="member_id" value="${content_view.member_id}"></td></tr>
					<tr><td>제목</td><td><input type="text" name="title" value="${content_view.title}"></td></tr>
					<tr><td>내용</td><td><input type="text" name="content" value="${content_view.content}"></td></tr>
		            <tr>
		                <td colspan="2">
		                    <input type="submit" value="수정">
		                    &nbsp;&nbsp;<a href="list">목록보기</a>
		                    &nbsp;&nbsp;<a href="delete?board_id=${content_view.board_id}">삭제</a>
		                </td>
		            </tr>
		        </form>
		    </table>
	    </div>
		
		<hr>
		    
		    <h3>댓글 작성</h3>
		    <div id="comment-form-area" style="margin-bottom: 20px;">
		        <input type="hidden" id="parent_comment_id" value=""> 
<!--				<input type="hidden" id="comment_id" placeholder="댓글번호" value="">-->
				<input type="text" id="member_id" placeholder="작성자">
		        <input type="text" id="comment_content" placeholder="내용">
		        <button id="write-comment-btn">댓글작성</button>
		        <button id="cancel_reply_btn" onclick="fn_cancel_reply()" style="display: none;">대댓글 취소</button>
		    </div>

		    <div id="comment-list">
		    </div>
	

<script>
	$("#write-comment-btn").on('click', commentWrite);
		function commentWrite() {

//<!--			const commentId = $("#comment_id").val();-->
			const writer = $("#member_id").val();
			const commentContent = $("#comment_content").val();
			const boardId = "${content_view.board_id}";
			const parentCommentId = $("#parent_comment_id").val();
			
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
					
					// 폼 초기화 및 대댓글 모드 해제
		            $("#member_id").val('');
		            $("#comment_content").val('');
		            fn_cancel_reply();
					
					
					renderCommentList(commentList);
				},error: function(){
					console.log("작성 실패");
				}
			});
		}
		
	// ========================renderCommentList(commentList) =====================
	/**
	 * 댓글 목록 배열을 받아 HTML을 생성하고 화면에 출력합니다.
	 */
	function renderCommentList(commentList) {
	    const paddingLeft = '30px'; 
	    let output = ''; 
	    
	    output += '<p style="font-weight: bold; margin-top: 20px;">댓글 목록</p>';
	    
	    // 헤더는 고정된 DIV 블록으로 표시 (테이블 헤더 대신 사용)
		output += `<div class="comment-header-row">`;
	    output += `<div style="flex: 0.5;">번호</div>`;
	    output += `<div style="flex: 1.5; text-align: left;">작성자 / 내용</div>`;
	    output += `<div style="flex: 1;">작성시간</div>`;
	    output += `<div style="flex: 0.5;">답글</div>`;
	    output += `</div>`;

	    if (commentList && commentList.length > 0) {
	        for(const comment of commentList){
//	            const comment = commentList[i];
	            
	            // 현재 댓글이 대댓글인지 확인
	            let isCurrentReply = comment.parent_comment_id > 0;
	            
	            // 기본 스타일
	            let commentStyle = `border: 1px solid #007bff; margin-bottom: 5px; padding: 5px; display: flex; align-items: center;`;
	                    
	            if(isCurrentReply){
	                // 대댓글인 경우 들여쓰기
	                commentStyle += `padding-left: ${paddingLeft};`;
	            }
	            
	            // 댓글 하나의 DIV 블록 시작
	            output += `<div style="${commentStyle}">`;
	            
	            // 1. 번호 (flex: 0.5)
	            output += `<div style="flex: 0.5;">${comment.comment_id}</div>`;
	            
	            // 2. 작성자 및 내용 (flex: 1.5)
				output += `<div style="flex: 1.5; text-align: left;">`;
	            output += `<strong>${comment.member_id}</strong> (${comment.created_at})<br>`;
	            output += `<span>${comment.comment_content}</span>`;
	            output += `</div>`;
	            
	            // 3. 작성시간 (flex: 1)
	            output += `<div style="flex: 1;"></div>`;

	            // 4. 대댓글 버튼 (flex: 0.5)
	            output += `<div style="flex: 0.5;">`;
	            output += `<input type='button' onclick='fn_open_reply_form(${comment.comment_id})' value='답글'>`;
	            output += `</div>`;
	            
	            output += `</div>`; // <div> 닫기
	        }
	    } else {
	        output += '<p>등록된 댓글이 없습니다.</p>';
	    }

	    // 최종적으로 comment-list 영역에 삽입
	    $("#comment-list").html(output); // jQuery 사용으로 변경
	}		
	// -------------------------------------------------------------
	// 페이지 로드 후 초기 댓글 목록을 AJAX로 가져와 렌더링 
	// -------------------------------------------------------------
	$(document).ready(function() {
	    const boardId = "${content_view.board_id}";
		$("#write-comment-btn").on('click', commentWrite);
	    if (boardId) {
	        $.ajax({
	            type:"get", // 댓글 조회는 GET 방식이 적절
	            url:"/comment/findAll", // Controller의 findAll 경로에 맞게 수정 필요
	            data:{ board_id : boardId },
	            success: function(initialCommentList){
	                renderCommentList(initialCommentList);
	            },
	            error: function(){
	                console.log("초기 댓글 목록 로드 실패");
	            }
	        });
	    }
	});
</script>
