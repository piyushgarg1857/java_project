<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shopsphere.model.Product,java.util.List,com.shopsphere.model.User" %>
<% 
    User u = (User) session.getAttribute("loggedInUser"); 
    List<Product> products = (List<Product>) request.getAttribute("products"); 
    List<String[]> categories = (List<String[]>) request.getAttribute("categories");
    String query = (String) request.getAttribute("query"); if (query == null) query = ""; 
    String sort = (String) request.getAttribute("sort"); if (sort == null) sort = "newest"; 
    Integer pageObj = (Integer) request.getAttribute("page"); int currentPage = pageObj == null ? 1 : pageObj; 
    Integer currentCat = (Integer) request.getAttribute("category"); if (currentCat == null) currentCat = 0;
    Object minP = request.getAttribute("minPrice"); String minPrice = minP == null ? "" : String.valueOf(minP);
    Object maxP = request.getAttribute("maxPrice"); String maxPrice = maxP == null ? "" : String.valueOf(maxP);
    Boolean inStock = (Boolean) request.getAttribute("inStock"); if (inStock == null) inStock = false;
    String ctx = request.getContextPath();
%>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width,initial-scale=1">
    <title>Shop — ShopSphere</title>
    <link rel="stylesheet" href="<%= ctx %>/assets/css/app.css">
    <style>
        .catalog-layout { display: grid; grid-template-columns: 260px 1fr; gap: 32px; align-items: start; }
        .filter-sidebar { background: var(--bg-card, #fff); border: 1px solid var(--line, #e5e5e5); border-radius: 12px; padding: 20px; position: sticky; top: 90px; }
        .filter-group { margin-bottom: 20px; }
        .filter-group label { display: block; font-size: 13px; font-weight: 600; text-transform: uppercase; letter-spacing: 0.05em; color: var(--muted, #666); margin-bottom: 10px; }
        .price-inputs { display: flex; gap: 8px; align-items: center; }
        .price-inputs input { width: 100%; padding: 8px 12px; border: 1px solid var(--line, #ccc); border-radius: 6px; font-size: 14px; }
        .stock-check { display: flex; align-items: center; gap: 8px; cursor: pointer; font-size: 14px; font-weight: 500; }
        .cat-list { list-style: none; padding: 0; margin: 0; }
        .cat-list li { margin-bottom: 6px; }
        .cat-link { text-decoration: none; font-size: 14px; color: var(--text, #333); display: block; padding: 6px 10px; border-radius: 6px; transition: all 0.2s; }
        .cat-link:hover, .cat-link.active { background: var(--accent-light, #f0f4ff); color: var(--accent, #0052cc); font-weight: 600; }
        @media (max-width: 768px) { .catalog-layout { grid-template-columns: 1fr; } .filter-sidebar { position: static; } }
    </style>
</head>
<body>
<div class="announcement-bar"><span>CURATED PRODUCTS FOR MODERN LIVING</span></div>
<header class="nav-header">
    <div class="container nav-inner">
        <nav class="nav-menu">
            <a class="nav-link" href="<%= ctx %>/">Shop</a>
            <a class="nav-link active" href="<%= ctx %>/products">Collections</a>
            <a class="nav-link" href="<%= ctx %>/products?category=3">Fashion</a>
            <a class="nav-link" href="<%= ctx %>/products?category=2">Books</a>
        </nav>
        <a class="brand-logo" href="<%= ctx %>/">ShopSphere</a>
        <div>
            <a class="btn ghost" href="<%= ctx %>/products">Search</a>
            <a class="btn ghost" href="<%= u == null ? ctx + "/login" : ("ADMIN".equalsIgnoreCase(u.getRole()) ? ctx + "/admin/dashboard" : ctx + "/profile") %>">Account</a>
            <a class="btn ghost" href="<%= ctx %>/cart">Cart</a>
        </div>
    </div>
</header>
<main class="container products-section">
    <div class="section-head">
        <div>
            <span class="eyebrow">EXPLORE COLLECTION</span>
            <h1 class="section-title">The Collection</h1>
            <p class="muted">Discover premium products curated for your daily lifestyle.</p>
        </div>
    </div>

    <div class="catalog-layout">
        <!-- Sidebar Filters -->
        <aside class="filter-sidebar">
            <form method="get" action="<%= ctx %>/products" id="filterForm">
                <input type="hidden" name="q" value="<%= query %>">
                <input type="hidden" name="sort" value="<%= sort %>">
                
                <div class="filter-group">
                    <label>Categories</label>
                    <ul class="cat-list">
                        <li>
                            <a class="cat-link <%= currentCat == 0 ? "active" : "" %>" href="<%= ctx %>/products?q=<%= query %>&sort=<%= sort %>">All Categories</a>
                        </li>
                        <% if (categories != null) { for (String[] c : categories) { int cid = Integer.parseInt(c[0]); %>
                        <li>
                            <a class="cat-link <%= currentCat == cid ? "active" : "" %>" href="<%= ctx %>/products?category=<%= cid %>&q=<%= query %>&sort=<%= sort %>"><%= c[1] %></a>
                        </li>
                        <% } } %>
                    </ul>
                    <input type="hidden" name="category" value="<%= currentCat %>">
                </div>

                <div class="filter-group">
                    <label>Price Range (₹)</label>
                    <div class="price-inputs">
                        <input type="number" name="minPrice" placeholder="Min" value="<%= minPrice %>" min="0">
                        <span>–</span>
                        <input type="number" name="maxPrice" placeholder="Max" value="<%= maxPrice %>" min="0">
                    </div>
                </div>

                <div class="filter-group">
                    <label class="stock-check">
                        <input type="checkbox" name="inStock" value="1" <%= inStock ? "checked" : "" %>>
                        In stock only
                    </label>
                </div>

                <button type="submit" class="button primary" style="width:100%; margin-top:8px;">Apply Filters</button>
                <% if (!query.isEmpty() || currentCat > 0 || !minPrice.isEmpty() || !maxPrice.isEmpty() || inStock) { %>
                    <a href="<%= ctx %>/products" class="button secondary" style="width:100%; margin-top:8px; text-align:center; display:block;">Clear All</a>
                <% } %>
            </form>
        </aside>

        <!-- Product Grid & Search Bar -->
        <div>
            <div class="filter-bar" style="margin-bottom:24px;">
                <form method="get" action="<%= ctx %>/products" class="filter-form" style="width:100%;">
                    <input name="q" value="<%= query %>" placeholder="Search products, brands, or keywords…" style="flex:1;">
                    <input type="hidden" name="category" value="<%= currentCat %>">
                    <input type="hidden" name="minPrice" value="<%= minPrice %>">
                    <input type="hidden" name="maxPrice" value="<%= maxPrice %>">
                    <% if (inStock) { %><input type="hidden" name="inStock" value="1"><% } %>
                    <select name="sort" onchange="this.form.submit()">
                        <option value="newest" <%= "newest".equals(sort) ? "selected" : "" %>>Newest Arrivals</option>
                        <option value="price_asc" <%= "price_asc".equals(sort) ? "selected" : "" %>>Price: Low to High</option>
                        <option value="price_desc" <%= "price_desc".equals(sort) ? "selected" : "" %>>Price: High to Low</option>
                        <option value="stock" <%= "stock".equals(sort) ? "selected" : "" %>>In Stock First</option>
                    </select>
                    <button type="submit">Search</button>
                </form>
            </div>

            <% if (products == null || products.isEmpty()) { %>
                <div class="card empty" style="text-align:center; padding:48px 24px;">
                    <h3>No matching products found</h3>
                    <p class="muted" style="margin-top:8px;">Try adjusting your price range, category, or search keywords.</p>
                    <a class="button primary" href="<%= ctx %>/products" style="margin-top:20px; display:inline-block;">Reset All Filters</a>
                </div>
            <% } else { %>
                <div class="grid">
                <% 
                    String[] defaultImages = {
                        "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?auto=format&fit=crop&w=900&q=85",
                        "https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=900&q=85",
                        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?auto=format&fit=crop&w=900&q=85",
                        "https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=900&q=85"
                    };
                    int imgIdx = 0;
                    for (Product p : products) {
                        String image = (p.getImageUrl() != null && !p.getImageUrl().trim().isEmpty()) ? p.getImageUrl() : defaultImages[imgIdx++ % defaultImages.length];
                %>
                    <article class="product-card">
                        <a class="product-image" href="<%= ctx %>/product?id=<%= p.getProductId() %>">
                            <img src="<%= image %>" alt="<%= p.getName() %>" style="width:100%; height:220px; object-fit:cover;">
                            <span class="product-tag"><%= p.getStock() > 0 ? "AVAILABLE" : "SOLD OUT" %></span>
                        </a>
                        <div class="product-body">
                            <span class="chip"><%= p.getBrand() != null ? p.getBrand() : "ShopSphere" %></span>
                            <a class="product-title" href="<%= ctx %>/product?id=<%= p.getProductId() %>"><%= p.getName() %></a>
                            <p class="muted"><%= p.getDescription() != null && p.getDescription().length() > 80 ? p.getDescription().substring(0, 80) + "…" : (p.getDescription() == null ? "" : p.getDescription()) %></p>
                            <div style="display:flex; justify-content:space-between; align-items:center; margin-top:12px;">
                                <span class="price">₹<%= String.format("%.2f", p.getPrice()) %></span>
                                <span class="chip <%= p.getStock() > 0 ? "success" : "danger" %>"><%= p.getStock() > 0 ? "In stock" : "Out of stock" %></span>
                            </div>
                            <div class="product-actions" style="margin-top:14px; display:flex; gap:8px;">
                                <% if (p.getStock() > 0) { %>
                                <form method="post" action="<%= ctx %>/cart" style="flex:1;">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                    <input type="hidden" name="quantity" value="1">
                                    <button type="submit" style="width:100%;">Add to Bag</button>
                                </form>
                                <% } %>
                                <form method="post" action="<%= ctx %>/wishlist">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                    <button class="btn ghost" type="submit" title="Add to Wishlist">♡</button>
                                </form>
                            </div>
                        </div>
                    </article>
                <% } %>
                </div>

                <div class="filter-bar" style="margin-top:40px; display:flex; justify-content:space-between; align-items:center;">
                    <span class="muted">Page <%= currentPage %></span>
                    <div style="display:flex; gap:8px;">
                        <% if (currentPage > 1) { %>
                        <a class="button secondary" href="?q=<%= query %>&category=<%= currentCat %>&minPrice=<%= minPrice %>&maxPrice=<%= maxPrice %>&inStock=<%= inStock ? "1" : "" %>&sort=<%= sort %>&page=<%= currentPage - 1 %>">← Previous</a>
                        <% } %>
                        <a class="button secondary" href="?q=<%= query %>&category=<%= currentCat %>&minPrice=<%= minPrice %>&maxPrice=<%= maxPrice %>&inStock=<%= inStock ? "1" : "" %>&sort=<%= sort %>&page=<%= currentPage + 1 %>">Next →</a>
                    </div>
                </div>
            <% } %>
        </div>
    </div>
</main>

<footer class="main-footer" style="margin-top:60px;">
    <div class="container">
        <div class="footer-bottom">
            <span>© 2026 ShopSphere</span>
            <span>Refined shopping for everyday life.</span>
        </div>
    </div>
</footer>
</body>
</html>