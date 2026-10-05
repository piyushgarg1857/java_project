# ShopSphere — RTU Advanced Java E-Commerce Project

ShopSphere is an educational Java e-commerce capstone aligned with the RTU Advanced Java project guide. It combines a Java web application with the guide's advanced Java modules.

## Technology
- Java 17+
- Jakarta Servlet + JSP
- JDBC + MySQL
- Maven + WAR
- Apache Tomcat
- Java Swing
- java.net Socket/ServerSocket
- Java RMI
- JNDI
- Serialization
- Servlet Filters + Listeners
- Cookies + basic internationalization

## Architecture
Browser → JSP → Servlet → Service → DAO → JDBC → MySQL

Advanced modules live alongside the core web application:
- Networking: `com.shopsphere.network`
- RMI: `com.shopsphere.rmi`
- Serialization: `com.shopsphere.serialization`
- Swing: `com.shopsphere.desktop`
- JNDI: `com.shopsphere.jndi`
- Web infrastructure: `com.shopsphere.web`
- Internationalization: `com.shopsphere.i18n`

## Implemented phases

### Phase 1 — Foundation
- Maven WAR project
- MySQL schema
- JDBC connection
- Product model/DAO/service
- Product listing

### Phase 2 — Authentication
- User model
- Registration/login/logout
- HTTP session
- Authentication filter
- Admin role protection

### Phase 3 — Catalog Administration
- Category DAO/service
- Product create/update
- Category create/disable
- Admin-only routes

### Phase 4 — Shopping
- Cart add/remove/clear
- Wishlist add/remove
- Checkout
- Address creation
- Order transaction
- Order success flow
- Reviews

### Phase 5 — Advanced Java
- Socket server/client
- Java RMI server/client
- Serializable message demo
- Swing desktop admin starter
- JNDI DataSource lookup example
- ServletContext listener
- Request logging filter
- Cookie preference example
- English/Hindi resource bundles

## Database
Run:
`database/shopsphere.sql`

Then configure the JDBC credentials in:
`src/main/java/com/shopsphere/config/DBConnection.java`

The current educational default is localhost MySQL with user `root` and password `root`. For a real deployment, move credentials to environment variables or Tomcat JNDI.

## Build
```bash
mvn clean package
```

Deploy the generated `target/shopsphere.war` to Tomcat.

## Advanced module examples
Run the Java main classes directly from the IDE:
- `com.shopsphere.network.ShopSocketServer`
- `com.shopsphere.network.ShopSocketClient`
- `com.shopsphere.rmi.ShopRmiServer`
- `com.shopsphere.rmi.ShopRmiClient`
- `com.shopsphere.serialization.SerializationDemo`
- `com.shopsphere.desktop.AdminDesktopApp`
- `com.shopsphere.i18n.I18nDemo`

## Important educational note
The repository contains the complete project skeleton and working implementations for the requested phases, but payment gateway integration, production password hashing, connection pooling, comprehensive validation, automated tests, and production deployment hardening are separate production-grade improvements rather than claims of a live payment system.
