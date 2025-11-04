package com.boot.dto;

import java.sql.Timestamp;
import java.time.LocalDateTime;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentDTO {
	private int comment_id;
	private String board_id;
	private String member_id;
	private int parent_comment_id;
	private String comment_content;
	private Timestamp created_at;
	private String created_at2;
	private Timestamp updated_at;
	private String updated_at2;
}
