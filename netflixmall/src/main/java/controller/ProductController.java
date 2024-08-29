package controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

import dao.ProductDAO;
import util.Common;
import vo.ProductVO;

@Controller
public class ProductController {
	
    @Autowired
    Cartcontroller cartController;
    
    @Autowired
	HttpSession session;

	@Autowired
	ServletContext app;

	ProductDAO productDAO;

	public ProductController(ProductDAO productDAO) {
		this.productDAO = productDAO;
	}

	@RequestMapping(value = {"/", "/shop_page.do" })
	public String list(Model model) {
		List<ProductVO> list = productDAO.s_selectList();
		model.addAttribute("list", list);

        cartController.cart_list(model);
        
		return Common.Product.VIEW_PATH + "shop_page.jsp";
	}

	@RequestMapping("/insert.do")
	public String insert(ProductVO vo) {

		String webPath = "/resources/upload/";
		String savePath = app.getRealPath(webPath);
	    String[] filenames = new String[6];

	    // MultipartFile 諛곗뿴
	    MultipartFile[] photos = { vo.getPhoto1(), vo.getPhoto2(), vo.getPhoto3(),
	                               vo.getPhoto4(), vo.getPhoto5(), vo.getPhoto6() };

	    for( int i = 0; i < photos.length; i++ ) {
	    System.out.println( photos[i] );
	    }
	    for (int i = 0; i < photos.length; i++) {
	        MultipartFile photo = photos[i];
	        String filename = "no_file";
	        if (!photo.isEmpty()) {
	            filename = photo.getOriginalFilename();
	            System.out.println(photo);

	            File savefile = new File(savePath, filename);

	            if (savefile.exists()) {
	                long time = System.currentTimeMillis();
	                filename = String.format("%d_%s", time, filename);
	                savefile = new File(savePath, filename);
	            }

	            try {
	                photo.transferTo(savefile);
	            } catch (Exception e) {
	                e.printStackTrace();
	            }
	        }
	        filenames[i] = filename;
	    }
	    
	    vo.setFilename1(filenames[0]);
	    vo.setFilename2(filenames[1]);
	    vo.setFilename3(filenames[2]);
	    vo.setFilename4(filenames[3]);
	    vo.setFilename5(filenames[4]);
	    vo.setFilename6(filenames[5]);
	    
	    
	    int u_idx = (Integer) session.getAttribute("u_idx");
	    vo.setUser_idx(u_idx);
		productDAO.insert(vo);
		session.setAttribute("p_idx", vo.getP_idx());
		return "redirect:shop_page.do";
	}

	@RequestMapping(value = "/delete.do")
	public String delete(ProductVO vo) {
		int result = productDAO.delete(vo.getP_idx());
		if (result > 0) {
			return "redirect:/shop_page.do";
		} else {

			return "error";
		}
	}

	@RequestMapping("modify_form.do")
	public String selectone(Model model, int p_idx) {
		ProductVO vo = productDAO.selectone(p_idx);
		model.addAttribute("vo", vo);
		System.out.println(vo);
		return Common.Product.VIEW_PATH + "modify_form.jsp";
	}
	
	@RequestMapping(value = "/update.do", method = RequestMethod.POST)
	public String update(ProductVO vo,
	                     @RequestParam("p_idx") int p_idx,
	                     @RequestParam("name") String name,
	                     @RequestParam("description") String description,
	                     @RequestParam("price") int price,
	                     @RequestParam("stock") int stock,
	                     @RequestParam("category") String category,
	                     @RequestParam(value = "photos", required = false) MultipartFile[] photos) {

	    String webPath = "/resources/upload/";
	    String savePath = app.getRealPath(webPath);
	    System.out.println("�젅��寃쎈줈: " + savePath);

	    String[] filenames = new String[6];
	    for (int i = 0; i < photos.length; i++) {
	        MultipartFile photo = photos[i];
	        if (photo != null && !photo.isEmpty()) {
	            String filename = photo.getOriginalFilename();
	            if (filename != null) {
	                File savefile = new File(savePath, filename);
	                if (savefile.exists()) {
	                    long time = System.currentTimeMillis();
	                    filename = String.format("%d_%s", time, filename);
	                    savefile = new File(savePath, filename);
	                }

	                try {
	                    photo.transferTo(savefile);
	                } catch (Exception e) {
	                    e.printStackTrace();
	                }

	                if (i < filenames.length) {
	                    filenames[i] = filename;
	                }
	            }
	        }
	    }

	    // 湲곗〈 �뙆�씪 �쑀吏��븯硫댁꽌 �깉 �뙆�씪 �뜮�뼱�벐湲�
	    vo.setFilename1(filenames[0] != null ? filenames[0] : vo.getFilename1());
	    vo.setFilename2(filenames[1] != null ? filenames[1] : vo.getFilename2());
	    vo.setFilename3(filenames[2] != null ? filenames[2] : vo.getFilename3());
	    vo.setFilename4(filenames[3] != null ? filenames[3] : vo.getFilename4());
	    vo.setFilename5(filenames[4] != null ? filenames[4] : vo.getFilename5());
	    vo.setFilename6(filenames[5] != null ? filenames[5] : vo.getFilename6());

	    vo.setP_idx(p_idx);
	    vo.setName(name);
	    vo.setDescription(description);
	    vo.setPrice(price);
	    vo.setStock(stock);
	    vo.setCategory(category);

	    Map<String, Object> map = new HashMap<String, Object>();
	    map.put("vo", vo);
	    map.put("P_IDX", p_idx);
	    map.put("filename1", vo.getFilename1());
	    map.put("filename2", vo.getFilename2());
	    map.put("filename3", vo.getFilename3());
	    map.put("filename4", vo.getFilename4());
	    map.put("filename5", vo.getFilename5());
	    map.put("filename6", vo.getFilename6());

	    productDAO.update(map);

	    return "redirect:/shop_page.do";
	}
	@RequestMapping("product_details.do")
	public String select_detail(int p_idx,Model model) {
		ProductVO vo = productDAO.selectone(p_idx);
		model.addAttribute("vo", vo);
		cartController.cart_list(model);
		return Common.Product.VIEW_PATH + "product_detail.jsp";
	}
	
	@RequestMapping("myItem.do")
	public String select_my_items(int user_idx, Model model) {
		List<ProductVO> vo = productDAO.selectSellerList(user_idx);
		model.addAttribute("product", vo);
		return Common.Product.VIEW_PATH + "sellerItems.jsp";
	}
}