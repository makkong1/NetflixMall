<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>주문 목록</title>
    <link rel="stylesheet" href="/netflixmall/resources/css/main_admin_table.css">
</head>
<body>
    <h2>${param.username}님의 주문 목록</h2>
    <table>
        <thead>
            <tr>
                <th>주문번호</th>
                <th>상품명</th>
                <th>가격</th>
                <th>주문일자</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="vo" items="${list}">
                <tr>
                    <td>${order.order_id}</td>
                    <td>${order.product_name}</td>
                    <td>${order.price}</td>
                    <td>${order.order_date}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</body>
</html>
