package util;

import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

import dao.QuestionDAO;
import dao.UsersDAO;
import vo.QuestionVO;
import vo.UsersVO;

public class Common {

	public static class Users{
		public static final String VIEW_PATH = "/WEB-INF/views/users/";
	}
	
	public static class Admin{
		public static final String VIEW_PATH = "/WEB-INF/views/admin/";
	}
	
	public static class Product{
		public static final String VIEW_PATH = "/WEB-INF/views/product/";
	}
	
	public static class questions {
		
		public static final String VIEW_PATH = "/WEB-INF/views/questions/";
		
		//한 페이지당 보여줄 게시글 수
		public final static int BLOCKLIST = 5;
		
		//한 화면에 보여지는 페이지 메뉴의 수
		public final static int BLOCKPAGE = 3;
	}
	
	public static class SecurePwd {
		// 비밀번호 암호화 메서드
		public static String encodePwd(String pwd) {
			BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
			String encodePwd = encoder.encode(pwd);
			return encodePwd;
		}

		// 비밀번호 복호화 메서드
		public static boolean decodePwd(UsersVO vo, UsersDAO dao) {
			boolean isValid = false;

			UsersVO resultVO = dao.select_email(vo.getEmail());
			if (resultVO != null) {
				isValid = BCrypt.checkpw(vo.getPassword(), resultVO.getPassword());
			}
			return isValid;
		}

		// 비밀번호 복호화 메서드 - question테이블
		public static boolean decodePwd_question(QuestionVO vo, QuestionDAO dao) {
			boolean isValid = false;

			QuestionVO resultVO = dao.selectOne(vo.getQ_id());
			if (resultVO != null) {
				isValid = BCrypt.checkpw(vo.getPwd(), resultVO.getPwd());
			}
			return isValid;
		}
	}
}
