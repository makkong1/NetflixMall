<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet"
	href="/netflixmall/resources/css/main_admin_table.css">
<script src="/netflixmall/resources/js/httpRequest.js"></script>
<script>
	//제품 블락 처리
	function block_products(p_idx) {
		if (!confirm("정말 블락처리 하시겠습니까?")) {
			return;
		}

		let blockReason = prompt("사유를 적어주세요");
		if (blockReason == null || blockReason.trim() == "") {
			alert("사유를 입력해야 합니다.");
			return;
		}

		let url = "product_block.do"
		let param = "p_idx=" + p_idx + "&blockReason="
				+ encodeURIComponent(blockReason);

		sendRequest(url, param, deleteProductFn, "post");
	}

	//제품 블락 콜백함수
	function deleteProductFn() {
		if (xhr.readyState == 4 && xhr.status == 200) {
			let data = xhr.responseText;
			let json = (new Function('return ' + data))();

			if (json[0].result == 'success') {
				alert("블락처리 성공했습니다.");
				location.href = "Products_detail_list.do";
			} else {
				alert("블락처리 실패")

			}
		}
	}

	//제품 블락 취소 처리
	function unblock_products(p_idx) {
		if (!confirm("정말 블락 취소 하시겠습니까?")) {
			return;
		}

		let url = "product_unblock.do"
		let param = "p_idx=" + p_idx;

		sendRequest(url, param, UnDeleteProductFn, "post");
	}

	//제품 블락 취소 콜백함수
	function UnDeleteProductFn() {
		if (xhr.readyState == 4 && xhr.status == 200) {
			let data = xhr.responseText;
			let json = (new Function('return ' + data))();
			if (json[0].result == 'success') {
				alert("블락취소처리 성공했습니다.");
				location.href = "Products_detail_list.do";
			} else {
				alert("블락취소처리 실패")
			}
		}
	}

	//제품 검색
	function search_product() {
		let search_product = document.getElementById("search_product").value;
		let url = "product_search.do";
		let param = "search_product=" + search_product;

		sendRequest(url, param, product_search_callBack, "get")
	}

	//제품 검색 콜백
	function product_search_callBack() {
		if (xhr.readyState == 4 && xhr.status == 200) {
			let data = xhr.responseText;
			let json = (new Function('return ' + data))();
			if (json[0].result == "success") {
				let product_name = json[1].result2;
				location.href = "Products_detail_list.do?product_name="
						+ product_name;
			} else {
				alert("제품을 다시 입력하세요");
				document.getElementById("search_product").focus();
			}
		}
	}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<div class="select1">
		<input placeholder="제품 이름을 입력하세여" id="search_product">
		<button onclick="search_product()">검색</button>
		<table id="user_detail_table">
			<thead>
				<tr>
					<th>제품 사진</th>
					<th>제품명</th>
					<th>제품 설명</th>
					<th>제품 가격</th>
					<th>제품 수량</th>
					<th>카테고리</th>
					<th>블락 사유</th>
					<th>비고</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="vo" items="${p_list}">
					<tr class="${not empty vo.block_reason ? 'blocked-product' : ''}">
						<td>
							<c:if test="${empty vo.block_reason}">
								<c:if test="${vo.filename1 ne 'no_file'}">
									<img src="/netflixmall/resources/upload/${vo.filename1}" alt="${vo.name}">
								</c:if>
							</c:if> 
							<c:if test="${not empty vo.block_reason}">
								<font color="red">${vo.name}는 블락처리된 제품입니다</font>
							</c:if></td>
						<td>
							<c:if test="${not empty vo.block_reason}">
								<font color="red">${vo.name}는 블락처리된 제품입니다</font>
							</c:if> 
							<c:if test="${empty vo.block_reason}">
								${vo.name}
							</c:if>
						</td>
						<td>${vo.description}</td>
						<td>${vo.price}</td>
						<td>${vo.stock}</td>
						<td>${vo.category}</td>
						<td>
							<c:if test="${empty vo.block_reason}">
								x
							</c:if>
							<c:if test="${not empty vo.block_reason}">
								${vo.block_reason}
							</c:if>
						</td>
						<td>
							<c:if test="${vo.block_reason eq null}">
								<input class="block_btn" type="button" value="블락"
								onclick="block_products('${vo.p_idx}')"> 
							</c:if>
							<c:if test="${vo.block_reason ne null}">
								<input
								class="block_btn" type="button" value="블락취소"
								onclick="unblock_products('${vo.p_idx}')">
							</c:if>
						</td>
					</tr>
					<tr>
						<td colspan="8"><hr></td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>