package com.boot.service;

import java.util.ArrayList;
import java.util.HashMap;

import com.boot.dto.MemDTO;

public interface MemService {
	public ArrayList<MemDTO> loginYn(HashMap<String, String> param);
	public void write(HashMap<String, String> param);
}
