<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="vo.UsersVO"%>
<%@ page import="javax.servlet.http.HttpSession"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
HttpSession hs = request.getSession();
UsersVO user_pay = (UsersVO) hs.getAttribute("user");
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Cart</title>
<script src="/netflixmall/resources/js/httpRequest.js"></script>
<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
<link rel="stylesheet" href="/netflixmall/resources/css/cart.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<!-- 포트원 결제창 -->
<script src="https://cdn.iamport.kr/js/iamport.payment-1.1.8.js"></script>
<script>
  let u_idx = '<%=user_pay != null ? user_pay.getU_idx() : "하하"%>';
  let user_email = '<%=user_pay != null ? user_pay.getEmail() : ""%>';
  let user_addr = '<%=user_pay != null ? user_pay.getAddress() : ""%>';
</script>

<script>
	
		$(document).ready(function() {
			updateTotalAmount();
		});
		
		var totalAmount = 0;
		    
		function updateTotalAmount() {
			<c:forEach var="cart" items="${cartlist}" varStatus="status">
				var quantity = ${cart.quantity};
				var price = ${products[status.index].price};
			totalAmount += quantity * price;
			</c:forEach>
				$('#totalAmount').text(totalAmount.toLocaleString());
		}
		
		let isCartVisible = false;
	
		function toggleCart() {
			const cartContainer = document.querySelector('.cart-container');
	
			if (isCartVisible) {
				cartContainer.classList.toggle('show');
			} else {
				cartContainer.classList.toggle('show');
			}
	
			isCartVisible = !isCartVisible;
			console.log('New display:', cartContainer.style.display);
		}	
	
		function cart_update(id, action) {
			let quantity = parseInt(document.getElementById("quantity_" + id).value);

			if (action === '+') {
				quantity++;
			} else if (action === '-') {
				if (quantity > 1) {
					quantity--;
				} else {
					// Optionally handle minimum quantity reached scenario
					return;
				}
			}
			location.href = "cart_update.do?id=" + id + "&quantity=" + quantity;
		}

		function cart_delete(id) {
			if (confirm("정말 삭제 하시겠습니까?")) {
				location.href = "cart_delete.do?id="+id;
			}		
		}

		function show_pay() {
			
			<c:if test="${cartlist eq null}">
				alert("결제할 상품을 넣어주세요.");
				return;
			</c:if>

			//실제 결제
			/* console.log(u_idx);
			let IMP = window.IMP;
			IMP.init('imp19424728'); // 실제 가맹점 식별코드로 변경하세요

			IMP.request_pay({
				pg : 'html5_inicis', // 사용할 PG사
				pay_method : 'card', // 결제 수단
				merchant_uid : 'merchant_' + new Date().getTime(), // 가맹점에서 생성한 고유 주문번호
				name : '주문명: netflix mall 결제테스트',
				amount : totalAmount, // 결제금액
				buyer_email : user_email,
				/*buyer_name: '구매자이름',
				 buyer_tel: '010-1234-5678', */
				// buyer_addr : user_addr,
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
	    

		function resultPay() {
			if (xhr.readyState == 4 && xhr.status == 200) {
				let data = xhr.responseText;
				let json = (new Function('return ' + data))();

			if (json[0].result == 'success') {
				alert("주문 정보 저장성공");
			} else {
				alert("주문 정보 저장실패");
			}
		}
	} */
	 		//실결제를 안하고 그냥 바로 결제로 간주
			console.log(u_idx);

			let IMP = window.IMP;
			IMP.init('imp19424728'); // 실제 가맹점 식별코드로 변경하세요

			// 가짜 결제 창을 띄우고, 바로 결제 완료 처리를 합니다.
			alert('결제 창이 열렸습니다.');

			// 결제 성공 결과를 가정하여 직접 처리
			let response = {
				success: true, // 결제 성공으로 간주
				imp_uid: 'test_imp_uid', // 가짜 imp_uid
				paid_amount: totalAmount, // 가짜 결제 금액
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
		
		//1차 콜백
		function resultPay() {
	
			if(xhr.readyState == 4 && xhr.status == 200){
				let data = xhr.responseText;
				let json = (new Function('return ' + data))();

				if(json[0].result == 'success'){
					alert("주문 정보 저장성공");
					//2차 ajax
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
		
		//2차 콜백
		function insert_order_item(){
			if(xhr.readyState == 4 && xhr.status == 200){
				let data = xhr.responseText;
				alert(data)
				let json = (new Function('return ' + data))();
				if(json[0].result == 'success'){
					alert("주문제품 저장 완료");
					location.href="cart_list_delete.do";//장바구니 삭제 아직작동안함;;
				}else{
					alert("실패");
				}
			}
		}
	
</script>
</head>
<body>
	<form name="f" method="post">
		<c:forEach var="cart" items="${cartlist}" varStatus="status">
			<div class="cart-item">
				<c:if test="${ product.filename1 ne 'no_file' }">
					<img src="/netflixmall/resources/upload/${products[status.index].filename1}" alt="Product Image">
				</c:if>
				<div class="cart-details">
					<h2>${products[status.index].name}</h2>
					<p>${products[status.index].category}</p>

					<div class="quantity-control">
						<button class="quantity-button" onclick="cart_update('${cart.id}', '-')">-</button>
						<input style="color: white;" type="text" class="quantity-input" id="quantity_${cart.id}" value="${cart.quantity}" readonly>
						<button class="quantity-button" onclick="cart_update('${cart.id}', '+')">+</button>
					</div>
					<p class="price">₩${products[status.index].price}</p>
					<input type="button" value="Remove" class="remove" onclick="cart_delete('${cart.id}');">
				</div>
			</div>
		</c:forEach>
	</form>
	<div class="cart-summary">
		<p>Subtotal</p>
		<p class="subtotal">
			₩<span id="totalAmount"></span>
		</p>
		<p style="font-size: 13px;">Discounts, taxes & shipping calculated at checkout.</p>
		<button class="checkout-button" onclick="show_pay()">Checkout</button>
	</div>
</body>
</html>