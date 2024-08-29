package dao;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.web.bind.annotation.RequestMapping;

import vo.OrderVO;

public class OrderDAO {
	

	SqlSession sqlSession;
	
	public OrderDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	

	//주문 전체 보기
	public List<OrderVO> selectList() {
		List<OrderVO> list4 = sqlSession.selectList("o.order_list");
		return list4; 
	}
	
	public int insertOrder(OrderVO vo) {
		int res = sqlSession.insert("o.insert_order", vo);
		return res;
	}
	
	public int selectOrder(int u_idx) {
		OrderVO idx = sqlSession.selectOne("o.order_insert_idx", u_idx);
		int res = idx.getO_idx();
		return res;
	}
		
}	
