package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.boot.dto.CommentDTO;
import com.boot.dto.MemDTO;
import com.boot.service.CommentService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
@RequestMapping("/comment")
public class CommentController {
	
	@Autowired
	private CommentService service;
	
	@RequestMapping("/save")
//	public String save(@RequestParam HashMap<String, String> param, Model model) {
	public @ResponseBody ArrayList<CommentDTO> save(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		log.info("@# save()");
		log.info("@# param=>"+param);
		
		String boardId = param.get("board_id");
		log.info("@# boardIdStr=>"+boardId);
		
		CommentDTO comment = new CommentDTO();
	    comment.setBoard_id(param.get("board_id")); // String
	    comment.setMember_id(param.get("member_id"));
	    comment.setComment_content(param.get("comment_content"));
	    
	 // DTO 설정 시에만 null/빈 문자열 체크
	    String parentIdStr = param.get("parent_comment_id");
	    if (parentIdStr != null && !parentIdStr.isEmpty()) {
	        // 값이 있을 때만 파싱 시도
	        try {
	            comment.setParent_comment_id(Integer.parseInt(parentIdStr));
	        } catch (NumberFormatException e) {
	            // 유효하지 않은 숫자일 경우 0으로 처리 (일반 댓글로 간주)
	            comment.setParent_comment_id(0); 
	        }
	    } else if (parentIdStr == null) {
	        // null 또는 빈 문자열인 경우 0으로 설정 (DTO에서만 사용)
	        comment.setParent_comment_id(0); 
	    }
		
		service.save(param);
		
//		comment.setComment_id(Integer.parseInt(param.get("comment_id")));
		
		HashMap<String, String> queryParam = new HashMap<>();
		queryParam.put("board_id", param.get("board_id"));
//		queryParam.put("board_id", param.get("board_id")); // String 그대로 전달
		
		ArrayList<CommentDTO> commentList = service.findAll(queryParam);
	    
		return commentList;
	}
	
	@GetMapping("/findAll")
	public @ResponseBody ArrayList<CommentDTO> findAll(@RequestParam HashMap<String, String> param) {
		log.info("@# findAll()");
		log.info("@# findAll param=>"+param);
		
		String boardId = param.get("board_id");
		log.info("@# findAll boardIdStr=>"+boardId);
		
		HashMap<String, String> queryParam = new HashMap<>();
		queryParam.put("board_id", boardId);
		
		ArrayList<CommentDTO> commentList = (ArrayList<CommentDTO>) service.findAll(queryParam);
		
		return commentList;
	    
	}
	

	
}