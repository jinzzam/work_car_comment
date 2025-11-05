package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
	
//	static String checkSession(HttpServletRequest request) {
//		HttpSession session = request.getSession();
//		MemDTO mDTO = (MemDTO) session.getAttribute("LOGIN_MEMBER");
//		
//		if(mDTO == null) {
//			return "redirect:logout";
//		}
//		return "redirect:comment/save";	
//	}
	
	
	@Autowired
	private CommentService service;
	
	@RequestMapping("/save")
//	public String save(@RequestParam HashMap<String, String> param, Model model) {
	public @ResponseBody ArrayList<CommentDTO> save(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
//		checkSession(request);
		
		log.info("@# save()");
		log.info("@# param=>"+param);
		
		String boardId = param.get("board_id");
		log.info("@# boardIdStr=>"+boardId);
//	    Integer boardId = Integer.parseInt(boardIdStr);
		
//	    param.put("board_id", boardId); // service.findAll을 위해 param 맵에 board_id 추가
		service.save(param);
		ArrayList<CommentDTO> commentList = service.findAll(param);
	    
		
//		return "redirect:list";
		return commentList;
	}
	

	
}