package vo;

import java.util.Date;

public class UsersVO {
    private int u_idx;
    private String username;
    private String password;
    private String email;
    private String address;
    private int is_approved;
    private Date regdate;
    private int is_deleted;
    private String new_password;//비밀번호 수정할 때 필요
    private String block_reason;
    private String role;

   
    public String getRole() {
		return role;
	}

	public void setRole(String role) {
		this.role = role;
	}

	public String getBlock_reason() {
		return block_reason;
	}

	public void setBlock_reason(String block_reason) {
		this.block_reason = block_reason;
	}

	public String getNew_password() {
		return new_password;
	}

	public void setNew_password(String new_password) {
		this.new_password = new_password;
	}

	public int getIs_deleted() {
		return is_deleted;
	}

	public void setIs_deleted(int is_deleted) {
		this.is_deleted = is_deleted;
	}

	// Getters
    public int getU_idx() {
        return u_idx;
    }

    public String getUsername() {
        return username;
    }

    public String getPassword() {
        return password;
    }

    public String getEmail() {
        return email;
    }

    public String getAddress() {
        return address;
    }

    public int getIs_approved() {
        return is_approved;
    }

    public Date getRegdate() {
        return regdate;
    }

    // Setters
    public void setU_idx(int u_idx) {
        this.u_idx = u_idx;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public void setIs_approved(int is_approved) {
        this.is_approved = is_approved;
    }

    public void setRegdate(Date regdate) {
        this.regdate = regdate;
    }
}

