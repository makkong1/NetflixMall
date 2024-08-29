<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8">
		<title>상품 수정</title>
		<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
		<link rel="stylesheet" href="/netflixmall/resources/css/Shop_insert.css">
		<script
			src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
		<script src="/netflixmall/resources/js/uploadImage.js"></script>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/users/header.jsp"%>
		<div id="wrapper">
			<form action="update.do" method="post" enctype="multipart/form-data">
				<input type="hidden" name="p_idx" value="${vo.p_idx}"> 
				
				<label>제품 이름</label> 
				<input type="text" name="name" value="${vo.name}" required /> 
					
				<label>설명</label>
				<textarea name="description" required>${vo.description}</textarea>
	
				<label>가격</label> 
				<input type="number" name="price" value="${vo.price}" required /> 
				
				<label>재고수량</label> 
				<input type="number" name="stock" value="${vo.stock}" required /> 
				
				<label>카테고리</label>
				<input type="text" name="category" value="${vo.category}" required />
	
				<img src="/resources/upload/${vo.filename1}" alt="${vo.filename1}"
					style="width: 100px; height: auto;" /> 
				<img src="/resources/upload/${vo.filename2}" alt="${vo.filename2}"
					style="width: 100px; height: auto;" /> 
				<img src="/resources/upload/${vo.filename3}" alt="${vo.filename3}"
					style="width: 100px; height: auto;" /> 4-
				<img src="/resources/upload/${vo.filename4}" alt="${vo.filename4}"
					style="width: 100px; height: auto;" /> 
				<img src="/resources/upload/${vo.filename5}" alt="${vo.filename5}"
					style="width: 100px; height: auto;" /> 
				<img src="/resources/upload/${vo.filename6}" alt="${vo.filename6}"
					style="width: 100px; height: auto;" /> 
				
				<br> 
					
				<label>새 이미지 업로드 (최대 6개)</label> <input type="file" name="photos" /> 
				<input type="file" name="photos" /> <input type="file" name="photos" /> 
				<input type="file" name="photos" /> <input type="file" name="photos" /> 
				<input  type="file" name="photos" />
	
				<button type="submit">수정</button>
			</form>
		</div>
	</body>
</html>
