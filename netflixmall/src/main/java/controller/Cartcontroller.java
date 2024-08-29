package controller;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import dao.CartDAO;
import dao.ProductDAO;
import dao.UsersDAO;
import util.Common;
import vo.CartVO;
import vo.ProductVO;
import vo.UsersVO;

@Controller
public class Cartcontroller {

    @Autowired
    SqlSession sqlSession;

    @Autowired
    HttpServletRequest request;

    @Autowired
    HttpSession session;

    @Autowired
    ServletContext app;

    CartDAO cartDAO;
    ProductDAO productsDAO;
    UsersDAO usersDAO;

    public Cartcontroller(CartDAO cartDAO, ProductDAO productsDAO, UsersDAO usersDAO) {
        this.cartDAO = cartDAO;
        this.productsDAO = productsDAO;
        this.usersDAO = usersDAO;
    }

    @RequestMapping("/cart_list.do")
    public String cart_list(Model model) {
        UsersVO user = (UsersVO) session.getAttribute("user");
        
        if (user == null) {
            return "redirect:login_form.do";
        }
        
        int user_Id = user.getU_idx();
        
        List<CartVO> cartlist = cartDAO.cart_list(user_Id);
        
        List<ProductVO> products = new ArrayList<ProductVO>();
        for (CartVO cart : cartlist) {
            ProductVO product = productsDAO.selectone(cart.getP_idx());
            if (product != null) {
                products.add(product);
            }
        }

        model.addAttribute("cartlist", cartlist);
        model.addAttribute("products", products);

        return "redirect:shop_page.do";
    }
    
    @RequestMapping("/cart_insert.do")
    public String cart_insert(CartVO cartVO) {
        UsersVO user = (UsersVO) session.getAttribute("user");

        if (user == null) {
            return Common.Users.VIEW_PATH + "login_form.jsp";
        }

        cartVO.setUser_Id(user.getU_idx());
     
        List<CartVO> existingCartItems = cartDAO.findByUserIdAndProductId(cartVO.getUser_Id(), cartVO.getP_idx());
        
        if (!existingCartItems.isEmpty()) {
            // Update the quantity of the first matching product
            CartVO existingCartItem = existingCartItems.get(0);
            existingCartItem.setQuantity(existingCartItem.getQuantity() + cartVO.getQuantity());
            cartDAO.cart_update(existingCartItem);
        } else {
            // Insert a new product into the cart
            cartDAO.cart_insert(cartVO);
            session.setAttribute("pIdx", cartVO.getP_idx());
        }
         
        return "redirect:cart_list.do";
    }
    
    @RequestMapping("/cart_update.do")
    
    public String cart_update(Model model, @RequestParam int id, @RequestParam int quantity) {    	
       
    	CartVO cartVO = cartDAO.select_One(id);
        cartVO.setQuantity(quantity);
        cartDAO.cart_update(cartVO);
        String referer = request.getHeader("Referer");
        return "redirect:"+ referer;
    }

    @RequestMapping("/cart_delete.do")
    public String cart_delete(@RequestParam int id) {
        cartDAO.cart_delete(id); 
        String referer = request.getHeader("Referer");
        return "redirect:"+ referer;
    }
    
    @RequestMapping("/cart_list_delete.do")
    public String cart_list_delete() {
    	UsersVO user = (UsersVO) session.getAttribute("user");
    	int id = user.getU_idx();
    	cartDAO.cart_list_delete(id);
        return "redirect:cart_list.do";
    }
    
    
}