<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>주문 목록</title>
<link rel="stylesheet" href="/netflixmall/resources/css/main_admin_table.css">
<script src="/netflixmall/resources/js/httpRequest.js"></script>
<script>
	//주문 검색
	function search_order(){
		let search_order = document.getElementById("search_order").value;

		if( search_order == '' ){
			alert("입력해주세요");
			return;
		}

		let url = "search_order.do"
		let param = "search_order=" + encodeURIComponent(search_order);

		sendRequest(url, param, search_order_callBack, "get");
	}

	//주문검색 콜백
	function search_order_callBack(){
		if(xhr.readyState == 4 && xhr.status == 200) {
			let data = xhr.responseText;
			let json = (new Function('return ' + data))();
			if(json[0].result == "success"){
				let username = json[1].result2;
				location.href = "order_list.do?username=" + username;
			}else if(json[0].result = "fail"){
				alert("이름을 다시 입력하세요");
				document.getElementById("search_order").focus();  // 입력 필드에 포커스
				return;
			}
		}
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<div class="select">
		<input placeholder="이름을 입력하세여" id="search_order">
		<button onclick="search_order()">검색</button>
		<table id="user_detail_table">
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
			<!-- 이전 주문번호(o_idx)를 저장할 변수 초기화 -->
			<c:set var="prevOIdx" value="" />
		
			<!-- 현재 주문번호에 해당하는 모든 물품 이름을 저장할 변수 초기화 -->   
			<c:set var="names" value="" /> 
			<!-- 현재 주문번호에 해당하는 총 가격 초기화 -->
			<c:set var="totalPrice" value="0" /> 
			<!-- 현재 주문번호에 해당하는 단가 초기화 -->
			<c:set var="pricePerItem" value="" />
			
			<!-- 주문 목록을 순회 -->
			<c:forEach var="vo" items="${list}">
				<c:choose>
					<c:when test="${prevOIdx == vo.o_idx}">
						<!-- 동일한 주문번호: 현재 항목의 물품 이름을 names 변수에 추가 -->
						<c:set var="names" value="${names}, ${vo.name}" />
						<!-- 동일한 주문번호: 수량 합산 -->
						<c:set var="prevQuantity" value="${prevQuantity + vo.quantity}" />
						<!-- 동일한 주문번호: 총 가격 합산 -->
						<c:set var="totalPrice" value="${totalPrice + (vo.quantity * vo.price)}" />
					</c:when>
					<c:otherwise>
						<!-- 다른 주문번호: 이전 주문번호 그룹의 데이터를 출력하고 변수 초기화 -->
						<c:if test="${not empty prevOIdx}">
							<tr>
								<!-- 이전 List 출력 -->
								<td>${prevOIdx}</td>
								<td>${prevUsername}</td>
								<td>${names}</td>
								<td>${prevQuantity}</td>
								<td>${pricePerItem}</td> <!-- 단가 출력 -->
								<td>${totalPrice}</td> <!-- 총 가격 출력 -->
								<td>
									<c:choose>
										<c:when test="${prevStatus == 'Pending'}">접수</c:when>
										<c:when test="${prevStatus == 'Shipped'}">배송 중</c:when>
										<c:when test="${prevStatus == 'Delivered'}">배송 완료</c:when>
										<c:otherwise>${prevStatus}</c:otherwise>
									</c:choose>
								</td>
								<td>
									<fmt:formatDate value="${prevOrderDate}" pattern="yyyy-MM-dd HH:mm" />
								</td>
							</tr>
						</c:if>
						
						<!-- 새로운 주문번호로 초기화 -->
						<c:set var="prevOIdx" value="${vo.o_idx}" />
						<!-- 새로운 주문번호의 첫 번째 물품 이름을 names 변수에 설정 -->
						<c:set var="names" value="${vo.name}" />
						<!-- 새로운 주문번호의 값들 설정 -->
						<c:set var="prevUsername" value="${vo.username}" />
						<c:set var="prevQuantity" value="${vo.quantity}" />
						<c:set var="pricePerItem" value="${vo.price}" /> <!-- 단가 설정 -->
						<c:set var="totalPrice" value="${vo.quantity * vo.price}" /> <!-- 총 가격 설정 -->
						<c:set var="prevPrice" value="${vo.price}" />
						<c:set var="prevTotalPrice" value="${vo.total_price}" />
						<c:set var="prevStatus" value="${vo.status}" />
						<c:set var="prevOrderDate" value="${vo.orderDate}" />
					</c:otherwise>
				</c:choose>
			</c:forEach>
			
			<!-- 루프가 끝난 후, 마지막 주문번호 그룹의 데이터 출력 -->
			<tr>
				<td>${prevOIdx}</td>
				<td>${prevUsername}</td>
				<td>${names}</td>
				<td>${prevQuantity}</td>
				<td>${pricePerItem}</td> <!-- 단가 출력 -->
				<td>${totalPrice}</td> <!-- 총 가격 출력 -->
				<td>
					<c:choose>
						<c:when test="${prevStatus == 'Pending'}">접수</c:when>
						<c:when test="${prevStatus == 'Shipped'}">배송 중</c:when>
						<c:when test="${prevStatus == 'Delivered'}">배송 완료</c:when>
					</c:choose>
				</td>
				<td>
					<fmt:formatDate value="${prevOrderDate}" pattern="yyyy-MM-dd HH:mm" />
				</td>
			</tr>
		</tbody>


		</table>
	</div>
</body>
</html>
