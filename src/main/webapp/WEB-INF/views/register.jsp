<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
</head>
<body>
	<table border="1" align="center">
		<form method="post" action="registerOk">
			<tr height="50">
				<td colspan="2">
					<h1>회원 가입 신청</h1>
				</td>
			</tr>
			<tr height="30">
				<td width="80">
					ID
				</td>
				<td>
					<input type="text" size="20" name="member_id">
				</td>
			</tr>
			<tr height="30">
				<td width="80">
					암호
				</td>
				<td>
					<input type="text" size="20" name="password">
				</td>
			</tr>
			<tr height="30">
				<td width="80">
					이름
				</td>
				<td>
					<input type="text" size="20" name="name">
				</td>
			</tr>
			<tr height="30">
				
			</tr>
			<tr height="30">
				<td width="80">
					닉네임
				</td>
				<td>
					<input type="text" size="20" name="nickname">
				</td>
			</tr>
			<tr height="30">
				
			</tr>
			<tr height="30">
				<td width="80">
					이메일
				</td>
				<td>
					<input type="text" size="20" name="email">
				</td>
			</tr>
			<tr height="30">
				
			</tr>
			<tr height="30">
				<td width="80">
					전화번호
				</td>
				<td>
					<input type="text" size="20" name="phone_number">
				</td>
			</tr>
			<tr height="30">
				<td width="80">
					생년월일
				</td>
				<td>
					<input type="date" size="20" name="birthdate">
				</td>
			</tr>
			<tr height="30">
				<td>
					<input type="submit" value="가입">
				</td>
			</tr>
		</form>
	</table>
</body>
</html>