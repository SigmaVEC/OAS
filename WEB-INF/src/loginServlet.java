import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class loginServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data
        String userId = req.getParameter("userId"), s = "",name, message;
        String pass = req.getParameter("password");
        JSONObject jo = new JSONObject();
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");

            PreparedStatement stmt = con.prepareStatement("select name, password, role from login where userid = ?");
            stmt.setString(1,userId);

            ResultSet rs=stmt.executeQuery();

            if(!rs.next()){
                message = "Try Again";
                session.invalidate();
            }else{

                name = rs.getString(1);
                String p = rs.getString(2);
                if(p.equals(pass)){
                    jo.put("name",name);
                    String role = rs.getString(3);
                    session.setAttribute("role",role);
                    session.setAttribute("userId",userId);
                    session.setAttribute("name",name);
                    message = "Success";
                }else {
                    message = "Try Again";
                    session.invalidate();
                }
            }
            jo.put("message",message);
            stmt.close();
            con.close();
        }catch(Exception e){
            s = s + e.toString();
            jo.put("error",e.toString());
        }
        //writing html in the stream
        out.println(jo);

        out.close();//closing the stream
    }
}
