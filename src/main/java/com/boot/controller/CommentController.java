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
		comment.setComment_id(Integer.parseInt(param.get("comment_id")));
	    comment.setBoard_id(param.get("board_id")); // String
	    comment.setMember_id(param.get("member_id"));
	    comment.setComment_content(param.get("comment_content"));
	    
	    try {
	        comment.setParent_comment_id(Integer.parseInt(param.get("parent_comment_id")));
	    } catch (NumberFormatException e) {
	        comment.setParent_comment_id(0); // 예외 발생 시 기본값 0 설정
	    }
		
		service.save(param);
		
		HashMap<String, String> queryParam = new HashMap<>();
//		queryParam.put("board_id", Integer.parseInt(param.get("board_id")));
		queryParam.put("board_id", param.get("board_id")); // String 그대로 전달
		
		ArrayList<CommentDTO> commentList = service.findAll(queryParam);
	    
		return commentList;
	}
	
	@GetMapping("/findAll")
	public @ResponseBody ArrayList<CommentDTO> findAll(@RequestParam HashMap<String, String> param) {
		log.info("@# findAll()");
		log.info("@# param=>"+param);
		
		String boardId = param.get("board_id");
		log.info("@# boardIdStr=>"+boardId);
		
		HashMap<String, String> queryParam = new HashMap<>();
		queryParam.put("board_id", boardId); // String 그대로 전달
		
		ArrayList<CommentDTO> commentList = service.findAll(queryParam);
		
		return commentList;
	    
	}
	

	
}