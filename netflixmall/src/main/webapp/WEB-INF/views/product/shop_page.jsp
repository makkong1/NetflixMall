<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@page import="java.util.List"%>
<%@page import="dao.ProductDAO"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>netflix GoodsShop</title>
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
   <div id="wrapper">
   <h1 class="title">NETFLIX Goods mall</h1>
      <div class="GoodsContainer">
         <c:forEach var="product" items="${list}">
            <div class="GoodsBox">
               <div class="img" onclick="goToProductDetails(${product.p_idx})">
                  <c:if test="${ product.filename1 ne 'no_file' }">
                     <img src="/netflixmall/resources/upload/${product.filename1}">
                  </c:if>
               </div>

            <div class="ExplainBox">
                   <p class="category">${product.category}</p>               
                  <p>${product.name}</p>
<p>가격: <fmt:formatNumber value="${product.price}" type="number" minFractionDigits="0" maxFractionDigits="0" />원</p>                </div>
               
               <form name="f" method="get" action="/netflixmall/cart_insert.do">
                  <input type="hidden" name="filename" value="${product.filename1}">
                  <input type="hidden" name="userId" value="${userId}"> 
                  <input type="hidden" name="p_idx" value="${product.p_idx}"> 
                  <input class="btn" type="button" value="장바구니에 추가" onclick="cart_insert(this.form);">
               </form>

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
   <%@ include file="/WEB-INF/views/users/footer.jsp"%>
   </div>
</body>
</html>





