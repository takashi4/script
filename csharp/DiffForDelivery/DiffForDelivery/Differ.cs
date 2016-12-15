using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;

namespace DiffForDelivery
{
    internal class Differ
    {
        private string output;
        private string source;
        private string target;

        private List<string> deletedList;

        public Differ(string source, string target, string output)
        {
            this.source = source;
            this.target = target;
            this.output = output;
        }

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
            throw new NotImplementedException();
        }

        private void detailDiffing(string startDir, string compareDir, object outputDir)
        {
            Directory.GetDirectories(startDir).ForEach(dir =>
                detailDiffing($"{startDir}/{dir}", $"{compareDir}/{dir}", $"{outputDir}/{dir}")
            );
        }
    }
}