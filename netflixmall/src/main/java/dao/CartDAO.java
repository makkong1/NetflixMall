
package dao;

import java.util.List;


import org.apache.ibatis.session.SqlSession;

import vo.CartVO;

public class CartDAO {
    
    SqlSession sqlSession;
    
    public CartDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }
    

    public List<CartVO> cart_list(int user_Id) {
    	List<CartVO> list = sqlSession.selectList("c.cart_list", user_Id);
        return list;
    }    	


    public int cart_insert(CartVO cartVO) {
        int res = sqlSession.insert("c.cart_insert", cartVO);
        return res;
        
    }

    public int cart_update(CartVO cartVO) {
        int res = sqlSession.update("c.cart_update", cartVO);
        return res;
    }
    
	public CartVO select_One(int id) {
		CartVO vo = sqlSession.selectOne("c.cart_one", id);
		return vo;
	}

    public int cart_delete(int id) {
        int res = sqlSession.delete("c.cart_delete", id);
        return res;
    }

    public List<CartVO> findByUserIdAndProductId(int user_Id, int p_idx) {
        CartVO params = new CartVO();
        params.setUser_Id(user_Id);
        params.setP_idx(p_idx);
        return sqlSession.selectList("c.findByUserIdAndProductId", params);
    }
    
    public int cart_list_delete(int id) {
    	int res = sqlSession.delete("c.cart_list_delete", id);
    	return res;
    }
}
