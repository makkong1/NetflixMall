<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 목록</title>
<link rel="stylesheet"
	href="/netflixmall/resources/css/main_admin_table.css">
<script src="/netflixmall/resources/js/httpRequest.js"></script>
</head>
<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<div class="select" style="background: white">
		<div class="item">
			<div class="item-caption">
				<div class="item-title">주문 목록</div>
			</div>
			<table>
				<thead>
					<tr>
						<th>주문번호</th>
						<th>주문한 사람</th>
						<th>주문한 물품</th>
						<th>수량</th>
						<th>단가</th>
						<th>총가격</th>
						<th>주문 상태</th>
						<th>주문 시간</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="vo" items="${o_list}">
						<tr>
							<td>${vo.o_idx}</td>
							<td>${vo.username}</td>
							<td>${vo.name}</td>
							<td>${vo.quantity}</td>
							<td>${vo.price}</td>
							<td>${vo.total_price}</td>
							<td>
								<c:choose>
									<c:when
										test="${sessionScope.role == 'seller' || sessionScope.role == 'admin'}">
										<select name="status"
											onchange="updateStatus(${vo.o_idx}, this.value)">
											<option value="Pending"
												${vo.status == 'Pending' ? 'selected' : ''}>접수</option>
											<option value="Shipped"
												${vo.status == 'Shipped' ? 'selected' : ''}>배송중</option>
											<option value="Delivered"
												${vo.status == 'Delivered' ? 'selected' : ''}>완료</option>
										</select>
									</c:when>
									<c:otherwise>
										${vo.status}
									</c:otherwise>
								</c:choose>
							</td>
							<td>
								<fmt:formatDate value="${vo.orderDate}" attern="yyyy-MM-dd HH:mm" />
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</body>
</html>
