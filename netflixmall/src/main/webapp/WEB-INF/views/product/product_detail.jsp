<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<html>
<head>
<meta charset="UTF-8">
<title>Goods Detail</title>
<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
<link rel="stylesheet" href="/netflixmall/resources/css/product_detail.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>
<script src="/netflixmall/resources/js/uploadImage.js"></script>
<script>
    function cart_insert(f) {
        f.action = "/netflixmall/cart_insert.do"; // Ensure the correct action URL
        f.submit();
    }
</script>
</head>
<body>
    <%@ include file="/WEB-INF/views/users/header.jsp"%>
    <div id="wrapper">
        <div class="left-side">
            <div class="imgbox">
                <c:if test="${not empty vo.filename1 and vo.filename1 ne 'no_file'}">
                    <img src="/netflixmall/resources/upload/${vo.filename1}" alt="상품 이미지 1">
                </c:if>
                <c:if test="${not empty vo.filename2 and vo.filename2 ne 'no_file'}">
                    <img src="/netflixmall/resources/upload/${vo.filename2}" alt="상품 이미지 2">
                </c:if>
                <c:if test="${not empty vo.filename3 and vo.filename3 ne 'no_file'}">
                    <img src="/netflixmall/resources/upload/${vo.filename3}" alt="상품 이미지 3">
                </c:if>
                <c:if test="${not empty vo.filename4 and vo.filename4 ne 'no_file'}">
                    <img src="/netflixmall/resources/upload/${vo.filename4}" alt="상품 이미지 4">
                </c:if>
                <c:if test="${not empty vo.filename5 and vo.filename5 ne 'no_file'}">
                    <img src="/netflixmall/resources/upload/${vo.filename5}" alt="상품 이미지 5">
                </c:if>
                <c:if test="${not empty vo.filename6 and vo.filename6 ne 'no_file' }">
                    <img src="/netflixmall/resources/upload/${vo.filename6}" alt="상품 이미지 6">
                </c:if>
            </div>
        </div>

        <div class="right-side">
            <form action="/netflixmall/cart_insert.do" method="post">
                <input type="hidden" name="userId" value="${user.u_idx}">
                <input type="hidden" name="p_idx" value="${vo.p_idx}">
                <input type="hidden" name="filename1" value="${vo.filename1}">
                <input type="hidden" name="block_reason" value="${vo.block_reason}">
                <div class="text">${vo.name}</div>
                <div class="description-box"><fmt:formatNumber value="${vo.price}" type="number" minFractionDigits="0" maxFractionDigits="0" />원</div>
                <div class="description-box">설명</div>
                <div class="description-box">${vo.description}</div>
                <input type="number" name="quantity" value="1" min="1">
                <input class="cart_button" type="submit" value="장바구니">
            </form>
        </div>
    </div>
</body>
</html>
