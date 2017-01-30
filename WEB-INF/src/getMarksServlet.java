import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
import org.json.simple.parser.*;
public class getMarksServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        PrintWriter out=res.getWriter();//get the stream to write the data

        JSONParser parser = new JSONParser();
        JSONObject jo = new JSONObject();

        String subjectCode = req.getParameter("subjectCode");

        HttpSession session = req.getSession(true);
        String ayear = (String)session.getAttribute("ayear");
        String year = (String)session.getAttribute("year");
        String department = (String)session.getAttribute("department");
        String section = (String)session.getAttribute("section");
        String assesment = (String)session.getAttribute("assesment");
        String userRole = (String)session.getAttribute("role");
        String msg = "done";
        if (userRole == null)
            userRole = "";
        if(userRole.equalsIgnoreCase("admin") || userRole.equalsIgnoreCase("faculty")){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");
                //here sonoo is database name, root is username and password
                PreparedStatement stmt = con.prepareStatement("select excelData, coData from marks where subjectCode = ? and assesment = ? and section = ? and department = ? and year = ?");

                stmt.setString(1,subjectCode);
                stmt.setString(2,assesment);
                stmt.setString(3,section);
                stmt.setString(4,department);
                stmt.setString(5,year);

                ResultSet rs=stmt.executeQuery();

                if(!rs.next()){
                    msg = "No marks Found";
                }else{
                    String excel = rs.getString(1);
                    String co = rs.getString(2);
                    Object obj1 = parser.parse(excel);
                    Object obj2 = parser.parse(co);
                    JSONObject jo1 = (JSONObject) obj1;
                    JSONObject jo2 = (JSONObject) obj2;
                    jo.put("excel", jo1);
                    jo.put("co", jo2);
                }

                stmt.close();
                con.close();
            }catch(Exception e){
                msg = "error";
                jo.put("error", e.toString());
            }
        } else {
            msg = "error";
            jo.put("error","not authenticated");
        }
        jo.put("message",msg);
        out.println(jo);
        out.close();//closing the stream
    }
}
