<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>사용자 상세보기</title>
<link rel="stylesheet"
	href="/netflixmall/resources/css/main_admin_table.css">
<script src="/netflixmall/resources/js/httpRequest.js"></script>
<script>
		 //유저 검색 화면에 저장헤놓는 기능
		 window.onload = function(){
				let select_user = document.getElementById("select_user");
				let user_array = [ 1, 2, 0 ];
				
				//for( let i = 0; i < user_array.length; i++ ){
					//     0 - 사용자
					//     1 - 판매자
					//     2 - 전체
					if( '${param.is_approved}' == user_array[2] ){//0
						select_user[1].selected = true;
					}
					
					if( '${param.is_approved}' == user_array[0] ){//1
						select_user[2].selected = true;
					}
					
					if( '${param.is_approved}' == user_array[1] ){//2
						select_user[0].selected = true;
					}
				
			}
		 
			// 사용자 블락
			function user_block(u_idx){
				if(!confirm("정말 블락처리 하시겠습니까?")){
					return;
				}

				let blockReason = prompt("사유를 적어주세요");
				if (blockReason == null || blockReason.trim() == "") {
					alert("사유를 입력해야 합니다.");
					return;
				}

				let url = "user_delete.do";
				let param = "u_idx=" + u_idx + "&blockReason=" + encodeURIComponent(blockReason);

				sendRequest(url, param, deleteUsetFn, "post");
			}
			

			// 사용자 블락 콜백함수
			function deleteUsetFn(){
				if(xhr.readyState == 4 && xhr.status == 200){
					let data = xhr.responseText;
					let json = (new Function('return '+ data))();

					if(json[0].result == 'success'){
						alert("블락처리 성공했습니다.");
						location.href = "users_detail_list.do?is_approved=2";
					}else{
						alert("블락처리 실패")
					}
				}
			}

			// 사용자 블락 취소
			function user_unblock(u_idx){
				if(!confirm("정말 블락을 취소하시겠습니까?")){
					return;
				}

				let url = "user_unblock.do";
				let param = "u_idx=" + u_idx;
				sendRequest(url, param, unblockUserFn, "post");
			}

			// 사용자 블락 취소 콜백함수
			function unblockUserFn(){
				if(xhr.readyState == 4 && xhr.status == 200){
					let data = xhr.responseText;
					let json = (new Function('return '+ data))();
					
					if(json[0].result == 'success'){
						alert("블락 취소 성공했습니다.");
						location.href = "users_detail_list.do?is_approved=2";
					}else{
						alert("블락 취소 실패");
					}
				}
			}
			
			//사용자, 판매자 따로 보여주기
			function select_user_status(){
				let user_status = document.getElementById("select_user").value;
				
				let url = "user_status.do"
				let param = "";

				if (user_status === "all") {
					param = "is_approved=2";
				} else if (user_status === "user") {
					param = "is_approved=0";
				} else if (user_status === "seller") {
					param = "is_approved=1";
				}
				sendRequest(url, param, select_user , "get");
			}

			//사용자 구분 콜백함수
			function select_user(){
				if(xhr.readyState == 4 && xhr.status == 200) {
					let data = xhr.responseText;
					let json = (new Function('return ' +  data))();
					if(json[0].result == 'success'){
						let is_approved = json[1].is_approved2;
						location.href = "users_detail_list.do?is_approved=" + is_approved;
					} else {
						alert("왜 실패지?");
					}
				}
			} 

			//유저검색
			function search_users(){
				let search_user = 
					document.getElementById("search_user").value;
				
				if( search_user == '' ){
					alert("입력해주세요");
					return;
				}

				let url = "search_users.do"
				let param = "search_user=" + encodeURIComponent(search_user);
				sendRequest(url, param, search_user_callBack, "get");
			}

			//유저검색 콜백
			function search_user_callBack(){
				if(xhr.readyState == 4 && xhr.status == 200) {
					let data = xhr.responseText;
					let json = (new Function('return ' + data))();
					if(json[0].result == "success"){
						let email = json[1].result2;
						let is_approved = json[2].result3;
						location.href = "users_detail_list.do?is_approved="+ is_approved +"&search_user=" + email;
					}else if(json[0].result = "fail"){
						alert("이메일을 다시 입력하세요");
						document.getElementById("search_user").focus(); 
						return;
					}
				}
				
			}

			function showUserOrders(username) {
				location.href = 'order_list.do?username=' + encodeURIComponent(username);
			}
			
			function apply_seller(u_idx) {
				
				if (!confirm("정말 판매자로 변경 하시겠습니까?")) {
					return;
				}

				let url = "apply_seller.do";
				let param = "u_idx=" + u_idx;

				sendRequest(url, param, applySellerFn, "post");
				
			}
			
			// 판매자 신청 콜백함수
			function applySellerFn(){
				if(xhr.readyState == 4 && xhr.status == 200){
					let data = xhr.responseText;
					let json = (new Function('return '+ data))();
					
					if(json[0].result == 'success'){
						alert("판매자 변경을 성공했습니다.");
						location.href = "users_detail_list.do?is_approved=2";
					}else{
						alert("판매자 변경 실패");
					}
				}
			}
</script>
</head>
<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<div class="select">
		<select id="select_user" onchange="select_user_status()">
			<option value="all">전체보기</option>
			<option value="user">사용자</option>
			<option value="seller">판매자</option>
		</select> <input placeholder="이메일을 입력하세여" id="search_user">
		<button onclick="search_users()">검색</button>
		<table id="user_detail_table">
			<thead>
				<tr>
					<th>이름</th>
					<th>가입 날짜</th>
					<th>판매 가능 여부</th>
					<th>블락 처리 여부</th>
					<th>블락 처리 사유</th>
					<th>비고</th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="vo" items="${list}">
					<tr class="${vo.is_deleted == 1 ? 'blocked-user' : ''}">
					<!-- is_deleted 는 빨간색으로 표시 하기 위해 씀 -->
						<td>
							<c:if test="${vo.is_deleted eq 1}">
								<font color="red">
									${vo.username}(${vo.email})은 블락처리된 유저입니다
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
						<td>
							<c:if test="${empty vo.block_reason}">
								x
							</c:if> 
							<c:if test="${not empty vo.block_reason}">
								${vo.block_reason}
							</c:if></td>
						<td colspan=2>
							<c:if test="${vo.block_reason eq null }">
								<input class="block_btn" type="button" value="블랙"
								onclick="user_block('${vo.u_idx}')"> 
							</c:if>
							<c:if test="${vo.block_reason ne null }">
								<input
								class="block_btn" type="button" value="블랙취소"
								onclick="user_unblock('${vo.u_idx}')">
							</c:if>
							<c:if test="${vo.role eq 'user' and vo.block_reason eq null }">
								/	<input class="apply_btn" type="button" onclick="apply_seller(${vo.u_idx})" value="판매자 승인">
							</c:if>
						</td>
					</tr>
				</c:forEach>
			</tbody>
		</table>
	</div>
</body>
</html>