package com.jtspringproject.JtSpringProject.dao;

import java.util.List;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.jtspringproject.JtSpringProject.models.Category;
import com.jtspringproject.JtSpringProject.models.Product;

@Repository
public class categoryDao {
	@Autowired
	private SessionFactory sessionFactory;

	public void setSessionFactory(SessionFactory sf) {
		this.sessionFactory = sf;
	}

	@Transactional
	public Category addCategory(String name) {
		try {
			if (name == null || name.trim().isEmpty()) {
				throw new IllegalArgumentException("Category name cannot be empty");
			}
			
			String trimmedName = name.trim();
			if (trimmedName.length() < 2) {
				throw new IllegalArgumentException("Category name must be at least 2 characters long");
			}
			
			Session session = this.sessionFactory.getCurrentSession();
			
			// Check for duplicate name
			Long count = session.createQuery(
				"SELECT COUNT(c) FROM CATEGORY c WHERE LOWER(c.name) = :name", Long.class)
				.setParameter("name", trimmedName.toLowerCase())
				.uniqueResult();
				
			if (count > 0) {
				throw new IllegalStateException("A category with this name already exists");
			}
			
			Category category = new Category();
			// Do not set ID - let the database handle it with auto-increment
			category.setName(trimmedName);
			
			// Use persist instead of save to better handle identity column
			session.persist(category);
			session.flush(); // Force execution of the insert statement
			
			return category;
		} catch (Exception e) {
			throw new RuntimeException("Error adding category: " + e.getMessage(), e);
		}
	}

	@Transactional
	public List<Category> getCategories() {
		try {
			Session session = this.sessionFactory.getCurrentSession();
			return session.createQuery("from CATEGORY", Category.class).list();
		} catch (Exception e) {
			throw new RuntimeException("Error retrieving categories: " + e.getMessage(), e);
		}
	}

	@Transactional
	public Boolean deletCategory(int id) {
		try {
			Session session = this.sessionFactory.getCurrentSession();
			Category category = session.get(Category.class, id);
			
			if (category != null) {
				// Check if any products exist with this category
				List<Product> products = session.createQuery("FROM PRODUCT WHERE category.id = :categoryId", Product.class)
					.setParameter("categoryId", id)
					.list();
				
				// Delete all products associated with this category first
				if (!products.isEmpty()) {
					session.createQuery("DELETE FROM PRODUCT WHERE category.id = :categoryId")
						.setParameter("categoryId", id)
						.executeUpdate();
				}
				
				// Then delete the category
				session.delete(category);
				return true;
			}
			return false;
		} catch (Exception e) {
			throw new RuntimeException("Error deleting category: " + e.getMessage(), e);
		}
	}

	@Transactional
	public Category updateCategory(int id, String name) {
		try {
			if (name == null || name.trim().isEmpty()) {
				throw new IllegalArgumentException("Category name cannot be empty");
			}
			
			String trimmedName = name.trim();
			if (trimmedName.length() < 2) {
				throw new IllegalArgumentException("Category name must be at least 2 characters long");
			}
			
			Session session = this.sessionFactory.getCurrentSession();
			Category category = session.get(Category.class, id);
			
			if (category == null) {
				throw new IllegalArgumentException("Category not found with ID: " + id);
			}
			
			// Check for duplicate name, but exclude current category
			Long count = session.createQuery(
				"SELECT COUNT(c) FROM CATEGORY c WHERE LOWER(c.name) = :name AND c.id != :id", Long.class)
				.setParameter("name", trimmedName.toLowerCase())
				.setParameter("id", id)
				.uniqueResult();
				
			if (count > 0) {
				throw new IllegalStateException("A category with this name already exists");
			}
			
			category.setName(trimmedName);
			session.update(category);
			return category;
		} catch (Exception e) {
			throw new RuntimeException("Error updating category: " + e.getMessage(), e);
		}
	}

	@Transactional
	public Category getCategory(int id) {
		try {
			Session session = this.sessionFactory.getCurrentSession();
			Category category = session.get(Category.class, id);
			// Don't throw exception, just return null and let service layer handle it
			return category;
		} catch (Exception e) {
			throw new RuntimeException("Error retrieving category: " + e.getMessage(), e);
		}
	}
}
