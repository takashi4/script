using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace WebApplication1
{
    public partial class _Default : Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {

        }

        protected void Button1_Click(object sender, EventArgs e)
        {
            var client = new ServiceReference1.Service1Client();
            var composite = new ServiceReference1.CompositeType();

            Label1.Text = client.GetData(12345);
            composite.BoolValue = CheckBox1.Checked;
            composite.StringValue = TextBox1.Text;
            composite = client.GetDataUsingDataContract(composite);
            Label2.Text = composite.StringValue;
        }
    }
}