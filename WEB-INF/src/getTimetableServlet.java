import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
import org.json.simple.parser.*;
public class getTimetableServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        PrintWriter out=res.getWriter();//get the stream to write the data

        JSONParser parser = new JSONParser();
        JSONObject jo = new JSONObject();

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
        if(userRole.equalsIgnoreCase("admin")){
            try{
                Class.forName("com.mysql.jdbc.Driver");
                Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");
                //here sonoo is database name, root is username and password
                PreparedStatement stmt = con.prepareStatement("select subjectcode, facultyid, courseName from timetable where section = ? and department = ? and year = ?");

                stmt.setString(1,section);
                stmt.setString(2,department);
                stmt.setString(3,year);

                ResultSet rs=stmt.executeQuery();
                JSONArray ar = new JSONArray();
                while(rs.next()){
                    String sc = rs.getString(1);
                    String fi = rs.getString(2);
                    String cn = rs.getString(3);
                    JSONObject j1 = new JSONObject();;
                    j1.put("subjectCode", sc);
                    j1.put("courseName", cn);
                    j1.put("facultyId", fi);
                    ar.add(j1);
                }
                jo.put("timetable",ar);
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
