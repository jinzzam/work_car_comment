package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Param;

import com.boot.dto.CommentDTO;

//public class BoardDAO {
public interface CommentDAO {
	public void save(HashMap<String, String> param);
	public ArrayList<CommentDTO> findAll(HashMap<String, String> param);
	public ArrayList<CommentDTO> findAll(@Param("paramMap") HashMap<String, String> param
										,@Param("board_id") int board_id);

}

