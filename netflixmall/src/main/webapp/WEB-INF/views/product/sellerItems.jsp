<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>My Items</title>
	<link rel="stylesheet" href="/netflixmall/resources/css/Shop_Goods.css">
	<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
	<link rel="stylesheet" href="/netflixmall/resources/css/footer.css">
	<script>
	
		function toggleButtons(p_idx) {
			var container = document.getElementById('button-container-' + p_idx);
			if (container.classList.contains('show')) {
				container.classList.remove('show');
			} else {
				container.classList.add('show');
			}
		}
		
		
		function del(p_idx) {
			if(!confirm("정말 삭제하시겠습니까?")){
				return;
			}
			location.href="delete.do?p_idx="+p_idx;
		}
		function goToProductDetails(p_idx) {
		    location.href = "product_details.do?p_idx=" + p_idx;
		}
		
	</script>
	
	<script>
		function cart_insert(f) {
			f.submit();
		}
	</script>
	
	</head>
	<body>
		<%@ include file="/WEB-INF/views/users/header.jsp"%>
		
		<h1>netflix Goods mall</h1>
		
		<div id="wrapper">
			<div class="GoodsContainer">
				<c:forEach var="product" items="${product}">
					<div class="GoodsBox">
						<div class="img" onclick="goToProductDetails(${product.p_idx})">
							<c:if test="${ product.filename1 ne 'no_file' }">
								<img src="/netflixmall/resources/upload/${product.filename1}">
							</c:if>
						</div>
	
						<div class="ExplainBox">
							<p>${product.name}</p>
							<p>가격: ${product.price}</p>
							<p>카테고리: ${product.category}</p>
						</div>
						
						<div id="button-container-${product.p_idx}" class="buttonContainer">
							<input type="button" value="수정" class="btn"
								onclick="location.href='modify_form.do?p_idx=${product.p_idx}'">
							<input type="button" value="삭제" class="btn"
								onclick="del(${product.p_idx});">
						</div>
	
						<div class="toggleButton" onclick="toggleButtons(${product.p_idx})">
							버튼 표시/숨기기</div>
					</div>
				</c:forEach>
	
			</div>
		</div>
		<%@ include file="/WEB-INF/views/users/footer.jsp"%>
		
	</body>
</html>





