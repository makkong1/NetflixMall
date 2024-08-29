package dao;

import java.util.List;

import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import dao.ProductDAO;
import vo.ProductVO;

@Repository

public class ProductDAO {
	
	@Autowired
	SqlSession sqlSession;

	public ProductDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}

	public List<ProductVO> s_selectList() {
		List<ProductVO> list = sqlSession.selectList("p.product_list");
		return list;
	}
	public List<ProductVO> a_selectList() {
		List<ProductVO> list = sqlSession.selectList("p.a_product_list");
		return list;
	}
	
	//전체, 검색
	public List<ProductVO> p_selectDetailList(String product_name){
		List<ProductVO> list = null;
		System.out.println(product_name);
		if(product_name == null) {
			list = sqlSession.selectList("p.product_detail_list");
		}else {
			list = sqlSession.selectList("p.product_search_detail_list", product_name);
		}
		
		return list;
	}

	public int insert(ProductVO vo) {
		int res = sqlSession.insert("p.product_insert", vo);
		return res;
	}

	public int delete(int P_IDX) {
		int res = sqlSession.delete("p.product_delete", P_IDX);
		return res;
	}

	public ProductVO selectone(int P_IDX) {
		ProductVO vo = sqlSession.selectOne("p.product_selectone", P_IDX);
		return vo;
	}
	
	public int update(Map<String, Object> map) {
		int res = sqlSession.update("p.product_update", map);
		return res;
	}
	
	public ProductVO select_detail(int P_IDX) {
		ProductVO vo=sqlSession.selectOne("p.proudct_select_detail", P_IDX);
		return vo;
		
	}
	public List<ProductVO> selectSellerList(int user_idx){
		List<ProductVO> vo = sqlSession.selectList("p.seller_product", user_idx);
		return vo;
	}

}
