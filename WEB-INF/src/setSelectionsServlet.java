import javax.servlet.http.*;
import javax.servlet.*;
import java.io.*;
import org.json.simple.*;
import java.sql.*;
public class setSelectionsServlet extends HttpServlet{
    public void doGet(HttpServletRequest req,HttpServletResponse res) throws ServletException,IOException {
        res.setContentType("application/json");//setting the content type
        HttpSession session = req.getSession(true);
        PrintWriter out=res.getWriter();//get the stream to write the data
        String ayear = req.getParameter("ayear");
        String year = req.getParameter("year");
        String department = req.getParameter("department");
        String section = req.getParameter("section");
        String assesment = req.getParameter("assesment");
        JSONObject jo = new JSONObject();
        String msg = "done";
        try{
            Class.forName("com.mysql.jdbc.Driver");
            Connection con=DriverManager.getConnection("jdbc:mysql://localhost:3306/course","test","test");

            if (ayear != null)
                session.setAttribute("ayear",ayear);
            if (year != null)
                session.setAttribute("year",year);
            if (department != null)
                session.setAttribute("department",department);
            if (section != null)
                session.setAttribute("section", section);
            if (assesment != null)
                session.setAttribute("assesment", assesment);
            String role1 = (String)session.getAttribute("role");
            if(role1.equals("faculty")){
                PreparedStatement stmt = con.prepareStatement("select subjectCode from timetable where facultyid = ? and section = ? and department = ? and year = ?");

                stmt.setString(1, (String)session.getAttribute("userId"));
                stmt.setString(2, (String)session.getAttribute("section"));
                stmt.setString(3, (String)session.getAttribute("department"));
                stmt.setString(4, (String)session.getAttribute("year"));
                ResultSet rs = stmt.executeQuery();
                JSONArray ar = new JSONArray();
                boolean flag = true;
                while(rs.next()){
                    flag = true;
                    String scode = rs.getString(1);
                    ar.add(scode);
                }

                if(flag){
                        msg = "not assigned";
                }else{
                    session.setAttribute("subjects", ar.toJSONString());
                }
            }

        }catch(Exception e){
            String s = e.toString();
            msg = "error";;
            jo.put("error",e.toString());
        }
        jo.put("message",msg);
        //writing html in the stream
        out.println(jo);

        out.close();//closing the stream
    }
}
