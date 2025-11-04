package com.boot.dto;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class MemDTO {
	private String member_id;
	private String name;
	private String password;
	private String nickname;
	private String email;
	private String phone_number;
	private Date birthdate;
	private String birthdate2;
	private int admin_ck;
	private String social_type;
	private String social_id;
	
	public MemDTO(String member_id, String name, String password
				, String nickname, String email){
		this.member_id = member_id;
		this.name = name;
		this.password = password;
		this.nickname = nickname;
		this.email = email;
	}
	
}

