import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class deleteServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        PrintWriter out=res.getWriter();//get the stream to write the data

        String userId = req.getParameter("userId");

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
                PreparedStatement stmt = con.prepareStatement("DELETE FROM login WHERE userid = ?");
                stmt.setString(1,userId);

                int c = stmt.executeUpdate();
                jo.put("row deleted", c);

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
