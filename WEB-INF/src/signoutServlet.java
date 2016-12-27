import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
public class signoutServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("text/html");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data
        try{
            session.invalidate();
        }catch(Exception e){}
        //writing html in the stream
        res.setStatus(res.SC_MOVED_TEMPORARILY);
        res.setHeader("Location", "index.html");
        out.println("redirect to home page");

        out.close();//closing the stream
    }
}
