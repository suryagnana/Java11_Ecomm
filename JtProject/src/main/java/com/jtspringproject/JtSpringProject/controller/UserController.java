package com.jtspringproject.JtSpringProject.controller;

import com.jtspringproject.JtSpringProject.models.Cart;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.models.CartProduct;

import java.io.Console;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import com.jtspringproject.JtSpringProject.services.cartService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.services.userService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.services.cartService;
import com.jtspringproject.JtSpringProject.dao.cartProductDao;

@Controller
public class UserController{

	private final userService userService;
	private final productService productService;
	private final cartService cartService;
	private final cartProductDao cartProductDao;

	@Autowired
	public UserController(userService userService, productService productService, cartService cartService, cartProductDao cartProductDao) {
		this.userService = userService;
		this.productService = productService;
		this.cartService = cartService;
		this.cartProductDao = cartProductDao;
	}

	@GetMapping("/register")
	public String registerUser()
	{
		return "register";
	}

	@GetMapping("/buy")
	public String buy()
	{
		return "buy";
	}

	@GetMapping("/login")
	public ModelAndView userlogin(@RequestParam(required = false) String error) {
	    ModelAndView mv = new ModelAndView("userLogin");
	    if ("true".equals(error)) {
	        mv.addObject("msg", "Please enter correct email and password");
	    }
	    return mv;
	}
	
	@GetMapping("/")
	public ModelAndView indexPage()
	{
		ModelAndView mView  = new ModelAndView("index");	
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		mView.addObject("username", username);
		List<Product> products = this.productService.getProducts();

		if (products.isEmpty()) {
			mView.addObject("msg", "No products are available");
		} else {
			mView.addObject("products", products);
		}
		return mView;
	}
	
	@GetMapping("/user/products")
	public ModelAndView getproduct() {

		ModelAndView mView = new ModelAndView("uproduct");

		List<Product> products = this.productService.getProducts();

		if(products.isEmpty()) {
			mView.addObject("msg","No products are available");
		}else {
			mView.addObject("products",products);
		}

		return mView;
	}
	
	@RequestMapping(value = "newuserregister", method = RequestMethod.POST)
	public ModelAndView newUseRegister(@ModelAttribute User user)
	{
		// Check if username already exists in database
		boolean exists = this.userService.checkUserExists(user.getUsername());

		if(!exists) {
			System.out.println(user.getEmail());
			user.setRole("ROLE_NORMAL");
			this.userService.addUser(user);

			System.out.println("New user created: " + user.getUsername());
			ModelAndView mView = new ModelAndView("userLogin");
			return mView;
		} else {
			System.out.println("New user not created - username taken: " + user.getUsername());
			ModelAndView mView = new ModelAndView("register");
			mView.addObject("msg", user.getUsername() + " is taken. Please choose a different username.");
			return mView;
		}
	}

	@GetMapping("/profileDisplay")
	public String profileDisplay(Model model, HttpServletRequest request) {
		
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		User user = userService.getUserByUsername(username);
	
		if (user != null) {
			model.addAttribute("userid", user.getId());
			model.addAttribute("username", user.getUsername());
			model.addAttribute("email", user.getEmail());
			model.addAttribute("password", user.getPassword()); 
			model.addAttribute("address", user.getAddress());
	    } else {
	    	model.addAttribute("msg", "User not found");
	    } 

		return "updateProfile";
	}
	

	   //for Learning purpose of model
		@GetMapping("/test")
		public String Test(Model model)
		{
			System.out.println("test page");
			model.addAttribute("author","jay gajera");
			model.addAttribute("id",40);
			
			List<String> friends = new ArrayList<String>();
			model.addAttribute("f",friends);
			friends.add("xyz");
			friends.add("abc");
			
			return "test";
		}
		
		// for learning purpose of model and view ( how data is pass to view)
		
		@GetMapping("/test2")
		public ModelAndView Test2()
		{
			System.out.println("test page");
			//create modelandview object
			ModelAndView mv=new ModelAndView();
			mv.addObject("name","jay gajera 17");
			mv.addObject("id",40);
			mv.setViewName("test2");
			
			List<Integer> list=new ArrayList<Integer>();
			list.add(10);
			list.add(25);
			mv.addObject("marks",list);
			return mv;
			
			
		}

	@GetMapping("/cart")
	public ModelAndView viewCart() {
		ModelAndView mView = new ModelAndView("cart");
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		User user = userService.getUser(username);
		
		if (user != null) {
			Cart cart = cartService.getCartByUser(user);
			if (cart == null) {
				cart = new Cart();
				cart.setCustomer(user);
				cartService.addCart(cart);
			}
			
			List<Product> cartProducts = cartProductDao.getProductByCartID(cart.getId());
			mView.addObject("cartProducts", cartProducts);
		}
		
		return mView;
	}
	
	@GetMapping("/products/addtocart")
	public ModelAndView addToCart(@RequestParam("id") int productId) {
		ModelAndView mView = new ModelAndView("redirect:/cart");
		
		try {
			String username = SecurityContextHolder.getContext().getAuthentication().getName();
			User user = userService.getUser(username);
			
			if (user == null) {
				mView.addObject("msg", "Please login to add items to cart");
				mView.addObject("msgType", "warning");
				return mView;
			}
			
			Product product = productService.getProduct(productId);
			if (product == null) {
				mView.addObject("msg", "Product not found");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Get or create cart for user
			Cart cart = cartService.getCartByUser(user);
			if (cart == null) {
				cart = new Cart();
				cart.setCustomer(user);
				cartService.addCart(cart);
			}
			
			// Add product to cart
			CartProduct cartProduct = new CartProduct(cart, product);
			cartProductDao.addCartProduct(cartProduct);
			
			mView.addObject("msg", "Product added to cart successfully");
			mView.addObject("msgType", "success");
			
		} catch (Exception e) {
			mView.addObject("msg", "Error adding product to cart: " + e.getMessage());
			mView.addObject("msgType", "danger");
		}
		
		return mView;
	}
	
	@GetMapping("/cart/remove")
	public ModelAndView removeFromCart(@RequestParam("id") int cartProductId) {
		ModelAndView mView = new ModelAndView("redirect:/cart");
		
		try {
			cartProductDao.deleteCartProduct(cartProductId);
			mView.addObject("msg", "Product removed from cart");
			mView.addObject("msgType", "success");
		} catch (Exception e) {
			mView.addObject("msg", "Error removing product from cart: " + e.getMessage());
			mView.addObject("msgType", "danger");
		}
		
		return mView;
	}
	  
}