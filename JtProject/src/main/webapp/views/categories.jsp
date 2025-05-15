<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>

<!doctype html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
    <title>Categories Management</title>
    <style>
        .modal-body input:focus {
            border-color: #80bdff;
            box-shadow: 0 0 0 0.2rem rgba(0,123,255,.25);
        }
        .table td {
            vertical-align: middle;
        }
        .update-form {
            display: flex;
            gap: 10px;
        }
        .update-form input[type="text"] {
            max-width: 200px;
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
                    <li class="nav-item active">
                        <a class="nav-link" href="/admin/"><i class="fas fa-home"></i> Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/admin/logout"><i class="fas fa-sign-out-alt"></i> Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-4">
        <div class="row mb-4">
            <div class="col">
                <h2><i class="fas fa-tags"></i> Categories</h2>
            </div>
            <div class="col text-right">
                <button type="button" class="btn btn-primary" data-toggle="modal" data-target="#addCategoryModal">
                    <i class="fas fa-plus"></i> Add Category
                </button>
            </div>
        </div>

        <c:if test="${not empty msg}">
            <div class="alert alert-${msgType} alert-dismissible fade show" role="alert">
                ${msg}
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div>
        </c:if>

        <!-- Add Category Modal -->
        <div class="modal fade" id="addCategoryModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title">
                            <i class="fas fa-plus-circle"></i> Add New Category
                        </h5>
                        <button type="button" class="close" data-dismiss="modal">&times;</button>
                    </div>
                    <div class="modal-body">
                        <form action="/admin/categories" method="post" class="needs-validation" novalidate>
                            <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                            <div class="form-group">
                                <label for="categoryname">Category Name</label>
                                <input type="text" name="categoryname" id="categoryname" 
                                       class="form-control" required minlength="2"
                                       placeholder="Enter category name"
                                       pattern="^[a-zA-Z0-9\s-]+$">
                                <div class="invalid-feedback">
                                    Please enter a valid category name (minimum 2 characters, only letters, numbers, spaces and hyphens allowed).
                                </div>
                            </div>
                            <div class="modal-footer">
                                <button type="button" class="btn btn-secondary" data-dismiss="modal">Close</button>
                                <button type="submit" class="btn btn-primary">Add Category</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>

        <!-- Update Category Modal -->
        <div class="modal fade" id="updateCategoryModal" tabindex="-1" role="dialog">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <form action="/admin/categories/update" method="post" id="updateCategoryForm" class="needs-validation" novalidate>
                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                        <input type="hidden" name="categoryid" id="updateCategoryId">
                        <div class="modal-header">
                            <h5 class="modal-title">
                                <i class="fas fa-edit"></i> Update Category
                            </h5>
                            <button type="button" class="close" data-dismiss="modal">&times;</button>
                        </div>
                        <div class="modal-body">
                            <div class="form-group">
                                <label for="updateCategoryName">Category Name</label>
                                <input type="text" name="categoryname" id="updateCategoryName" 
                                       class="form-control" required minlength="2"
                                       placeholder="Enter category name">
                                <div class="invalid-feedback">
                                    Please enter a valid category name (minimum 2 characters).
                                </div>
                            </div>
                        </div>
                        <div class="modal-footer">
                            <button type="button" class="btn btn-secondary" data-dismiss="modal">
                                <i class="fas fa-times"></i> Cancel
                            </button>
                            <button type="submit" class="btn btn-warning">
                                <i class="fas fa-save"></i> Update Category
                            </button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- Categories Table -->
        <div class="table-responsive">
            <table class="table table-hover">
                <thead class="thead-dark">
                    <tr>
                        <th scope="col">#</th>
                        <th scope="col">Category Name</th>
                        <th scope="col" class="text-center">Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="category" items="${categories}">
                        <tr>
                            <td>${category.id}</td>
                            <td>${category.name}</td>
                            <td class="text-center">
                                <div class="btn-group" role="group">
                                    <button type="button" class="btn btn-warning btn-sm mr-2" 
                                            onclick="showUpdateModal(${category.id}, '${category.name}')">
                                        <i class="fas fa-edit"></i> Update
                                    </button>
                                    <form action="/admin/categories/delete" method="post" class="delete-form" 
                                          onsubmit="return confirm('Warning: Deleting category \'${category.name}\' will also delete all products in this category.\n\nThis action cannot be undone. Are you sure you want to proceed?');">
                                        <input type="hidden" name="id" value="${category.id}">
                                        <input type="hidden" name="${_csrf.parameterName}" value="${_csrf.token}"/>
                                        <button type="submit" class="btn btn-danger btn-sm">
                                            <i class="fas fa-trash"></i> Delete
                                        </button>
                                    </form>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <script src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
    
    <script>
        $(document).ready(function() {
            // Form validation
            $('.needs-validation').on('submit', function(e) {
                if (!this.checkValidity()) {
                    e.preventDefault();
                    e.stopPropagation();
                }
                $(this).addClass('was-validated');
            });

            // Auto-hide alerts after 5 seconds
            $('.alert').delay(5000).fadeOut('slow');

            // Initialize tooltips
            $('[data-toggle="tooltip"]').tooltip();
        });

        function showUpdateModal(categoryId, categoryName) {
            $('#updateCategoryId').val(categoryId);
            $('#updateCategoryName').val(categoryName);
            $('#updateCategoryModal').modal('show');
        }

        function confirmDelete(categoryId, categoryName) {
            return confirm('Warning: Are you sure you want to delete the category "' + categoryName + '"?\n\nThis action cannot be undone and may affect related products.');
        }
    </script>
</body>
</html>