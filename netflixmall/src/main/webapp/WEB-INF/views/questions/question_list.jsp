<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Q & A page</title>

<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
<link rel="stylesheet" href="/netflixmall/resources/css/question.css">
<link rel="stylesheet" href="/netflixmall/resources/css/pagination.css">
<script src="/netflixmall/resources/js/httpRequest.js"></script>

<script>
	function showPop() {
	  document.getElementById("writeForm").style.display = "block";
	}

	function closePop() {
    document.getElementById("writeForm").style.display = "none";
  }
	
	function showAlert() {
	  if(!confirm("로그인 후 작성가능합니다. 로그인 페이지로 이동하시겠습니까?")){
	   	return;
	  }
    location.href = "login_form.do";
  }
	
	function send(f) {
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
   
      if(content.length < 10 || content.length > 2000){
        alert("내용은 10자 이상 2000자 이하로 입력하세요.");
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
	//window.onload 이벤트 핸들러를 통해 페이지가 완전히 로드된 후 실행
	window.onload = function() {
	  let search = document.getElementById("search");
	  //검색 옵션을 나타내는 문자열 배열을 생성합니다. 이 배열은 select 요소의 옵션들과 일치해야함
	  let search_array = ['all', 'title', 'content', 'title_content'];
	  
	  for(let i = 0; i < search_array.length; i++){
	    if('${param.search}' === search_array[i]) {
	      //select 요소에서 현재 인덱스에 해당하는 옵션을 선택 상태로 만듭니다.
	      //select 요소의 옵션들은 배열과 비슷하게 인덱스를 가진다.
	      search[i].selected = true;
	      
	      let search_text = document.getElementById("search_text");
	      search_text.value = '${param.search_text}';
	    }
	  }
	}
	
	function search() {
   		//조회 카테고리
   		let search = document.getElementById("search").value;
   		//검색어
   		let search_text = document.getElementById("search_text").value.trim();
   		
   		if( search != 'all' && search_text == '' ){
   		  alert("검색할 내용을 입력하세요.");
   		  return;
   		}
   		
   		location.href = "question_list.do?search=" + search + "&search_text=" + encodeURIComponent(search_text) + "&page=1";
  }
</script>
</head>

<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<div class="container">
		<p class="title">netflixmall Q & A</p>
		<p class="info">Tel. +82-111-1111 &nbsp;&nbsp;&nbsp; E-mail. netflixMall@netflixmall.com</p>

		<table class="table" border="1">
			<tr>
				<th>No</th>
				<th>Title</th>
				<th>E-mail</th>
				<th>Views</th>
				<th>Date</th>
			</tr>

			<c:forEach var="list" items="${list}">
				<c:if test="${ list.del_info eq -1 }">
					<tr class="delete-tr">
						<td>-</td>
						<td>삭제된 댓글입니다.</td>
						<td>-</td>
						<td>-</td>
						<td>-</td>
					</tr>
				</c:if>
				<c:if test="${ list.del_info eq 0 }">
					<tr>
						<td>${ list.q_id }</td>
						<td class="q-title" onclick="location.href = 'detail_question.do?q_id=${list.q_id}&page=${param.page}'">${ list.title }</td>
						<td>
							<c:set var="maskingEmail" value="***${fn:substring(list.email, 3, fn:length(list.email))}" />
							${maskingEmail}
						</td>
						<td>${ list.views }</td>
						<td>
							<fmt:formatDate value="${ list.regdate }" pattern="yyyy-MM-dd" />
						</td>
					</tr>
				</c:if>
			</c:forEach>
			<tr>
				<td colspan="5" align="center">${ pageMenu }</td>
			</tr>
		</table>

		<div class="floor">
			<div class="search-box">
				<select id="search">
					<option value="all">전체보기</option>
					<option value="title">제목</option>
					<option value="content">내용</option>
					<option value="title_content">제목+내용</option>
				</select>
				<input id="search_text" type="text" placeholder="검색어를 입력해주세요.">
				<svg class="search-icon" style="width: 20px; height: 15px;" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 512 512">
					<path d="M416 208c0 45.9-14.9 88.3-40 122.7L502.6 457.4c12.5 12.5 12.5 32.8 0 45.3s-32.8 12.5-45.3 0L330.7 376c-34.4 25.2-76.8 40-122.7 40C93.1 416 0 322.9 0 208S93.1 0 208 0S416 93.1 416 208zM208 352a144 144 0 1 0 0-288 144 144 0 1 0 0 288z" /></svg>
				</input>
				<input class="search-btn" type="button" value="검색" onclick="search();">
			</div>
			<c:choose>
				<c:when test="${not empty sessionScope.user}">
					<input class="qna-btn" type="button" value="문의" onclick="showPop()">
				</c:when>
				<c:otherwise>
					<input class="qna-btn" type="button" value="문의" onclick="showAlert()">
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<div id="writeForm">
		<div class="content">
			<span class="close" onclick="closePop()">&times;</span>
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
				<input type="button" class="btn" onclick="send(this.form)" value="Submit" />
			</form>
		</div>
	</div>

</body>
</html>