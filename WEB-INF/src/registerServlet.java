import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class registerServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        PrintWriter out=res.getWriter();//get the stream to write the data

        String userId = req.getParameter("userid");
        String name = req.getParameter("name");
        String role = req.getParameter("role");
        String password = req.getParameter("password");
        String mobile = req.getParameter("mobile");
        String email = req.getParameter("email");
        String mode = req.getParameter("mode");

        JSONObject jo = new JSONObject();
        HttpSession session = req.getSession(true);
        String userRole = (String)session.getAttribute("role");
        if (userRole == null)
            userRole = "";
        if(userRole.equalsIgnoreCase("admin")){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");
                //here sonoo is database name, root is username and password
                PreparedStatement stmt = null;
                if (mode.equalsIgnoreCase("insert"))
                    stmt = con.prepareStatement("INSERT INTO login(userid, name, password, role, mobile, email) VALUES(?, ?, ?, ?, ?, ?)");
                else if(mode.equalsIgnoreCase("update")){
                    stmt = con.prepareStatement("UPDATE login SET userid = ? , name = ?, password = ?, role = ?, mobile = ?, email = ? where userid = ?");
                    stmt.setString(7,userId);
                }
                stmt.setString(1,userId);
                stmt.setString(2,name);
                stmt.setString(3,password);
                stmt.setString(4,role);
                stmt.setString(5,mobile);
                stmt.setString(6,email);

                int c = stmt.executeUpdate();
                jo.put("row changed", c);

                stmt.close();
                con.close();
            }catch(Exception e){
                jo.put("error", e.toString());
            }
        } else {
            jo.put("error","not authenticated");
        }

        out.println(jo);
        out.close();//closing the stream
    }
}
