<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.UsersVO"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%
HttpSession httpSession = request.getSession();
UsersVO user = (UsersVO) httpSession.getAttribute("user");
%>
<!DOCTYPE html>
<html>
	<head>
	<meta charset="UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
	<link rel="stylesheet" href="/netflixmall/resources/css/user_info.css">
	<script src="/netflixmall/resources/js/httpRequest.js"></script>
	<script>
	  let userEmail = '${user.email}';
	</script>
	<script>
	  function showPop() {
	    document.getElementById("changePwdPopup").style.display = "block";
	  }
	
	  function closePop() {
	    document.getElementById("changePwdPopup").style.display = "none";
	  }
	
	  function showPop_delete() {
	    document.getElementById("deletePopup").style.display = "block";
	  }
	
	  function closePop_delete() {
	    document.getElementById("deletePopup").style.display = "none";
	  }
	
	  let isPwd = false;
	
	  function is_pwd() {
	    isPwd = false;
	  }
	  
	function showSellerPop() {
		document.getElementById("changeUserPopup").style.display = "block";
	}
	function closeSellerPop() {
		document.getElementById("changeUserPopup").style.display = "none";
	}
	
	
	  function validPwd() {
	    let currentPwd = document.getElementById("currentPwd").value.trim();
	    let newPwd = document.getElementById("newPwd");
	
	    let regex = /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[\W_])[0-9a-zA-Z\W_]{8,20}$/;
	
	    if (currentPwd !== "" && currentPwd === newPwd.value.trim()) {
	      newPwd.value = "";
	      return "기존의 비밀번호와 같습니다";
	    }
	
	    if (!regex.test(newPwd.value.trim())) {
	      newPwd.value = "";
	      return "비밀번호는 8자 이상 20자 이하의 영문자, 숫자, 특수문자를 포함해야 합니다";
	    } else {
	      return "비밀번호 조합 성공";
	    }
	  }
	
	  function checkPwd() {
	    let msg = validPwd();
	
	    document.getElementById("text1").textContent = msg;
	  }
	
	  //비밀번호 일치여부 확인 함수
	  function matchPwd() {
	    let newPwd = document.getElementById("newPwd");
	    let confirmPwd = document.getElementById("confirmPwd");
	
	    if (newPwd.value.trim() !== confirmPwd.value.trim()) {
	      confirmPwd.value = "";
	      isPwd = false;
	      return "비밀번호가 불일치합니다";
	    } else if (newPwd.value.trim() !== "" && newPwd.value.trim() === confirmPwd.value.trim()) {
	      isPwd = true;
	      return "비밀번호가 일치합니다";
	    }
	  }
	
	  function confirmPassword() {
	    let msg = matchPwd();
	
	    document.getElementById("text2").textContent = msg;
	  }
	
	  //비밀번호 수정 함수
	  function updatePwd(f) {
	    let currentPwd = f.currentPwd.value.trim();
	    let newPwd = f.newPwd.value.trim();
	    let confirmPwd = f.confirmPwd.value.trim();
	
	    if (currentPwd == '' || newPwd == '' || confirmPwd == '') {
	      alert("모든 항목을 입력해주세요");
	      return;
	    }
	
	    if (!isPwd) {
	      alert("비밀번호 확인을 다시 진행해주세요");
	      return;
	    }
	
	    console.log(userEmail);
	    let url = "update_pwd.do";
	    let param = "email=" + encodeURIComponent(userEmail) + "&password=" + encodeURIComponent(currentPwd) + "&new_password=" + encodeURIComponent(newPwd);
	    sendRequest(url, param, resultFn, "post");
	  }
	
	  function resultFn() {
	    if (xhr.readyState == 4 && xhr.status == 200) {
	      let data = xhr.responseText;
	      let json = (new Function('return ' + data))();
	
	      if (json[0].result == "success") {
	        alert("비밀번호가 변경되었습니다. 로그인페이지로 이동합니다.");
	        location.href = "logout.do";
	      }
	      if (json[0].result == "fail") {
	        alert("비밀번호 변경 실패");
	        return;
	      }
	      if (json[0].result == "no_match") {
	        alert("입력하신 현재 비밀번호가 일치하지 않습니다.");
	        return;
	      }
	
	    }
	  }
	
	  // 스페이스바 입력 방지 함수
	  function preventSpace(event) {
	    if (event.key === ' ') {
	      event.preventDefault();
	    }
	  }
	  
	  function delete_user(f) {
	    let password = f.password;
	    
	    let regex = /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[\W_])[0-9a-zA-Z\W_]{8,20}$/;
	    
	    if(password.value.trim() == ""){
	      alert("비밀번호를 입력하세요.");
	      return;
	    }
	    
	    if(!regex.test(password.value.trim())){
	      alert("비밀번호는 8자 이상 20자 이하의 영문자, 숫자, 특수문자를 포함해야 합니다.");
	      password.value = "";
	      password.focus();
	      return;
	    }
	    
	    let url = "delete_user.do";
	    let param = "email=" + encodeURIComponent(userEmail) + "&password=" + encodeURIComponent(password.value.trim());
	    sendRequest(url, param, resultDelete, "post");
	    
	  }
	  
	  function resultDelete() {
	    let password = document.getElementById("pwdForDelete");
	    if(xhr.readyState == 4 && xhr.status == 200){
	      let data = xhr.responseText;
	      let json = (new Function('return ' + data))();
	      
	      if(json[0].result == "no_email"){
	        alert("미 가입된 이메일입니다.");
	        return;
	      } else if(json[0].result == "no_match") {
	        alert("비밀번호가 일치하지 않습니다.");
	        password.value = "";
	        password.focus();
	        return;
	      } else if(json[0].result == "fail"){
	        alert("회원삭제 실패.");
	        return;
	      } else {
	        alert("웹사이트에서 탈퇴되었습니다.");
	        location.href = "logout.do";
	      }
	    }
	  }
	  
	function send_apply_seller(f){
		let email = f.email.value.trim();
		let title = f.title.value.trim();
		let content = f.content.value.trim();
		let pwd = f.pwd;//얘는 비밀번호 필드
		let password = pwd.value.trim();//얘는 비밀번호 value값
		
		let regex = /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[\W_])[0-9a-zA-Z\W_]{8,20}$/;
		
		if(title == '' || content == ''  || password == ''){
			alert("모든 필드를 입력하세요.");
			return;
		}
	      
		// 길이 검사 (예: 제목은 최소 3자, 최대 100자, 내용은 최소 10자, 최대 2000자)
		if(title.length < 3 || title.length > 100){
			alert("제목은 3자 이상 100자 이하로 입력하세요.");
			return; // 기본 폼 제출을 막음
		}
	   
		if(content.length < 5 || content.length > 2000){
			alert("내용은 5자 이상 2000자 이하로 입력하세요.");
			return; // 기본 폼 제출을 막음
		}
	      
		// 특수 문자 검사 (예: 제목에 특정 특수 문자가 포함되지 않도록)
		let specialCharRegex = /[<>]/g;
		if(specialCharRegex.test(title)){
			alert("제목에 특수 문자를 포함할 수 없습니다.");
			return; // 기본 폼 제출을 막음
		}
	      
		//비밀번호 유효성 검사
		if(!regex.test(password)){
			alert("비밀번호는 8자 이상 20자 이하의 영문자, 숫자, 특수문자를 포함해야 합니다.");
			pwd.value = "";
			pwd.focus();
			return;
		}
		
		let url = "insert_question.do";
		let param = "email=" + encodeURIComponent(email) + "&title=" + title + "&content=" + content +"&pwd=" + encodeURIComponent(password);
		sendRequest(url, param, resultFn, "post");
	}
	
	function resultFn() {
		let pwd = document.getElementById("write-input");

		if(xhr.readyState == 4 && xhr.status == 200){
			let data = xhr.responseText;
			let json = (new Function('return ' + data))();

			if(json[0].result == 'fail'){
				alert("비밀번호가 일치하지 않습니다.");
				pwd.value = "";
				pwd.focus();
				return;
			} else if(json[0].result == 'no_email'){
				alert("미가입 이메일입니다.");
				return;
			} else {
				alert("문의글이 등록되었습니다. 감사합니다.");
				location.href = "question_list.do";
			}
		}
	}
	</script>
	</head>
	
	<body>
		<%@ include file="/WEB-INF/views/users/header.jsp"%>
		<div id="wrapper">
			<div class="infoContainer">
				<p class="userTitle">${user.username}님,안녕하세요!</p>
				<p>${user.email}</p>
				<p>${user.address}</p>
				<input class="changePwd" type="button" value="비밀번호 변경하기" onclick="showPop()">
				<br>
				<c:if test="${ sessionScope.role eq 'user'}">
					<input class="changePwd" type="button" value="판매자 신청" onclick="showSellerPop()">
					<br>
				</c:if>
				<input class="changePwd" type="button" value="회원탈퇴" onclick="showPop_delete()">
			</div>
	
			<div class="orderContainer">
				<!-- 주문테이블에 제품하나씩 뜨는거 주문번호를 기준으로 합치게 바꿈 -->
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
							<!-- 같은 주문번호를 기준으로 제품이름을 합침 -->
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
					<c:forEach var="vo" items="${o_list}">
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
		</div>
	
		<div id="changePwdPopup">
			<div class="popupContent">
				<span class="close" onclick="closePop()">&times;</span>
				<h1 class="text">비밀번호 변경</h1>
				<form>
					<div class="input_box">
						<label for="currentPwd">현재 비밀번호</label>
						<br>
						<input id="currentPwd" type="password" name="currentPwd" onchange="is_pwd()" onkeydown="preventSpace(event)">
					</div>
					<hr>
					<div class="input_box">
						<label for="newPwd">새 비밀번호</label>
						<br>
						<input id="newPwd" type="password" name="newPwd" onblur="checkPwd()" onchange="is_pwd()" onkeydown="preventSpace(event)">
						<p id="text1" class="message"></p>
					</div>
					<hr>
					<div class="input_box">
						<label for="confirmPwd">새 비밀번호 확인</label>
						<br>
						<input id="confirmPwd" type="password" name="confirmPwd" onblur="confirmPassword()" onchange="is_pwd()" onkeydown="preventSpace(event)">
						<p id="text2" class="message"></p>
					</div>
					<hr>
					<input class="changeBtn" type="button" value="변경하기" onclick="updatePwd(this.form)">
				</form>
			</div>
		</div>
	
		<div id="deletePopup">
			<div class="popupContent">
				<span class="close" onclick="closePop_delete()">&times;</span>
				<h1 class="text">회원탈퇴</h1>
				<form>
	
					<p>
						<strong style="color: #E50914; font-weight: bolder; font-size: 24px;">NetflixMall </strong>웹사이트에서 회원님의 계정이 삭제됩니다. 탈퇴 시 개인정보 및 이용 정보가 삭제되며 복구할 수 없습니다. 본인의 비밀번호를 입력한 후 하단의 탈퇴하기를 눌러주세요.
					</p>
	
					<div class="input_box">
						<label for="pwdForDelete">비밀번호</label>
						<br>
						<input id="pwdForDelete" type="password" name="password" onchange="is_pwd()" onkeydown="preventSpace(event)">
					</div>
					<hr>
	
					<textarea class="ta" rows="20" cols="70" style="resize: none;" readonly="readonly">
						[회원 탈퇴 약관]
						
						제 1 조 (목적)
						이 약관은 Netflix Mall(이하 '회사')가 제공하는 서비스의 회원 탈퇴에 관한 절차와 규정을 명시하는 것을 목적으로 합니다.
						
						제 2 조 (회원 탈퇴 신청)
						1. 회원은 언제든지 회원 탈퇴를 신청할 수 있으며, 회원 탈퇴 신청은 회사가 정한 절차에 따라 처리됩니다.
						2. 회원 탈퇴 신청 시 회원의 모든 정보는 즉시 삭제되며, 삭제된 정보는 복구할 수 없습니다.
						
						제 3 조 (회원 정보의 처리)
						1. 회원 탈퇴 후, 회원의 모든 정보는 회사의 데이터베이스에서 삭제됩니다.
						2. 단, 관련 법령에 의거하여 보관이 필요한 경우 해당 정보를 일정 기간 동안 보관할 수 있습니다.
						
						제 4 조 (회원의 의무)
						1. 회원은 탈퇴 전 자신의 데이터 및 정보를 백업할 책임이 있습니다.
						2. 탈퇴 후에는 모든 서비스 이용이 불가능하며, 복구를 요청할 수 없습니다.
						
						제 5 조 (회사의 책임)
						1. 회사는 회원의 탈퇴 신청이 접수된 후 신속하게 처리하여야 합니다.
						2. 회사는 회원의 탈퇴에 따른 불이익에 대해 책임지지 않습니다.
						
						제 6 조 (기타)
						1. 이 약관에 명시되지 않은 사항은 관련 법령에 따릅니다.
						2. 이 약관은 2024년 7월 22일부터 적용됩니다.
						
						[Netflix Mall]
					</textarea>
	
					<input class="deleteBtn" type="button" value="탈퇴하기" onclick="delete_user(this.form)">
				</form>
			</div>
		</div>
		
		<div id="changeUserPopup" style="display: none;">
		<span class="close" onclick="closeSellerPop()" style="color: white;">&times;</span>
		<div class="content">
			<form>
				<table class="write-table" border="1">
					<tr>
						<th>E-mail</th>
						<td>
							<input class="write-input" name="email" type="text" value="${ sessionScope.user.email }" readonly>
						</td>
					<tr>
					<tr>
						<th>Title</th>
						<td>
							<input class="write-input" name="title" type="text">
						</td>
					<tr>
					<tr>
						<th>Content</th>
						<td>
							<textarea class="ta" name="content" rows="8" cols="10" style="resize: none;"></textarea>
						</td>
					<tr>
					<tr>
						<th>Password</th>
						<td>
							<input id="write-input" class="write-input" name="pwd" type="password" placeholder="비밀번호 입력">
						</td>
					<tr>
				</table>
				<input type="button" class="btn" onclick="send_apply_seller(this.form)" value="Submit" />
			</form>
		</div>
	</div>
	
	</body>
</html>









