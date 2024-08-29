package vo;
public class OrderItemVO {
    private int idx;
    private int o_idx;
    private int p_idx;
    private int quantity;
    private int price;
    
	// Getter and Setter methods
    public int getIdx() {
        return idx;
    }

    public void setIdx(int idx) {
        this.idx = idx;
    }

    public int getO_idx() {
        return o_idx;
    }

    public void setO_idx(int o_idx) {
        this.o_idx = o_idx;
    }

    public int getP_idx() {
        return p_idx;
    }

    public void setP_idx(int p_idx) {
        this.p_idx = p_idx;
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
}
