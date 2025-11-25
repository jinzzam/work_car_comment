package com.boot.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CommentCriteria {
	private int start_comment_id;
	private int nearest_parent_id;
	private int root_comment_id;
	private int level_depth;
}
