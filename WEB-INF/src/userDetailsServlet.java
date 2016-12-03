import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class userDetailsServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        PrintWriter out=res.getWriter();//get the stream to write the data

        String userId = req.getParameter("userid");

        JSONObject jo = new JSONObject();
        HttpSession session = req.getSession(false);
        String userRole = (String)session.getAttribute("role");
        if (userRole == null)
            userRole = "";
        if(!userRole.equalsIgnoreCase("admin") || userId == null)
            userId = (String)session.getAttribute("userId");
        if(userId != null){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");
                //here sonoo is database name, root is username and password
                PreparedStatement stmt = con.prepareStatement("SELECT userid, name, role, mobile, email FROM login WHERE userid = ?");
                stmt.setString(1,userId);

                ResultSet rs = stmt.executeQuery();
                if (!rs.next()){

                }else{
                    jo.put("userid",userId);
                    jo.put("name",rs.getString(2));
                    jo.put("role",rs.getString(3));
                    jo.put("mobile",rs.getString(4));
                    jo.put("email",rs.getString(5));
                }

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
