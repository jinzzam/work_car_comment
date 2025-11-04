package com.boot.dao;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.MemDTO;

public interface MemDAO {
	public ArrayList<MemDTO> loginYn(HashMap<String, String> param);
	public void write(HashMap<String, String> param);
}






















