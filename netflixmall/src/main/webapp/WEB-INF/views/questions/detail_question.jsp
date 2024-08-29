<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<script src="/netflixmall/resources/js/httpRequest.js"></script>
<script>

	let currentPage = '${param.page}';
	
//페이지가 실행되면 존재하는 comment를 보여준다
	window.onload = function () {
	  comm_list();
  }

  function del(q_id) {
    console.log(q_id);
    let inputPwd = document.getElementById("input-pwd");
	//inputPwd요소에 show라는 클래스가 없다면 추가해서 인풋요소를 보이게..
	//show클래스가 이미 있다면, 삭제 로직 진행
    if (!inputPwd.classList.contains("show")) {
      inputPwd.classList.add("show");
    }else {
      //비밀번호창 비었는지 검사
      if(inputPwd.value.trim() == ''){
        alert("비밀번호를 입력해주세요.");
        inputPwd.focus();
        return;
      }
      
      //비밀번호 형식 유효성 검사
      let regex = /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[\W_])[0-9a-zA-Z\W_]{8,20}$/;
      if(!regex.test(inputPwd.value.trim())){
        alert("비밀번호는 8자 이상 20자 이하의 영문자, 숫자, 특수문자를 포함해야 합니다.");
        inputPwd.value = "";
        inputPwd.focus();
        return;
      }
      
      if(!confirm("정말 삭제하시겠습니까?")){
        return;
      }
      
      //aJax 요청
      let url = "delete_question.do";
      let param = "q_id=" + q_id + "&pwd=" + encodeURIComponent(inputPwd.value.trim());
      sendRequest(url, param, resultDel, "post");
    }
  }
  
  function resultDel() {
    if(xhr.readyState == 4 && xhr.status == 200){
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();
      
      if(json[0].result == "no_pwd") {
        alert("비밀번호가 불일치합니다. 다시 입력해주세요.");
        return;
      } else if(json[0].result == "fail") {
        alert("삭제 실패");
        return;
      } else {
        alert("게시글이 삭제되었습니다.");
        location.href = "question_list.do?page=" + currentPage;
      }
    }
  }
  
  //팝업창 show
  function showPop() {
	  document.getElementById("writeForm").style.display = "block";
	}
  
  //팝업창 close
  function closePop() {
    document.getElementById("writeForm").style.display = "none";
  }
  
  function send(f) {
    let q_id = f.q_id.value;
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
      
      //aJax요청
      let url = "update_question.do";
      let param = "q_id=" + q_id + "&title=" + title + "&content=" + content +"&pwd=" + encodeURIComponent(password);
      sendRequest(url, param, resultUpdate, "post");
  }
  
  
  
  function resultUpdate() {
    let pwd = document.getElementById("write-input");
    if(xhr.readyState == 4 && xhr.status == 200){
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();
      
      if(json[0].result == 'no_pwd'){
        alert("비밀번호가 일치하지 않습니다.");
        pwd.value = "";
        pwd.focus();
        return;
      } else if(json[0].result == 'fail'){
        alert("게시글 수정 실패.");
        return;
      } else {
        alert("게시글이 수정 되었습니다.");
        //수정완료 후 해당 글의 상세페이지로 이동
        location.href = "detail_question.do?q_id=" + ${question.q_id} + "&page=" + currentPage;
      }
    }
  }
  
  function sendComm(f) {
    let nickname = f.nickname.value;
    let content = f.content.value;
    
    if(nickname == '' || content == ''){
      alert("모든 필드를 입력해주세요");
      return;
    }
    
    let url = "comment_insert.do";
    let param = "q_id=" + f.q_id.value + "&nickname=" + nickname + "&email=" + f.email.value + "&content=" + content;
    sendRequest(url, param, resultComm, "post");
    
  //form태그에 포함되어 있는 모든 입력 상자에 값을 초기화
		f.reset();
  }
  
  function resultComm() {
    if(xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();
      
      if(json[0].result == 'yes'){
        alert("성공, 리스트불러오면됨");
        comm_list();
      } else {
        alert("등록실패");
        return;
      }
    }
  }
  
  function comm_list() {
    let url = "comment_list.do";
    let param = "q_id=" + ${question.q_id};
    sendRequest(url, param, resultCommList, "post");
  }
  
  /* 코멘트 작성 완료 후, 해당 게시글에 대한 코멘트만 추려내서 가져온 결과 */
  function resultCommList() {
    if(xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      document.getElementById("commDiv").innerHTML = data;
    }
  }
  
  function show_commentBox(c_idx) {
    document.getElementById("comment-writeBox-" + c_idx).style.display = "block";
  }
  
  function close_commentBox(c_idx) {
    document.getElementById("comment-writeBox-" + c_idx).style.display = "none";
  }
  
  //대댓등록
  function reply(f) {
    let nickname = f.nickname.value;
    let content = f.content.value;
   
    if(nickname == '' || content == ''){
      alert("모든 필드를 입력해주세요");
      return;
    }

    let url = "reply.do"
    let param = "q_id=" + f.q_id.value + "&c_idx=" + f.c_idx.value + "&nickname=" + nickname + "&email=" + f.email.value + "&content=" + content;
    sendRequest(url, param, resultReply, "post");
  //form태그에 포함되어 있는 모든 입력 상자에 값을 초기화
		f.reset();
  }
  
  function resultReply() {
    if(xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();
      
      if(json[0].result == "yes"){
        comm_list();
      } else {
        alert("등록실패");
        return;
      }
    }
  }
  
</script>

</head>
<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
<link rel="stylesheet" href="/netflixmall/resources/css/detail_question.css">

<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<div class="container">
		<div class="title-box">
			<p class="mark">nexflixmall Q & A</p>
			<h1>${ question.title }</h1>
			<p>
				<c:set var="maskingEmail" value="***${fn:substring(question.email, 3, fn:length(question.email))}" />
				<c:set var="maskingIp" value="*${fn:substring(question.ip, 1, fn:length(question.ip))}" />
				E-mail : ${ maskingEmail } / IP : ${ maskingIp }
			</p>
			<p>

				<fmt:formatDate value="${ question.regdate }" pattern="yyyy-MM-dd HH:mm" />
				/ 조회 : ${ question.views }
				<input class="back-btn" type="button" value="뒤로가기" onclick="location.href='question_list.do?page=${param.page}'">


			</p>
			<div class="btn-box">
				<c:if test="${not empty sessionScope.user and sessionScope.user.email eq question.email}">
					<input type="button" value="수정" onclick="showPop()">
					<input type="button" value="삭제" onclick="del(${ question.q_id })">
					<input id="input-pwd" type="password" placeholder="Password">
				</c:if>
				<c:if test="${empty sessionScope.user}">
					<p>본인의 게시글을 수정/삭제하려면 로그인을 하세요.</p>
				</c:if>
			</div>
			<hr>
		</div>
		<div class="content-box">${ question.content }</div>
		<div style="background-color: gray; text-align: center;">Comments</div>
		<div id="commDiv"></div>
		<c:if test="${not empty sessionScope.user}">
			<div class="comment-writeBox">
				<form>
					<input type="hidden" name="q_id" value="${question.q_id}">
					<input type="hidden" name="email" value="${sessionScope.user.email}">
					<label style="color: gray;" for="nickname">Nickname : </label>
					<input id="nickname" type="text" name="nickname">
					<br>
					<textarea name="content" class="comment-ta" rows="4" cols="60" placeholder="댓글을 남겨보세요"></textarea>
					<input class="comment-btn" type="button" value="등록" onclick="sendComm(this.form)">
				</form>
			</div>
		</c:if>
	</div>
	

	<div id="writeForm">
		<div class="content">
			<span class="close" onclick="closePop()">&times;</span>
			<form>
				<table class="write-table" border="1">
					<tr>
						<th>Post Number</th>
						<td>
							<input class="write-input" name="q_id" type="text" value="${ question.q_id }" readonly>
						</td>
					<tr>
					<tr>
						<th>E-mail</th>
						<td>
							<input class="write-input" name="email" type="text" value="${ sessionScope.user.email }" readonly>
						</td>
					<tr>
					<tr>
						<th>Title</th>
						<td>
							<input class="write-input" name="title" type="text" value="${ question.title }">
						</td>
					<tr>
					<tr>
						<th>Content</th>
						<td>
							<textarea class="ta" name="content" rows="8" cols="10" style="resize: none;">${ question.content }</textarea>
						</td>
					<tr>
					<tr>
						<th>Password</th>
						<td>
							<input id="write-input" class="write-input" name="pwd" type="password" placeholder="비밀번호 입력">
						</td>
					<tr>
				</table>
				<input type="button" class="btn" onclick="send(this.form)" value="Modify" />
			</form>
		</div>
	</div>

</body>
</html>