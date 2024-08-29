<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>관리자 페이지</title>
<link rel="stylesheet" href="/netflixmall/resources/css/main_admin_table.css">
<script src="/netflixmall/resources/js/httpRequest.js"></script>
<script>
	    </script>
</head>
<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>

	<!-- 사용자 테이블 -->
	<section>
		<div class="item1">
			<div class="item-caption">
				<div class="item-title">사용자 목록</div>
				<a href="users_detail_list.do?is_approved=2">자세히보기</a>
			</div>
			<table>
				<thead>
					<tr>
						<th>이름</th>
						<th>가입 날짜</th>
						<th>판매 가능 여부</th>
						<th>블락 처리 여부</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${list1}">
						<tr>
							<td>
								<c:if test="${vo.is_deleted eq 1}">
									<font color="gray">${vo.username}
									(${vo.email})은 블락처리된 유저입니다
									</font>
								</c:if> 
								<c:if test="${vo.is_deleted eq 0}">
										${vo.username}(${vo.email})
								</c:if>
							</td>
							<td>
								<fmt:formatDate value="${vo.regdate}"
									pattern="yyyy-MM-dd" />
							</td>
							<td>
								<c:if test="${vo.is_approved eq 0}">
									사용자
								</c:if>
								<c:if test="${vo.is_approved eq 1}">
									판매자
								</c:if>
							</td>
							<td>${vo.is_deleted}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		<!-- 제품 테이블 -->
		<div class="item1">
			<div class="item-caption">
				<div class="item-title">제품 목록</div>
				<a href="Products_detail_list.do">자세히보기</a>
			</div>
			<table>
				<thead>
					<tr>
						<th>제품명</th>
						<th>제품 가격</th>
						<th>제품 수량</th>
						<th>카테고리</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${list2}">
						<tr>
							<td>${vo.name}</td>
							<td>${vo.price}</td>
							<td>${vo.stock}</td>
							<td>${vo.category}</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>

		
	</section>
<!-- 주문 목록 보기 -->
		<div class="item">
			<div class="item-caption">
				<div class="item-title">주문 목록</div>
				<a href="order_list.do">자세히보기</a>
			</div>
			<table>
				<thead>
					<tr>
						<th>주문번호</th>
						<th>주문한 사람</th>
						<th>주문 상태</th>
						<!-- 추가해야됨 -->
						<th>주문 날짜</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${list4}">
						<tr>
							<td>${vo.o_idx}</td>
							<td>${vo.username}</td>
							<td><c:choose>
									<c:when test="${vo.status == 'Pending'}">
										접수
									</c:when>
									<c:when test="${vo.status == 'Shipped'}">
										배송중
									</c:when>
									<c:when test="${vo.status == 'Delivered'}">
										완료
									</c:when>
									<c:otherwise>
										기타
									</c:otherwise>
								</c:choose></td>
							<td>
								<fmt:formatDate value="${vo.orderDate}" pattern="yyyy-MM-dd HH:mm" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
</body>
</html>
