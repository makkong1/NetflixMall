package vo;

import org.springframework.web.multipart.MultipartFile;

public class ProductVO {

	private int p_idx, price, stock, is_sellable;
	private int user_idx;
	private String name, description, category;
	private String registered_at;
	private String block_reason; // 블락 사유 필드 추가
	
	// 파입업로드객체
	private MultipartFile photo1;
	private MultipartFile photo2;
	private MultipartFile photo3;
	private MultipartFile photo4;
	private MultipartFile photo5;
	private MultipartFile photo6;
	
	private String filename1;
	private String filename2;
	private String filename3;
	private String filename4;
	private String filename5;
	private String filename6;
	
	public int getUser_idx() {
		return user_idx;
	}
	
	public void setUser_idx(int user_idx) {
		this.user_idx = user_idx;
	}
	public void setPhoto1(MultipartFile photo1) {
		this.photo1 = photo1;
	}

	public void setPhoto2(MultipartFile photo2) {
		this.photo2 = photo2;
	}

	public void setPhoto3(MultipartFile photo3) {
		this.photo3 = photo3;
	}

	public void setPhoto4(MultipartFile photo4) {
		this.photo4 = photo4;
	}

	public void setPhoto5(MultipartFile photo5) {
		this.photo5 = photo5;
	}

	public void setPhoto6(MultipartFile photo6) {
		this.photo6 = photo6;
	}

	public MultipartFile getPhoto1() {
		return photo1;
	}

	public MultipartFile getPhoto2() {
		return photo2;
	}

	public MultipartFile getPhoto3() {
		return photo3;
	}

	public MultipartFile getPhoto4() {
		return photo4;
	}

	public MultipartFile getPhoto5() {
		return photo5;
	}

	public MultipartFile getPhoto6() {
		return photo6;
	}

	public String getFilename1() {
		return filename1;
	}

	public void setFilename1(String filename1) {
		this.filename1 = filename1;
	}

	public String getFilename2() {
		return filename2;
	}

	public void setFilename2(String filename2) {
		this.filename2 = filename2;
	}

	public String getFilename3() {
		return filename3;
	}

	public void setFilename3(String filename3) {
		this.filename3 = filename3;
	}

	public String getFilename4() {
		return filename4;
	}

	public void setFilename4(String filename4) {
		this.filename4 = filename4;
	}

	public String getFilename5() {
		return filename5;
	}

	public void setFilename5(String filename5) {
		this.filename5 = filename5;
	}

	public String getFilename6() {
		return filename6;
	}

	public void setFilename6(String filename6) {
		this.filename6 = filename6;
	}
		
		
	public String getBlock_reason() {
		return block_reason;
	}
	public void setBlock_reason(String block_reason) {
		this.block_reason = block_reason;
	}
	
	public int getP_idx() {
		return p_idx;
	}
	public void setP_idx(int p_idx) {
		this.p_idx = p_idx;
	}
	public int getPrice() {
		return price;
	}
	public void setPrice(int price) {
		this.price = price;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public int getIs_sellable() {
		return is_sellable;
	}
	public void setIs_sellable(int is_sellable) {
		this.is_sellable = is_sellable;
	}
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getDescription() {
		return description;
	}
	public void setDescription(String description) {
		this.description = description;
	}
	public String getCategory() {
		return category;
	}
	public void setCategory(String category) {
		this.category = category;
	}
	public String getRegistered_at() {
		return registered_at;
	}
	public void setRegistered_at(String registered_at) {
		this.registered_at = registered_at;
	}
	
}
