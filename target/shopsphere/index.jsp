<!DOCTYPE html>
<%@ page contentType="text/html;charset=UTF-8" %>
<%@ page import="com.shopsphere.model.User" %>
<%@ page import="com.shopsphere.model.Product" %>
<%@ page import="com.shopsphere.dao.ProductDAO" %>
<%@ page import="java.util.List" %>
<% 
    User u = (User) session.getAttribute("loggedInUser"); 
    List<Product> featuredProducts = null;
    try {
        ProductDAO dao = new ProductDAO();
        featuredProducts = dao.search(null, 0, "newest", 1, 6);
    } catch(Exception e) {
        featuredProducts = java.util.Collections.emptyList();
    }
%>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ShopSphere — Premier E-Commerce & Next-Gen Storefront</title>
    <meta name="description" content="ShopSphere is your ultimate destination for high-performance electronics, modern fashion, and premium accessories with instant express delivery.">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/app.css">
    <style>
        .hero-showcase-img {
            width: 100%;
            height: 180px;
            object-fit: cover;
            border-radius: var(--radius-md);
            margin: 1rem 0;
            background: linear-gradient(135deg, rgba(99, 102, 241, 0.2), rgba(236, 72, 153, 0.2));
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 3.5rem;
        }
        .rating-stars {
            color: #fbbf24;
            font-size: 0.9rem;
            margin-top: 0.25rem;
        }
        .testimonial-grid {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
            gap: 1.5rem;
            margin: 3rem 0;
        }
        .testimonial-card {
            background: var(--surface-card);
            border: 1px solid var(--surface-border);
            border-radius: var(--radius-md);
            padding: 1.5rem;
            backdrop-filter: blur(12px);
        }
        .newsletter-box {
            background: linear-gradient(135deg, rgba(30, 41, 59, 0.9), rgba(15, 23, 42, 0.95));
            border: 1px solid var(--surface-border-glow);
            border-radius: var(--radius-lg);
            padding: 3.5rem 2rem;
            text-align: center;
            margin: 4rem 0 2rem;
            position: relative;
            overflow: hidden;
        }
        .newsletter-box::before {
            content: '';
            position: absolute;
            top: -50%;
            left: 50%;
            transform: translateX(-50%);
            width: 600px;
            height: 300px;
            background: radial-gradient(circle, rgba(99, 102, 241, 0.25) 0%, transparent 70%);
            pointer-events: none;
        }
        .newsletter-form {
            display: flex;
            gap: 0.8rem;
            max-width: 500px;
            margin: 1.8rem auto 0;
        }
        .category-pill-bar {
            display: flex;
            gap: 0.75rem;
            overflow-x: auto;
            padding-bottom: 0.5rem;
            margin-bottom: 2rem;
        }
        .cat-pill {
            padding: 0.55rem 1.25rem;
            border-radius: var(--radius-full);
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid var(--surface-border);
            color: var(--text-muted);
            font-weight: 700;
            font-size: 0.88rem;
            white-space: nowrap;
            transition: all 0.25s ease;
        }
        .cat-pill:hover, .cat-pill.active {
            background: var(--gradient-brand);
            color: #ffffff;
            border-color: transparent;
            box-shadow: 0 4px 15px rgba(99, 102, 241, 0.4);
        }
    </style>
</head>
<body>

    <!-- TOP ANNOUNCEMENT BAR -->
    <div class="announcement-bar">
        <span class="badge-pill">⚡ SPECIAL OFFER</span>
        <span>FREE EXPRESS SHIPPING ON ORDERS OVER ₹999 | USE CODE <strong>SHOPSPHERE</strong> FOR 15% OFF</span>
    </div>

    <!-- GLASS HEADER NAVIGATION -->
    <header class="nav-header">
        <div class="container nav-inner">
            <a class="brand-logo" href="${pageContext.request.contextPath}/">
                <div class="brand-icon">⚡</div>
                Shop<span>Sphere</span>
            </a>
            
            <nav class="nav-menu">
                <a class="nav-link active" href="${pageContext.request.contextPath}/">Home</a>
                <a class="nav-link" href="${pageContext.request.contextPath}/products">Store Catalog</a>
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

    <!-- HERO SECTION -->
    <section class="hero-wrapper">
        <div class="container hero-grid">
            <div>
                <div class="badge-tag">
                    <span>✨ NEXT-GEN E-COMMERCE</span>
                    <span>• 2026 EDITION</span>
                </div>
                <h1 class="hero-title">Experience Modern Shopping Without Limits.</h1>
                <p class="hero-subtitle">
                    Discover ultra-sleek gadgets, luxury lifestyle accessories, and trending collection items with lightning-fast delivery and uncompromised quality.
                </p>
                <div class="hero-buttons">
                    <a class="btn" href="${pageContext.request.contextPath}/products">Explore Products Catalog →</a>
                    <a class="btn secondary" href="${pageContext.request.contextPath}/register">Create Free Account</a>
                </div>
            </div>

            <!-- HERO CARD SHOWCASE -->
            <div class="hero-card">
                <div class="hero-card-badge">🔥 FEATURED SHOWCASE</div>
                <div class="hero-showcase-img">🎧</div>
                <h3 style="font-size: 1.35rem; color: #fff; margin-bottom: 0.3rem;">SpherePro Wireless ANC Headphones</h3>
                <div class="rating-stars">★★★★★ <span style="color: var(--text-muted); font-size: 0.8rem;">(4.9 • 2,450 Verified Reviews)</span></div>
                <p style="color: var(--text-muted); font-size: 0.88rem; margin-top: 0.5rem;">Active noise cancellation, 40-hour battery life, and custom spatial audio engineering.</p>

                <div class="hero-metrics">
                    <div class="metric-box">
                        <div class="metric-number">99.8%</div>
                        <div class="metric-label">Satisfaction Rate</div>
                    </div>
                    <div class="metric-box">
                        <div class="metric-number">24 Hrs</div>
                        <div class="metric-label">Express Shipping</div>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- TRUST BADGES GRID -->
    <section class="container">
        <div class="features-grid">
            <div class="feature-card">
                <div class="feature-icon">🚀</div>
                <div>
                    <h4 style="font-size: 1rem; color: #fff;">Free Express Shipping</h4>
                    <p style="font-size: 0.82rem; color: var(--text-muted);">On all orders above ₹999 worldwide</p>
                </div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🛡️</div>
                <div>
                    <h4 style="font-size: 1rem; color: #fff;">100% Genuine Products</h4>
                    <p style="font-size: 0.82rem; color: var(--text-muted);">Directly sourced from verified brands</p>
                </div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔒</div>
                <div>
                    <h4 style="font-size: 1rem; color: #fff;">256-Bit SSL Encryption</h4>
                    <p style="font-size: 0.82rem; color: var(--text-muted);">Ultra-secure checkout & payments</p>
                </div>
            </div>
            <div class="feature-card">
                <div class="feature-icon">🔄</div>
                <div>
                    <h4 style="font-size: 1rem; color: #fff;">30 Days Replacement</h4>
                    <p style="font-size: 0.82rem; color: var(--text-muted);">No-questions-asked easy return policy</p>
                </div>
            </div>
        </div>
    </section>

    <!-- FEATURED PRODUCTS SECTION -->
    <main class="container products-section">
        <div class="section-header">
            <div>
                <span class="badge-tag" style="margin-bottom: 0.5rem;">🔥 TRENDING NOW</span>
                <h2 class="section-title">Curated Best Sellers</h2>
                <p class="muted">Hand-picked premium electronics and lifestyle products built for modern living.</p>
            </div>
            <a class="btn secondary" href="${pageContext.request.contextPath}/products">View All Products →</a>
        </div>

        <!-- CATEGORY PILL FILTER -->
        <div class="category-pill-bar">
            <a class="cat-pill active" href="${pageContext.request.contextPath}/products">✨ All Categories</a>
            <a class="cat-pill" href="${pageContext.request.contextPath}/products?category=1">📱 Smart Electronics</a>
            <a class="cat-pill" href="${pageContext.request.contextPath}/products?category=2">💻 Computing & Work</a>
            <a class="cat-pill" href="${pageContext.request.contextPath}/products?category=3">🎧 Audio & Wearables</a>
            <a class="cat-pill" href="${pageContext.request.contextPath}/products?category=4">🏠 Modern Home</a>
        </div>

        <div class="grid">
            <% if (featuredProducts != null && !featuredProducts.isEmpty()) { 
                for (Product p : featuredProducts) { %>
                    <article class="product-card">
                        <div class="product-image">
                            <span class="product-tag">BESTSELLER</span>
                            📦
                        </div>
                        <div class="product-body">
                            <span class="chip"><%= p.getBrand() != null ? p.getBrand() : "ShopSphere" %></span>
                            <a class="product-title" href="${pageContext.request.contextPath}/product?id=<%= p.getProductId() %>"><%= p.getName() %></a>
                            <p class="muted" style="font-size: 0.85rem; line-height: 1.4;"><%= p.getDescription() != null && p.getDescription().length() > 70 ? p.getDescription().substring(0, 70) + "..." : p.getDescription() %></p>
                            
                            <div style="display: flex; justify-content: space-between; align-items: center; margin-top: 0.6rem;">
                                <span class="price">₹<%= String.format("%.2f", p.getPrice()) %></span>
                                <span class="chip <%= p.getStock() > 0 ? "success" : "danger" %>"><%= p.getStock() > 0 ? p.getStock() + " in stock" : "Out of stock" %></span>
                            </div>

                            <div class="product-actions">
                                <% if (p.getStock() > 0) { %>
                                    <form method="post" action="${pageContext.request.contextPath}/cart" style="flex: 1; display: flex;">
                                        <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                        <input type="hidden" name="quantity" value="1">
                                        <button type="submit" style="width: 100%;">Add to Cart 🛒</button>
                                    </form>
                                <% } %>
                                <form method="post" action="${pageContext.request.contextPath}/wishlist">
                                    <input type="hidden" name="productId" value="<%= p.getProductId() %>">
                                    <button class="btn ghost" type="submit" title="Add to Wishlist">♡</button>
                                </form>
                            </div>
                        </div>
                    </article>
            <%   } 
               } else { %>
                <div class="card" style="grid-column: 1 / -1; text-align: center; padding: 3rem;">
                    <h3>Discover Our Catalog</h3>
                    <p class="muted">Explore our full list of products in the store.</p>
                    <a class="btn" href="${pageContext.request.contextPath}/products" style="margin-top: 1rem;">Browse Products</a>
                </div>
            <% } %>
        </div>
    </main>

    <!-- TESTIMONIALS / REVIEWS -->
    <section class="container">
        <div style="text-align: center; margin-bottom: 2rem;">
            <span class="badge-tag">💬 CUSTOMER LOVE</span>
            <h2 style="font-size: 2.2rem; color: #fff;">Loved by Thousands of Buyers</h2>
            <p class="muted">Read what our verified shoppers have to say about ShopSphere.</p>
        </div>

        <div class="testimonial-grid">
            <div class="testimonial-card">
                <div class="rating-stars">★★★★★</div>
                <p style="margin: 0.8rem 0; font-size: 0.92rem; color: #cbd5e1;">"Ordered the wireless noise cancelling headphones and received them the next afternoon! Incredible packaging and quality."</p>
                <div style="display: flex; align-items: center; gap: 0.6rem; margin-top: 1rem;">
                    <div style="width: 36px; height: 36px; border-radius: 50%; background: var(--gradient-brand); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.85rem; color: #fff;">AR</div>
                    <div>
                        <strong style="font-size: 0.88rem; color: #fff; display: block;">Aarav Sharma</strong>
                        <span style="font-size: 0.75rem; color: var(--text-dim);">Verified Buyer • Delhi</span>
                    </div>
                </div>
            </div>

            <div class="testimonial-card">
                <div class="rating-stars">★★★★★</div>
                <p style="margin: 0.8rem 0; font-size: 0.92rem; color: #cbd5e1;">"ShopSphere's UI is super smooth and payment processing was effortless. Customer support helped me track my order instantly."</p>
                <div style="display: flex; align-items: center; gap: 0.6rem; margin-top: 1rem;">
                    <div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #06b6d4, #3b82f6); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.85rem; color: #fff;">PM</div>
                    <div>
                        <strong style="font-size: 0.88rem; color: #fff; display: block;">Priya Mehta</strong>
                        <span style="font-size: 0.75rem; color: var(--text-dim);">Verified Buyer • Mumbai</span>
                    </div>
                </div>
            </div>

            <div class="testimonial-card">
                <div class="rating-stars">★★★★★</div>
                <p style="margin: 0.8rem 0; font-size: 0.92rem; color: #cbd5e1;">"Top tier store experience! All products come with official warranty and the discounts during launch were amazing."</p>
                <div style="display: flex; align-items: center; gap: 0.6rem; margin-top: 1rem;">
                    <div style="width: 36px; height: 36px; border-radius: 50%; background: linear-gradient(135deg, #10b981, #059669); display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 0.85rem; color: #fff;">RK</div>
                    <div>
                        <strong style="font-size: 0.88rem; color: #fff; display: block;">Rohan Kapoor</strong>
                        <span style="font-size: 0.75rem; color: var(--text-dim);">Verified Buyer • Bangalore</span>
                    </div>
                </div>
            </div>
        </div>
    </section>

    <!-- NEWSLETTER SIGNUP -->
    <section class="container">
        <div class="newsletter-box">
            <span class="badge-tag">✉️ JOIN THE VIP CLUB</span>
            <h2 style="font-size: 2.2rem; color: #fff; margin-top: 0.4rem;">Unlock Exclusive Deals & 15% Off</h2>
            <p class="muted" style="max-width: 500px; margin: 0.5rem auto 0;">Subscribe to get early access to product launches, seasonal discounts, and VIP promo codes directly to your inbox.</p>

            <form class="newsletter-form" onsubmit="event.preventDefault(); alert('Thank you for subscribing to ShopSphere VIP!');">
                <input type="email" placeholder="Enter your email address…" required style="background: rgba(15, 23, 42, 0.9);">
                <button type="submit" class="btn" style="white-space: nowrap;">Subscribe Now</button>
            </form>
        </div>
    </section>

    <!-- E-COMMERCE FOOTER -->
    <footer class="main-footer">
        <div class="container">
            <div class="footer-grid">
                <div>
                    <a class="brand-logo" href="${pageContext.request.contextPath}/" style="margin-bottom: 1rem;">
                        <div class="brand-icon">⚡</div>
                        Shop<span>Sphere</span>
                    </a>
                    <p style="font-size: 0.9rem; color: var(--text-muted); line-height: 1.6; max-width: 340px;">
                        ShopSphere is a next-generation e-commerce platform delivering high-performance products, seamless shopping experiences, and trusted service.
                    </p>
                </div>

                <div>
                    <h4 class="footer-title">Shop Categories</h4>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/products?category=1">Smart Electronics</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=2">Computing & Laptops</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=3">Audio & Headphones</a></li>
                        <li><a href="${pageContext.request.contextPath}/products?category=4">Home Automation</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="footer-title">Customer Care</h4>
                    <ul class="footer-links">
                        <li><a href="${pageContext.request.contextPath}/orders">Track Your Order</a></li>
                        <li><a href="${pageContext.request.contextPath}/wishlist">Saved Wishlist</a></li>
                        <li><a href="${pageContext.request.contextPath}/cart">Shopping Cart</a></li>
                        <li><a href="${pageContext.request.contextPath}/profile">Account Settings</a></li>
                    </ul>
                </div>

                <div>
                    <h4 class="footer-title">Contact & Support</h4>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-bottom: 0.5rem;">📍 100 Innovation Way, Tech Park</p>
                    <p style="font-size: 0.88rem; color: var(--text-muted); margin-bottom: 0.5rem;">✉️ support@shopsphere-store.com</p>
                    <p style="font-size: 0.88rem; color: var(--text-muted);">📞 +1 (800) 555-SPHERE</p>
                </div>
            </div>

            <div class="footer-bottom">
                <div>© 2026 ShopSphere Inc. All rights reserved. Designed with precision & luxury aesthetics.</div>
                <div style="display: flex; gap: 1.2rem;">
                    <a href="#" style="color: var(--text-dim); font-size: 0.8rem;">Privacy Policy</a>
                    <a href="#" style="color: var(--text-dim); font-size: 0.8rem;">Terms of Service</a>
                    <a href="${pageContext.request.contextPath}/syllabus" style="color: var(--text-dim); font-size: 0.8rem; text-decoration: underline;">Syllabus Overview</a>
                </div>
            </div>
        </div>
    </footer>

    <script src="${pageContext.request.contextPath}/assets/js/app.js"></script>
</body>
</html>