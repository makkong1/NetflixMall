package controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.OrderDAO;
import dao.OrderItemDAO;
import dao.UsersDAO;
import util.Common;
import vo.OrderVO;

@Controller
public class OrderController {
	
	OrderDAO order_dao;
	UsersDAO userdao;
	OrderItemDAO order_item_dao;
	
	@Autowired
	HttpSession session;
	
	public OrderController(OrderDAO order_dao, UsersDAO userdao, OrderItemDAO order_item_dao) {
		this.order_dao = order_dao;
		this.userdao = userdao;
		this.order_item_dao = order_item_dao;
	}
	
	@RequestMapping("pay.do")
	@ResponseBody 
	public String order(OrderVO vo) {
		int res = order_dao.insertOrder(vo);
		int o_idx = order_dao.selectOrder(vo.getU_idx()); 
		if(res > 0) {
			String resultStr = String.format("[{'result':'success', 'result2':'%s'}]", o_idx); 
			return resultStr;
		} else {
			return "[{'result':'fail'}]";
		}
	}
	
	//user_info에 주문 상세 보기
	@RequestMapping(value={"seller_order_list.do"})
	public String order_list(Model model) {
		List<OrderVO> o_list = order_dao.selectList();  
		model.addAttribute("o_list", o_list); // 사용자 전체보기  
		return Common.Users.VIEW_PATH + "user_info.jsp"; 
	}
} 
