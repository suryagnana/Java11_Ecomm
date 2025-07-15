package com.jtspringproject.JtSpringProject.controller;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import com.jtspringproject.JtSpringProject.models.Category;
import com.jtspringproject.JtSpringProject.models.Product;
import com.jtspringproject.JtSpringProject.models.User;
import com.jtspringproject.JtSpringProject.services.categoryService;
import com.jtspringproject.JtSpringProject.services.productService;
import com.jtspringproject.JtSpringProject.services.userService;

@Controller
@RequestMapping("/admin")
public class AdminController {

	private final userService userService;
	private final categoryService categoryService;
	private final productService productService;

	@Autowired
	public AdminController(userService userService, categoryService categoryService, productService productService) {
		this.userService = userService;
		this.categoryService = categoryService;
		this.productService = productService;
	}
	
	@GetMapping("/index")
	public String index(Model model) {
		String username = SecurityContextHolder.getContext().getAuthentication().getName();
		model.addAttribute("username", username);
		return "index";			
	}
	
	@GetMapping("login")
	public ModelAndView adminlogin(@RequestParam(required = false) String error) {
	    ModelAndView mv = new ModelAndView("admin");
	    if ("true".equals(error)) {
	        mv.addObject("msg", "Invalid username or password. Please try again.");
	    }
	    return mv;
	}
	
	@GetMapping( value={"/","Dashboard"})
	public ModelAndView adminHome(Model model) {
		Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
	    ModelAndView mv = new ModelAndView("adminHome");
	    mv.addObject("admin", authentication.getName());
	    return mv;
	}
	
	@GetMapping("categories")
	public ModelAndView getcategory() {
		ModelAndView mView = new ModelAndView("categories");
		List<Category> categories = this.categoryService.getCategories();
		mView.addObject("categories", categories);
		return mView;
	}
	
	@PostMapping("/categories")
	public ModelAndView addCategory(@RequestParam("categoryname") String category_name) {
		ModelAndView mView = new ModelAndView("redirect:/admin/categories");
		
		try {
			// Validate input
			if (category_name == null || category_name.trim().isEmpty()) {
				mView.addObject("msg", "Category name cannot be empty");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			String trimmedName = category_name.trim();
			if (trimmedName.length() < 2) {
				mView.addObject("msg", "Category name must be at least 2 characters long");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Try to add the category
			try {
				Category category = this.categoryService.addCategory(trimmedName);
				if (category != null && category.getId() > 0) {
					mView.addObject("msg", "Category '" + trimmedName + "' added successfully");
					mView.addObject("msgType", "success");
				} else {
					mView.addObject("msg", "Failed to add category");
					mView.addObject("msgType", "danger");
				}
			} catch (Exception ex) {
				if (ex.getMessage().contains("already exists")) {
					mView.addObject("msg", "A category with this name already exists");
				} else {
					mView.addObject("msg", "Error adding category: " + ex.getMessage());
				}
				mView.addObject("msgType", "danger");
			}
		} catch (Exception e) {
			mView.addObject("msg", "Error adding category: " + e.getMessage());
			mView.addObject("msgType", "danger");
		}
		
		return mView;
	}
	
	@PostMapping("/categories/delete")
	public ModelAndView removeCategoryDb(@RequestParam("id") int id) {
		ModelAndView mView = new ModelAndView("redirect:/admin/categories");
		
		try {
			// Check if category exists
			Category category = null;
			try {
				category = this.categoryService.getCategory(id);
			} catch (Exception ex) {
				mView.addObject("msg", "Category not found");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Get count of products before deletion
			List<Product> products = this.productService.getProductsByCategory(id);
			int productCount = products != null ? products.size() : 0;
			
			// Attempt to delete
			boolean deleted = this.categoryService.deleteCategory(id);
			if (deleted) {
				String msg = String.format("Category '%s' deleted successfully", category.getName());
				if (productCount > 0) {
					msg += String.format(" along with %d associated product%s", 
						productCount, productCount == 1 ? "" : "s");
				}
				mView.addObject("msg", msg);
				mView.addObject("msgType", "success");
			} else {
				mView.addObject("msg", "Failed to delete category");
				mView.addObject("msgType", "danger");
			}
		} catch (Exception e) {
			mView.addObject("msg", "Error deleting category: " + e.getMessage());
			mView.addObject("msgType", "danger");
		}
		
		return mView;
	}
	
	@PostMapping("/categories/update")
	public ModelAndView updateCategory(@RequestParam("categoryid") int id, @RequestParam("categoryname") String categoryName) {
		ModelAndView mView = new ModelAndView("redirect:/admin/categories");
		
		try {
			// Basic validation
			if (categoryName == null || categoryName.trim().isEmpty()) {
				mView.addObject("msg", "Category name cannot be empty");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			String trimmedName = categoryName.trim();
			if (trimmedName.length() < 2) {
				mView.addObject("msg", "Category name must be at least 2 characters long");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Check that category exists
			try {
				Category existingCategory = this.categoryService.getCategory(id);
			} catch (Exception ex) {
				mView.addObject("msg", "Category not found");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Try to update
			try {
				Category category = this.categoryService.updateCategory(id, trimmedName);
				if (category != null) {
					mView.addObject("msg", "Category updated successfully");
					mView.addObject("msgType", "success");
				} else {
					mView.addObject("msg", "Failed to update category");
					mView.addObject("msgType", "danger");
				}
			} catch (Exception ex) {
				if (ex.getMessage().contains("already exists")) {
					mView.addObject("msg", "A category with this name already exists");
				} else {
					mView.addObject("msg", "Error updating category: " + ex.getMessage());
				}
				mView.addObject("msgType", "danger");
			}
		} catch (Exception e) {
			mView.addObject("msg", "Error updating category: " + e.getMessage());
			mView.addObject("msgType", "danger");
		}
		
		return mView;
	}

	
//	 --------------------------Remaining --------------------
	@GetMapping("products")
	public ModelAndView getproduct() {
		ModelAndView mView = new ModelAndView("products");

		List<Product> products = this.productService.getProducts();
		
		if (products.isEmpty()) {
			mView.addObject("msg", "No products are available");
		} else {
			mView.addObject("products", products);
		}
		return mView;
	}
	
	@GetMapping("products/add")
	public ModelAndView addProduct() {
		ModelAndView mView = new ModelAndView("productsAdd");
		List<Category> categories = this.categoryService.getCategories();
		mView.addObject("categories",categories);
		return mView;
	}

	@RequestMapping(value = "products/add", method=RequestMethod.POST)
	public String addProduct(@RequestParam("name") String name,
							@RequestParam("categoryid") int categoryId,
							@RequestParam("price") int price,
							@RequestParam("weight") int weight,
							@RequestParam("quantity") int quantity,
							@RequestParam("description") String description,
							@RequestParam("productImage") String productImage) {
		try {
			// Get the category by ID
			Category category = this.categoryService.getCategory(categoryId);
			
			// Create a new product object
			Product product = new Product();
			// Do NOT set ID manually - let Hibernate auto-generate it
			product.setName(name);
			product.setCategory(category);
			product.setDescription(description);
			product.setPrice(price);
			product.setImage(productImage);
			product.setWeight(weight);
			product.setQuantity(quantity);
			
			// Save the product
			this.productService.addProduct(product);
			return "redirect:/admin/products";
		} catch (Exception e) {
			System.out.println("Error adding product: " + e.getMessage());
			return "redirect:/admin/products?error=true";
		}
	}

	@GetMapping("products/update/{id}")
	public ModelAndView updateproduct(@PathVariable("id") int id) {
		
		ModelAndView mView = new ModelAndView("productsUpdate");
		Product product = this.productService.getProduct(id);
		List<Category> categories = this.categoryService.getCategories();

		mView.addObject("categories",categories);
		mView.addObject("product", product);
		return mView;
	}
	
	@RequestMapping(value = "products/update/{id}",method=RequestMethod.POST)
	public ModelAndView updateProduct(@PathVariable("id") int id,
								  @RequestParam("name") String name,
								  @RequestParam("categoryid") int categoryId,
								  @RequestParam("price") int price,
								  @RequestParam("weight") int weight,
								  @RequestParam("quantity") int quantity,
								  @RequestParam("description") String description,
								  @RequestParam("productImage") String productImage)
	{
		ModelAndView mView = new ModelAndView("redirect:/admin/products");
		
		try {
			// Input validation
			if (name == null || name.trim().isEmpty()) {
				mView.addObject("msg", "Product name cannot be empty");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			if (description == null || description.trim().isEmpty()) {
				mView.addObject("msg", "Product description cannot be empty");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			if (price <= 0) {
				mView.addObject("msg", "Price must be greater than 0");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			if (weight <= 0) {
				mView.addObject("msg", "Weight must be greater than 0");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			if (quantity < 0) {
				mView.addObject("msg", "Quantity cannot be negative");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Get category
			Category category = this.categoryService.getCategory(categoryId);
			if (category == null) {
				mView.addObject("msg", "Selected category does not exist");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Get and update product
			Product product = this.productService.getProduct(id);
			if (product == null) {
				mView.addObject("msg", "Product not found");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			product.setName(name.trim());
			product.setCategory(category);
			product.setDescription(description.trim());
			product.setPrice(price);
			product.setImage(productImage);
			product.setWeight(weight);
			product.setQuantity(quantity);
			
			Product updatedProduct = this.productService.updateProduct(id, product);
			if (updatedProduct != null) {
				mView.addObject("msg", "Product updated successfully");
				mView.addObject("msgType", "success");
			} else {
				mView.addObject("msg", "Failed to update product");
				mView.addObject("msgType", "danger");
			}
		} catch (Exception e) {
			mView.addObject("msg", "Error updating product: " + e.getMessage());
			mView.addObject("msgType", "danger");
		}
		
		return mView;
	}
	
	@PostMapping("products/delete")
	public ModelAndView removeProduct(@RequestParam("id") int id) {
		ModelAndView mView = new ModelAndView("redirect:/admin/products");
		
		try {
			// Check if product exists
			Product product = this.productService.getProduct(id);
			if (product == null) {
				mView.addObject("msg", "Product not found");
				mView.addObject("msgType", "danger");
				return mView;
			}
			
			// Attempt to delete
			if (this.productService.deleteProduct(id)) {
				mView.addObject("msg", "Product '" + product.getName() + "' deleted successfully");
				mView.addObject("msgType", "success");
			} else {
				mView.addObject("msg", "Failed to delete product");
				mView.addObject("msgType", "danger");
			}
		} catch (Exception e) {
			mView.addObject("msg", "Error deleting product: " + e.getMessage());
			mView.addObject("msgType", "danger");
		}
		
		return mView;
	}
	
	@PostMapping("products")
	public String postproduct() {
		return "redirect:/admin/categories";
	}
	
	@GetMapping("customers")
	public ModelAndView getCustomerDetail() {
		ModelAndView mView = new ModelAndView("displayCustomers");
		List<User> users = this.userService.getUsers();
		mView.addObject("customers", users);
		return mView;
	}
	
	
	@GetMapping("profileDisplay")
	public String profileDisplay(Model model) {
		String displayusername,displaypassword,displayemail,displayaddress;
		try
		{
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommjava","root","");
			PreparedStatement stmt = con.prepareStatement("select * from users where username = ?"+";");
			
			String username = SecurityContextHolder.getContext().getAuthentication().getName();
			stmt.setString(1, username);
			
			ResultSet rst = stmt.executeQuery();
			
			if(rst.next())
			{
			int userid = rst.getInt(1);
			displayusername = rst.getString(2);
			displayemail = rst.getString(3);
			displaypassword = rst.getString(4);
			displayaddress = rst.getString(5);
			model.addAttribute("userid",userid);
			model.addAttribute("username",displayusername);
			model.addAttribute("email",displayemail);
			model.addAttribute("password",displaypassword);
			model.addAttribute("address",displayaddress);
			}
		}
		catch(Exception e)
		{
			System.out.println("Exception:"+e);
		}
		System.out.println("Hello");
		return "updateProfile";
	}
	
	@RequestMapping(value = "updateuser",method=RequestMethod.POST)
	public String updateUserProfile(@RequestParam("userid") int userid,@RequestParam("username") String username, @RequestParam("email") String email, @RequestParam("password") String password, @RequestParam("address") String address) 
	
	{
		try
		{
			Class.forName("com.mysql.jdbc.Driver");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/ecommjava","root","");
			
			PreparedStatement pst = con.prepareStatement("update users set username= ?,email = ?,password= ?, address= ? where uid = ?;");
			pst.setString(1, username);
			pst.setString(2, email);
			pst.setString(3, password);
			pst.setString(4, address);
			pst.setInt(5, userid);
			int i = pst.executeUpdate();	
			
			Authentication newAuthentication = new UsernamePasswordAuthenticationToken(
		            username,
		            password,
		            SecurityContextHolder.getContext().getAuthentication().getAuthorities());

		    SecurityContextHolder.getContext().setAuthentication(newAuthentication);
		}
		catch(Exception e)
		{
			System.out.println("Exception:"+e);
		}
		return "redirect:index";
	}

}
