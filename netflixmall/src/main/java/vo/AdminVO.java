package vo;
 
public class AdminVO {

	private int admin_idx;
	private String username, password, email, redgate;
	
	public int getAdmin_idx() {
		return admin_idx;
	}
	public void setAdmin_idx(int admin_idx) {
		this.admin_idx = admin_idx;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public String getPassword() {
		return password;
	}
	public void setPassword(String password) {
		this.password = password;
	}
	public String getEmail() {
		return email;
	}
	public void setEmail(String email) {
		this.email = email;
	}
	public String getRedgate() {
		return redgate;
	}
	public void setRedgate(String redgate) {
		this.redgate = redgate;
	}
	
	
}
