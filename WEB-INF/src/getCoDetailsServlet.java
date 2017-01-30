import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class getCoDetailsServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data
        //String subjectCode = req.getParameter("subjectCode");
        String subjectCode = (String)session.getAttribute("course");

        JSONObject jo = new JSONObject();

        String msg = "done";
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");


            PreparedStatement stmt = con.prepareStatement("select cono, description, threshold, target from CODetails where subjectCode = ?");
            stmt.setString(1,subjectCode);
            ResultSet rs=stmt.executeQuery();

            JSONArray ar = new JSONArray();
            while(rs.next()){
                JSONObject o = new JSONObject();
                o.put("co",rs.getString(1));
                o.put("description",rs.getString(2));
                o.put("threshold",rs.getString(3));
                o.put("target",rs.getString(4));
                ar.add(o);
            }
            jo.put("co",ar);


        }catch(Exception e){
            msg = "try again";
            jo.put("error",e.toString());
        }
        jo.put("message",msg);
        //writing html in the stream
        out.println(jo);

        out.close();//closing the stream
    }
}
