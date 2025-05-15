package com.jtspringproject.JtSpringProject.services;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.jtspringproject.JtSpringProject.dao.categoryDao;
import com.jtspringproject.JtSpringProject.models.Category;

import net.bytebuddy.dynamic.DynamicType.Builder.InnerTypeDefinition;

@Service
public class categoryService {
	@Autowired
	private categoryDao categoryDao;
	
	public Category addCategory(String name) {
		try {
			return this.categoryDao.addCategory(name);
		} catch (Exception e) {
			throw new RuntimeException("Failed to add category: " + e.getMessage(), e);
		}
	}
	
	public List<Category> getCategories(){
		try {
			return this.categoryDao.getCategories();
		} catch (Exception e) {
			throw new RuntimeException("Failed to retrieve categories: " + e.getMessage(), e);
		}
	}
	
	public Boolean deleteCategory(int id) {
		try {
			return this.categoryDao.deletCategory(id);
		} catch (Exception e) {
			throw new RuntimeException("Failed to delete category: " + e.getMessage(), e);
		}
	}
	
	public Category updateCategory(int id, String name) {
		try {
			return this.categoryDao.updateCategory(id, name);
		} catch (Exception e) {
			throw new RuntimeException("Failed to update category: " + e.getMessage(), e);
		}
	}

	public Category getCategory(int id) {
		try {
			Category category = this.categoryDao.getCategory(id);
			if (category == null) {
				throw new RuntimeException("Category not found with ID: " + id);
			}
			return category;
		} catch (Exception e) {
			throw new RuntimeException("Failed to retrieve category: " + e.getMessage(), e);
		}
	}
}
