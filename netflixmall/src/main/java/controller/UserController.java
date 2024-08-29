package controller;

import java.util.List;
import java.util.Random;

import javax.mail.internet.MimeMessage;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.OrderDAO;
import dao.UsersDAO;
import util.Common;
import vo.OrderVO;
import vo.UsersVO;

@Controller
public class UserController {

	UsersDAO userDAO;
	OrderDAO order_dao;
@Autowired
Cartcontroller cartcontroller;
	
	@Autowired
	private JavaMailSender mailSender;
	@Autowired
	HttpSession session;

	public UserController(UsersDAO userDAO, OrderDAO order_dao) {
		this.userDAO = userDAO;
		this.order_dao = order_dao;
	}

	// 로그인 페이지 이동
	@RequestMapping("login_form.do")
	public String login_form(Model model) {
		cartcontroller.cart_list(model);
		return Common.Users.VIEW_PATH + "login_form.jsp";
		
	}

	// shop 페이지 이동
	@RequestMapping(value = "shop.do")
	public String shop_Page() {
		return Common.Product.VIEW_PATH + "shop_page.jsp";
	}

	// 제품insert 페이지 이동
	@RequestMapping(value = "insert_page.do")
	public String insert_Page() {
		return Common.Product.VIEW_PATH + "insert_page.jsp";
	}

	// 이메일 중복 체크
	@RequestMapping("check_email.do")
	@ResponseBody
	public String checkMail(String email) {
		UsersVO vo = userDAO.select_email(email);

		if (vo == null) {
			return "[{'result':'yes'}]";
		} else {
			return "[{'result':'no'}]";
		}
	}

	// 임시 비밀번호 메일 발송 메서드
	public void sendMail_temp(UsersVO vo) {
		String setFrom = "hagenith@nate.com";
		String toMail = vo.getEmail();
		String title = "[netflix mall] 임시 비밀번호 전송";
		String content = "<p>임시비밀번호: <strong style='color: blue; font-size: 24px;'>" + vo.getPassword()
				+ "</strong> 입니다. 비밀번호를 변경하여 사용하세요.</p>";

		try {
			MimeMessage msg = mailSender.createMimeMessage();
			MimeMessageHelper msgHelper = new MimeMessageHelper(msg, true, "utf-8");

			msgHelper.setFrom(setFrom);
			msgHelper.setTo(toMail);
			msgHelper.setSubject(title);
			msgHelper.setText(content, true);

			mailSender.send(msg);
		} catch (Exception e) {
			System.out.println(e.getMessage());
		}
	}

	// 비밀번호 찾기(임시비밀번호 전송)
	@RequestMapping("find_pwd.do")
	@ResponseBody
	public String find_pwd(String email) {
		System.out.println("넘어온이메일:" + email);
		UsersVO user = userDAO.select_email(email);

		String str = "";

		if (user == null) {
			str = "[{'result':'no_email'}]";
		} else {
			// 임시 비밀번호 생성
			String pwd = "";
			for (int i = 0; i < 12; i++) {
				pwd += (char) ((Math.random() * 26) + 97);
			}
			user.setPassword(pwd);

			// 임시비밀번호 메일 발송
			sendMail_temp(user);
			System.out.println("임시비번:" + pwd);

			// 새로 생성한 임시 비밀번호 암호화
			String encoded = Common.SecurePwd.encodePwd(pwd);
			System.out.println("Encoded password: " + encoded);

			// newpassword 변수에 셋팅
			user.setNew_password(encoded);

			// 비밀번호 변경
			userDAO.update_pwd(user);

			str = "[{'result':'success'}]";
		}
		return str;
	}

	// 인증번호 메일 발송
	@RequestMapping("sendMail.do")
	@ResponseBody
	public String sendMail(String email) {
		System.out.println(email);

		Random random = new Random();
		int checkNum = random.nextInt(888888) + 111111;

		String setFrom = "hagenith@nate.com";
		String toMail = email;
		String title = "[netflix mall] 이메일 인증";
		String content = "인증번호는 " + checkNum + " 입니다.";
		System.out.println(content);

		try {
			MimeMessage msg = mailSender.createMimeMessage();
			MimeMessageHelper msgHelper = new MimeMessageHelper(msg, true, "utf-8");

			msgHelper.setFrom(setFrom);
			msgHelper.setTo(toMail);
			msgHelper.setSubject(title);
			msgHelper.setText(content);

			mailSender.send(msg);

		} catch (Exception e) {
			System.out.println(e.getMessage());
		}

		String num = Integer.toString(checkNum);

		return num;
	}

	// user insert
	@RequestMapping("insert_user.do")
	@ResponseBody
	public String insert_user(UsersVO vo) {
		// 비밀번호 암호화
		String encodePwd = Common.SecurePwd.encodePwd(vo.getPassword());
		vo.setPassword(encodePwd);

		int res = userDAO.user_insert(vo);

		if (res > 0) {
			return "[{'result':'success'}]";
		} else {
			return "[{'result':'fail'}]";
		}
	}

	// user login
	@RequestMapping("user_login.do")
	@ResponseBody
	public String login_user(UsersVO vo) {
		String str = "";

		// db에저장된 암호화된 pwd와 입력한 pwd의 일치여부 판단
		boolean isValid = Common.SecurePwd.decodePwd(vo, userDAO);

		// email존재하는지 검색
		UsersVO user = userDAO.select_email(vo.getEmail());

		// 가입된 이메일이 없는 경우
		if (user == null) {
			str = "[{'result':'no_id'}]";
		}

		// 이메일이 존재할 경우
		if (user != null) {
			// 비밀번호 일치할 때
			if (isValid) {
				session.setAttribute("user", user);
				session.setAttribute("role", user.getRole());
				session.setAttribute("u_idx", user.getU_idx()); //세션에 u_idx를 저장

				if (user.getIs_approved() == 0) {
					str = String.format("[{'result':'success'}, {'result2':'%s'}]", user.getRole());
				} else if (user.getIs_approved() == 1) {
					str = String.format("[{'result':'success'}, {'result2':'%s'}]", user.getRole());
				} else {
					str = String.format("[{'result':'success'}, {'result2':'%s'}]", user.getRole());
				}

			} else {
				// 비밀번호 불일치 할 때
				str = "[{'result':'fail'}]";
			}

			if (!(user.getBlock_reason() == null)) {
				// block_reason에 값이 있다면
				str = "[{'result':'login_reject'}]";
			}
		}
		return str;
	}

	// user logout
	@RequestMapping("logout.do")
	public String logout_user() {
		// session.invalidate(); : 모든 세션 데이터를 삭제하고 새 세션을 시작하기 때문에 일반적으로 로그아웃 기능에 사용
		session.invalidate();
		return "redirect:login_form.do";
	}

	// user_info 페이지
	@RequestMapping("user_info.do")
	public String user_info(Model model) {
		List<OrderVO> o_list = order_dao.selectList();
		model.addAttribute("o_list", o_list); // 사용자 전체보기
		return Common.Users.VIEW_PATH + "user_info.jsp";
	}

	// 비밀번호 업데이트
	@RequestMapping("update_pwd.do")
	@ResponseBody
	public String update_userPwd(UsersVO vo) {
		// 현재입력한 비밀번호가 db에 저장된 비밀번호와 일치하는지 여부 확인
		boolean isValid = Common.SecurePwd.decodePwd(vo, userDAO);

		// 새로 넘어온 pwd도 암호화해줘야함
		String encodeNewPwd = Common.SecurePwd.encodePwd(vo.getNew_password());
		vo.setNew_password(encodeNewPwd);

		// json형태의 결과값 담을 변수
		String str = "";

		// 비밀번호가 일치하는 상황이라면 -> 넘어온 newPwd로 수정작업진행
		if (isValid) {
			int res = userDAO.update_pwd(vo);
			if (res > 0) {
				str = "[{'result':'success'}]";
			} else {
				str = "[{'result':'fail'}]";
			}
			// db의 비밀번호와 불일치하는 경우
		} else if (!isValid) {
			str = "[{'result':'no_match'}]";
		}

		return str;
	}

	@RequestMapping("delete_user.do")
	@ResponseBody
	public String delete_user(UsersVO vo) {

		// 넘어온 이메일로 저장된 user정보를 가져온다
		UsersVO user = userDAO.select_email(vo.getEmail());

		String str = "";

		if (user != null) {
			boolean isValid = Common.SecurePwd.decodePwd(vo, userDAO);
			// 비밀번호 일치하는 경우
			if (isValid) {
				int res = userDAO.drop_user(vo);

				if (res > 0) {
					str = "[{'result':'success'}]";
				} else {
					str = "[{'result':'fail'}]";
				}
				// 비밀번호 불일치
			} else {
				str = "[{'result':'no_match'}]";
			}
			// 넘어온 email의 가입정보가 없을 때
		} else {
			str = "[{'result':'no_email'}]";
		}
		return str;
	}
}
