<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!doctype html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title>Update Product - Admin Panel</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <style>
        .form-group label {
            font-weight: 500;
        }
        .preview-image {
            max-width: 200px;
            max-height: 200px;
            object-fit: contain;
        }
        .custom-file-label::after {
            content: "Browse";
        }
        .was-validated .form-control:invalid {
            border-color: #dc3545;
            padding-right: calc(1.5em + .75rem);
            background-image: url("data:image/svg+xml,%3csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='none' stroke='%23dc3545' viewBox='0 0 12 12'%3e%3ccircle cx='6' cy='6' r='4.5'/%3e%3cpath stroke-linejoin='round' d='M5.8 3.6h.4L6 6.5z'/%3e%3ccircle cx='6' cy='8.2' r='.6' fill='%23dc3545' stroke='none'/%3e%3c/svg%3e");
            background-repeat: no-repeat;
            background-position: right calc(.375em + .1875rem) center;
            background-size: calc(.75em + .375rem) calc(.75em + .375rem);
        }
    </style>
</head>
<body class="bg-light">
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <a class="navbar-brand" href="/admin/">
                <i class="fas fa-shopping-cart"></i> Admin Panel
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/admin/products">
                            <i class="fas fa-list"></i> Products List
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/admin/">
                            <i class="fas fa-home"></i> Home
                        </a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/admin/logout">
                            <i class="fas fa-sign-out-alt"></i> Logout
                        </a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <h2><i class="fas fa-edit"></i> Update Product</h2>
                <p class="text-muted">Update the product information below</p>
            </div>
        </div>

        <div class="row">
            <div class="col-md-8">
                <div class="card">
                    <div class="card-body">
                        <form action="/admin/products/update/${product.id}" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="id" value="${product.id}">
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            
                            <div class="form-row">
                                <div class="form-group col-md-6">
                                    <label for="name">Product Name</label>
                                    <input type="text" class="form-control" id="name" name="name" 
                                           value="${product.name}" required minlength="3"
                                           placeholder="Enter product name">
                                    <div class="invalid-feedback">
                                        Please provide a valid product name (minimum 3 characters).
                                    </div>
                                </div>
                                
                                <div class="form-group col-md-6">
                                    <label for="categoryid">Category</label>
                                    <select class="form-control" id="categoryid" name="categoryid" required>
                                        <option value="">Select a Category</option>
                                        <c:forEach var="category" items="${categories}">
                                            <option value="${category.id}" ${product.category.id == category.id ? 'selected' : ''}>
                                                ${category.name}
                                            </option>
                                        </c:forEach>
                                    </select>
                                    <div class="invalid-feedback">
                                        Please select a category.
                                    </div>
                                </div>
                            </div>

                            <div class="form-row">
                                <div class="form-group col-md-4">
                                    <label for="price">Price ($)</label>
                                    <input type="number" class="form-control" id="price" name="price"
                                           value="${product.price}" required min="0.01" step="0.01"
                                           placeholder="Enter price">
                                    <div class="invalid-feedback">
                                        Please provide a valid price (minimum $0.01).
                                    </div>
                                </div>
                                
                                <div class="form-group col-md-4">
                                    <label for="weight">Weight (grams)</label>
                                    <input type="number" class="form-control" id="weight" name="weight"
                                           value="${product.weight}" required min="1"
                                           placeholder="Enter weight">
                                    <div class="invalid-feedback">
                                        Please provide a valid weight (minimum 1g).
                                    </div>
                                </div>
                                
                                <div class="form-group col-md-4">
                                    <label for="quantity">Available Quantity</label>
                                    <input type="number" class="form-control" id="quantity" name="quantity"
                                           value="${product.quantity}" required min="0"
                                           placeholder="Enter quantity">
                                    <div class="invalid-feedback">
                                        Please provide a valid quantity (minimum 0).
                                    </div>
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="description">Product Description</label>
                                <textarea class="form-control" id="description" name="description"
                                          rows="4" required minlength="10"
                                          placeholder="Enter product description">${product.description}</textarea>
                                <div class="invalid-feedback">
                                    Please provide a product description (minimum 10 characters).
                                </div>
                            </div>

                            <div class="form-group">
                                <label for="productImage">Product Image URL</label>
                                <input type="url" class="form-control" id="productImage" name="productImage"
                                       value="${product.image}" required
                                       placeholder="Enter image URL">
                                <div class="invalid-feedback">
                                    Please provide a valid image URL.
                                </div>
                            </div>

                            <div class="form-group">
                                <label>Current Image Preview</label><br>
                                <img src="${product.image}" alt="Product preview" class="preview-image border rounded" 
                                     onerror="this.src='https://via.placeholder.com/200x200?text=No+Image';">
                            </div>

                            <div class="form-group mt-4">
                                <div class="btn-group" role="group">
                                    <button type="submit" class="btn btn-success">
                                        <i class="fas fa-save"></i> Save Changes
                                    </button>
                                    <a href="/admin/products" class="btn btn-light border">
                                        <i class="fas fa-times"></i> Cancel
                                    </a>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>

            <div class="col-md-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Product Information</h5>
                        <p class="card-text">
                            <strong>Product ID:</strong> ${product.id}<br>
                            <strong>Current Category:</strong> ${product.category.name}<br>
                            <strong>Current Stock:</strong> ${product.quantity} units<br>
                            <strong>Current Price:</strong> $${product.price}
                        </p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    
    <script>
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

        // Image URL preview
        document.getElementById('productImage').addEventListener('change', function() {
            const previewImg = document.querySelector('.preview-image');
            if (this.value) {
                previewImg.src = this.value;
            }
        });
    })();
    </script>
</body>
</html>