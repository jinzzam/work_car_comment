package com.boot.controller;

import java.util.ArrayList;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

//import javax.servlet.http.HttpServletRequest;
//import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.boot.dto.MemDTO;
import com.boot.service.MemService;

import lombok.extern.slf4j.Slf4j;

@Controller
@Slf4j
public class MemController {
	
	@Autowired
	private MemService service;
	
//	로그인 화면 이동
	@RequestMapping("/login")
	public String login() {
		log.info("@# login()");
		
		return "login";
	}
	
//	로그인화면->로그인 여부 판단
	@RequestMapping("/login_yn")
//	public String login_yn(@RequestParam HashMap<String, String> param, Model model) {
	public String login_yn(@RequestParam HashMap<String, String> param, HttpServletRequest request) {
		log.info("@# login_yn()");
		log.info("@# param=>"+param);
		
		
		HttpSession session = request.getSession();
		
		MemDTO dto = new MemDTO(param.get("member_id")
							  , param.get("name")
							  , param.get("password")
							  , param.get("nickname")
							  , param.get("email")
				);
		MemDTO mDto = null;
		
		ArrayList<MemDTO> dtos = service.loginYn(param);
		
		if (dtos.isEmpty()) {
			return "login";
		} else {
			if (param.get("password").equals(dtos.get(0).getPassword())) {
//				로그인 성공시 사용자정보를 세션에 저장
				session.setAttribute("LOGIN_MEMBER", dto);
				mDto = (MemDTO) session.getAttribute("LOGIN_MEMBER");
				log.info("@# param=>"+param);

//				return "login_ok";
				return "redirect:list";
			} else {
				return "login";
			}
		}
	}
	

//	등록 화면 이동
	@RequestMapping("/register")
	public String register() {
		log.info("@# register()");
		
		return "register";
	}
	
	@RequestMapping("/registerOk")
	public String registerOk(@RequestParam HashMap<String, String> param, Model model) {
		log.info("@# registerOk()");
		
		service.write(param);
		
		return "login";
	}
//	@RequestMapping("/logout_mem")
//	public String logout(HttpServletRequest request) {
//		log.info("@# logout()");
//		
//		HttpSession session = request.getSession();
//		session.invalidate();
//		
//		return "login";
//	}
	
	@RequestMapping("/logout")
	public String logout(HttpServletRequest request) {
		HttpSession session = request.getSession();
		log.info("@# logout()");
		log.info("@# session => " + session.getSessionContext());
		if(session.getAttribute("LOGIN_MEMBER") == null) {
			log.info("이미 세션이 만료되었습니다.");
		}else {
			log.info("@# 로그인 세션 =>" + session.getAttribute("LOGIN_MEMBER"));
			log.info("세션을 삭제합니다.");
			session.invalidate();
		}
		return "redirect:login";
	}
}









