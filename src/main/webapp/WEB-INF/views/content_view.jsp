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
		flex-direction: row;
	    font-weight: bold;
	    border-bottom: 2px solid #000;
	    padding: 5px 0;
	}

	.comment-header-row > div:nth-child(1),
	.comment-header-row > div:nth-child(3),
	.comment-header-row > div:nth-child(4) {
		text-align: center;
	}

</style>
<script type="text/javascript">

// ========================fn_open_reply_form(parent_comment_id) =====================
		// '대댓글 작성' 버튼 클릭 시 호출될 함수
	function fn_open_reply_form(parent_comment_id) {
    
    // 1. 기존에 열려있는 대댓글 폼(class="reply-form-box") 제거
    $(".reply-form-box").remove();
    
    // 2. 새로운 대댓글 폼 생성 (최상단 작성 폼을 복사하여 템플릿으로 사용)
    // 최상단 div id="comment-write-box"를 템플릿으로 가정하고, 구조만 복사
    // 복사를 위해 원본 HTML 구조를 그대로 가져옵니다. (JSP/HTML 영역도 변경 필요)
    
    const replyFormHtml = `
        <div class="reply-form-box" style="padding-left: 30px; border-left: 5px solid #ccc; margin-top: 10px; margin-bottom: 10px;">
            <h4>대댓글 작성 (TO: ${parent_comment_id})</h4>
            <div class="reply-form-area" data-parent-id="${parent_comment_id}">
                <input type="text" class="reply-member-id" placeholder="작성자">
                <input type="text" class="reply-comment-content" placeholder="내용">
                <button class="reply-write-btn">작성</button>
                <button class="reply-cancel-btn" onclick="fn_cancel_reply()">취소</button>
            </div>
        </div>
    `;

	const targetRowId = "#comment-show-box-" + parent_comment_id;
    // 3. 해당 댓글(#comment-show-box-N) 바로 아래에 폼 추가
    $(targetRowId).after(replyFormHtml);
    
    // 4. 새롭게 생성된 '작성' 버튼에 이벤트 핸들러 연결
    // (이벤트 연결은 `$(document).on`을 사용하여 동적 요소에 연결하는 것이 안전합니다.)
    
    console.log("@# 부모 댓글 번호=>" + parent_comment_id);
    console.log(">> 대댓글 작성 폼 삽입 완료.");
			
// ========================fn_cancel_reply() =====================
		// '대댓글 취소' 버튼 클릭 시 호출될 함수
	function fn_cancel_reply() {
		// 동적으로 추가된 대댓글 폼 제거
		$(".reply-form-box").remove();
		
		console.log(">> 대댓글 작성 취소. 폼 제거 완료.");
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
			<input type="text" id="member_id" placeholder="작성자">
			<input type="text" id="comment_content" placeholder="내용">
			<button id="write-comment-btn">댓글작성</button>
			</div>

		<div id="comment-list">
		</div>
	

<script>
//	$("#write-comment-btn").on('click', commentWrite());
//	$("#write-comment-btn").on('click', commentWrite);

// '댓글 작성' 버튼에 대한 이벤트 핸들러 (최상단 폼)
$("#write-comment-btn").off('click').on('click', function() {
    commentWrite(null); // 최상위 댓글 작성 (parentCommentId = null)
});

// 동적으로 생성된 '대댓글 작성' 버튼에 대한 이벤트 핸들러
$(document).off('click', '.reply-write-btn').on('click', '.reply-write-btn', function() {
    // 부모 ID는 data 속성에서 가져옴
    const $formArea = $(this).closest('.reply-form-area');
    const parentCommentId = $formArea.data('parent-id');
    
    commentWrite(parentCommentId, $formArea);
});

	function commentWrite(parentCommentId, $replyFormArea) {

		let writer;
		let commentContent;
		
		if (parentCommentId) {
			// 대댓글 작성 모드
			writer = $replyFormArea.find('.reply-member-id').val();
			commentContent = $replyFormArea.find('.reply-comment-content').val();
		} else {
			// 최상위 댓글 작성 모드
			writer = $("#member_id").val();
			commentContent = $("#comment_content").val();
		}
		
		writer = $("#member_id").val();
		commentContent = $("#comment_content").val();
		const boardId = "${content_view.board_id}";
		// let parentCommentId = $("#parent_comment_id").val();
		
		if (parentCommentId === '' || parentCommentId === undefined || parentCommentId === null) {
				parentCommentId = null; 
		}
		
		if (!writer || !commentContent) {
			alert("작성자와 내용을 모두 입력해주세요.");
			return; 
		}
		
		$.ajax({
			type:"post"
			,url:"/comment/save"
			,dataType: "json"
			,data:{
				board_id : boardId,
				member_id : writer,
				comment_content : commentContent,
				parent_comment_id : parentCommentId
			}
			,success: function(commentList){
				console.log("작성 성공");
				console.log("@# 작성 후=>" + commentList);
				
				// 폼 초기화 및 대댓글 모드 해제
				if (parentCommentId) {
					fn_cancel_reply(); // 동적 폼 제거
				} else{
					$("#member_id").val('');
					$("#comment_content").val('');
				}
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
	    
	    // 헤더는 고정된 div 블록으로 표시 (테이블 헤더 대신 사용)
		output += `<div class="comment-header-row">`;
	    output += `<div style="flex: 0.5;">번호</div>`;
	    output += `<div style="flex: 1.5; text-align: left;">작성자 / 내용</div>`;
	    output += `<div style="flex: 1;">작성시간</div>`;
	    output += `<div style="flex: 0.5;">답글</div>`;
	    output += `</div>`;

	    if (commentList && commentList.length > 0) {
	        for(let i = 0; i < commentList.length; i++){
	            const comment = commentList[i];
	            
	            // 현재 댓글이 대댓글인지 확인
	            let isCurrentReply = comment.parent_comment_id > 0;
	            
				let rowStyle = `border: 1px solid #007bff; margin-bottom: 5px; padding: 5px; display: flex; align-items: center;`;        
				
	            if(isCurrentReply){
	                // 대댓글인 경우 들여쓰기
	                rowStyle += `padding-left: ${paddingLeft};`;
	            }
	            
				// output += '<div id="comment-show-box" style="' + rowStyle + '">';
				output += '<div id="comment-show-box-' + (comment.comment_id || 0) + '" style="' + rowStyle + '">'; 
					
	            // 댓글 하나의 DIV 블록 시작
				// 1. 번호 (flex: 0.5)
				output += '<div style="flex: 0.5; text-align: center;">' + (comment.comment_id || '') + '</div>';

				// 대댓글 : 상자 속의 새 div 블록
				// 2. 작성자 및 내용 (flex: 1.5)
				output += '<div style="flex: 1.5; text-align: left;">';
				output += '<strong>' + (comment.member_id || '') + '</strong>: ' + (comment.comment_content || '');
            	output += '</div>';

				// 3. 작성시간 (flex: 1)
		//		output += '<div style="flex: 1;"></div>';
				output += '<div style="flex: 1; text-align: center;">' + (comment.created_at2 || '') + '</div>';

				// 4. 대댓글 버튼 (flex: 0.5)
				output += '<div style="flex: 0.5; text-align: center">';
				output += '<input type=\'button\' onclick="fn_open_reply_form(\'' + (comment.comment_id || 0) + '\')" value=\'답글\'>';
				output += '</div>';
				
				/* 대댓글 새 블록 자리 */
				
				/*
				JQurey 요소선택
				버튼 클릭하면 div #comment-write-box
				대댓글 작성하면 div #comment-show-box
				

				output += '<div id="container">';
				output += 	'<div class="toggle-switch">';
				output +=	'<input type="checkbox" id="toggle" hidden>'; 
				output +=	'<label for="toggle" class="toggleSwitch">';
				output += 		'<span class="toggleButton">대댓</span>';
				output +=	'</label>';
				output +=	'</div>';
				output += '</div>';
				*/
				output += '</div>'; // comment-show-box <div> 닫기 : 댓글 한 줄 끝
	        }
	    } else {
	        output += '<p>등록된 댓글이 없습니다.</p>';
	    }
		
		//alert(output);
	    // 최종적으로 comment-list 영역에 삽입
	    $("#comment-list").html(output); 
	}		
	// -------------------------------------------------------------
	// 페이지 로드 후 초기 댓글 목록을 AJAX로 가져와 렌더링 
	// -------------------------------------------------------------
	$(document).ready(function() {
	    const boardId = "${content_view.board_id}";
		
	    if (boardId != null) {
	       
			 $.ajax({
	            type:"get", // 댓글 조회는 GET 방식이 적절
	            url:"/comment/findAll", 
				dataType: "json",
	            data:{ board_id : boardId },
	            success: function(initialCommentList){
	                renderCommentList(initialCommentList);
					console.log("@# initialCommentList(페이지 로드)=>", initialCommentList);
	            },
	            error: function(){
	                console.log("초기 댓글 목록 로드 실패");
	            }
	        });
	    } // end of if

		$("#toggle").change(function(){
	        if($(this).is(":checked")){ 
	            $("#comment-list").show();
	        } else {
	            $("#comment-list").hide(); 
	        }
		});//end of toggle
	});
</script>
