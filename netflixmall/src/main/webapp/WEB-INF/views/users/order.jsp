<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ page import="java.util.List"%>
<%@ page import="vo.OrderVO"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Order Management</title>
<link rel="stylesheet" href="/netflixmall/resources/css/header.css">
 <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
 <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<h2>주문관리 페이지</h2>

	<table border="1">
		<tr>
			<td>주문항목번호</td>
			<th>주문 번호</th>
			<th>주문자 번호</th>
			<th>총 가격</th>
			<th>상태</th>
			<th>주문 일자</th>
			<th>조회</th>
			<th>반품</th>
			<th>취소</th>
		</tr>
		<c:forEach var="vo" items="${orderList}">
			<tr>
				<td>${vo.o_idx}</td>
				<td>${vo.u_idx}</td>
				<td>${vo.total}</td>
				<td>${vo.status}</td>
				<td><fmt:formatDate value="${vo.orderDate}"
						pattern="yyyy-MM-dd HH:mm:ss" /></td>
				<td><a href="<spring:url value='/returnOrder/${vo.o_idx}' />">반품하기</a></td>
				<td><a href="<spring:url value='/cancelOrder/${vo.o_idx}' />">취소하기</a></td>
			</tr>
		</c:forEach>
	</table>
</body>
</html>