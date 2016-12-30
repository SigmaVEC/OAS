import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import java.sql.*;
import org.json.simple.*;
public class listCoForClassServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data\
        JSONObject jo = new JSONObject();
        String year = (String)session.getAttribute("year");
        String department = (String)session.getAttribute("department");
        String section = (String)session.getAttribute("section");

        String msg = "done";
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");

            PreparedStatement stmt1 = con.prepareStatement("select subjectCode from timetable where section = ? and department = ? and year = ?");
            stmt1.setString(1,section);
            stmt1.setString(2,department);
            stmt1.setString(3,year);

            ResultSet r1 = stmt1.executeQuery();

            JSONArray a1 = new JSONArray();
            while (r1.next()){
                String subjectCode = r1.getString(1);

                JSONObject o1 = new JSONObject();
                o1.put("subjectCode",subjectCode);

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
                o1.put("co", ar);
                a1.add(o1);
            }

            jo.put("co",a1);


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
