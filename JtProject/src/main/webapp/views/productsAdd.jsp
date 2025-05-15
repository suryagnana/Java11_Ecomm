<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>

<%@page import="java.sql.*"%>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
<meta charset="UTF-8">
<meta name="viewport"
	content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<link rel="stylesheet"
	href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css"
	integrity="sha384-Vkoo8x4CGsO3+Hhxv8T/Q5PaXtkKtu6ug5TOeNV6gBiFeWPGFN9MuhOf23Q9Ifjh"
	crossorigin="anonymous">
<link rel="stylesheet"
	href="https://use.fontawesome.com/releases/v5.7.0/css/all.css"
	integrity="sha384-lZN37f5QGtY3VHgisS14W3ExzMWZxybE1SJSEsQp9S+oqd12jhcu+A56Ebc1zFSJ"
	crossorigin="anonymous">
<title>Add Product</title>
</head>
<body>
	<nav class="navbar navbar-expand-lg navbar-dark bg-dark">
		<div class="container-fluid">
			<a class="navbar-brand" href="#"> <img
				th:src="@{/images/logo.png}" src="../static/images/logo.png"
				width="auto" height="40" class="d-inline-block align-top" alt="" />
			</a>
			<button class="navbar-toggler" type="button" data-toggle="collapse"
				data-target="#navbarSupportedContent"
				aria-controls="navbarSupportedContent" aria-expanded="false"
				aria-label="Toggle navigation">
				<span class="navbar-toggler-icon"></span>
			</button>

			<div class="collapse navbar-collapse" id="navbarSupportedContent">
				<ul class="navbar-nav mr-auto"></ul>
				<ul class="navbar-nav">
					<li class="nav-item active"><a class="nav-link"
						href="/admin/" >Home Page</a></li>
					<li class="nav-item active"><a class="nav-link"
						href="/admin/logout" >Logout</a></li>
				</ul>
			</div>
		</div>
	</nav>
	
	<div class="container mt-5">
		<h3 class="mb-4">Add a new Product</h3>
		<form action="/admin/products/add" method="post" class="needs-validation" novalidate>
			<div class="row">
				<div class="col-md-6">
					<div class="form-group">
						<label for="name">Product Name</label> 
						<input type="text" class="form-control" id="name" name="name" required placeholder="Enter product name">
						<div class="invalid-feedback">Please provide a product name.</div>
					</div>
					
					<div class="form-group">
						<label for="categoryid">Category</label> 
						<select class="form-control" id="categoryid" name="categoryid" required>
							<option value="">Select a Category</option>
							<c:forEach var="category" items="${categories}">
								<option value="${category.id}">${category.name}</option>
							</c:forEach>
						</select>
						<div class="invalid-feedback">Please select a category.</div>
					</div>
					
					<div class="form-group">
						<label for="price">Price</label> 
						<input type="number" class="form-control" id="price" name="price" required min="1" placeholder="Enter price">
						<div class="invalid-feedback">Please provide a valid price (minimum 1).</div>
					</div>
					
					<div class="form-group">
						<label for="weight">Weight (in grams)</label> 
						<input type="number" class="form-control" id="weight" name="weight" required min="1" placeholder="Enter weight">
						<div class="invalid-feedback">Please provide a valid weight (minimum 1g).</div>
					</div>
				</div>
				
				<div class="col-md-6">
					<div class="form-group">
						<label for="quantity">Available Quantity</label> 
						<input type="number" class="form-control" id="quantity" name="quantity" required min="1" placeholder="Enter quantity">
						<div class="invalid-feedback">Please provide a valid quantity (minimum 1).</div>
					</div>
					
					<div class="form-group">
						<label for="description">Product Description</label>
						<textarea class="form-control" id="description" name="description" rows="4" required placeholder="Enter product description"></textarea>
						<div class="invalid-feedback">Please provide a product description.</div>
					</div>
					
					<div class="form-group">
						<label for="productImage">Product Image URL</label>
						<input type="url" class="form-control" id="productImage" name="productImage" required placeholder="Enter image URL">
						<div class="invalid-feedback">Please provide a valid image URL.</div>
					</div>
					
					<div class="form-group">
						<img id="imgPreview" src="#" alt="Product preview" class="img-thumbnail mt-2" style="max-width: 200px; display: none;">
					</div>
				</div>
			</div>
			
			<div class="row mt-4">
				<div class="col-12">
					<button type="submit" class="btn btn-primary">Add Product</button>
					<a href="/admin/products" class="btn btn-secondary ml-2">Cancel</a>
				</div>
			</div>
		</form>
	</div>

	<script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"
		integrity="sha384-J6qa4849blE2+poT4WnyKhv5vZF5SrPo0iEjwBvKU7imGFAV0wwj1yYfoRSJoZ+n"
		crossorigin="anonymous"></script>
	<script
		src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"
		integrity="sha384-Q6E9RHvbIyZFJoft+2mJbHaEWldlvI9IOYy5n3zV9zzTtmI3UksdQRVvoxMfooAo"
		crossorigin="anonymous"></script>
	<script
		src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"
		integrity="sha384-wfSDF2E50Y2D1uUdj0O3uMBJnjuUD4Ih7YwaYd1iqfktj0Uod8GCExl3Og8ifwB6"
		crossorigin="anonymous"></script>
	<script>
	// Image preview
	document.getElementById('productImage').addEventListener('change', function() {
		const imgPreview = document.getElementById('imgPreview');
		if (this.value) {
			imgPreview.src = this.value;
			imgPreview.style.display = 'block';
		} else {
			imgPreview.style.display = 'none';
		}
	});

	// Form validation
	(function() {
		'use strict';
		window.addEventListener('load', function() {
			var forms = document.getElementsByClassName('needs-validation');
			Array.prototype.filter.call(forms, function(form) {
				form.addEventListener('submit', function(event) {
					if (form.checkValidity() === false) {
						event.preventDefault();
						event.stopPropagation();
					}
					form.classList.add('was-validated');
				}, false);
			});
		}, false);
	})();
	</script>
</body>
</html>