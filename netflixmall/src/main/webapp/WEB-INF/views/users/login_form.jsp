<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="/netflixmall/resources/css/reset.css">
<link rel="stylesheet" href="/netflixmall/resources/css/login_form.css">
<!-- <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script> -->
<script src="/netflixmall/resources/js/httpRequest.js"></script>
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<script>
  //아래 부분의 코드는 로그인이나 회원가입을 클릭했을 때 같은 공간 내에서 폼을 변화시켜주는 것
  //DOMContentLoaded 이벤트는 초기 html문서가 완전히 로드되고
  //파싱되었을 때 발생
  document.addEventListener("DOMContentLoaded", function() {
    //.picked 클래스를 가진 모든 element를 선택해서 클릭이벤트를 할당해줌
    document.querySelectorAll(".picked").forEach(function(element) {

      element.addEventListener("click", function() {
        // 모든 span 요소의 border-bottom 스타일을 초기화
        document.querySelectorAll(".picked").forEach(function(e) {
          e.style.borderBottom = "2px solid gray";
        });
        // 클릭된 요소의 borderBottom 스타일을 굵은 레드로 변경
        this.style.borderBottom = "5px solid red";

        // 클릭된 요소의 텍스트 내용에 따라 폼을 전환
        if (this.textContent === "Log In") {
          //.classList.add or remove를 사용해 클래스를 동적으로 추가 또는 제거할 수 있다
          // login_container 요소에서 hidden 클래스를 제거하여 로그인 폼을 보이게 한다
          document.getElementById("login_container").classList.remove('hidden');
          // signup_container 요소에 hidden 클래스를 추가하여 회원가입 폼을 숨긴다
          document.getElementById("signup_container").classList.add('hidden');
        } else if (this.textContent === "Sign Up") {
          //여기는 위의 동작과 반대
          document.getElementById("login_container").classList.add('hidden');
          document.getElementById("signup_container").classList.remove('hidden');
        }
      });

    });
  });//DOMContentLoaded

  //-------------회원가입 함수--------------------

  let isPwd = false;
  let isCode = false;

  //확인 후 비밀번호 변경했을 때 회원가입 진행되는 것을 방지하기위함
  function is_pwd() {
    isPwd = false;
    console.log(isPwd);
  }

  function is_code() {
    isCode = false;
  }

  //비밀번호 유효성 검사 후 각각의 메시지를 반환한다
  function validPwd() {
    let inputPwd = document.getElementById("password");
    let pwd = inputPwd.value.trim();

    let regex = /^(?=.*\d)(?=.*[a-zA-Z])(?=.*[\W_])[0-9a-zA-Z\W_]{8,20}$/;

    if (!regex.test(pwd) && pwd !== "") {
      //alert("비밀번호는 8자 이상 20자 이하의 영문자, 숫자, 특수문자를 포함해야 합니다");
      inputPwd.value = "";
      inputPwd.focus();
      return "비밀번호는 8자 이상 20자 이하의 영문자, 숫자, 특수문자를 포함해야 합니다";
    } else if (regex.test(pwd)) {
      //alert("통과");	
      return "비밀번호 조합 성공";
    }
  }//validPwd()

  //비밀번호 필드가 포커스를 잃으면 실행 validPwd()통해서 유효성 검사 후 반환된 메시지를 <p>태그의 텍스트로 넣어줌
  function checkPwdMsg() {
    let msg = validPwd();

    document.getElementById("msg").textContent = msg;
  }//checkPwdMsg()

  //비밀번호 확인 함수
  function pwdMatch() {
    let pwd = document.getElementById("password").value.trim();
    let checkPwd = document.getElementById("check_password");

    if (pwd === checkPwd.value.trim()) {
      alert("비밀번호 일치");
      isPwd = true;
      console.log(isPwd);
    } else {
      alert("비밀번호 불일치");
      checkPwd.value = "";
      checkPwd.focus();
    }
  }

  //발송된 인증번호를 저장하는 변수
  let code = "";

  //인증하기 버튼 클릭 이벤트 함수(중복체크 -> 이메일 전송)
  function sendCode() {
    let email = document.getElementById("inputEmail").value;

    //이메일 유효성테스트 코드
    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    //이메일입력하지 않으면 경고창
    if (email === '') {
      alert("email을 입력하세요");
      return;
    }
    //이메일 형식 유효성 검사
    if (!emailRegex.test(email)) {
      alert("유효한 형식의 email을 작성하세요");
      return;
    }
    //이메일 중복
    let url = "check_email.do";
    let param = "email=" + email;
    sendRequest(url, param, checkEmail, "GET");

  }
  //이메일 중복검사 결과 반환함수
  function checkEmail() {
    let email = document.getElementById("inputEmail");

    if (xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();

      if (json[0].result === "yes") {
        let url = "sendMail.do";
        let param = "email=" + email.value;
        sendRequest(url, param, resultFn, "GET");
      } else {
        alert("이미 가입된 email입니다.");
        email.value = '';
        email.focus();
        return;
      }
    }
  }

  //인증메일 발송 결과 반환 함수
  function resultFn() {
    //xhr.readyState가 4인 경우를 명시적으로 처리하여, 요청이 완료된 후에만 성공 또는 실패 메시지를 출력
    if (xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      alert("인증번호 발송 완료");
      console.log(data);
      code = data;
      //요청은 되었으나, 실패한 경우
    } else if (xhr.readyState == 4) {
      alert("인증번호 발송 실패");
      return;
    }
  }

  //인증번호 일치여부 확인
  function codeMatch() {
    let inputCode = document.getElementById("code_input");
    if (inputCode.value.trim() === "") {
      alert("인증번호를 입력해주세요");
      return;
    }

    if (inputCode.value.trim() !== code) {
      alert("인증번호 불일치");
      inputCode.value = '';
      inputCode.focus();
      return;
    } else {
      alert("인증완료");
      isCode = true;
    }
  }

  //daum 팝업 주소 검색창
  function popup_address() {
    new daum.Postcode({
      oncomplete : function(data) {
        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.

        // 각 주소의 노출 규칙에 따라 주소를 조합한다.
        // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
        var addr = ''; // 주소 변수
        var extraAddr = ''; // 참고항목 변수

        //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
        if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
          addr = data.roadAddress;
        } else { // 사용자가 지번 주소를 선택했을 경우(J)
          addr = data.jibunAddress;
        }

        // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
        if (data.userSelectedType === 'R') {
          // 법정동명이 있을 경우 추가한다. (법정리는 제외)
          // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
          if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
            extraAddr += data.bname;
          }
          // 건물명이 있고, 공동주택일 경우 추가한다.
          if (data.buildingName !== '' && data.apartment === 'Y') {
            extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
          }
          // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
          if (extraAddr !== '') {
            extraAddr = ' (' + extraAddr + ')';
          }
          // 주소변수 문자열과 참고항목 문자열 합치기
          addr += extraAddr;

        } else {
          addr += ' ';
        }

        // 우편번호와 주소 정보를 해당 필드에 넣는다.
        document.getElementById('address1').value = data.zonecode;
        document.getElementById("address2").value = addr;
      }
    }).open();
  }

  //회원가입 버튼 form 제출
  function sendInfo(f) {
    let username = f.username.value;
    let email = f.email.value;
    let code = document.getElementById("code_input").value;
    let password = f.password.value;
    let check_password = document.getElementById("check_password").value;
    let address1 = document.getElementById("address1").value;
    let address = f.address.value;
    let role = document.querySelector('input[name="role"]:checked').value; // 선택된 역할을 가져옴

    //비어있는 필드가 있다면 블록
    if (username === '' || email === '' || code === '' || password === '' || check_password === '' || address1 === '' || address === '') {
      alert("모든 항목을 작성해주세요");
      return;
    }

    //비밀번호 확인 또는 인증번호 확인 후 제출 전 변경사항이 있다면 블록
    if (!isPwd || !isCode) {
      alert("비밀번호 또는 인증번호를 확인해주세요.");
      return;
    }

    //이름 유효성 검사
    const namePattern = /^[a-zA-Z가-힣\s]+$/;
    if (!namePattern.test(username)) {
      alert("유효한 이름을 입력하세요.(특수문자 및 숫자 불가)");
      return;
    }

    let url = "insert_user.do";
    let param = "username=" + username + "&password=" + encodeURIComponent(password) + 
    "&email=" + encodeURIComponent(email) + "&address=" + address  + "&role=" + role;

    sendRequest(url, param, resultInsert, "post");
  }

  //insert aJax 반환 함수
  function resultInsert() {
    if (xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();

      if (json[0].result === "success") {
        alert("회원가입이 완료되었습니다. 로그인페이지로 이동합니다.");
        location.href = "login_form.do";
      } else if (xhr.readyState == 4) {
        alert("회원가입에 실패했습니다.");
        return;
      }
    }
  }
  //------------------ 로그인 함수 ---------------------

  function showPop() {
    document.getElementById("forgotPwdPopup").style.display = "block";
  }

  function closePop() {
    document.getElementById("forgotPwdPopup").style.display = "none";
  }

  function checkLogin(f) {
    let email = f.email.value.trim();
    let password = f.pwd.value.trim();

    if (email === '' || password === '') {
      alert("모든 항목을 입력하세요");
      return;
    }

    //이메일 유효성테스트 코드
    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    //이메일 형식 유효성 검사
    if (!emailRegex.test(email)) {
      alert("유효한 형식의 email을 작성하세요");
      return;
    }

    let url = "user_login.do";
    let param = "email=" + encodeURIComponent(email) + "&password=" + encodeURIComponent(password);
    sendRequest(url, param, resultLogin, "post");

  }//checkLogin()

  function resultLogin() {
    let email = document.getElementById("login_email");
    let pwd = document.getElementById("login_pwd");

    if (xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();
	  
      if (json[0].result === "no_id") {
        alert("미가입된 이메일 입니다");
        email.value = "";
        pwd.value = "";
        email.focus();
        return;
      } else if( json[0].result === "login_reject"){
    	  alert("블락처리된 아이디 입니다. 관리자한테 문의하세요");
    	  return;
      } else if (json[0].result === "fail") {
        alert("비밀번호가 불일치합니다");
        pwd.value = "";
        pwd.focus();
        return;
      } else {
        alert("로그인 성공");
        let json2 = json[1].result2
        if(json2 == "user"){
        	location.href = "shop_page.do"; //사용자
        } else if(json2 == "seller"){
        	location.href = "shop_page.do"; //판매자
        } else {
        	location.href = "admin.do"; //관리자
        }
      }
    }
  }
  

  function sendEmail(f) {
    let email = f.email.value.trim();

    //이메일 유효성테스트 코드
    let emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;

    //이메일 형식 유효성 검사
    if (!emailRegex.test(email)) {
      alert("유효한 형식의 email을 작성하세요(example@domain.com)");
      return;
    }

    let url = "find_pwd.do";
    let param = "email=" + encodeURIComponent(email);
    sendRequest(url, param, resultPwd, "post");
  }

  function resultPwd() {
    if (xhr.readyState == 4 && xhr.status == 200) {
      let data = xhr.responseText;
      let json = (new Function('return ' + data))();

      if (json[0].result == "no_email") {
        alert("미가입된 이메일입니다.");
        return;
      } else if (json[0].result == "success") {
        alert("임시비밀번호 전송성공.");
        location.href = "login_form.do";

      }
    }
  }
</script>
</head>

<body>
	<%@ include file="/WEB-INF/views/users/header.jsp"%>
	<div id="wrapper">
		<div id="text">Welcome to the Netflix Goods Mall</div>
		<div id="pick">
			<span style="border-bottom: 5px solid red" class="picked">Log In</span> 
			<span class="picked">Sign Up</span>
		</div>

		<!-- 로그인 form -->
		<form>
			<div id="login_container" class="container">
				<input id="login_email" name="email" type="text" placeholder="example@domain.com">
				<input id="login_pwd" name="pwd" type="password" placeholder="password를 입력하세요">
				<p onclick="showPop()">Forgot password?</p>
				<input class="btn" type="button" value="Log In" onclick="checkLogin(this.form)">
			</div>
		</form>

		<div id="forgotPwdPopup">
			<div class="popupContent">
				<span class="close" onclick="closePop()">&times;</span>
				<h1 class="text">Reset Password</h1>
				<h1 class="content">이메일 주소를 입력해주세요</h1>
				<form>
					<div class="input_box">
						<input class="email_input" type="text" name="email" placeholder="Email">
					</div>

					<input class="sendBtn" type="button" value="Submit" onclick="sendEmail(this.form)">
				</form>
			</div>
		</div>
		<!-- 회원가입 form -->
		<form>
			<div id="signup_container" class="container hidden">
				
				 <!-- 역할 선택 추가 -->	
				<div class="role_selection">
		            <input type="radio" id="user_role" name="role" value="user" checked>
		            <label for="user_role">일반 사용자</label>
		            <input type="radio" id="seller_role" name="role" value="seller">
		            <label for="seller_role">판매자</label>
		        </div>
		        
				<input name="username" type="text" placeholder="이름 입력">
				<div class="addr_pwd_email_container">
					<input id="inputEmail" name="email" type="text" placeholder="이메일 입력">
					<input type="button" value="인증하기" onclick="sendCode()">
				</div>
				<div class="addr_pwd_email_container">
					<input id="code_input" type="text" placeholder="인증번호" onchange="is_code()">
					<input type="button" value="확인" onclick="codeMatch()">
				</div>

				<!-- 비밀번호 -->
				<input id="password" name="password" type="password" placeholder="비밀번호(8자이상 영문자와 숫자, 특수문자 조합)" onblur="checkPwdMsg()">
				<p id="msg"></p>

				<!-- 비밀번호 확인 -->
				<div class="addr_pwd_email_container">
					<input id="check_password" type="password" placeholder="비밀번호 확인" onchange="is_pwd()">
					<input type="button" value="확인하기" onclick="pwdMatch()">
				</div>

				<!-- 주소 -->
				<div class="addr_pwd_email_container">
					<input id="address1" type="text" placeholder="우편번호" readonly="readonly">
					<input type="button" value="주소검색" onclick="popup_address()">
				</div>
				<input id="address2" name="address" type="text" placeholder="주소" readonly="readonly">
				<input class="btn" type="button" value="Sign Up" onclick="sendInfo(this.form)">

			</div>
		</form>


	</div>

</body>
</html>