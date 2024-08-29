package dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;

import vo.QuestionVO;

public class QuestionDAO {

	SqlSession sqlSession;
	
	public QuestionDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	//전체 게시글 조회
	public List<QuestionVO> selectList(Map<String, Object> map){
		List<QuestionVO> list = sqlSession.selectList("q.question_list", map);
		return list;
	}
	
	//게시글 1개 조회
	public QuestionVO selectOne(int q_id) {
		QuestionVO vo = sqlSession.selectOne("q.select_one", q_id);
		return vo;
	}
	
	//게시글 등록
	public int insert_question(QuestionVO vo) {
		int res = sqlSession.insert("q.insert_question", vo);
		return res;
	}
	
	//조회수 증가
	public int increase_view(int q_id) {
		int res = sqlSession.update("q.increase_view", q_id);
		return res;
	}
	
	//게시글 삭제
	public int delete_question(int q_id) {
		int res = sqlSession.update("q.delete_question", q_id);
		return res;
	}
	
	//게시글 수정
	public int update_question(QuestionVO vo) {
		int res = sqlSession.update("q.update_question", vo);
		return res;
	}
	
	//전체 게시글 수 가져오기
	public int getRowTotal(Map<String, Object> map) {
		int count = sqlSession.selectOne("q.rowTotal", map);
		return count;
		}
}
