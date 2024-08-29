package dao;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;

public class OrderItemDAO {
	 

	SqlSession sqlSession;
	
	public OrderItemDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	} 
	
    public int order_item_insert(Map<String, Object> params) {
    	int res = sqlSession.update("oi.insert_order_items", params);
    	return res;
    }
}
