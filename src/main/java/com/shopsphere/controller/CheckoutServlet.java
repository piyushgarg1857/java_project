package com.shopsphere.controller;

import com.shopsphere.model.Coupon;
import com.shopsphere.model.User;
import com.shopsphere.service.OrderService;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/checkout")
public class CheckoutServlet extends HttpServlet {
    private final OrderService service=new OrderService();

    private User user(HttpServletRequest r){return (User)r.getSession().getAttribute("loggedInUser");}

    protected void doGet(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{
        try{
            double total=service.cartTotal(user(r).getUserId());
            Coupon coupon=(Coupon)r.getSession().getAttribute("checkoutCoupon");
            double discount=service.couponDiscount(coupon,total);
            r.setAttribute("cartTotal",total);
            r.setAttribute("couponDiscount",discount);
            r.setAttribute("payableTotal",total-discount);
            r.setAttribute("checkoutCoupon",coupon);
            r.getRequestDispatcher("/WEB-INF/views/checkout.jsp").forward(r,p);
        }catch(Exception e){throw new ServletException("Unable to load checkout",e);}
    }

    protected void doPost(HttpServletRequest r,HttpServletResponse p)throws ServletException,IOException{
        HttpSession session=r.getSession();
        try{
            User u=user(r);
            if("applyCoupon".equals(r.getParameter("action"))){
                double total=service.cartTotal(u.getUserId());
                Coupon c=service.validateCoupon(r.getParameter("couponCode"),total);
                session.setAttribute("checkoutCoupon",c);
                session.setAttribute("checkoutMessage","Coupon "+c.getCode()+" applied successfully.");
                p.sendRedirect(r.getContextPath()+"/checkout");
                return;
            }
            if("removeCoupon".equals(r.getParameter("action"))){
                session.removeAttribute("checkoutCoupon");
                session.setAttribute("checkoutMessage","Coupon removed.");
                p.sendRedirect(r.getContextPath()+"/checkout");
                return;
            }
            Coupon c=(Coupon)session.getAttribute("checkoutCoupon");
            String code=c==null?null:c.getCode();
            int id=service.placeOrder(u.getUserId(),r.getParameter("addressLine"),r.getParameter("city"),r.getParameter("state"),r.getParameter("pincode"),code);
            session.removeAttribute("checkoutCoupon");
            session.setAttribute("checkoutMessage",null);
            r.setAttribute("orderId",id);
            r.getRequestDispatcher("/WEB-INF/views/order-success.jsp").forward(r,p);
        }catch(IllegalArgumentException e){
            session.setAttribute("checkoutMessage",e.getMessage());
            p.sendRedirect(r.getContextPath()+"/checkout");
        }catch(Exception e){throw new ServletException("Checkout failed",e);}
    }
}