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

import com.boot.dto.BoardDTO;
import com.boot.dto.MemDTO;
import com.boot.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class BoardController {
	
	static String checkSession(HttpSession session) {
		MemDTO mDTO = (MemDTO) session.getAttribute("LOGIN_MEMBER");
		log.info("@# mDTO=>" + mDTO);
		if(mDTO == null) {
			return "redirect:login";
		}
		return "OK";
	}
	
	@Autowired
	private BoardService service;
	
	@RequestMapping("/list")
//	public String list(Model model) {
	public String list(Model model, HttpServletRequest request) {
		String result = checkSession(request.getSession());
		if(!result.equals("OK")) {
			return "redirect:login";
		}
		
		log.info("@# list()");
		
		ArrayList<BoardDTO> list = service.list();
		model.addAttribute("list", list);
		
		return "list";
	}
	
	@RequestMapping("/write")
	public String write(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		String result = checkSession(request.getSession());
		if(!result.equals("OK")) {
			return "redirect:login";
		}
		
		log.info("@# write()");
		log.info("@# param=>"+param);
		service.write(param);
		
		return "redirect:list";
	}
	
	@RequestMapping("/write_view")
	public String write_view(HttpServletRequest request) {
		String result = checkSession(request.getSession());
		if(!result.equals("OK")) {
			return "redirect:login";
		}
		
		log.info("@# write_view()");
		
		return "write_view";
	}
	
	@RequestMapping("/content_view")
	public String content_view(@RequestParam HashMap<String, String> param, Model model, HttpServletRequest request) {
		String result = checkSession(request.getSession());
		if(!result.equals("OK")) {
			return "redirect:login";
		}
		
		log.info("@# content_view()");
		
		BoardDTO dto = service.contentView(param);
		model.addAttribute("content_view", dto);
		
		return "content_view";
	}
	
	@RequestMapping("/modify")
	public String modify(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		String result = checkSession(request.getSession());
		if(!result.equals("OK")) {
			return "redirect:login";
		}
		
		log.info("@# modify()");
		service.modify(param);
		
		return "redirect:list";
	}
	
	@RequestMapping("/delete")
	public String delete(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		String result = checkSession(request.getSession());
		if(!result.equals("OK")) {
			return "redirect:login";
		}
		
		log.info("@# delete()");
		service.delete(param);
		
		return "redirect:list";
	}
	
//	@RequestMapping("/logout")
//	public String logout(HttpServletRequest request) {
//		HttpSession session = request.getSession();
//		if(session == null) {
//			log.info("이미 세션이 만료되었습니다.");
//		}else {
//			session.invalidate();
//		}
//		return "login";
//	}
}