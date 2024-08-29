package dao;

import org.apache.ibatis.session.SqlSession;

import vo.UsersVO;

public class UsersDAO {
	

	SqlSession sqlSession;
	
	public UsersDAO(SqlSession sqlSession) {
		this.sqlSession = sqlSession;
	}
	
	public int user_delete(int u_idx) {
		int res = sqlSession.delete("u.user_delete",u_idx);
		return res;
	}
	
	//email 검색
	public UsersVO select_email(String email) {
		UsersVO vo = sqlSession.selectOne("u.select_email",email);
		return vo;
	}
	
	//user insert
	public int user_insert(UsersVO vo) {
		int res = sqlSession.insert("u.user_insert", vo);
		return res;
	}
	
	//user pwd update
	public int update_pwd(UsersVO vo) {
		int res = sqlSession.update("u.userPwd_update", vo);
		return res;
	}
	
	//drop user
	public int drop_user(UsersVO vo) {
		int res = sqlSession.delete("u.user_drop", vo);
		return res;
	}
	
}
