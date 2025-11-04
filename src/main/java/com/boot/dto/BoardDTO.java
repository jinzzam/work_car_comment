package com.boot.dto;

import java.time.LocalDateTime;
import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class BoardDTO {
	private int board_id;
	private String member_id;
	private String title;
	private String content;
	private LocalDateTime created_at;
	private String created_at2;
	private LocalDateTime updated_at;
	private String updated_at2;
	private int view_count;
}
