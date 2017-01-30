import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
import org.json.simple.parser.*;
public class getQuesAndStudServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);

        PrintWriter out=res.getWriter();//get the stream to write the data
        String ayear = (String)session.getAttribute("ayear");
        String year = (String)session.getAttribute("year");
        String department = (String)session.getAttribute("department");
        String section = (String)session.getAttribute("section");
        String assesment = (String)session.getAttribute("assesment");
        String msg = "done";
        //String subjectCode = req.getParameter("subjectCode");
        String subjectCode = (String)session.getAttribute("course");

        JSONObject jo = new JSONObject();
        JSONParser parser = new JSONParser();
        try{
            jo.put("ayear",ayear);
            jo.put("year",year);
            jo.put("department",department);
            jo.put("section",section);
            jo.put("assesment",assesment);

            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");

            PreparedStatement stmt = con.prepareStatement("select questions from questions where subjectCode = ? and assesment = ? and section = ? and  department = ? and year = ?");
            stmt.setString(1, subjectCode);
            stmt.setString(2, assesment);
            stmt.setString(3, section);
            stmt.setString(4, department);
            stmt.setString(5, year);

            ResultSet rs=stmt.executeQuery();

            if(!rs.next()){
                msg = "No Questions Found";
            }else{

                String ques = rs.getString(1);
                Object obj = parser.parse(ques);
                JSONObject jo1 = (JSONObject) obj;
                jo.put("questions", jo1);

                stmt = con.prepareStatement("select name from students where section = ? and  department = ? and year = ?");
                stmt.setString(1, section);
                stmt.setString(2, department);
                stmt.setString(3, year);

                rs=stmt.executeQuery();

                JSONArray ar = new JSONArray();
                while(rs.next()){
                    ar.add(rs.getString(1));
                }
                jo.put("students",ar);
            }

        }catch(Exception e){
            String s = e.toString();
            msg = "error";
            jo.put("error",e.toString());
        }

        jo.put("message",msg);
        //writing html in the stream
        out.println(jo);

        out.close();//closing the stream
    }
}
