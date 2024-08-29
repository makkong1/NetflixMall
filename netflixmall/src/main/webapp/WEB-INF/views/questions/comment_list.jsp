<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<style>
body {
        font-family: 'Arial', sans-serif;
        background-color: #2F2F2F;
        margin: 0;
        padding: 0;
        color: black;
    }

    .comm-box {
        background-color: #fff;
        border-radius: 10px;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        margin: 20px 0 20px 20px;
        padding: 20px;
        max-width: 600px;
    }

    .comm-box span {
        display: inline-block;
        margin-bottom: 10px;
    }

    .nick {
        font-weight: bold;
        font-size: 18px;
        color: #333;
    }

    .content {
        color: #555;
        font-size: 16px;
        margin-bottom: 10px;
    }

    .date {
        color: gray;
        font-size: 12px;
    }

    #reply {
        color: #007bff;
        cursor: pointer;
        font-size: 14px;
    }

    .writeBox {
        display: none;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 15px;
        margin-top: 15px;
        background-color: #f9f9f9;
    }

    #nickname {
        padding: 10px;
        border-bottom: 1px solid #ddd;
        width: calc(100% - 50px);
        margin-bottom: 10px;
    }

    .comment-ta {
        width: calc(100% - 30px);
        height: 80px;
        border: 1px solid #ddd;
        border-radius: 5px;
        padding: 10px;
        resize: none;
    }

    .comment-btn {
        color: #fff;
        background-color: #007bff;
        border: none;
        border-radius: 5px;
        padding: 10px 20px;
        cursor: pointer;
        margin-right: 10px;
        margin-top: 10px;
    }

    .comment-btn:hover {
        background-color: #0056b3;
    }


</style>

<script>
	
</script>

</head>
<body>
	<c:forEach var="vo" items="${ list }">
	
		<div class="comm-box">
		
			
				<c:if test="${ vo.depth ne 0 }">ㄴ</c:if>
				<span class="nick" >${ vo.nickname }</span>
				<br>
				<span class="content">${ vo.content }</span>
				<br>
				<span style="color: gray;">
					<fmt:formatDate value="${ vo.regdate }" pattern="yyyy-MM-dd HH:mm" />
				</span>
			
			<span id="reply" onclick="show_commentBox(${vo.c_idx})">답글쓰기</span>
			<div id="comment-writeBox-${vo.c_idx}" class="writeBox">
				<form >
					<input type="hidden" name="c_idx" value="${vo.c_idx}">
					<input type="hidden" name="q_id" value="${vo.q_id}">
					<input type="hidden" name="email" value="${sessionScope.user.email}">
					<label style="color: gray;" for="nickname">Nickname : </label>
					<input id="nickname" type="text" name="nickname">
					<br>
					<textarea name="content" class="comment-ta" rows="4" cols="60" placeholder="${vo.nickname}님께 댓글을 남겨보세요"></textarea>
					<span id="reply" onclick="close_commentBox(${vo.c_idx})">취소</span> 
					<input class="comment-btn" type="button" value="등록" onclick="reply(this.form)">
				</form>
			</div>
		</div>
		<hr>
	</c:forEach>
	
	
	
	
</body>
</html>