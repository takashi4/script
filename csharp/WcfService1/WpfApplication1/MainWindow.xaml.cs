using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace WpfApplication1
{
    /// <summary>
    /// MainWindow.xaml の相互作用ロジック
    /// </summary>
    public partial class MainWindow : Window
    {
        public MainWindow()
        {
            InitializeComponent();
        }

        private void button_Click(object sender, RoutedEventArgs e)
        {
            var client = new ServiceReference1.Service1Client();
            var composite = new ServiceReference1.CompositeType();
            label.Content = client.GetData(12345);
            composite.BoolValue = checkBox.IsChecked == true;
            composite.StringValue = textBox.Text;
            composite = client.GetDataUsingDataContract(composite);
            label1.Content = composite.StringValue;
        }
    }
}
