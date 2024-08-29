package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import vo.CommentVO;

public class CommentDAO {
	
	SqlSession sqlSession;
	
	public CommentDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	public int insert_comm(CommentVO vo) {
		int res = sqlSession.insert("c.insert_comm", vo);
		return res;
	}
	
	public List<CommentVO> selectList(int q_id) {
		List<CommentVO> list = sqlSession.selectList("c.comm_list", q_id);
		return list;
	}
	
	public CommentVO selectOne(int c_id) {
		CommentVO vo = sqlSession.selectOne("c.select_one", c_id);
		return vo;
	}
	
	public int update_step(CommentVO vo) {
		int res = sqlSession.update("c.comm_update_step", vo);
		return res;
	}
	
	public int reply(CommentVO vo) {
		int res = sqlSession.insert("c.comm_reply", vo);
		return res;
	}
	
	
}















