package vo;

import java.util.Date;

public class CartVO {
    private int id;
    private int user_Id;
    private int p_idx;
	private int quantity;
    private Date added_At;
    private String filename1;
    private String block_reason;
    
	public int getP_idx() {
		return p_idx;
	}

	public void setP_idx(int p_idx) {
		this.p_idx = p_idx;
	}

	public String getFilename1() {
		return filename1;
	}

	public void setFilename1(String filename1) {
		this.filename1 = filename1;
	}

	public String getBlock_reason() {
		return block_reason;
	}

	public void setBlock_reason(String block_reason) {
		this.block_reason = block_reason;
	}

    // Getter and Setter methods
    
    public String getFilename() {
		return filename1;
	}

	public void setFilename(String filename1) {
		this.filename1 = filename1;
	}
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUser_Id() {
        return user_Id;
    }

    public void setUser_Id(int user_Id) {
        this.user_Id = user_Id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public Date getAdded_At() {
        return added_At;
    }

    public void setAdded_At(Date added_At) {
        this.added_At = added_At;
    }
}