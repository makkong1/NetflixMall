package vo;

import java.util.Date;
import java.util.List;

public class OrderVO {
    private int o_idx, total;             // 주문 ID
	private int u_idx;             // 사용자 ID
    private String username, name;       // 사용자 이름
    private int p_idx;             // 제품 ID
    private String productName;    // 제품 이름
    private int quantity;          // 수량
    private int price;          // 단가
    private int total_price;          // 총 가격
	private String status;         // 주문 상태
    private Date order_date;       // 주문 날짜
    

	public int getTotal() {
		return total;
	}

	public void setTotal(int total) {
		this.total = total;
	}
	
    public int getTotal_price() {
			return total_price;
	}
	
	public void setTotal_price(int total_price) {
		this.total_price = total_price;
	}

    public int getO_idx() {
        return o_idx;
    }

    public void setO_idx(int o_idx) {
        this.o_idx = o_idx;
    }

    public int getU_idx() {
        return u_idx;
    }

    public void setU_idx(int u_idx) {
        this.u_idx = u_idx;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public int getP_idx() {
        return p_idx;
    }

    public void setP_idx(int p_idx) {
        this.p_idx = p_idx;
    }

    public String getProductName() {
        return productName;
    }

    public void setProductName(String productName) {
        this.productName = productName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public Date getOrderDate() {
        return order_date;
    }

    public void setOrderDate(Date order_date) {
        this.order_date = order_date;
    }

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}
    
    
}
