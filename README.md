# ShopSphere — RTU Advanced Java E-Commerce Project

Java enterprise-style e-commerce project for the RTU Advanced Java syllabus.

## Stack
- Java 17+
- Jakarta Servlet + JSP
- JDBC + MySQL
- Maven
- Apache Tomcat 11
- JSP EL + JSTL
- Java Swing
- java.net Socket/ServerSocket
- Java RMI

## Architecture
Browser → JSP → Servlet → Service → DAO → JDBC → MySQL

## Development order
Core web application first, then networking, RMI and Swing modules.

## Run
Requirements: JDK 17+, Maven, MySQL, Tomcat 11.

Database script: database/shopsphere.sql

Build with: mvn clean package
