using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;

namespace DiffForDelivery
{
    internal class Differ
    {
        private string output;
        private string source;
        private string target;

        private static MD5 md5 = MD5.Create();

        public Differ(string source, string target, string output)
        {
            this.source = source;
            this.target = target;
            this.output = output;
            this.DeletedList = new List<string>();
        }

        public List<string> DeletedList { get; protected set; }

        public void Exec()
        {
            // target に沿ってrecursive
            // 存在確認、MD5チェック
            detailDiffing(target, source, output);
            // source に沿ってrecursive
            // 存在確認のみ
            simpleDiffingWithDeletedList(source, target);
        }

        private void simpleDiffingWithDeletedList(string loopDir, string compareDir)
        {
            // まずはディレクトリの存在確認
            foreach (var dir in Directory.GetDirectories(loopDir))
            {
                var dir2 = $"{compareDir}/{Path.GetFileName(dir)}";
                if (Directory.Exists(dir2))
                    simpleDiffingWithDeletedList(dir, dir2);
                else
                    this.DeletedList.Add(dir);
            }

            // 次に消されたファイル郡
            foreach (var file in Directory.GetFiles(loopDir))
            {
                var file2 = $"{compareDir}/{Path.GetFileName(file)}";
                if (File.Exists(file2))
                    continue;

                this.DeletedList.Add(file);
            }
        }

        private void detailDiffing(string startDir, string compareDir, string outputDir)
        {
            // まずはディレクトリについて処理
            foreach (var dir in Directory.GetDirectories(startDir)) {
                var dir2 = Path.GetFileName(dir);
                // compareDir にディレクトリが存在するなら再帰
                if (Directory.Exists($"{compareDir}\\{dir2}"))
                    detailDiffing(dir, $"{compareDir}/{dir2}", $"{outputDir}/{dir2}");
                // 存在しないならディレクトリごとまるっとコピー
                else
                    DirectoryCopy(dir, $"{outputDir}/{dir2}");
            }

            // 次にディレクトリ内のファイルを処理
            foreach (var file in Directory.GetFiles(startDir)) {
                var file2 = Path.GetFileName(file);
                // ファイルが存在するなら、md5で比較
                if (File.Exists($"{compareDir}\\{file2}"))
                    // 同じmd5なら何もしないで次
                    if (equalFile(startDir, compareDir, file2))
                        continue;
                // 新規ファイルか、md5が違う時はファイルコピー
                if (!Directory.Exists(outputDir))
                    Directory.CreateDirectory(outputDir);
                File.Copy(file, $"{outputDir}\\{file2}", true);
            }
        }

        private bool equalFile(string startDir, string compareDir, string file)
        {
            using (var fs1 = File.Open($"{startDir}\\{file}", FileMode.Open, FileAccess.Read))
            using (var fs2 = File.Open($"{compareDir}\\{file}", FileMode.Open, FileAccess.Read))
            {
                var bytes = md5.ComputeHash(fs1);
                return bytes.SequenceEqual(md5.ComputeHash(fs2));
            }
        }

        private static void DirectoryCopy(string sourcePath, string destinationPath)
        {
            DirectoryInfo sourceDirectory = new DirectoryInfo(sourcePath);
            DirectoryInfo destinationDirectory = new DirectoryInfo(destinationPath);

            //コピー先のディレクトリがなければ作成する
            if (destinationDirectory.Exists == false)
            {
                destinationDirectory.Create();
                destinationDirectory.Attributes = sourceDirectory.Attributes;
            }

            //ファイルのコピー
            foreach (FileInfo fileInfo in sourceDirectory.GetFiles())
            {
                //同じファイルが存在していたら、常に上書きする
                fileInfo.CopyTo(destinationDirectory.FullName + @"\" + fileInfo.Name, true);
            }

            //ディレクトリのコピー（再帰を使用）
            foreach (System.IO.DirectoryInfo directoryInfo in sourceDirectory.GetDirectories())
            {
                DirectoryCopy(directoryInfo.FullName, destinationDirectory.FullName + @"\" + directoryInfo.Name);
            }
        }
    }
}