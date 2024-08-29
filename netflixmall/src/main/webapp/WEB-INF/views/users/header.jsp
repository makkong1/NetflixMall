<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<% Integer userIdx = (Integer) session.getAttribute("u_idx"); %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
<link rel="stylesheet" href="/netflixmall/resources/css/header.css">
<!-- jQuery CDN 참조 -->
<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<script>
//Document Ready Event : $(document).ready() 함수는 DOM이 완전히 로드되고 파싱된 후에 코드를 실행
$(document).ready(function() {
   //마지막 스크롤 위치를 저장
    let lastScrollLocation = 0;
    //$(window).scroll() 함수는 사용자가 페이지를 스크롤할 때마다 실행
    $(window).scroll(function(event) {
       //현재 스크롤 위치를 저장, this -> 이벤트객체 여기서는 window
       //$(this).scrollTop();는 현재 스크롤 위치(수직)를 픽셀 단위로 반환
        let nowScrollLocation = $(this).scrollTop();
        if (nowScrollLocation > lastScrollLocation && nowScrollLocation > 70) {
           // Scroll Down
            $("#head").fadeOut();
        } else if (nowScrollLocation < lastScrollLocation && nowScrollLocation > 70) {
            // Scroll Up
            $("#head").fadeIn();
        }
        //마지막 스크롤 위치를 현재 스크롤 위치로 업데이트
        lastScrollLocation = nowScrollLocation;
    });
});
</script>
<script>
//장바구니 버튼 클릭 이벤트
	function show_cart() {
		document.getElementById("cart").classList.add('show');
	}

	function close_cart() {
		document.getElementById("cart").classList.remove('show');
	}
</script>

<script>
	//실제 결제
	/* function pay() {
	  console.log(u_idx);
	  let IMP = window.IMP;
	  IMP.init('imp19424728'); // 실제 가맹점 식별코드로 변경하세요
	  
	  IMP.request_pay({
	      pg: 'html5_inicis', // 사용할 PG사
	      pay_method: 'card', // 결제 수단
	      merchant_uid: 'merchant_' + new Date().getTime(), // 가맹점에서 생성한 고유 주문번호
	      name: '주문명: netflix mall 결제테스트',
	      amount: 100, // 결제금액
	      buyer_email: 'buyer@domain.com',
	     /*  buyer_name: '구매자이름',
	      buyer_tel: '010-1234-5678', */
	     // buyer_addr: '구매자 주소..',
	      /* buyer_postcode: '123-456' */
		 /* }, function(response) {
		      if (response.success) {
		          alert('결제가 완료되었습니다.');
		          let url = "pay.do";
		          let param = "imp_uid=" + response.imp_uid + "&total=" + response.paid_amount + "&u_idx=" + u_idx; // u_idx는 실제 사용자 ID로 변경
		          sendRequest(url, param, resultPay, "post"); 
		      } else {
		          alert('결제에 실패하였습니다. 에러내용: ' + response.error_msg);
		      }
		  }); 
		  alert('결제가 완료되었습니다.');
          let url = "pay.do";
          let param = "imp_uid=" + response.imp_uid + "&total=" + response.paid_amount + "&u_idx=" + u_idx; // u_idx는 실제 사용자 ID로 변경
          sendRequest(url, param, resultPay, "post"); 
		  
	}

	function resultPay() {
	  if(xhr.readyState == 4 && xhr.status == 200){
	    let data = xhr.responseText;
	    let json = (new Function('return ' + data))();
	    
	    if(json[0].result == 'success'){
	      alert("주문 정보 저장성공");
	    }else {
	      alert("주문 정보 저장실패");
	    }
	  }
	} */
	//실결제를 안하고 그냥 바로 결제로 간주
	function pay() {
	    console.log(u_idx);
	    alert()
	    let IMP = window.IMP;
	    IMP.init('imp19424728'); // 실제 가맹점 식별코드로 변경하세요
	    
	    // 가짜 결제 창을 띄우고, 바로 결제 완료 처리를 합니다.
	    alert('결제 창이 열렸습니다.');

	    // 결제 성공 결과를 가정하여 직접 처리
	    let response = {
	        success: true, // 결제 성공으로 간주
	        imp_uid: 'test_imp_uid', // 가짜 imp_uid
	        paid_amount: 100, // 가짜 결제 금액
	        error_msg: '' // 성공이므로 오류 메시지는 비움
	    };

	    if (response.success) {
	        alert('결제가 완료되었습니다.');
	        let url = "pay.do";
	        let param = "imp_uid=" + response.imp_uid + "&total=" + response.paid_amount + "&u_idx=" + u_idx; // u_idx는 실제 사용자 ID로 변경
	        sendRequest(url, param, resultPay, "post"); 
	    } else {
	        alert('결제에 실패하였습니다. 에러내용: ' + response.error_msg);
	    }
	}

	function resultPay() {
		alert(xhr.readyState + "/" + xhr.status);
		if(xhr.readyState == 4 && xhr.status == 200){
			let data = xhr.responseText;
			let json = (new Function('return ' + data))();
			alert(data);
			
			if(json[0].result == 'success'){
				alert("주문 정보 저장성공");
				let o_idx = json[0].result2;
				let url = "order_item_insert.do"
				let param = "o_idx=" + o_idx + "&u_idx=" + u_idx;
	            
				sendRequest(url, param, insert_order_item, "post"); 
	            
			} else {
				alert("주문 정보 저장실패");
				return;
			}
		}
	}
	
	function insert_order_item(){
		if(xhr.readyState == 4 && xhr.status == 200){
			let data = xhr.responseText;
			let json = (new Function('return ' + data))();
			if(json[0].result == 'success'){
				alert("주문제품 저장 완료");
				location.href="cart_list_delete.do";
			}else{
				alert("실패")
			}
		}
	}

</script>

</head>

<body>
	<header id="head">
		<div class="flex-container">
			<div class="flex-item" onclick="location.href='shop_page.do'">
				<img class="logo" alt="logo" src="/netflixmall/resources/image/netflixLogo.png">
			</div>
			<%-- 사용자 role이 'user'일 경우 --%>
			<c:if test="${sessionScope.role eq 'user' or sessionScope.role eq 'seller' or 
			 				sessionScope.user eq 'null'}"> 
				<div class="flex-item">
					<a href="order_list.do">주문목록</a>
					<a href="shop_page.do">상품</a>
						<c:if test="${sessionScope.role eq 'seller'}">
							<a href="insert_page.do">상품등록</a>
							<a href="myItem.do?user_idx=<%= userIdx %>">내상품</a>
						</c:if>
						<a href="question_list.do">Q & A</a>
				</div>
			</c:if>
			
			<%-- 사용자 role이 'user'가 아닌 경우 --%>
			<c:if test="${sessionScope.role eq 'admin' or sessionScope.role eq 'null'}"> 
	 			<div class="flex-item">
					<a href="users_detail_list.do?is_approved=2">사용자</a> 
					<a href="Products_detail_list.do">제품</a> 
					<a href="board_detail_list.do">Q & A</a> 
				</div>
			</c:if> 
			<div class="flex-item">
				<!-- session의 저장여부에 따라 다르게 보여줌 -->
				<c:choose>
					<c:when test="${not empty sessionScope.user}">
						<c:if test="${ sessionScope.role eq 'admin'}">
							<input type="button" value="관리자님"
								id="loginBtn" onclick="location.href='user_info.do'">
						</c:if>
						<c:if test="${ sessionScope.role eq 'user' or sessionScope.role eq 'seller' }">
							<input type="button" value="${sessionScope.user.username}님"
									id="loginBtn" onclick="location.href='user_info.do'">
						</c:if>
						<input type="button" value="로그아웃" id="loginBtn"
							onclick="location.href='logout.do'">
							<svg onclick="toggleCart()" id="cart_icon"
								xmlns="http://www.w3.org/2000/svg" viewBox="0 0 576 512">
								<path
									d="M0 24C0 10.7 10.7 0 24 0L69.5 0c22 0 41.5 12.8 50.6 32l411 0c26.3 0 45.5 25 38.6 50.4l-41 152.3c-8.5 31.4-37 53.3-69.5 53.3l-288.5 0 5.4 28.5c2.2 11.3 12.1 19.5 23.6 19.5L488 336c13.3 0 24 10.7 24 24s-10.7 24-24 24l-288.3 0c-34.6 0-64.3-24.6-70.7-58.5L77.4 54.5c-.7-3.8-4-6.5-7.9-6.5L24 48C10.7 48 0 37.3 0 24zM128 464a48 48 0 1 1 96 0 48 48 0 1 1 -96 0zm336-48a48 48 0 1 1 0 96 48 48 0 1 1 0-96z" />
							</svg>
					</c:when>
				<c:otherwise>
					<input type="button" value="로그인" id="loginBtn"
						onclick="location.href='login_form.do'">
				</c:otherwise>
				</c:choose>
					<input type="button" value="관리자" id="loginBtn2"
						onclick="location.href='admin.do'">
			</div>
		</div>
	</header>
   
   <!-- 장바구니 -->
   <div id="cart" class="cart">
      <div class="cart-header">
         <h2>My Cart</h2>
         <button id="close-cart" class="close-button" onclick="close_cart()">&times;</button>
      </div>
      <hr>
      <div class="cart-content">
         <div class="cart-item">
            <div class="item-details">
               <!-- title, price 등등..  -->
            </div>
            <div class="item-quantity">
               <!-- 아이템수량.. - / +  -->
            </div>
         </div>
      </div>
      <hr>
      <div class="price">
         <h2>SubTotal</h2>
         <h2>\total price..</h2>
      </div>
      <input class="order" type="button" value="CheckOut">
   </div>
   <div class="cart-container">
		<%@ include file="/WEB-INF/views/users/cart.jsp"%>
	</div>
</body>
</html>
