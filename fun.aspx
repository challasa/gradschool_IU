<script runat="server">
Sub Page_Load
link1.HRef="http://www.cheminfo.informatics.indiana.edu"
End Sub
</script>


<html><body bgcolor="maroon">
<center>
<form runat="server">
<a id="link1" runat="server">Visit Cheminfo at Indiana University</a>
<br /><br />
<p style="color:white">Enter a number from 1 to 100:
<asp:TextBox id="tbox1" runat="server"/>
<br /><br />
<asp:Button Text="Submit" runat="server" />
</p>

<p>
<asp:RangeValidator 
ControlToValidate="tbox1"
MinimumValue="1"
MaximumValue="100"
Type="Integer"
Text="The value must be from 1 to 100"
runat="server"/>
</p>
</form>

<h2 style="color:white">Good Thoughts make your Life</h2>
<p><%Response.Write(now())%></p>
</center>
</body>
</html>