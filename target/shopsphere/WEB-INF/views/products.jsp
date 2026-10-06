<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ page import="com.shopsphere.model.User" %>
<% User u = (User) session.getAttribute("loggedInUser"); %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Store Catalog — ShopSphere</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <style>
        .filter-bar {
            background: var(--surface-card);
            border: 1px solid var(--surface-border);
            border-radius: var(--radius-lg);
            padding: 1.2rem 1.6rem;
            margin-bottom: 2.5rem;
            display: flex;
            align-items: center;
            justify-content: space-between;
            gap: 1.2rem;
            flex-wrap: wrap;
            backdrop-filter: blur(12px);
        }
        .filter-form {
            display: flex;
            align-items: center;
            gap: 0.8rem;
            flex: 1;
            flex-wrap: wrap;
        }
        .filter-form input {
            max-width: 320px;
        }
        .filter-form select {
            max-width: 200px;
        }
    </style>
</head>
<body>

    <!-- ANNOUNCEMENT BAR -->
    <div class="announcement-bar">
        <span class="badge-pill">⚡ STORE CATALOG</span>
        <span>BROWSE OUR CURATED COLLECTION OF PREMIUM TECH & LIFESTYLE PRODUCTS</span>
    </div>

    <!-- GLASS HEADER NAVIGATION -->
    <header class="nav-header">
        <div class="container nav-inner">
            <a class="brand-logo" href="${pageContext.request.contextPath}/">
                <div class="brand-icon">⚡</div>
                Shop<span>Sphere</span>
            </a>
            
            <nav class="nav-menu">
                <a class="nav-link" href="${pageContext.request.contextPath}/">Home</a>
                <a class="nav-link active" href="${pageContext.request.contextPath}/products">Store Catalog</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/wishlist">Wishlist</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/cart">My Cart 🛒</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/orders">Orders</a>
            </nav>

            <div style="display: flex; align-items: center; gap: 0.75rem;">
                <% if (u == null) { %>
                    <a class="btn secondary" href="${pageContext.request.contextPath}/login">Sign In</a>
                    <a class="btn" href="${pageContext.request.contextPath}/register">Get Started</a>
                <% } else { %>
                    <span class="chip success">👤 <%= u.getName() %></span>
                    <% if ("ADMIN".equalsIgnoreCase(u.getRole())) { %>
                        <a class="btn secondary" style="background: rgba(168, 85, 247, 0.2); border-color: rgba(168, 85, 247, 0.4);" href="${pageContext.request.contextPath}/admin/dashboard">Admin Panel</a>
                    <% } else { %>
                        <a class="btn secondary" href="${pageContext.request.contextPath}/profile">My Account</a>
                    <% } %>
                    <a class="btn ghost" href="${pageContext.request.contextPath}/logout">Logout</a>
                <% } %>
            </div>
        </div>
    </header>

    <main class="container products-section" style="padding-top: 3rem;">
        
        <!-- HEADER TITLE -->
        <div class="section-header">
            <div>
                <span class="badge-tag" style="margin-bottom: 0.4rem;">🛍️ EXPLORE PRODUCTS</span>
                <h1 class="section-title" style="font-size: 2.5rem;">Official Storefront</h1>
                <p class="muted">Filter by category, search by title, or sort by pricing and popularity.</p>
            </div>
        </div>

        <!-- SEARCH AND FILTER BAR -->
        <div class="filter-bar">
            <form method="get" action="${pageContext.request.contextPath}/products" class="filter-form">
                <input name="q" value="${query}" placeholder="Search products by name or brand…">
                
                <select name="sort">
                    <option value="newest" ${sort=="newest"?"selected":""}>Sort: Newest Arrivals</option>
                    <option value="price_asc" ${sort=="price_asc"?"selected":""}>Price: Low to High</option>
                    <option value="price_desc" ${sort=="price_desc"?"selected":""}>Price: High to Low</option>
                    <option value="stock" ${sort=="stock"?"selected":""}>Availability: In Stock</option>
                </select>

                <button type="submit" class="btn">Filter Products</button>
                <c:if test="${not empty query}">
                    <a href="${pageContext.request.contextPath}/products" class="btn ghost">Clear Search</a>
                </c:if>
            </form>
        </div>

        <!-- PRODUCTS GRID -->
        <c:choose>
            <c:when test="${empty products}">
                <div class="card" style="text-align: center; padding: 4rem 2rem;">
                    <div style="font-size: 3.5rem; margin-bottom: 1rem;">🔍</div>
                    <h3>No products found matching your search</h3>
                    <p class="muted" style="margin-top: 0.5rem;">Try adjusting your search terms or filters to find what you're looking for.</p>
                    <a href="${pageContext.request.contextPath}/products" class="btn" style="margin-top: 1.5rem;">Reset All Filters</a>
                </div>
            </c:when>
            <c:otherwise>
                <div id="productGrid" class="grid">
                    <c:forEach var="product" items="${products}">
                        <article class="product-card">
                            <div class="product-image">
                                <span class="product-tag">${product.brand}</span>
                                📦
                            </div>

                            <div class="product-body">
                                <span class="chip">${product.brand}</span>
                                <a class="product-title" href="${pageContext.request.contextPath}/product?id=${product.productId}">${product.name}</a>
                                <p class="muted" style="font-size: 0.85rem; line-height: 1.4;">${product.description}</p>
                                
                                <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 0.6rem;">
                                    <span class="price">₹${product.price}</span>
                                    <span class="chip ${product.stock > 0 ? 'success' : 'danger'}">
                                        <c:choose>
                                            <c:when test="${product.stock > 0}">${product.stock} in stock</c:when>
                                            <c:otherwise>Out of Stock</c:otherwise>
                                        </c:choose>
                                    </span>
                                </div>

                                <div class="product-actions">
                                    <c:if test="${product.stock > 0}">
                                        <form method="post" action="${pageContext.request.contextPath}/cart" style="flex: 1; display: flex; gap: 0.4rem;">
                                            <input type="hidden" name="productId" value="${product.productId}">
                                            <input style="width:65px; text-align: center;" type="number" name="quantity" value="1" min="1" max="${product.stock}" required>
                                            <button type="submit" style="flex: 1;">Add to Cart 🛒</button>
                                        </form>
                                    </if>
                                    <form method="post" action="${pageContext.request.contextPath}/wishlist">
                                        <input type="hidden" name="productId" value="${product.productId}">
                                        <button class="btn ghost" type="submit" title="Add to Wishlist">♡</button>
                                    </form>
                                </div>
                            </div>
                        </article>
                    </c:forEach>
                </div>

                <!-- PAGINATION -->
                <div class="filter-bar" style="margin-top: 3rem; justify-content: space-between;">
                    <span class="muted" style="font-weight: 600;">Showing Page ${page}</span>
                    <div style="display: flex; gap: 0.5rem;">
                        <c:if test="${page > 1}">
                            <a class="btn secondary" href="?q=${query}&sort=${sort}&page=${page-1}">← Previous Page</a>
                        </c:if>
                        <a class="btn secondary" href="?q=${query}&sort=${sort}&page=${page+1}">Next Page →</a>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </main>

    <!-- FOOTER -->
    <footer class="main-footer">
        <div class="container">
            <div class="footer-bottom" style="border-top: none; padding-top: 0;">
                <div>© 2026 ShopSphere Inc. All rights reserved. Premium Storefront Experience.</div>
                <div style="display: flex; gap: 1.2rem;">
                    <a href="${pageContext.request.contextPath}/" style="color: var(--text-dim);">Home</a>
                    <a href="${pageContext.request.contextPath}/products" style="color: var(--text-dim);">Catalog</a>
                    <a href="${pageContext.request.contextPath}/syllabus" style="color: var(--text-dim); text-decoration: underline;">Syllabus Overview</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>