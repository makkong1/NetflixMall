package controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.CommentDAO;
import dao.QuestionDAO;
import dao.UsersDAO;
import util.Common;
import util.Paging;
import vo.CommentVO;
import vo.QuestionVO;
import vo.UsersVO;

@Controller
public class QuestionController {

	QuestionDAO questionDAO;
	UsersDAO userDAO;
	CommentDAO commentDAO;

	@Autowired
	HttpServletRequest request;
	@Autowired
	HttpSession session;

	public QuestionController(QuestionDAO questionDAO, UsersDAO userDAO, CommentDAO commentDAO) {
		this.questionDAO = questionDAO;
		this.userDAO = userDAO;
		this.commentDAO = commentDAO;
	}

	@RequestMapping("question_list.do")
	public String question_list(Model model, String page, String search, String search_text) {
		
		int nowPage = 1;
		if(page != null && !page.isEmpty()) {
			nowPage = Integer.parseInt(page);
		}
		
		// 한 페이지에 표시되는 게시물의 시작과 끝 번호를 계산
		int start = (nowPage - 1) * Common.questions.BLOCKLIST + 1;
		int end = start + Common.questions.BLOCKLIST - 1;
		
		// Start, end 변수를 Map에 저장
		// 검색쪽에서 map을 재활용 하기 위해 start,end 는 int 내용은 String이기때문에 Map의 파라미터 타입을 Object로 설정
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("start", start);
		map.put("end", end);
		
		// 검색어 관련 파라미터들 수신
		// question_list.do?search=name&search_text=abc&page=2
		
		//검색할 내용이 있는 경우
		if(search != null && !search.equals("all")) {
			if(search.equals("title_content")) {
				map.put("title", search_text);
				map.put("content", search_text);
			} else if(search.equals("title")) {
				map.put("title", search_text);
			} else if(search.equals("content")) {
				map.put("content", search_text);
			}
		}
		
		// 전체목록 가져오기
		List<QuestionVO> list = questionDAO.selectList(map);
		
		//전체 게시글 수 가져오기
		// 검색된 결과에 따라 최종 게시글 수는 다를 수 있기때문에 map을 파라미터로 보내야한다
		int row_total = questionDAO.getRowTotal(map);
		
		//페이지 메뉴 생성
		String search_param = String.format("search=%s&search_text=%s", search, search_text);
		String pageMenu = Paging.getPaging("question_list.do", nowPage, row_total, search_param, Common.questions.BLOCKLIST, Common.questions.BLOCKPAGE);

		//list 객체 바인딩
		model.addAttribute("list", list);
		model.addAttribute("pageMenu", pageMenu);

		// 조회수 증가를 위해 기록되어 있던 show 정보를 삭제
		session.removeAttribute("show");
		
		return Common.questions.VIEW_PATH + "question_list.jsp";
	}

	// insert
	@RequestMapping("insert_question.do")
	@ResponseBody
	public String insert_question(QuestionVO vo) {

		String str = "";

		// 넘어온 email을 통해 해당 유저의 정보를 가져온다음 입력한 pwd와 db의 암호화된 pwd일치여부 체크
		UsersVO user = userDAO.select_email(vo.getEmail());

		if (user != null) {
			// 여기서 비밀번호 매치확인
			user.setPassword(vo.getPwd());
			boolean isValid = Common.SecurePwd.decodePwd(user, userDAO);

			// 비밀번호 일치하는 경우 db에 저장
			if (isValid) {
				String ip = request.getRemoteAddr();
				vo.setIp(ip);
				// 비밀번호 암호화
				String encodePwd = Common.SecurePwd.encodePwd(vo.getPwd());
				vo.setPwd(encodePwd);
				int res = questionDAO.insert_question(vo);
				str = "[{'result':'success'}]";
			} else {
				str = "[{'result':'fail'}]";
			}
		} else {
			str = "[{'result':'no_email'}]";
		}
		return str;
	}

	@RequestMapping("detail_question.do")
	public String detail_question(int q_id, Model model) {
		// 넘어온 게시글의 번호로 해당 게시글의 정보들을 가져온다
		QuestionVO question = questionDAO.selectOne(q_id);

		// 브라우저 새로고침했을때 조회수 무한 증가 방지를 위한 세션
		String show = (String) session.getAttribute("show");
		if (show == null) {
			// 조회수 증가
			questionDAO.increase_view(q_id);
			session.setAttribute("show", "");
		}

		// 바인딩
		model.addAttribute("question", question);
		return Common.questions.VIEW_PATH + "detail_question.jsp";
	}

	@RequestMapping("delete_question.do")
	@ResponseBody
	public String delete_question(QuestionVO vo) {
		//넘어온 q_id, pwd 파라미터통해서 비밀번호 일치여부 확인
		boolean isValid = Common.SecurePwd.decodePwd_question(vo, questionDAO);
		
		if(isValid) {
			//비밀번호가 일치하면, del_info 컬럼을 -1로 변경한다
			int res = questionDAO.delete_question(vo.getQ_id());
			if(res > 0) {
				return "[{'result':'success'}]";
			} else {
				return "[{'result':'fail'}]";
			}
		} else {
			return "[{'result':'no_pwd'}]";
		}

	}
	
	@RequestMapping("update_question.do")
	@ResponseBody
	public String update_question(QuestionVO vo) {
		//비밀번호 일치 여부 확인하기
		boolean isValid = Common.SecurePwd.decodePwd_question(vo, questionDAO);
		
		if(isValid) {
			//비밀번호 일치하면 게시글 수정
			int res = questionDAO.update_question(vo);
			
			if(res > 0) {
				return "[{'result':'success'}]";
			} else {
				return "[{'result':'fail'}]";
			}
		} else {
			//비밀번호 불일치
			return "[{'result':'no_pwd'}]";
		}
		
	}
	
	@RequestMapping("comment_insert.do")
	@ResponseBody
	public String insert_comm(CommentVO vo) {
		vo.setIp(request.getRemoteAddr()); 
		int res = commentDAO.insert_comm(vo);
		
		if(res > 0) {
			return "[{'result':'yes'}]";
		} else {
			return "[{'result':'no'}]";
		}
	}
	
	@RequestMapping("comment_list.do")
	public String comm_list(Model model, int q_id) {
		
		List<CommentVO> list = commentDAO.selectList(q_id);
		model.addAttribute("list", list);
		return Common.questions.VIEW_PATH + "comment_list.jsp";
	}
	
	@RequestMapping("reply.do")
	@ResponseBody
	public String reply(CommentVO vo) {
		vo.setIp(request.getRemoteAddr());
		
		// 댓글을 작성하고 싶은 게시글의 idx에 해당되는 상세정보를 얻기 ... ref, step, depth.. 정보필요
		CommentVO baseVO = commentDAO.selectOne(vo.getC_idx());
		System.out.println(baseVO.getDepth());
		
		// 가져온 baseVO의 step보다 큰 값을 가진 데이터들의 step을 +1처리
		commentDAO.update_step(baseVO);
		
		// 댓글이 들어갈 위치 설정
		vo.setRef(baseVO.getRef());
		vo.setStep(baseVO.getStep() + 1);
		vo.setDepth(baseVO.getDepth() + 1);
		
		int res = commentDAO.reply(vo);
		
		if(res > 0) {
			return "[{'result':'yes'}]";
		} else {
			return "[{'result':'no'}]";
		}
	}

}
