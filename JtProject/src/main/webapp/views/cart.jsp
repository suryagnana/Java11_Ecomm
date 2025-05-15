<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en" xmlns:th="http://www.thymeleaf.org">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Shopping Cart</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.7.0/css/all.css">
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container-fluid">
            <a class="navbar-brand" href="/">
                <img src="../static/images/logo.png" width="auto" height="40" class="d-inline-block align-top" alt=""/>
            </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarSupportedContent"
                    aria-controls="navbarSupportedContent" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>

            <div class="collapse navbar-collapse" id="navbarSupportedContent">
                <ul class="navbar-nav mr-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/">Home</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" href="/user/products">Products</a>
                    </li>
                    <li class="nav-item active">
                        <a class="nav-link" href="/cart">Cart</a>
                    </li>
                </ul>
                <ul class="navbar-nav ml-auto">
                    <li class="nav-item">
                        <a class="nav-link" href="/logout">Logout</a>
                    </li>
                </ul>
            </div>
        </div>
    </nav>

    <div class="container mt-5">
        <h2>Your Shopping Cart</h2>

        <c:if test="${not empty msg}">
            <div class="alert alert-${msgType} alert-dismissible fade show" role="alert">
                ${msg}
                <button type="button" class="close" data-dismiss="alert">&times;</button>
            </div>
            <script>
                setTimeout(function() {
                    $('.alert').alert('close');
                }, 5000);
            </script>
        </c:if>

        <c:choose>
            <c:when test="${empty cartProducts}">
                <div class="alert alert-info">
                    Your cart is empty. <a href="/user/products" class="alert-link">Continue shopping</a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="table-responsive">
                    <table class="table table-striped">
                        <thead>
                            <tr>
                                <th>Product</th>
                                <th>Image</th>
                                <th>Category</th>
                                <th>Quantity</th>
                                <th>Price</th>
                                <th>Total</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="cartProduct" items="${cartProducts}">
                                <tr>
                                    <td>${cartProduct.product.name}</td>
                                    <td>
                                        <img src="${cartProduct.product.image}" alt="${cartProduct.product.name}" style="max-width: 50px;">
                                    </td>
                                    <td>${cartProduct.product.category.name}</td>
                                    <td>
                                        <form action="/cart/update" method="post" class="form-inline">
                                            <input type="hidden" name="productId" value="${cartProduct.product.id}">
                                            <input type="number" name="quantity" value="${cartProduct.quantity}" 
                                                   min="1" class="form-control form-control-sm" style="width: 70px;">
                                            <button type="submit" class="btn btn-sm btn-secondary ml-2">
                                                <i class="fas fa-sync"></i>
                                            </button>
                                        </form>
                                    </td>
                                    <td>$${cartProduct.product.price}</td>
                                    <td>$${cartProduct.product.price * cartProduct.quantity}</td>
                                    <td>
                                        <form action="/cart/remove" method="get" style="display: inline;">
                                            <input type="hidden" name="id" value="${cartProduct.id}">
                                            <button type="submit" class="btn btn-danger btn-sm">
                                                <i class="fas fa-trash"></i> Remove
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                        <tfoot>
                            <tr>
                                <td colspan="5" class="text-right"><strong>Total:</strong></td>
                                <td>
                                    <strong>$
                                        <c:set var="total" value="0"/>
                                        <c:forEach var="cartProduct" items="${cartProducts}">
                                            <c:set var="total" value="${total + (cartProduct.product.price * cartProduct.quantity)}"/>
                                        </c:forEach>
                                        ${total}
                                    </strong>
                                </td>
                                <td></td>
                            </tr>
                        </tfoot>
                    </table>
                </div>

                <div class="row mt-4">
                    <div class="col-md-6">
                        <a href="/user/products" class="btn btn-secondary">
                            <i class="fas fa-arrow-left"></i> Continue Shopping
                        </a>
                    </div>
                    <div class="col-md-6 text-right">
                        <a href="/checkout" class="btn btn-success">
                            <i class="fas fa-shopping-cart"></i> Proceed to Checkout
                        </a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </div>

    <script src="https://code.jquery.com/jquery-3.4.1.slim.min.js"></script>
    <script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.0/dist/umd/popper.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.4.1/js/bootstrap.min.js"></script>
</body>
</html> 