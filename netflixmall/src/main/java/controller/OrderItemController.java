package controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import dao.OrderItemDAO;
import dao.UsersDAO;
 

@Controller
public class OrderItemController {
	UsersDAO userDAO;
	OrderItemDAO order_item_dao;
	
	public OrderItemController(UsersDAO userDAO, OrderItemDAO order_item_dao) {
		this.userDAO = userDAO;
		this.order_item_dao = order_item_dao;
	}
	
	@RequestMapping("order_item_insert.do")
	@ResponseBody
	public String order_item_insert(int o_idx, int u_idx) {
		Map<String, Object> params = new HashMap<String, Object>();
		params.put("o_idx", o_idx);
		params.put("u_idx", u_idx);
		int res = order_item_dao.order_item_insert(params);
		if(res > 0) {
			String resultStr = String.format("[{'result':'success'}]"); 
			return resultStr; 
		}else {
			return "[{'result':'fail'}]";
		}
	}
	
}
