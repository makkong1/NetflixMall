package controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.AdminDAO;
import dao.BoardDAO;
import dao.OrderDAO;
import dao.OrderItemDAO;
import dao.ProductDAO;
import dao.UsersDAO;
import util.Common;
import vo.BoardVO;
import vo.OrderVO;
import vo.ProductVO;
import vo.UsersVO; 

@Controller
public class AdminController { 
	
	@Autowired
	HttpSession session;

	AdminDAO adminDAO;
	UsersDAO user_dao;
	ProductDAO products_dao;
	BoardDAO board_dao;
	OrderDAO order_dao;
	OrderItemDAO orderItem_dao;
		
	public AdminController(AdminDAO adminDAO, UsersDAO user_dao, 
			ProductDAO products_dao, BoardDAO board_dao,
			OrderDAO order_dao, OrderItemDAO orderItem_dao) { 
		this.adminDAO = adminDAO;  
		this.user_dao = user_dao;
		this.products_dao = products_dao;
		this.board_dao = board_dao;
		this.order_dao = order_dao;
		this.orderItem_dao = orderItem_dao;
	}

	//메인페이지 테이블 넣기  
	@RequestMapping("/admin.do")  
	public String adminPage(Model model1 , Model model2, Model model3, Model model4) {
		Object role = session.getAttribute("role");
		System.out.println(role); 
		
		//관리자만 관리자페이지들어올수있음
//		if(role.equals("user")  || role.equals("seller") || role.equals(null)) { 
//			return "redirect:main.do"; 
//		}else { 
			List<UsersVO> list = adminDAO.selectList();
			List<ProductVO> list2 = products_dao.a_selectList(); 
			List<BoardVO> list3 = board_dao.selectSmallList(); 
			List<OrderVO> list4 = order_dao.selectList();
			model1.addAttribute("list1", list); // 사용자 전체보기 
			model2.addAttribute("list2", list2); // 제품 전체보기
			model3.addAttribute("list3", list3); // 게시글 전체보기 아직못함
			model4.addAttribute("list4", list4); // 주문 게시글 보기
			return Common.Admin.VIEW_PATH + "admin.jsp";
		//}
	} 

//================ 사용자, 판매자 관리 =================================
	
	//사용자 블락 처리 
	@RequestMapping("/user_delete.do") 
	@ResponseBody 
	public String user_block(int u_idx, String blockReason) { 
		int res = adminDAO.user_block(u_idx, blockReason);
		String resultStr = "";
		String result = "fail";
		session.removeAttribute("user");
		
		if(res > 0) {
			result = "success"; 
			resultStr = String.format("[{'result':'%s'}]", result);
			return resultStr;
		}
		return result;   
	} 
	
	//사용자 블락 취소
	@RequestMapping("/user_unblock.do")
	@ResponseBody
	public String user_unblock(int u_idx) {
	    int res = adminDAO.user_unblock(u_idx);
	    String resultStr = "";
	    String result = "fail";

	    if(res > 0) {
	        result = "success";
	        resultStr = String.format("[{'result':'%s'}]", result);
	        return resultStr;
	    }
	    return result;   
	}

	//사용자 전체 보기
	@RequestMapping("/users_detail_list.do")
	public String users_detail_list(Model model, Integer is_approved, 
			String search_user, String page) {

		Map<String, Object> map = new HashMap<String, Object>(); 

		List<UsersVO> list = null;

		// 검색어가 존재하면 검색 기능 실행
		if (search_user != null && !search_user.trim().isEmpty()) {
			map.put("email", search_user);
			list = adminDAO.selecDetailtList(map);  

		} else if (is_approved != null) { 

			// is_approved가 null이 아닐 경우 처리 
			// 전체보기
			if (is_approved == 2) { 
				map.put("is_approved", is_approved);
				list = adminDAO.selecDetailtList();
				model.addAttribute("list", list);

			// 사용자, 판매자 구분하기
			} else if (is_approved == 1 || is_approved == 0) { 
				map.put("is_approved", is_approved);
				list = adminDAO.user_status(is_approved);
				model.addAttribute("list", list);
			}  
		} else {
			//추가해야됨
		} 

		//list객체 바인딩 및 포워딩
		model.addAttribute("list", list); 

		return Common.Admin.VIEW_PATH + "users_detail_list.jsp";
	}

	// 사용자 구분 
	@RequestMapping("/user_status.do")
	@ResponseBody
	public String user_status(@RequestParam int is_approved) {
		List<UsersVO> res = adminDAO.user_status(is_approved);

		String resultStr = "";  
		String result = "fail"; 
		int isApprovedValue = 0;

		if (!res.isEmpty()) {
			result = "success"; 
			UsersVO is_approved2 = res.get(is_approved);  
			isApprovedValue = is_approved2.getIs_approved();
		}else {
			result = "success";
			isApprovedValue = 2; 
		}

		resultStr = String.format("[{'result':'%s'},{'is_approved2':'%s'}]", result, isApprovedValue);

		return resultStr;
	}

	//사용자 검색 
	//수정필요
	@RequestMapping("/search_users.do")
	@ResponseBody
	public String search_users(Model model, String search_user ) {
		List<UsersVO> res = adminDAO.search_user(search_user);

		String resultStr = "";  
		String result = "fail";  
		int is_approved = 0;
		
		if (!res.isEmpty()) {
			result = "success"; 
			UsersVO user = res.get(0);
	        is_approved = user.getIs_approved();
		}

		resultStr = String.format("[{'result':'%s'},{'result2':'%s'},{'result3':'%s'}]", result, search_user, is_approved);

		return resultStr; 
	}
	
	//사용자 판매자로 변경
	@RequestMapping("/apply_seller.do")
	@ResponseBody 
	public String apply_seller(int u_idx) { 
		int res = adminDAO.apply_seller(u_idx);
		String resultStr = "";
		String result = "fail";
		
		if(res > 0) {
			result = "success"; 
			resultStr = String.format("[{'result':'%s'}]", result);
			return resultStr;
		}
		return result;   
	} 
	
//================ 제품 =================================	
	
	//제품 디테일 전체보기 product_dao 재사용
	@RequestMapping(value = "/Products_detail_list.do")
	public String product_detail_list(Model model, String product_name) {
		//System.out.println("들어옴");
		System.out.println(product_name); 
		List<ProductVO> p_list = products_dao. p_selectDetailList(product_name);  
		model.addAttribute("p_list", p_list);
		return Common.Admin.VIEW_PATH + "Product_detail_list.jsp";
	}
	
	//제품 블락
	@RequestMapping("/product_block.do")
 	@ResponseBody
 	public String product_block(int p_idx, String blockReason) {
		int res = adminDAO.product_block(p_idx, blockReason);
		String resultStr = "";
		String result = "fail";
 
		if(res > 0) {
			result = "success"; 
			resultStr = String.format("[{'result':'%s'}]", result);
			return resultStr;
		}
		return result;   
	}
	
	//제품 블락 취소
	@RequestMapping("/product_unblock.do")
    @ResponseBody 
    public String unblockProduct( int p_idx ) {
        int res = adminDAO.product_unblock(p_idx);
        String resultStr = "";
		String result = "fail";
 
		if(res > 0) {
			result = "success"; 
			resultStr = String.format("[{'result':'%s'}]", result);
			return resultStr;
		}
		return result;  
    }
	
	//제품검색
	@RequestMapping(value="/product_search.do", produces="application/json;charset=UTF-8")
    @ResponseBody 
	public String product_search(String search_product) {
		List<ProductVO> res = adminDAO.p_selectDetailList(search_product);
		String resultStr = "";  
		String result = "fail";   
		
		if (!res.isEmpty()) {
			result = "success";
			String rsOrder = res.get(0).getName();
			resultStr = String.format("[{'result':'%s'},{'result2':'%s'}]", result, rsOrder);
		}else {
			resultStr = String.format("[{'result':'%s'}]", result);
		}
		
		System.out.println(resultStr);
		return resultStr;
	}
	
//================ 주문 =================================	
	
	//주문 상세 보기
	@RequestMapping("/order_list.do")
	public String order_list(Model model, String username) {
		
		List<OrderVO> list = adminDAO.selectOrdertList(username); 
		model.addAttribute("list", list); // 사용자 전체보기
		return Common.Admin.VIEW_PATH + "order_list.jsp";
	}
	 
	//주문 검색 
	@RequestMapping("/search_order.do")		
	@ResponseBody 
	public String search_order(String search_order ) {
		List<OrderVO> res = adminDAO.selectOrdertList(search_order); 
		String resultStr = "";  
		String result = "fail";   
		
		if (!res.isEmpty()) {
			result = "success";
			String rsOrder = res.get(0).getUsername(); 
			resultStr = String.format("[{'result':'%s'},{'result2':'%s'}]", result, rsOrder);
		}else {
			resultStr = String.format("[{'result':'%s'}]", result);
		}
		
		return resultStr; 
	}
	
}