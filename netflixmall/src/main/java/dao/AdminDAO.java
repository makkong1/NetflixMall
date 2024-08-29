package dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.OrderVO;
import vo.ProductVO;
import vo.UsersVO;

public class AdminDAO {

	SqlSession sqlSession;
	
	public AdminDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
//==================== 유저 ========================================
	//사용자 보기
	public List<UsersVO> selectList() {
		List<UsersVO> list = sqlSession.selectList("ad.users_list");
		return list;
	}
	
	//사용자 디테일
	public List<UsersVO> selecDetailtList() {
		List<UsersVO> list = sqlSession.selectList("ad.users_detail_list");
		return list;
	}
	
	//검색 결과를 포함한 사용자 디테일 오버로드
	public List<UsersVO> selecDetailtList(Map<String, Object> map) {
		List<UsersVO> list = sqlSession.selectList("ad.users_detail_list_search", map);
		return list;
	}
	
	//사용자 블락
	public int user_block(int u_idx, String blockReason) {
	    Map<String, Object> params = new HashMap<String, Object>();
	    params.put("u_idx", u_idx);
	    params.put("blockReason", blockReason);
	    int res = sqlSession.update("ad.user_block", params);
	    return res;
	}
	
	//사용자 블락 취소
	public int user_unblock(int u_idx) {
	    int res = sqlSession.update("ad.user_unblock", u_idx);
	    return res;
	}

	//사용자 구분
	public List<UsersVO> user_status(int is_approved) {
		List<UsersVO> res = 
				sqlSession.selectList("ad.user_status", is_approved);
		return res;
	} 
	
	//사용자 검색
	public List<UsersVO> search_user(String search_user){
		Map<String, String> params = new HashMap<String, String>();
	    params.put("search", search_user);
	    return sqlSession.selectList("ad.search_user", params); 
	}
	
	//사용자 수 계산
	public int getRowTotal( Map<String, Object> map ) {
		int count = sqlSession.selectOne("ad.user_count", map);
		return count;
	}
	
	//사용자 블락 취소
	public int apply_seller(int u_idx) {
		int res = sqlSession.update("ad.apply_seller", u_idx);
		return res;
	}

//===================== 제품 ========================================
	
	//제품 블락
	public int product_block(int p_idx, String blockReason) {
	    Map<String, Object> params = new HashMap<String, Object>();
	    params.put("p_idx", p_idx);
	    params.put("blockReason", blockReason);
	    int res = sqlSession.update("p.product_block", params);
	    return res;
	} 
	
	//제품 블락 취소
	public int product_unblock(int p_idx) {
		int res = sqlSession.update("p.product_unblock", p_idx);
	    return res;
	}
	
	//제품 검색 json받기
	public List<ProductVO> p_selectDetailList(String search_product){
		List<ProductVO> list = sqlSession.selectList("ad.product_search_list", search_product);
		return list;
	}
	
//===================== 주문 ========================================
	//주문 목록 ,주문 검색 목록 보여주기
	public List<OrderVO> selectOrdertList(String username){
		List<OrderVO> list = null;
		if(username == null) {
			list = sqlSession.selectList("o.order_list");
		}else {
			list = sqlSession.selectList("o.order_search_list", username);
		}
		return list;
	}
	
} 