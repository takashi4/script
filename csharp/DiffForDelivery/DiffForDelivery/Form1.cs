using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.IO;

namespace DiffForDelivery
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void folderBrowserDialog1_HelpRequest(object sender, EventArgs e)
        {

        }

        private void sourceBrowse_Click(object sender, EventArgs e)
        {
            DialogResult dr = folderBrowserDialog1.ShowDialog();
            if (dr == System.Windows.Forms.DialogResult.OK)
                sourceFolder.Text = folderBrowserDialog1.SelectedPath;
        }

        private void targetBrowse_Click(object sender, EventArgs e)
        {
            DialogResult dr = folderBrowserDialog1.ShowDialog();
            if (dr == System.Windows.Forms.DialogResult.OK)
                targetFolder.Text = folderBrowserDialog1.SelectedPath;

        }

        private void outputBrowse_Click(object sender, EventArgs e)
        {
            DialogResult dr = folderBrowserDialog1.ShowDialog();
            if (dr == System.Windows.Forms.DialogResult.OK)
                outputFolder.Text = folderBrowserDialog1.SelectedPath;
        }

        private void diffExec_Click(object sender, EventArgs e)
        {
            // 入力値確認
            var source = sourceFolder.Text;
            if (!checkFolder(source, "比較元"))
                return;

            var target = targetFolder.Text;
            if (!checkFolder(target, "納品物"))
                return;

            var output = outputFolder.Text;
            if (!checkFolder(output, "出力先"))
                return;

            var differ = new Differ(source, target, output);
            differ.Exec();

            resultMessage(differ);
        }

        private void resultMessage(Differ differ)
        {
            var message = "削除対象はありません";
            if (differ.DeletedList.Count > 0)
                message = string.Format("以下が削除対象になります。\r\n{0}",
                    string.Join("\r\n", differ.DeletedList.ToArray())
                );

            MessageBox.Show(message
                , "削除対象"
                , MessageBoxButtons.OK
                , MessageBoxIcon.Information
            );
        }


        private void cancel_Click(object sender, EventArgs e)
        {
            Close();
        }
        private bool checkFolder(string folder, string label)
        {
            // 空白？
            if (string.IsNullOrEmpty(folder))
            {
                MessageBox.Show(
                    label + "にフォルダを指定してください"
                    , "エラー"
                    , MessageBoxButtons.OK
                    , MessageBoxIcon.Error
                );
                return false;
            }
            // フォルダ存在確認
            if (!Directory.Exists(folder))
            {
                MessageBox.Show(
                    label + "に正しいフォルダパスを指定してください"
                    , "エラー"
                    , MessageBoxButtons.OK
                    , MessageBoxIcon.Error
                );
                return false;
            }
            return true;
        }
    }
}
