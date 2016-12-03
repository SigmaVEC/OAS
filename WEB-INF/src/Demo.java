import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class Demo extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("text/html");//setting the content type
        PrintWriter pw=res.getWriter();//get the stream to write the data
        String s = req.getParameter("userid");
        JSONObject jo = new JSONObject();
        JSONArray ja = new JSONArray();
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");
            //here sonoo is database name, root is username and password
            Statement stmt=con.createStatement();
            ResultSet rs=stmt.executeQuery("select * from login");
            while(rs.next()){
                jo.put("userid",rs.getString(1));
                jo.put("name",rs.getString(2));
                jo.put("password",rs.getString(3));
                ja.add(jo);
            }

            con.close();
        }catch(Exception e){ s = s + e.toString();}
        //writing html in the stream
        HttpSession session = req.getSession(true);
        s = (String)session.getAttribute("role");
        pw.println("<html><body>");
        pw.println("Welcome to servlets"+s);
        pw.println(jo);
        pw.println("</body></html>");

        pw.close();//closing the stream
    }
}
